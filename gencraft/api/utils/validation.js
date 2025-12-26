/**
 * GenCraft API - Request Validation Schemas
 *
 * Zod schemas for runtime type validation of API requests.
 * Ensures type safety and provides clear error messages.
 *
 * @module utils/validation
 */

import { z } from 'zod';

/**
 * Webapp generation request schema
 */
export const WebappGenerationSchema = z.object({
  type: z.literal('webapp'),
  description: z.string()
    .min(10, 'Description must be at least 10 characters')
    .max(5000, 'Description must not exceed 5000 characters'),
  options: z.object({
    framework: z.enum(['react', 'vue', 'svelte', 'nextjs', 'auto']).optional().default('auto'),
    complexity: z.enum(['simple', 'medium', 'complex']).optional().default('medium'),
    features: z.array(z.string()).optional().default([]),
    styling: z.enum(['tailwind', 'css', 'styled-components', 'auto']).optional().default('auto'),
    responsive: z.boolean().optional().default(true)
  }).optional().default({})
});

/**
 * Component generation request schema
 */
export const ComponentGenerationSchema = z.object({
  type: z.literal('component'),
  description: z.string()
    .min(10, 'Description must be at least 10 characters')
    .max(3000, 'Description must not exceed 3000 characters'),
  options: z.object({
    framework: z.enum(['react', 'vue', 'svelte', 'auto']).optional().default('auto'),
    typescript: z.boolean().optional().default(true),
    props: z.array(z.object({
      name: z.string(),
      type: z.string(),
      required: z.boolean().optional()
    })).optional().default([]),
    styling: z.enum(['tailwind', 'css', 'styled-components', 'auto']).optional().default('auto')
  }).optional().default({})
});

/**
 * Document generation request schema
 */
export const DocumentGenerationSchema = z.object({
  type: z.literal('document'),
  description: z.string()
    .min(10, 'Description must be at least 10 characters')
    .max(3000, 'Description must not exceed 3000 characters'),
  options: z.object({
    format: z.enum(['markdown', 'html', 'pdf', 'docx']).optional().default('markdown'),
    tone: z.enum(['professional', 'casual', 'technical', 'friendly']).optional().default('professional'),
    length: z.enum(['brief', 'detailed', 'comprehensive']).optional().default('detailed'),
    includeExamples: z.boolean().optional().default(true)
  }).optional().default({})
});

/**
 * Cost estimation request schema
 */
export const CostEstimationSchema = z.object({
  type: z.enum(['webapp', 'component', 'document']),
  complexity: z.enum(['simple', 'medium', 'complex']).optional().default('medium'),
  estimateOnly: z.boolean().optional().default(true)
});

/**
 * Unified generation request schema (accepts any type)
 */
export const GenerationRequestSchema = z.discriminatedUnion('type', [
  WebappGenerationSchema,
  ComponentGenerationSchema,
  DocumentGenerationSchema
]);

/**
 * Validate request against schema
 *
 * @param {object} data - Request data to validate
 * @param {z.ZodSchema} schema - Zod schema to validate against
 * @returns {object} Validation result { success: boolean, data?: object, errors?: array }
 */
export function validateRequest(data, schema) {
  try {
    const validated = schema.parse(data);
    return { success: true, data: validated };
  } catch (error) {
    if (error instanceof z.ZodError) {
      return {
        success: false,
        errors: error.errors.map(err => ({
          field: err.path.join('.'),
          message: err.message,
          code: err.code
        }))
      };
    }
    return {
      success: false,
      errors: [{ message: 'Validation failed', code: 'UNKNOWN_ERROR' }]
    };
  }
}

/**
 * Express middleware for request validation
 *
 * @param {z.ZodSchema} schema - Zod schema to validate against
 * @returns {Function} Express middleware function
 */
export function validateMiddleware(schema) {
  return (req, res, next) => {
    const result = validateRequest(req.body, schema);

    if (!result.success) {
      return res.status(400).json({
        error: {
          code: 'VALIDATION_ERROR',
          message: 'Request validation failed',
          details: result.errors
        }
      });
    }

    // Replace request body with validated data (includes defaults)
    req.body = result.data;
    next();
  };
}
