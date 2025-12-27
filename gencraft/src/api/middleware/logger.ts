/**
 * Request Logger Middleware
 * Logs all incoming requests with timing
 */

import { Request, Response, NextFunction } from 'express';

export function requestLogger(
  req: Request,
  res: Response,
  next: NextFunction
): void {
  const start = Date.now();

  // Log request start
  console.log(`[${new Date().toISOString()}] ${req.method} ${req.path}`);

  // Log response when finished
  res.on('finish', () => {
    const duration = Date.now() - start;
    const statusColor = res.statusCode >= 400 ? '\x1b[31m' : '\x1b[32m';
    const reset = '\x1b[0m';

    console.log(
      `[${new Date().toISOString()}] ${req.method} ${req.path} - ` +
      `${statusColor}${res.statusCode}${reset} - ${duration}ms`
    );
  });

  next();
}
