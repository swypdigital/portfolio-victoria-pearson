/**
 * GenCraft API - Request ID Middleware
 *
 * Assigns unique correlation ID to each request for tracing across logs.
 *
 * @module middleware/requestId
 */

import { v4 as uuidv4 } from 'uuid';

/**
 * Attach unique request ID to each request
 *
 * Request ID format: req_[uuid]
 * Used for correlation in structured logging.
 */
export function attachRequestId(req, res, next) {
  req.id = `req_${uuidv4().substring(0, 8)}`;
  res.setHeader('X-Request-ID', req.id);
  next();
}
