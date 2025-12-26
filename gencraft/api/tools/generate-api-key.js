#!/usr/bin/env node
/**
 * GenCraft API - API Key Generator
 *
 * Command-line tool to generate API keys for users.
 *
 * Usage:
 *   node tools/generate-api-key.js <name> [tier] [dailyCostLimit]
 *
 * Examples:
 *   node tools/generate-api-key.js "VIBE OS Production" pro 100.00
 *   node tools/generate-api-key.js "Test Key" basic 10.00
 *
 * @module tools/generate-api-key
 */

import { fileURLToPath } from 'url';
import path from 'path';
import dotenv from 'dotenv';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

// Load environment variables
dotenv.config({ path: path.join(__dirname, '../.env') });

// Import after env loaded
const { initializeDatabase } = await import('../config/database.js');
const { generateApiKey } = await import('../middleware/auth.js');

// Parse arguments
const args = process.argv.slice(2);

if (args.length < 1) {
  console.error(`
Usage: node tools/generate-api-key.js <name> [tier] [dailyCostLimit]

Arguments:
  name            - Descriptive name for the API key (required)
  tier            - Access tier: basic, pro, enterprise (default: basic)
  dailyCostLimit  - Daily cost limit in USD (default: 10.00 for basic, 100.00 for pro)

Examples:
  node tools/generate-api-key.js "VIBE OS Production" pro 100.00
  node tools/generate-api-key.js "Test Key" basic 10.00
  node tools/generate-api-key.js "Enterprise Client" enterprise 1000.00

Tiers:
  basic      - 100 requests/hour, VibeSdk engine only
  pro        - 1000 requests/hour, VibeSdk + SINDy-RL engines
  enterprise - 10000 requests/hour, all engines including Document07
  `);
  process.exit(1);
}

const name = args[0];
const tier = args[1] || 'basic';
const dailyCostLimit = parseFloat(args[2]) || (tier === 'basic' ? 10.00 : tier === 'pro' ? 100.00 : 1000.00);

// Validate tier
if (!['basic', 'pro', 'enterprise'].includes(tier)) {
  console.error(`Error: Invalid tier '${tier}'. Must be: basic, pro, or enterprise`);
  process.exit(1);
}

// Generate API key
console.log('Generating API key...\n');

try {
  await initializeDatabase();

  const { apiKey, keyId } = await generateApiKey(name, tier, dailyCostLimit);

  console.log('✅ API Key Generated Successfully!\n');
  console.log('═'.repeat(70));
  console.log('  API KEY (store this securely - it won\'t be shown again):');
  console.log('═'.repeat(70));
  console.log(`  ${apiKey}`);
  console.log('═'.repeat(70));
  console.log();
  console.log('Key Details:');
  console.log(`  ID:               ${keyId}`);
  console.log(`  Name:             ${name}`);
  console.log(`  Tier:             ${tier}`);
  console.log(`  Daily Cost Limit: $${dailyCostLimit.toFixed(2)}`);
  console.log();
  console.log('Usage:');
  console.log(`  Authorization: Bearer ${apiKey}`);
  console.log();
  console.log('Capabilities:');

  if (tier === 'basic') {
    console.log('  • 100 requests/hour');
    console.log('  • VibeSdk engine (webapp, component generation)');
  } else if (tier === 'pro') {
    console.log('  • 1000 requests/hour');
    console.log('  • VibeSdk + SINDy-RL engines');
    console.log('  • 82% cost optimization via intelligent routing');
  } else if (tier === 'enterprise') {
    console.log('  • 10000 requests/hour');
    console.log('  • All engines (VibeSdk, SINDy-RL, Document07)');
    console.log('  • Priority support');
  }

  console.log();
  console.log('⚠️  IMPORTANT: Store this API key securely. It cannot be retrieved later.');
  console.log();

  process.exit(0);
} catch (error) {
  console.error('❌ Failed to generate API key:', error.message);
  process.exit(1);
}
