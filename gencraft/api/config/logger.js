/**
 * GenCraft API - Structured Logger Configuration
 *
 * Provides structured logging with correlation IDs for request tracing.
 * Supports multiple transports (console, file) and log levels.
 *
 * @module config/logger
 */

import winston from 'winston';
import path from 'path';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const logLevel = process.env.LOG_LEVEL || 'info';
const logFilePath = process.env.LOG_FILE_PATH || path.join(__dirname, '../logs/gencraft-api.log');

/**
 * Custom log format with timestamp, level, correlation ID, and message
 */
const logFormat = winston.format.combine(
  winston.format.timestamp({ format: 'YYYY-MM-DD HH:mm:ss' }),
  winston.format.errors({ stack: true }),
  winston.format.splat(),
  winston.format.json(),
  winston.format.printf(({ timestamp, level, message, requestId, ...metadata }) => {
    let msg = `${timestamp} [${level.toUpperCase()}]`;

    if (requestId) {
      msg += ` [${requestId}]`;
    }

    msg += `: ${message}`;

    if (Object.keys(metadata).length > 0) {
      msg += ` ${JSON.stringify(metadata)}`;
    }

    return msg;
  })
);

/**
 * Winston logger instance with console and file transports
 */
const logger = winston.createLogger({
  level: logLevel,
  format: logFormat,
  transports: [
    // Console transport for development
    new winston.transports.Console({
      format: winston.format.combine(
        winston.format.colorize(),
        logFormat
      )
    }),

    // File transport for production
    new winston.transports.File({
      filename: logFilePath,
      maxsize: 10485760, // 10MB
      maxFiles: 5,
      tailable: true
    })
  ]
});

/**
 * Create child logger with request context (correlation ID)
 *
 * @param {string} requestId - Unique request identifier
 * @returns {winston.Logger} Child logger with request context
 */
export const createRequestLogger = (requestId) => {
  return logger.child({ requestId });
};

export default logger;
