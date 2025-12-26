/**
 * GenCraft API - Database Configuration
 *
 * SQLite database for API key management, usage tracking, and cost monitoring.
 * Provides functions for initialization and common queries.
 *
 * @module config/database
 */

import sqlite3 from 'sqlite3';
import { open } from 'sqlite';
import path from 'path';
import { fileURLToPath } from 'url';
import logger from './logger.js';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const dbPath = process.env.DB_PATH || path.join(__dirname, '../data/gencraft-api.db');

let db = null;

/**
 * Initialize database connection and create tables if they don't exist
 *
 * @returns {Promise<object>} Database instance
 */
export async function initializeDatabase() {
  try {
    db = await open({
      filename: dbPath,
      driver: sqlite3.Database
    });

    // Create API keys table
    await db.exec(`
      CREATE TABLE IF NOT EXISTS api_keys (
        id TEXT PRIMARY KEY,
        key_hash TEXT UNIQUE NOT NULL,
        name TEXT NOT NULL,
        tier TEXT NOT NULL CHECK(tier IN ('basic', 'pro', 'enterprise')),
        created_at TEXT NOT NULL,
        last_used_at TEXT,
        is_active INTEGER NOT NULL DEFAULT 1,
        daily_cost_limit REAL NOT NULL,
        metadata TEXT
      );
    `);

    // Create usage tracking table
    await db.exec(`
      CREATE TABLE IF NOT EXISTS api_usage (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        api_key_id TEXT NOT NULL,
        endpoint TEXT NOT NULL,
        engine TEXT NOT NULL,
        request_timestamp TEXT NOT NULL,
        response_time_ms INTEGER,
        status_code INTEGER,
        cost REAL,
        tokens_used INTEGER,
        FOREIGN KEY (api_key_id) REFERENCES api_keys(id)
      );
    `);

    // Create daily usage summary table for fast lookups
    await db.exec(`
      CREATE TABLE IF NOT EXISTS daily_usage_summary (
        api_key_id TEXT NOT NULL,
        date TEXT NOT NULL,
        total_requests INTEGER NOT NULL DEFAULT 0,
        total_cost REAL NOT NULL DEFAULT 0.0,
        engine_breakdown TEXT,
        PRIMARY KEY (api_key_id, date),
        FOREIGN KEY (api_key_id) REFERENCES api_keys(id)
      );
    `);

    // Create indexes for performance
    await db.exec(`
      CREATE INDEX IF NOT EXISTS idx_api_usage_timestamp
      ON api_usage(request_timestamp);

      CREATE INDEX IF NOT EXISTS idx_api_usage_key_date
      ON api_usage(api_key_id, request_timestamp);

      CREATE INDEX IF NOT EXISTS idx_daily_summary_date
      ON daily_usage_summary(date);
    `);

    logger.info('Database initialized successfully', { dbPath });
    return db;
  } catch (error) {
    logger.error('Failed to initialize database', { error: error.message, dbPath });
    throw error;
  }
}

/**
 * Get database instance (initialize if not already done)
 *
 * @returns {Promise<object>} Database instance
 */
export async function getDatabase() {
  if (!db) {
    await initializeDatabase();
  }
  return db;
}

/**
 * Close database connection
 */
export async function closeDatabase() {
  if (db) {
    await db.close();
    db = null;
    logger.info('Database connection closed');
  }
}

export default {
  initializeDatabase,
  getDatabase,
  closeDatabase
};
