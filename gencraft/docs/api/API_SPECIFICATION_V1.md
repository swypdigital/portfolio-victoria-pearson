# GenCraft v3.0 - API Specification v1.0
**RESTful API for Multi-Tenant AI Generation Platform**

**Document ID:** GENCRAFT-API-SPEC-V1
**Version:** 1.0.0
**Created:** December 26, 2025
**Author:** groklyGroup LLC
**Status:** Implementation Ready
**Base URL:** `https://api.gencraft.ai/v1`
**Copyright:** © 2025 groklyGroup LLC. All rights reserved.

---

## Table of Contents

1. [Authentication](#authentication)
2. [Core Endpoints](#core-endpoints)
3. [AIEN Endpoints](#aien-endpoints)
4. [SaleswriterCraft Endpoints](#saleswritercraft-endpoints)
5. [Admin Endpoints](#admin-endpoints)
6. [Error Handling](#error-handling)
7. [Rate Limiting](#rate-limiting)
8. [Webhooks](#webhooks)

---

## Authentication

### Bearer Token Authentication

All API requests must include an authentication token:

```http
Authorization: Bearer <access_token>
```

### Obtaining Access Token

**Endpoint:** `POST /auth/login`

**Request:**
```json
{
  "email": "user@example.com",
  "password": "secure_password"
}
```

**Response:**
```json
{
  "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "refresh_token": "refresh_token_here",
  "expires_in": 3600,
  "token_type": "Bearer",
  "user": {
    "id": "uuid-here",
    "email": "user@example.com",
    "role": "user",
    "tenant_id": "tenant-uuid"
  }
}
```

### Refresh Token

**Endpoint:** `POST /auth/refresh`

**Request:**
```json
{
  "refresh_token": "refresh_token_here"
}
```

---

## Core Endpoints

### GET /health
**Description:** Health check endpoint

**Response:**
```json
{
  "status": "healthy",
  "timestamp": "2025-12-26T12:00:00Z",
  "version": "1.0.0",
  "services": {
    "database": "healthy",
    "redis": "healthy",
    "aien": "healthy"
  }
}
```

---

### GET /me
**Description:** Get current user profile

**Headers:**
- `Authorization: Bearer <token>`

**Response:**
```json
{
  "id": "user-uuid",
  "email": "user@example.com",
  "full_name": "John Doe",
  "role": "user",
  "tenant": {
    "id": "tenant-uuid",
    "name": "Acme Corp",
    "slug": "acme-corp"
  },
  "subscription": {
    "tier": "pro",
    "tokens_remaining": 1500000,
    "allowed_verticals": ["SaleswriterCraft", "AppCraft", "ContentCraft"]
  }
}
```

---

### PATCH /me
**Description:** Update user profile

**Request:**
```json
{
  "full_name": "John Smith",
  "avatar_url": "https://example.com/avatar.jpg",
  "settings": {
    "theme": "dark",
    "notifications": true
  }
}
```

**Response:**
```json
{
  "id": "user-uuid",
  "email": "user@example.com",
  "full_name": "John Smith",
  "avatar_url": "https://example.com/avatar.jpg",
  "updated_at": "2025-12-26T12:00:00Z"
}
```

---

## AIEN Endpoints

### POST /aien/check
**Description:** Pre-flight check before generation (UX optimization, not security)

**Request:**
```json
{
  "prompt": "Write me a professional sales letter",
  "vertical": "SaleswriterCraft" // Optional hint
}
```

**Response (Allowed):**
```json
{
  "allowed": true,
  "vertical": "SaleswriterCraft",
  "feature": "generate_sales_letter",
  "confidence": 0.96,
  "estimated_tokens": 3500,
  "warnings": []
}
```

**Response (Denied):**
```json
{
  "allowed": false,
  "vertical": "SaleswriterCraft",
  "reason": "subscription_required",
  "message": "SaleswriterCraft requires Starter plan or higher",
  "upgrade_options": [
    {
      "tier": "starter",
      "price": 49.00,
      "features": ["SaleswriterCraft", "2 more verticals", "500K tokens/month"]
    }
  ],
  "alternatives": [
    {
      "vertical": "BasicWriter",
      "description": "Try our free basic writing tools"
    }
  ]
}
```

**Response (Soft Block):**
```json
{
  "allowed": "partial",
  "vertical": "SaleswriterCraft",
  "preview_mode": true,
  "preview_words": 100,
  "unlock_requirements": {
    "subscription": "starter",
    "estimated_cost_tokens": 3500
  }
}
```

---

### GET /aien/audit
**Description:** Get AIEN audit log (admin only)

**Query Parameters:**
- `start_date`: ISO 8601 date
- `end_date`: ISO 8601 date
- `user_id`: Filter by user
- `decision`: Filter by decision (allow, deny, soft_block)
- `vertical`: Filter by vertical
- `limit`: Results per page (default: 50, max: 200)
- `offset`: Pagination offset

**Response:**
```json
{
  "total": 1523,
  "results": [
    {
      "id": "audit-uuid",
      "timestamp": "2025-12-26T12:00:00Z",
      "user_id": "user-uuid",
      "prompt": "Write me a sales letter",
      "classified_vertical": "SaleswriterCraft",
      "confidence": 0.96,
      "decision": "allow",
      "decision_reason": "user_has_access",
      "processing_time_ms": 187
    }
  ],
  "pagination": {
    "limit": 50,
    "offset": 0,
    "has_more": true
  }
}
```

---

## SaleswriterCraft Endpoints

### POST /verticals/saleswriter/generate
**Description:** Generate sales content

**Request:**
```json
{
  "title": "Product Launch Sales Letter",
  "document_type": "sales_letter", // sales_letter, email_campaign, landing_page
  "prompt": "Write a compelling sales letter for a SaaS product that helps teams collaborate",
  "target_audience": "Small business owners",
  "product_name": "TeamSync Pro",
  "key_benefits": [
    "Real-time collaboration",
    "Unlimited file storage",
    "AI-powered insights"
  ],
  "template_id": "uuid-optional", // Use predefined template
  "options": {
    "tone": "professional", // professional, friendly, urgent
    "length": "medium", // short (300w), medium (800w), long (1500w)
    "include_cta": true,
    "cta_text": "Start Free Trial"
  }
}
```

**Response:**
```json
{
  "id": "document-uuid",
  "status": "generating",
  "estimated_completion_seconds": 30,
  "webhook_url": "https://api.gencraft.ai/v1/webhooks/completion/{document_id}"
}
```

---

### GET /verticals/saleswriter/documents/{id}
**Description:** Get generated document

**Response (Generating):**
```json
{
  "id": "document-uuid",
  "status": "generating",
  "progress": 45,
  "estimated_completion_seconds": 15
}
```

**Response (Completed):**
```json
{
  "id": "document-uuid",
  "status": "completed",
  "title": "Product Launch Sales Letter",
  "document_type": "sales_letter",
  "content": "# Unlock Seamless Team Collaboration\n\nDear Small Business Owner...",
  "word_count": 847,
  "tokens_used": 3421,
  "model_used": "gpt-4",
  "quality_score": 4.7,
  "generation_time_ms": 28543,
  "created_at": "2025-12-26T12:00:00Z",
  "completed_at": "2025-12-26T12:00:30Z",
  "export_options": {
    "pdf": "/api/v1/verticals/saleswriter/documents/{id}/export/pdf",
    "docx": "/api/v1/verticals/saleswriter/documents/{id}/export/docx",
    "html": "/api/v1/verticals/saleswriter/documents/{id}/export/html"
  }
}
```

---

### GET /verticals/saleswriter/documents
**Description:** List user's documents

**Query Parameters:**
- `status`: Filter by status (draft, generating, completed, failed)
- `document_type`: Filter by type
- `limit`: Results per page (default: 20)
- `offset`: Pagination offset
- `sort`: Sort order (created_desc, updated_desc, quality_desc)

**Response:**
```json
{
  "total": 147,
  "results": [
    {
      "id": "document-uuid-1",
      "title": "Product Launch Sales Letter",
      "document_type": "sales_letter",
      "status": "completed",
      "word_count": 847,
      "quality_score": 4.7,
      "created_at": "2025-12-26T12:00:00Z"
    }
  ],
  "pagination": {
    "limit": 20,
    "offset": 0,
    "has_more": true
  }
}
```

---

### POST /verticals/saleswriter/documents/{id}/revise
**Description:** Request revision/improvement

**Request:**
```json
{
  "revision_instructions": "Make the tone more urgent and add more statistics",
  "target_improvements": ["tone", "data_backing", "cta_strength"]
}
```

**Response:**
```json
{
  "id": "new-document-uuid",
  "parent_id": "original-document-uuid",
  "version": 2,
  "status": "generating"
}
```

---

### GET /verticals/saleswriter/documents/{id}/export/{format}
**Description:** Export document in specified format

**Formats:** `pdf`, `docx`, `html`, `txt`

**Response:** Binary file download

**Headers:**
```
Content-Type: application/pdf
Content-Disposition: attachment; filename="Product_Launch_Sales_Letter.pdf"
```

---

### DELETE /verticals/saleswriter/documents/{id}
**Description:** Archive document (soft delete)

**Response:**
```json
{
  "id": "document-uuid",
  "status": "archived",
  "archived_at": "2025-12-26T12:00:00Z"
}
```

---

## Admin Endpoints

### GET /admin/tenants
**Description:** List all tenants (god mode only)

**Response:**
```json
{
  "total": 1247,
  "results": [
    {
      "id": "tenant-uuid",
      "name": "Acme Corp",
      "slug": "acme-corp",
      "status": "active",
      "user_count": 47,
      "subscription_tier": "enterprise",
      "created_at": "2025-01-15T00:00:00Z"
    }
  ]
}
```

---

### POST /admin/tenants
**Description:** Create new tenant (god mode only)

**Request:**
```json
{
  "name": "New Corp",
  "slug": "new-corp",
  "admin_email": "admin@newcorp.com",
  "admin_password": "secure_password",
  "subscription_tier": "starter"
}
```

---

### GET /admin/analytics/overview
**Description:** Platform-wide analytics

**Response:**
```json
{
  "period": "last_30_days",
  "metrics": {
    "total_users": 12847,
    "active_users": 7234,
    "total_generations": 145723,
    "total_tokens_used": 423847392,
    "revenue_mrr": 487320,
    "churn_rate": 0.042
  },
  "top_verticals": [
    {"vertical": "SaleswriterCraft", "usage": 45231, "percentage": 31.0},
    {"vertical": "ContentCraft", "usage": 32847, "percentage": 22.5},
    {"vertical": "AppCraft", "usage": 28743, "percentage": 19.7}
  ]
}
```

---

## Error Handling

### Error Response Format

All errors follow this structure:

```json
{
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Invalid request parameters",
    "details": [
      {
        "field": "prompt",
        "message": "Prompt is required"
      }
    ],
    "request_id": "req_abc123",
    "timestamp": "2025-12-26T12:00:00Z"
  }
}
```

### Error Codes

| Code | HTTP Status | Description |
|------|-------------|-------------|
| `VALIDATION_ERROR` | 400 | Invalid request parameters |
| `AUTHENTICATION_REQUIRED` | 401 | Missing or invalid auth token |
| `FORBIDDEN` | 403 | User lacks required permissions |
| `NOT_FOUND` | 404 | Resource not found |
| `RATE_LIMIT_EXCEEDED` | 429 | Too many requests |
| `QUOTA_EXCEEDED` | 402 | Token quota exhausted |
| `SUBSCRIPTION_REQUIRED` | 402 | Upgrade required |
| `AIEN_BLOCKED` | 403 | AIEN enforcement denied access |
| `INTERNAL_ERROR` | 500 | Server error |
| `SERVICE_UNAVAILABLE` | 503 | Temporary service disruption |

---

## Rate Limiting

### Rate Limits by Tier

| Tier | Requests/Minute | Requests/Hour | Requests/Day |
|------|----------------|---------------|--------------|
| Free | 10 | 100 | 1,000 |
| Starter | 60 | 1,000 | 10,000 |
| Pro | 300 | 10,000 | 100,000 |
| Enterprise | Unlimited | Unlimited | Unlimited |

### Rate Limit Headers

```http
X-RateLimit-Limit: 60
X-RateLimit-Remaining: 42
X-RateLimit-Reset: 1640000000
```

### Rate Limit Error Response

```json
{
  "error": {
    "code": "RATE_LIMIT_EXCEEDED",
    "message": "Rate limit exceeded. Try again in 45 seconds.",
    "retry_after": 45
  }
}
```

---

## Webhooks

### Webhook Events

- `document.generating` - Generation started
- `document.completed` - Generation finished successfully
- `document.failed` - Generation failed
- `subscription.updated` - Subscription tier changed
- `quota.warning` - 90% token quota reached
- `quota.exceeded` - Token quota exhausted

### Webhook Payload

```json
{
  "event": "document.completed",
  "timestamp": "2025-12-26T12:00:30Z",
  "data": {
    "document_id": "document-uuid",
    "status": "completed",
    "word_count": 847,
    "tokens_used": 3421
  }
}
```

### Webhook Security

All webhooks include signature for verification:

```http
X-GenCraft-Signature: sha256=abc123...
```

**Verification:**
```javascript
const crypto = require('crypto');

function verifyWebhook(payload, signature, secret) {
  const hash = crypto
    .createHmac('sha256', secret)
    .update(JSON.stringify(payload))
    .digest('hex');

  return `sha256=${hash}` === signature;
}
```

---

## Pagination

All list endpoints support pagination:

**Query Parameters:**
- `limit`: Results per page (default: 20, max: 200)
- `offset`: Number of results to skip
- `cursor`: Cursor-based pagination (alternative to offset)

**Response:**
```json
{
  "results": [...],
  "pagination": {
    "limit": 20,
    "offset": 40,
    "total": 147,
    "has_more": true,
    "next_cursor": "cursor_abc123"
  }
}
```

---

## Filtering & Sorting

**Filters:**
```
GET /documents?status=completed&document_type=sales_letter
```

**Sorting:**
```
GET /documents?sort=created_desc,quality_desc
```

**Available Sort Fields:**
- `created_asc/desc` - Creation date
- `updated_asc/desc` - Last update
- `quality_asc/desc` - Quality score
- `word_count_asc/desc` - Document length

---

## Versioning

API versions are specified in the URL:

- Current: `https://api.gencraft.ai/v1`
- Future: `https://api.gencraft.ai/v2`

### Version Deprecation Policy

- New versions announced 6 months in advance
- Old versions supported for 12 months after deprecation
- Breaking changes only in new versions

---

**Document Version:** 1.0.0
**Last Updated:** December 26, 2025
**Author:** groklyGroup LLC
**Status:** Implementation Ready
**Copyright:** © 2025 groklyGroup LLC. All rights reserved.
