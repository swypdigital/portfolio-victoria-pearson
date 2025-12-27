/**
 * Rate Limiter Middleware
 * Simple in-memory rate limiting (production should use Redis)
 */

import { Request, Response, NextFunction } from 'express';
import { createAPIError } from './error-handler';

interface RateLimitStore {
  [key: string]: {
    count: number;
    resetTime: number;
  };
}

const store: RateLimitStore = {};

// Configuration
const WINDOW_MS = 60 * 1000; // 1 minute
const MAX_REQUESTS = 100; // 100 requests per minute

/**
 * Simple in-memory rate limiter
 * TODO: Replace with Redis-based limiter for production
 */
export function rateLimiter(
  req: Request,
  res: Response,
  next: NextFunction
): void {
  // Get client identifier (IP address)
  const identifier = req.ip || req.socket.remoteAddress || 'unknown';

  const now = Date.now();
  const record = store[identifier];

  if (!record || now > record.resetTime) {
    // Create new record
    store[identifier] = {
      count: 1,
      resetTime: now + WINDOW_MS,
    };
    setResponseHeaders(res, MAX_REQUESTS, MAX_REQUESTS - 1, WINDOW_MS);
    return next();
  }

  // Increment counter
  record.count++;

  // Check if limit exceeded
  if (record.count > MAX_REQUESTS) {
    const retryAfter = Math.ceil((record.resetTime - now) / 1000);
    res.setHeader('Retry-After', retryAfter.toString());
    setResponseHeaders(res, MAX_REQUESTS, 0, retryAfter * 1000);

    throw createAPIError(
      'Rate limit exceeded. Please try again later.',
      429,
      'rate_limit_exceeded'
    );
  }

  // Set rate limit headers
  const remaining = MAX_REQUESTS - record.count;
  const resetTime = record.resetTime - now;
  setResponseHeaders(res, MAX_REQUESTS, remaining, resetTime);

  next();
}

/**
 * Set standard rate limit headers
 */
function setResponseHeaders(
  res: Response,
  limit: number,
  remaining: number,
  resetMs: number
): void {
  res.setHeader('X-RateLimit-Limit', limit.toString());
  res.setHeader('X-RateLimit-Remaining', remaining.toString());
  res.setHeader('X-RateLimit-Reset', new Date(Date.now() + resetMs).toISOString());
}

/**
 * Cleanup old entries periodically (prevent memory leak)
 */
setInterval(() => {
  const now = Date.now();
  Object.keys(store).forEach((key) => {
    if (now > store[key].resetTime) {
      delete store[key];
    }
  });
}, WINDOW_MS);
