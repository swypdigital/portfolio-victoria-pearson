/**
 * Global Error Handler Middleware
 * Catches all errors and returns consistent error responses
 */

import { Request, Response, NextFunction } from 'express';

export interface APIError extends Error {
  statusCode?: number;
  code?: string;
  details?: any;
}

/**
 * Global error handling middleware
 */
export function errorHandler(
  err: APIError,
  req: Request,
  res: Response,
  next: NextFunction
): void {
  // Default to 500 if no status code provided
  const statusCode = err.statusCode || 500;
  const code = err.code || 'internal_error';

  // Log error (in production, send to logging service)
  console.error('[ERROR]', {
    timestamp: new Date().toISOString(),
    path: req.path,
    method: req.method,
    statusCode,
    code,
    message: err.message,
    stack: process.env.NODE_ENV === 'development' ? err.stack : undefined,
  });

  // Send error response
  res.status(statusCode).json({
    error: code,
    message: err.message,
    ...(process.env.NODE_ENV === 'development' && {
      stack: err.stack,
      details: err.details
    }),
  });
}

/**
 * Helper to create API errors with status codes
 */
export function createAPIError(
  message: string,
  statusCode: number = 500,
  code?: string
): APIError {
  const error = new Error(message) as APIError;
  error.statusCode = statusCode;
  error.code = code || getCodeFromStatus(statusCode);
  return error;
}

/**
 * Get error code from HTTP status
 */
function getCodeFromStatus(status: number): string {
  const codes: Record<number, string> = {
    400: 'bad_request',
    401: 'unauthorized',
    403: 'forbidden',
    404: 'not_found',
    409: 'conflict',
    422: 'validation_error',
    429: 'rate_limit_exceeded',
    500: 'internal_error',
    503: 'service_unavailable',
  };
  return codes[status] || 'unknown_error';
}

/**
 * Async handler wrapper to catch promise rejections
 */
export function asyncHandler(
  fn: (req: Request, res: Response, next: NextFunction) => Promise<any>
) {
  return (req: Request, res: Response, next: NextFunction) => {
    Promise.resolve(fn(req, res, next)).catch(next);
  };
}
