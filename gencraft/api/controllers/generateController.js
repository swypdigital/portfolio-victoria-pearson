/**
 * GenCraft API - Generation Controller
 *
 * Handles generation requests by routing to appropriate GenCraft engines.
 * Implements error translation for newbie-friendly error messages.
 *
 * @module controllers/generateController
 */

import { exec, spawn } from 'child_process';
import { promisify } from 'util';
import { fileURLToPath } from 'url';
import { dirname, join } from 'path';
import logger from '../config/logger.js';
import { trackUsage } from '../middleware/rateLimiter.js';

const execAsync = promisify(exec);
const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);
const ENGINES_DIR = join(__dirname, '../../engines');

/**
 * Call engine wrapper script and return parsed result
 *
 * @param {string} engine - Engine name (vibesdk, sindy-rl, document07)
 * @param {object} input - Input data for engine
 * @param {object} logger - Logger instance
 * @returns {Promise<object>} Engine result
 */
async function callEngine(engine, input, logger) {
  return new Promise((resolve, reject) => {
    const engineMap = {
      'vibesdk': 'vibesdk-wrapper.js',
      'sindy-rl': 'sindy-rl-wrapper.js',
      'document07': 'document07-wrapper.js'
    };

    const engineFile = engineMap[engine];
    if (!engineFile) {
      reject(new Error(`Unknown engine: ${engine}`));
      return;
    }

    const enginePath = join(ENGINES_DIR, engineFile);
    const child = spawn('node', [enginePath], {
      cwd: ENGINES_DIR
    });

    let stdout = '';
    let stderr = '';

    child.stdout.on('data', (data) => {
      stdout += data.toString();
    });

    child.stderr.on('data', (data) => {
      stderr += data.toString();
    });

    child.on('error', (error) => {
      logger.error('Engine execution error', {
        engine,
        error: error.message
      });
      reject(error);
    });

    child.on('close', (code) => {
      if (code !== 0 && code !== null) {
        logger.error('Engine exited with error', {
          engine,
          code,
          stderr
        });

        // Try to parse stderr as JSON error
        try {
          const errorResult = JSON.parse(stderr);
          resolve(errorResult);
        } catch {
          reject(new Error(`Engine ${engine} exited with code ${code}: ${stderr}`));
        }
        return;
      }

      try {
        const result = JSON.parse(stdout);
        logger.info('Engine execution successful', {
          engine,
          success: result.success,
          cost: result.metadata?.cost
        });
        resolve(result);
      } catch (error) {
        logger.error('Failed to parse engine output', {
          engine,
          error: error.message,
          stdout: stdout.substring(0, 200)
        });
        reject(new Error(`Failed to parse ${engine} output: ${error.message}`));
      }
    });

    // Send input to engine via stdin
    child.stdin.write(JSON.stringify(input));
    child.stdin.end();
  });
}

/**
 * Translate technical error to user-friendly message
 *
 * @param {Error} error - Technical error object
 * @param {string} engine - Engine that produced the error
 * @returns {object} Error translation with user-friendly message
 */
function translateError(error, engine) {
  const errorMessage = error.message.toLowerCase();

  // Common error patterns and translations
  const errorTranslations = {
    timeout: {
      userFriendly: 'The generation is taking longer than expected. This usually means the description was too complex. Try breaking it into smaller pieces.',
      suggestion: 'Split your request into 2-3 smaller components',
      learnMore: 'https://gencraft.dev/docs/generation-tips'
    },
    'out of memory': {
      userFriendly: 'The generation required too much memory. Try simplifying your description or reducing the number of features.',
      suggestion: 'Reduce complexity or split into multiple generations',
      learnMore: 'https://gencraft.dev/docs/memory-limits'
    },
    'command not found': {
      userFriendly: `The ${engine} engine is not properly installed or configured. Please contact support.`,
      suggestion: 'Contact support@gencraft.dev',
      learnMore: 'https://gencraft.dev/docs/troubleshooting'
    },
    'permission denied': {
      userFriendly: 'The server does not have permission to run the generation engine. Please contact support.',
      suggestion: 'Contact support@gencraft.dev',
      learnMore: 'https://gencraft.dev/docs/troubleshooting'
    }
  };

  // Find matching translation
  for (const [pattern, translation] of Object.entries(errorTranslations)) {
    if (errorMessage.includes(pattern)) {
      return {
        code: 'GENERATION_FAILED',
        message: 'Generation failed',
        technical: error.message,
        ...translation
      };
    }
  }

  // Default translation for unknown errors
  return {
    code: 'GENERATION_FAILED',
    message: 'Generation failed',
    technical: error.message,
    userFriendly: 'Something went wrong during generation. Our team has been notified and will investigate.',
    suggestion: 'Try again in a few minutes, or contact support if the problem persists',
    learnMore: 'https://gencraft.dev/docs/troubleshooting'
  };
}

/**
 * Estimate cost for a generation request
 *
 * @param {object} req - Express request
 * @param {object} res - Express response
 */
export async function estimateCost(req, res) {
  const requestLogger = logger.child({ requestId: req.id });

  try {
    const { type, complexity = 'medium' } = req.body;

    // Simple cost estimation based on type and complexity
    const baseCosts = {
      webapp: { simple: 0.05, medium: 0.15, complex: 0.50 },
      component: { simple: 0.02, medium: 0.05, complex: 0.15 },
      document: { simple: 0.01, medium: 0.03, complex: 0.10 }
    };

    const estimatedCost = baseCosts[type]?.[complexity] || 0.10;
    const estimatedTime = complexity === 'simple' ? '5-10s' : complexity === 'medium' ? '15-30s' : '30-60s';

    requestLogger.info('Cost estimated', {
      type,
      complexity,
      estimatedCost,
      keyId: req.apiKey.id
    });

    res.json({
      type,
      complexity,
      estimatedCost,
      estimatedTime,
      currency: 'USD',
      breakdown: {
        aiModelCost: estimatedCost * 0.7,
        processingCost: estimatedCost * 0.2,
        infrastructureCost: estimatedCost * 0.1
      }
    });
  } catch (error) {
    requestLogger.error('Cost estimation failed', { error: error.message });

    res.status(500).json({
      error: translateError(error, 'cost-estimator')
    });
  }
}

/**
 * Generate content using appropriate GenCraft engine
 *
 * @param {object} req - Express request
 * @param {object} res - Express response
 */
export async function generateContent(req, res) {
  const requestLogger = logger.child({ requestId: req.id });
  const startTime = Date.now();

  try {
    const { type, description, options = {} } = req.body;

    // Map type to engine
    const engineMap = {
      webapp: 'vibesdk',
      component: 'vibesdk',
      document: 'document07'
    };

    const engine = engineMap[type];

    if (!engine) {
      return res.status(400).json({
        error: {
          code: 'INVALID_TYPE',
          message: `Invalid generation type: ${type}`,
          userFriendly: `The type '${type}' is not supported. Please use 'webapp', 'component', or 'document'.`,
          suggestion: 'Check the API documentation for valid types',
          learnMore: 'https://gencraft.dev/docs/generation-types'
        }
      });
    }

    requestLogger.info('Generation started', {
      type,
      engine,
      descriptionLength: description.length,
      keyId: req.apiKey.id
    });

    // Call real engine wrapper
    const engineResult = await callEngine(engine, { description, options }, requestLogger);

    // Build response
    const result = {
      id: `gen_${Date.now()}_${Math.random().toString(36).substring(7)}`,
      type,
      engine,
      status: engineResult.success ? 'completed' : (engineResult.status || 'failed'),
      output: {
        code: engineResult.code || null,
        files: engineResult.files || [],
        framework: engineResult.metadata?.framework || options.framework || 'auto-detected',
        complexity: options.complexity || 'medium',
        ...(engineResult.roadmap && { roadmap: engineResult.roadmap }),
        ...(engineResult.alternatives && { alternatives: engineResult.alternatives })
      },
      metadata: {
        generatedAt: new Date().toISOString(),
        cost: engineResult.metadata?.cost || 0,
        tokensUsed: engineResult.metadata?.tokensUsed || 0,
        responseTime: `${((Date.now() - startTime) / 1000).toFixed(1)}s`,
        linesOfCode: engineResult.metadata?.linesOfCode || 0,
        fileCount: engineResult.metadata?.fileCount || 0
      },
      ...(engineResult.error && { error: engineResult.error })
    };

    // Track usage
    const responseTime = Date.now() - startTime;
    await trackUsage(
      req.apiKey.id,
      req.path,
      engine,
      result.metadata.cost,
      responseTime,
      200,
      result.metadata.tokensUsed
    );

    requestLogger.info('Generation completed', {
      generationId: result.id,
      responseTime,
      cost: result.metadata.cost,
      keyId: req.apiKey.id
    });

    res.json(result);
  } catch (error) {
    const responseTime = Date.now() - startTime;

    requestLogger.error('Generation failed', {
      error: error.message,
      responseTime,
      keyId: req.apiKey.id
    });

    // Track failed attempt
    await trackUsage(
      req.apiKey.id,
      req.path,
      'unknown',
      0,
      responseTime,
      500,
      0
    );

    res.status(500).json({
      error: translateError(error, req.body.engine || 'unknown')
    });
  }
}

/**
 * Get health status of all engines
 *
 * @param {object} req - Express request
 * @param {object} res - Express response
 */
export async function getHealth(req, res) {
  const requestLogger = logger.child({ requestId: req.id });

  try {
    // Import health check utility
    const { checkAllEngines } = await import('../utils/healthCheck.js');

    const health = await checkAllEngines(true); // Use cache

    requestLogger.info('Health check requested', {
      status: health.status
    });

    res.json({
      status: health.status,
      timestamp: new Date(health.lastCheck).toISOString(),
      engines: health.engines,
      api: {
        version: '1.0.0',
        uptime: process.uptime(),
        memoryUsage: process.memoryUsage()
      }
    });
  } catch (error) {
    requestLogger.error('Health check failed', { error: error.message });

    res.status(500).json({
      status: 'unhealthy',
      error: error.message
    });
  }
}
