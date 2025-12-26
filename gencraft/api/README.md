# GenCraft API Server

Enterprise-grade REST API for GenCraft's Three Generator Engines.

## Overview

The GenCraft API provides programmatic access to three powerful AI generation engines:

1. **VibeSdk** - Cloudflare's webapp generator (webapps, components)
2. **SINDy-RL** - 82% cost optimization via intelligent model routing
3. **Document 07** - Meta-generation engine (planned for 2026-Q1)

## Features

### Security & Authentication
- ✅ JWT-based authentication with API keys
- ✅ Tiered access control (basic, pro, enterprise)
- ✅ Secure key hashing with bcrypt
- ✅ Helmet.js security headers
- ✅ CORS configuration

### Rate Limiting & Cost Control
- ✅ Per-tier rate limiting (100/1000/10000 requests per hour)
- ✅ Daily cost circuit breaker to prevent runaway expenses
- ✅ Per-engine daily limits
- ✅ Real-time usage tracking

### Developer Experience
- ✅ Request validation with Zod schemas
- ✅ Error translation (newbie-friendly messages)
- ✅ Structured logging with correlation IDs
- ✅ Health monitoring for all engines
- ✅ Comprehensive error handling

## Quick Start

### 1. Installation

```bash
cd /mnt/c/Users/jdh/claude_projects/gencraft/api
npm install
```

### 2. Configuration

Copy `.env.example` to `.env` and configure:

```bash
cp .env.example .env
nano .env
```

**Critical settings:**
- `JWT_SECRET` - Change this to a secure random string
- `PORT` - API server port (default: 3001)
- `NODE_ENV` - development or production

### 3. Generate API Key

```bash
node tools/generate-api-key.js "My App" pro 100.00
```

This will output:
```
═══════════════════════════════════════════════════════════
  API KEY (store this securely - it won't be shown again):
═══════════════════════════════════════════════════════════
  gk_pro_a1b2c3d4e5f6g7h8i9j0
═══════════════════════════════════════════════════════════
```

**⚠️ IMPORTANT**: Save this key securely - it cannot be retrieved later!

### 4. Start Server

```bash
# Development (with auto-reload)
npm run dev

# Production
npm start
```

Server will start on `http://localhost:3001`

## API Endpoints

### POST /api/v1/generate

Generate content using GenCraft engines.

**Request:**
```bash
curl -X POST http://localhost:3001/api/v1/generate \
  -H "Authorization: Bearer gk_pro_your_key_here" \
  -H "Content-Type: application/json" \
  -d '{
    "type": "webapp",
    "description": "A todo list app with dark mode",
    "options": {
      "framework": "react",
      "complexity": "medium",
      "styling": "tailwind"
    }
  }'
```

**Response:**
```json
{
  "id": "gen_1735200000_abc123",
  "type": "webapp",
  "engine": "vibesdk",
  "status": "completed",
  "output": {
    "code": "// Generated React code...",
    "files": [
      { "path": "src/App.js", "content": "..." }
    ],
    "framework": "react",
    "complexity": "medium"
  },
  "metadata": {
    "generatedAt": "2025-12-26T10:30:00Z",
    "cost": 0.15,
    "tokensUsed": 1500,
    "responseTime": "2.3s"
  }
}
```

### POST /api/v1/estimate-cost

Estimate cost before generation.

**Request:**
```bash
curl -X POST http://localhost:3001/api/v1/estimate-cost \
  -H "Authorization: Bearer gk_pro_your_key_here" \
  -H "Content-Type: application/json" \
  -d '{
    "type": "webapp",
    "complexity": "medium"
  }'
```

**Response:**
```json
{
  "type": "webapp",
  "complexity": "medium",
  "estimatedCost": 0.15,
  "estimatedTime": "15-30s",
  "currency": "USD",
  "breakdown": {
    "aiModelCost": 0.105,
    "processingCost": 0.03,
    "infrastructureCost": 0.015
  }
}
```

### GET /api/v1/health

Check engine health status.

**Request:**
```bash
curl http://localhost:3001/api/v1/health
```

**Response:**
```json
{
  "status": "healthy",
  "timestamp": "2025-12-26T10:30:00Z",
  "engines": {
    "vibesdk": {
      "name": "VibeSdk",
      "status": "operational",
      "responseTime": "2.3s",
      "lastSuccess": "2025-12-26T10:29:45Z"
    },
    "sindy-rl": {
      "name": "SINDy-RL",
      "status": "operational",
      "responseTime": "1.8s",
      "lastSuccess": "2025-12-26T10:29:50Z"
    },
    "document07": {
      "name": "Document 07",
      "status": "not_implemented",
      "message": "Planned for 2026-Q1"
    }
  },
  "api": {
    "version": "1.0.0",
    "uptime": 3600,
    "memoryUsage": {...}
  }
}
```

## Validation Schemas

### Webapp Generation

```typescript
{
  type: "webapp",
  description: string (10-5000 chars),
  options?: {
    framework?: "react" | "vue" | "svelte" | "nextjs" | "auto",
    complexity?: "simple" | "medium" | "complex",
    features?: string[],
    styling?: "tailwind" | "css" | "styled-components" | "auto",
    responsive?: boolean
  }
}
```

### Component Generation

```typescript
{
  type: "component",
  description: string (10-3000 chars),
  options?: {
    framework?: "react" | "vue" | "svelte" | "auto",
    typescript?: boolean,
    props?: Array<{ name: string, type: string, required?: boolean }>,
    styling?: "tailwind" | "css" | "styled-components" | "auto"
  }
}
```

### Document Generation

```typescript
{
  type: "document",
  description: string (10-3000 chars),
  options?: {
    format?: "markdown" | "html" | "pdf" | "docx",
    tone?: "professional" | "casual" | "technical" | "friendly",
    length?: "brief" | "detailed" | "comprehensive",
    includeExamples?: boolean
  }
}
```

## Error Handling

All errors follow a consistent structure with newbie-friendly translations:

```json
{
  "error": {
    "code": "GENERATION_FAILED",
    "message": "Generation failed",
    "technical": "VibeSdk engine timeout after 30s",
    "userFriendly": "The generator is taking longer than expected. This usually means the description was too complex. Try breaking it into smaller pieces.",
    "suggestion": "Split your request into 2-3 smaller components",
    "learnMore": "https://gencraft.dev/docs/generation-tips"
  }
}
```

### Common Error Codes

| Code | Meaning | Status |
|------|---------|--------|
| `MISSING_API_KEY` | No Authorization header | 401 |
| `INVALID_API_KEY` | Invalid or revoked key | 401 |
| `ENGINE_ACCESS_DENIED` | Tier doesn't allow engine | 403 |
| `RATE_LIMIT_EXCEEDED` | Too many requests | 429 |
| `DAILY_COST_LIMIT_EXCEEDED` | Daily cost limit hit | 429 |
| `ENGINE_DAILY_LIMIT_EXCEEDED` | Engine daily limit hit | 429 |
| `VALIDATION_ERROR` | Invalid request format | 400 |
| `GENERATION_FAILED` | Generation error | 500 |

## Access Tiers

### Basic ($10/month)
- 100 requests/hour
- $10 daily cost limit
- VibeSdk engine only
- Community support

### Pro ($50/month)
- 1000 requests/hour
- $100 daily cost limit
- VibeSdk + SINDy-RL engines
- 82% cost optimization
- Email support

### Enterprise (Custom pricing)
- 10,000 requests/hour
- Custom daily cost limit
- All engines (including Document07)
- Priority support
- SLA guarantee

## Rate Limits

| Tier | Requests/Hour | Daily Cost Limit | Engines |
|------|--------------|------------------|---------|
| Basic | 100 | $10 | VibeSdk |
| Pro | 1000 | $100 | VibeSdk, SINDy-RL |
| Enterprise | 10,000 | Custom | All |

### Per-Engine Daily Limits

| Engine | Basic | Pro | Enterprise |
|--------|-------|-----|------------|
| VibeSdk | Unlimited | Unlimited | Unlimited |
| SINDy-RL | N/A | 500/day | 1000/day |
| Document07 | N/A | N/A | 100/day |

## Monitoring & Logging

All requests are logged with structured JSON format:

```json
{
  "timestamp": "2025-12-26 10:30:00",
  "level": "INFO",
  "requestId": "req_abc123",
  "message": "Generation completed",
  "generationId": "gen_xyz789",
  "responseTime": 2300,
  "cost": 0.15,
  "keyId": "key_user123"
}
```

Logs are written to:
- Console (development)
- `logs/gencraft-api.log` (production, rotated at 10MB)

## Database

API uses SQLite for API key management and usage tracking.

**Location**: `data/gencraft-api.db`

**Tables**:
- `api_keys` - API key credentials and metadata
- `api_usage` - Individual request records
- `daily_usage_summary` - Aggregated daily stats (fast lookups)

## Development

### Project Structure

```
gencraft/api/
├── server.js                 # Main server
├── package.json
├── .env.example
├── config/
│   ├── logger.js            # Winston logger
│   └── database.js          # SQLite database
├── middleware/
│   ├── auth.js              # JWT authentication
│   ├── rateLimiter.js       # Rate limiting & cost control
│   └── requestId.js         # Correlation IDs
├── routes/
│   └── generateRoutes.js    # API routes
├── controllers/
│   └── generateController.js # Request handlers
├── utils/
│   ├── validation.js        # Zod schemas
│   └── healthCheck.js       # Engine monitoring
├── tools/
│   └── generate-api-key.js  # Key generation CLI
├── data/                    # SQLite database
└── logs/                    # Log files
```

### Adding New Endpoints

1. Define validation schema in `utils/validation.js`
2. Create controller in `controllers/`
3. Add route in `routes/`
4. Add middleware as needed
5. Update this README

### Testing

```bash
# Run test suite (when implemented)
npm test

# Manual testing
curl -X POST http://localhost:3001/api/v1/generate \
  -H "Authorization: Bearer YOUR_KEY" \
  -H "Content-Type: application/json" \
  -d '{"type":"component","description":"A button component"}'
```

## Deployment

### Production Checklist

- [ ] Set `NODE_ENV=production`
- [ ] Change `JWT_SECRET` to secure random string
- [ ] Configure proper `CORS_ORIGIN`
- [ ] Set up log rotation
- [ ] Configure reverse proxy (nginx)
- [ ] Enable HTTPS
- [ ] Set up monitoring (uptime, errors)
- [ ] Database backups

### Environment Variables

See `.env.example` for full list of configuration options.

## Security Best Practices

1. **Never commit `.env` file** - Contains secrets
2. **Rotate API keys regularly** - Revoke old keys
3. **Monitor usage patterns** - Detect abuse
4. **Rate limit aggressively** - Prevent DOS
5. **Keep dependencies updated** - `npm audit`

## Troubleshooting

### "Database is locked"
Multiple processes accessing SQLite simultaneously. Use WAL mode or PostgreSQL for production.

### "Rate limit exceeded"
Wait for rate limit window to reset (1 hour) or upgrade tier.

### "Engine timeout"
Description too complex. Break into smaller generations.

## Roadmap

- [ ] PostgreSQL support (production deployments)
- [ ] WebSocket support for streaming generation
- [ ] Webhook notifications
- [ ] OpenAPI/Swagger documentation
- [ ] Admin dashboard
- [ ] Usage analytics
- [ ] Multi-region deployment

## Support

- Documentation: https://gencraft.dev/docs/api
- Issues: https://github.com/groklygroup/gencraft/issues
- Email: support@gencraft.dev

## License

MIT License - see LICENSE file for details.

---

**Built with ❤️ by groklyGroup**
