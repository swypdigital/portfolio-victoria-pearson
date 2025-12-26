/**
 * ReachCraft Authentication Service
 * Team 1: Infrastructure Foundation
 * Handles JWT, OAuth, and multi-tenancy
 */

import { createClient } from '@supabase/supabase-js';
import jwt from 'jsonwebtoken';
import bcrypt from 'bcrypt';

const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL!;
const supabaseServiceKey = process.env.SUPABASE_SERVICE_KEY!;
const jwtSecret = process.env.JWT_SECRET!;

export const supabase = createClient(supabaseUrl, supabaseServiceKey, {
  auth: {
    autoRefreshToken: false,
    persistSession: false
  }
});

export interface AuthPayload {
  user: User;
  organization: Organization;
  accessToken: string;
  refreshToken: string;
  expiresIn: number;
}

export interface User {
  id: string;
  email: string;
  name: string;
  role: UserRole;
  organizationId: string;
}

export interface Organization {
  id: string;
  name: string;
  subscriptionTier: SubscriptionTier;
  contactLimit: number;
  userLimit: number;
}

export enum UserRole {
  GOD = 'GOD',
  ADMIN = 'ADMIN',
  MANAGER = 'MANAGER',
  USER = 'USER',
  VIEWER = 'VIEWER'
}

export enum SubscriptionTier {
  FREE = 'FREE',
  STARTER = 'STARTER',
  PROFESSIONAL = 'PROFESSIONAL',
  BUSINESS = 'BUSINESS',
  ENTERPRISE = 'ENTERPRISE'
}

export class AuthService {
  /**
   * Sign up a new user and create organization
   */
  static async signUp(
    email: string,
    password: string,
    organizationName: string
  ): Promise<AuthPayload> {
    // Create organization first
    const { data: org, error: orgError } = await supabase
      .from('organizations')
      .insert({
        name: organizationName,
        domain: email.split('@')[1],
        subscription_tier: 'FREE'
      })
      .select()
      .single();

    if (orgError) throw new Error(`Organization creation failed: ${orgError.message}`);

    // Hash password
    const passwordHash = await bcrypt.hash(password, 10);

    // Create user
    const { data: user, error: userError } = await supabase
      .from('users')
      .insert({
        email,
        password_hash: passwordHash,
        role: 'ADMIN', // First user is admin
        organization_id: org.id
      })
      .select()
      .single();

    if (userError) {
      // Rollback organization creation
      await supabase.from('organizations').delete().eq('id', org.id);
      throw new Error(`User creation failed: ${userError.message}`);
    }

    // Create vertical config
    await supabase
      .from('vertical_configs')
      .insert({
        organization_id: org.id,
        primary_vertical: 'SALES',
        enabled_verticals: ['SALES']
      });

    // Generate tokens
    const accessToken = this.generateAccessToken(user, org);
    const refreshToken = this.generateRefreshToken(user.id);

    return {
      user: {
        id: user.id,
        email: user.email,
        name: user.name,
        role: user.role,
        organizationId: org.id
      },
      organization: {
        id: org.id,
        name: org.name,
        subscriptionTier: org.subscription_tier,
        contactLimit: org.contact_limit,
        userLimit: org.user_limit
      },
      accessToken,
      refreshToken,
      expiresIn: 3600
    };
  }

  /**
   * Sign in existing user
   */
  static async signIn(email: string, password: string): Promise<AuthPayload> {
    // Get user
    const { data: user, error: userError } = await supabase
      .from('users')
      .select('*, organization:organizations(*)')
      .eq('email', email)
      .single();

    if (userError || !user) {
      throw new Error('Invalid credentials');
    }

    // Verify password
    const validPassword = await bcrypt.compare(password, user.password_hash);
    if (!validPassword) {
      throw new Error('Invalid credentials');
    }

    // Update last login
    await supabase
      .from('users')
      .update({ last_login_at: new Date().toISOString() })
      .eq('id', user.id);

    // Generate tokens
    const accessToken = this.generateAccessToken(user, user.organization);
    const refreshToken = this.generateRefreshToken(user.id);

    return {
      user: {
        id: user.id,
        email: user.email,
        name: user.name,
        role: user.role,
        organizationId: user.organization.id
      },
      organization: {
        id: user.organization.id,
        name: user.organization.name,
        subscriptionTier: user.organization.subscription_tier,
        contactLimit: user.organization.contact_limit,
        userLimit: user.organization.user_limit
      },
      accessToken,
      refreshToken,
      expiresIn: 3600
    };
  }

  /**
   * OAuth sign in/up
   */
  static async oauthSignIn(
    provider: string,
    profile: any
  ): Promise<AuthPayload> {
    // Check if user exists
    let { data: user } = await supabase
      .from('users')
      .select('*, organization:organizations(*)')
      .eq('email', profile.email)
      .single();

    if (!user) {
      // Create new user and org
      const orgName = profile.company || `${profile.name}'s Organization`;
      return this.signUp(profile.email, this.generateRandomPassword(), orgName);
    }

    // Link social account
    await supabase
      .from('social_accounts')
      .upsert({
        user_id: user.id,
        platform: provider,
        account_id: profile.id,
        account_name: profile.name,
        is_active: true,
        connected_at: new Date().toISOString()
      });

    // Generate tokens
    const accessToken = this.generateAccessToken(user, user.organization);
    const refreshToken = this.generateRefreshToken(user.id);

    return {
      user: {
        id: user.id,
        email: user.email,
        name: user.name,
        role: user.role,
        organizationId: user.organization.id
      },
      organization: {
        id: user.organization.id,
        name: user.organization.name,
        subscriptionTier: user.organization.subscription_tier,
        contactLimit: user.organization.contact_limit,
        userLimit: user.organization.user_limit
      },
      accessToken,
      refreshToken,
      expiresIn: 3600
    };
  }

  /**
   * Refresh access token
   */
  static async refreshToken(refreshToken: string): Promise<AuthPayload> {
    try {
      const decoded = jwt.verify(refreshToken, jwtSecret) as any;

      // Get user and org
      const { data: user } = await supabase
        .from('users')
        .select('*, organization:organizations(*)')
        .eq('id', decoded.userId)
        .single();

      if (!user) throw new Error('User not found');

      // Generate new tokens
      const accessToken = this.generateAccessToken(user, user.organization);
      const newRefreshToken = this.generateRefreshToken(user.id);

      return {
        user: {
          id: user.id,
          email: user.email,
          name: user.name,
          role: user.role,
          organizationId: user.organization.id
        },
        organization: {
          id: user.organization.id,
          name: user.organization.name,
          subscriptionTier: user.organization.subscription_tier,
          contactLimit: user.organization.contact_limit,
          userLimit: user.organization.user_limit
        },
        accessToken,
        refreshToken: newRefreshToken,
        expiresIn: 3600
      };
    } catch (error) {
      throw new Error('Invalid refresh token');
    }
  }

  /**
   * Verify access token
   */
  static async verifyToken(token: string): Promise<any> {
    try {
      const decoded = jwt.verify(token, jwtSecret);
      return decoded;
    } catch (error) {
      throw new Error('Invalid token');
    }
  }

  /**
   * Generate access token (1 hour)
   */
  private static generateAccessToken(user: any, org: any): string {
    return jwt.sign(
      {
        userId: user.id,
        email: user.email,
        role: user.role,
        organizationId: org.id,
        permissions: this.getPermissions(user.role)
      },
      jwtSecret,
      { expiresIn: '1h' }
    );
  }

  /**
   * Generate refresh token (30 days)
   */
  private static generateRefreshToken(userId: string): string {
    return jwt.sign(
      {
        userId,
        type: 'refresh'
      },
      jwtSecret,
      { expiresIn: '30d' }
    );
  }

  /**
   * Get permissions based on role
   */
  private static getPermissions(role: UserRole): string[] {
    const permissions: Record<UserRole, string[]> = {
      [UserRole.GOD]: ['*'], // All permissions
      [UserRole.ADMIN]: [
        'contacts:*',
        'lists:*',
        'marketplace:*',
        'workflows:*',
        'team:*',
        'billing:*'
      ],
      [UserRole.MANAGER]: [
        'contacts:*',
        'lists:*',
        'marketplace:read',
        'marketplace:create',
        'workflows:*',
        'team:read'
      ],
      [UserRole.USER]: [
        'contacts:*',
        'lists:*',
        'marketplace:read',
        'workflows:read'
      ],
      [UserRole.VIEWER]: [
        'contacts:read',
        'lists:read',
        'marketplace:read'
      ]
    };

    return permissions[role] || [];
  }

  /**
   * Generate random password for OAuth users
   */
  private static generateRandomPassword(): string {
    return Math.random().toString(36).slice(-12) + Math.random().toString(36).slice(-12);
  }

  /**
   * Invite team member
   */
  static async inviteTeamMember(
    organizationId: string,
    email: string,
    role: UserRole,
    invitedBy: string
  ): Promise<void> {
    // Check organization user limit
    const { data: org } = await supabase
      .from('organizations')
      .select('user_limit')
      .eq('id', organizationId)
      .single();

    const { count } = await supabase
      .from('users')
      .select('*', { count: 'exact', head: true })
      .eq('organization_id', organizationId);

    if (count && org && count >= org.user_limit) {
      throw new Error('User limit reached. Please upgrade your subscription.');
    }

    // Send invitation email (would integrate with email service)
    // For now, just create a notification
    await supabase.from('notifications').insert({
      user_id: invitedBy,
      type: 'team_invite_sent',
      title: 'Team invitation sent',
      message: `Invitation sent to ${email}`
    });
  }

  /**
   * Check if user has permission
   */
  static hasPermission(
    userRole: UserRole,
    permission: string
  ): boolean {
    const permissions = this.getPermissions(userRole);

    // God mode has all permissions
    if (permissions.includes('*')) return true;

    // Check specific permission
    const [resource, action] = permission.split(':');
    return permissions.includes(permission) ||
           permissions.includes(`${resource}:*`);
  }
}

/**
 * Multi-tenancy middleware
 */
export function multiTenancyMiddleware(organizationId: string) {
  return async (req: any, res: any, next: any) => {
    // Set organization context for RLS
    await supabase.rpc('set_config', {
      parameter: 'app.current_organization_id',
      value: organizationId
    });

    next();
  };
}

/**
 * Auth middleware for Express/GraphQL
 */
export function authMiddleware() {
  return async (req: any, res: any, next: any) => {
    const token = req.headers.authorization?.replace('Bearer ', '');

    if (!token) {
      return res.status(401).json({ error: 'No token provided' });
    }

    try {
      const decoded = await AuthService.verifyToken(token);
      req.user = decoded;

      // Set RLS context
      await supabase.rpc('set_config', {
        parameter: 'app.current_user_id',
        value: decoded.userId
      });

      await supabase.rpc('set_config', {
        parameter: 'app.current_organization_id',
        value: decoded.organizationId
      });

      next();
    } catch (error) {
      return res.status(401).json({ error: 'Invalid token' });
    }
  };
}