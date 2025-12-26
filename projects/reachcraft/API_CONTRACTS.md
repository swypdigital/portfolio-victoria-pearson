# ReachCraft API Contracts v1.0.0
# Master API contract document for all 6 parallel teams
# Generated: 2025-12-25

## 🔌 API Overview

**GraphQL Endpoint**: `https://api.reachcraft.io/graphql`
**WebSocket Endpoint**: `wss://api.reachcraft.io/graphql`
**REST Endpoint** (limited): `https://api.reachcraft.io/v1`

## 📋 Team Responsibilities

### Team 1: Infrastructure Foundation
**Delivers**: Database schema, Auth endpoints, Multi-tenant middleware
**Blocks**: All other teams
**Timeline**: Hours 1-12

### Team 2: Backend API
**Delivers**: GraphQL resolvers for schema
**Depends on**: Team 1 (database)
**Timeline**: Hours 13-24

### Team 3: Frontend UI
**Delivers**: React components consuming GraphQL
**Depends on**: GraphQL schema (not implementation)
**Timeline**: Hours 13-48

### Team 4: AI Engine
**Delivers**: Enrichment endpoints, Scoring algorithms
**Depends on**: Team 1 (database access)
**Timeline**: Hours 13-24

### Team 5: Browser Extension
**Delivers**: Chrome extension, OAuth callbacks
**Depends on**: None (independent)
**Timeline**: Hours 13-24

### Team 6: Marketplace
**Delivers**: Payment endpoints, Vertical configs
**Depends on**: Team 2 (contact API)
**Timeline**: Hours 25-36

---

## 🔐 Authentication Contracts

### Sign Up
```graphql
mutation SignUp {
  signUp(
    email: "user@example.com"
    password: "SecurePass123!"
    organizationName: "Acme Corp"
  ) {
    user {
      id
      email
      name
      role
    }
    organization {
      id
      name
      subscription {
        tier
      }
    }
    accessToken
    refreshToken
    expiresIn
  }
}
```

**Response**:
```json
{
  "data": {
    "signUp": {
      "user": {
        "id": "550e8400-e29b-41d4-a716-446655440001",
        "email": "user@example.com",
        "name": "John Doe",
        "role": "ADMIN"
      },
      "organization": {
        "id": "550e8400-e29b-41d4-a716-446655440002",
        "name": "Acme Corp",
        "subscription": {
          "tier": "FREE"
        }
      },
      "accessToken": "eyJhbGciOiJIUzI1NiIs...",
      "refreshToken": "eyJhbGciOiJIUzI1NiIs...",
      "expiresIn": 3600
    }
  }
}
```

### Sign In
```graphql
mutation SignIn {
  signIn(
    email: "user@example.com"
    password: "SecurePass123!"
  ) {
    user { id email }
    accessToken
    refreshToken
    expiresIn
  }
}
```

### OAuth Flow (Team 5)
```typescript
// Browser Extension initiates OAuth
GET /auth/oauth/linkedin?redirect_uri=chrome-extension://[extension-id]/callback

// Callback receives code
POST /auth/oauth/linkedin/callback
{
  "code": "AQEda...",
  "state": "random-state"
}

// Response
{
  "socialAccount": {
    "id": "550e8400...",
    "platform": "LinkedIn",
    "accountName": "John Doe",
    "permissions": ["read_profile", "read_contacts"]
  }
}
```

---

## 👥 Contact Management Contracts

### Create Contact (Team 2)
```graphql
mutation CreateContact {
  createContact(input: {
    firstName: "Jane"
    lastName: "Smith"
    email: "jane@example.com"
    company: "TechCorp"
    title: "VP of Sales"
    category: PROSPECT
    vertical: SALES
    autoEnrich: true
  }) {
    id
    fullName
    email
    enrichmentStatus
    leadScore
    buyerStage
  }
}
```

**Response**:
```json
{
  "data": {
    "createContact": {
      "id": "550e8400-e29b-41d4-a716-446655440003",
      "fullName": "Jane Smith",
      "email": "jane@example.com",
      "enrichmentStatus": "PROCESSING",
      "leadScore": 0,
      "buyerStage": "UNAWARE"
    }
  }
}
```

### Bulk Import Contacts
```graphql
mutation BulkImport {
  bulkCreateContacts(contacts: [
    { firstName: "John", lastName: "Doe", email: "john@example.com" },
    { firstName: "Jane", lastName: "Smith", email: "jane@example.com" }
  ]) {
    id
    fullName
    email
  }
}
```

### Search Contacts
```graphql
query SearchContacts {
  searchContacts(
    query: "VP Sales California"
    limit: 20
  ) {
    id
    fullName
    title
    company
    location
    leadScore
  }
}
```

### Filter Contacts
```graphql
query FilterContacts {
  contacts(
    filter: {
      categories: [PROSPECT]
      leadScores: [HOT, WARM]
      hasEmail: true
      createdAfter: "2024-01-01"
    }
    first: 50
  ) {
    edges {
      node {
        id
        fullName
        email
        leadScore
      }
    }
    totalCount
  }
}
```

---

## 🤖 AI Enrichment Contracts (Team 4)

### Enrich Single Contact
```graphql
mutation EnrichContact {
  enrichContact(id: "550e8400...") {
    id
    enrichmentStatus
    enrichmentData {
      companySize
      companyRevenue
      companyIndustry
      biography
      socialProfiles {
        platform
        profileUrl
        followers
      }
    }
    leadScore
    buyerStage
    intentSignals {
      type
      strength
      description
    }
  }
}
```

**Enrichment Webhook** (Async):
```json
POST /webhooks/enrichment-complete
{
  "contactId": "550e8400...",
  "enrichmentStatus": "COMPLETED",
  "enrichmentData": {
    "companySize": "100-500",
    "companyRevenue": "$10M-$50M",
    "companyIndustry": "Software",
    "twitterFollowers": 5420,
    "linkedinConnections": 500
  },
  "leadScore": 78,
  "buyerStage": "EVALUATION",
  "intentSignals": [
    {
      "type": "website_visit",
      "strength": "HIGH",
      "description": "Visited pricing page 3 times"
    }
  ]
}
```

### Auto-Scraping Configuration
```graphql
mutation ConfigureScraping {
  createWorkflow(input: {
    name: "Auto-scrape VPs"
    triggerType: "natural_language"
    triggerConfig: {
      prompt: "Find all VPs at Series B SaaS companies in California"
    }
    actions: [
      { type: "scrape_linkedin", order: 1 },
      { type: "enrich_contact", order: 2 },
      { type: "score_lead", order: 3 }
    ]
    isActive: true
  }) {
    id
    name
    isActive
  }
}
```

---

## 🛒 Marketplace Contracts (Team 6)

### Create Listing
```graphql
mutation CreateListing {
  createMarketplaceListing(input: {
    contactId: "550e8400..."
    title: "VP of Sales at $50M SaaS"
    description: "Verified email and phone..."
    price: 2.99
    category: PROSPECT
    vertical: SALES
    expiresInDays: 7
  }) {
    id
    title
    price
    status
    listedAt
    expiresAt
  }
}
```

### Purchase Lead
```graphql
mutation PurchaseLead {
  purchaseMarketplaceListing(
    listingId: "550e8400..."
  ) {
    id
    listing {
      contact {
        id
        fullName
        email
        phone
      }
    }
    price
    sellerRevenue
    platformFee
    paymentStatus
  }
}
```

**Stripe Payment Intent** (REST):
```json
POST /api/v1/payments/create-intent
{
  "listingId": "550e8400...",
  "amount": 299,
  "currency": "usd"
}

Response:
{
  "clientSecret": "pi_3KGsy..._secret_FowP...",
  "paymentIntentId": "pi_3KGsy..."
}
```

---

## 🌐 Browser Extension Contracts (Team 5)

### Extension Registration
```json
POST /api/v1/extension/register
{
  "extensionVersion": "1.0.0",
  "browser": "Chrome",
  "browserVersion": "120.0.0"
}

Response:
{
  "sessionId": "550e8400...",
  "userId": "550e8400...",
  "apiKey": "ext_live_..."
}
```

### Capture Contact
```json
POST /api/v1/extension/capture
{
  "sessionId": "550e8400...",
  "platform": "LinkedIn",
  "url": "https://linkedin.com/in/johndoe",
  "contactData": {
    "firstName": "John",
    "lastName": "Doe",
    "title": "VP Sales",
    "company": "TechCorp",
    "email": null,
    "profileImageUrl": "https://..."
  }
}

Response:
{
  "contact": {
    "id": "550e8400...",
    "status": "CAPTURED",
    "enrichmentTriggered": true
  },
  "catchFolder": {
    "totalContacts": 5,
    "needsReview": true
  }
}
```

### Catch Folder Review
```graphql
mutation ReviewCatchFolder {
  reviewCatchFolder(
    approve: ["id1", "id2", "id3"]
    reject: ["id4", "id5"]
  )
}
```

---

## ⚙️ Vertical Configuration (Team 6)

### Configure Vertical
```graphql
mutation ConfigureVertical {
  updateVerticalConfig(
    primaryVertical: RECRUITING
    enabledVerticals: [RECRUITING, SALES]
  ) {
    id
    primaryVertical
    enabledVerticals
    features {
      resumeParsing
      candidateTracking
      interviewScheduling
    }
  }
}
```

### Vertical-Specific Fields
```json
// Recruiting Vertical
{
  "customFields": {
    "resumeUrl": "https://...",
    "githubProfile": "johndoe",
    "portfolioUrl": "https://...",
    "desiredSalary": 150000,
    "yearsExperience": 5,
    "skills": ["React", "Node.js", "Python"]
  }
}

// Sales Vertical
{
  "customFields": {
    "dealSize": 50000,
    "budgetAuthority": true,
    "decisionMaker": true,
    "competitorUsing": "Salesforce",
    "painPoints": ["Manual processes", "No automation"]
  }
}

// Creator Vertical
{
  "customFields": {
    "followers": 50000,
    "engagement_rate": 3.5,
    "content_categories": ["Tech", "Business"],
    "sponsored_post_rate": 5000,
    "platforms": ["YouTube", "TikTok", "Instagram"]
  }
}
```

---

## 🔄 Real-time Subscriptions

### Contact Updates
```graphql
subscription ContactUpdates {
  contactUpdated(id: "550e8400...") {
    id
    enrichmentStatus
    leadScore
    buyerStage
    lastActivityAt
  }
}
```

### New Marketplace Listings
```graphql
subscription NewListings {
  newMarketplaceListing(
    vertical: SALES
    category: PROSPECT
  ) {
    id
    title
    price
    seller {
      name
    }
  }
}
```

---

## 📊 Response Status Codes

### GraphQL Standard
- `200 OK`: All GraphQL responses (check `errors` field)
- `401 Unauthorized`: Invalid/expired token
- `429 Too Many Requests`: Rate limited

### REST Endpoints
- `200 OK`: Success
- `201 Created`: Resource created
- `400 Bad Request`: Invalid input
- `401 Unauthorized`: Auth required
- `403 Forbidden`: Insufficient permissions
- `404 Not Found`: Resource not found
- `409 Conflict`: Duplicate resource
- `429 Too Many Requests`: Rate limited
- `500 Internal Server Error`: Server error

---

## 🔒 Security Headers

All API responses include:
```
X-Request-Id: 550e8400-e29b-41d4-a716-446655440000
X-Rate-Limit-Limit: 1000
X-Rate-Limit-Remaining: 999
X-Rate-Limit-Reset: 1640995200
X-Response-Time: 125ms
Content-Security-Policy: default-src 'self'
X-Frame-Options: DENY
X-Content-Type-Options: nosniff
```

---

## 🧪 Mock Server (Team 3 Frontend)

Frontend team uses MSW (Mock Service Worker) with this configuration:

```typescript
// mocks/handlers.ts
import { graphql } from 'msw'

export const handlers = [
  graphql.mutation('CreateContact', (req, res, ctx) => {
    return res(
      ctx.data({
        createContact: {
          id: faker.string.uuid(),
          fullName: `${req.variables.input.firstName} ${req.variables.input.lastName}`,
          email: req.variables.input.email,
          enrichmentStatus: 'PENDING',
          leadScore: faker.number.int({ min: 0, max: 100 }),
          buyerStage: faker.helpers.arrayElement(['UNAWARE', 'PROBLEM_AWARE', 'EVALUATION'])
        }
      })
    )
  }),

  graphql.query('FilterContacts', (req, res, ctx) => {
    const contacts = Array.from({ length: 20 }, () => ({
      id: faker.string.uuid(),
      fullName: faker.person.fullName(),
      email: faker.internet.email(),
      leadScore: faker.number.int({ min: 0, max: 100 })
    }))

    return res(
      ctx.data({
        contacts: {
          edges: contacts.map(node => ({ node, cursor: btoa(node.id) })),
          totalCount: 245
        }
      })
    )
  })
]
```

---

## 📦 Data Formats

### Dates
- ISO 8601: `2024-01-15T14:30:00Z`
- Timezone: UTC unless specified

### Money
- Cents as integers: `299` = $2.99
- Currency: USD default

### Phone Numbers
- E.164 format: `+14155551234`

### UUIDs
- Version 4: `550e8400-e29b-41d4-a716-446655440000`

### Pagination
- Cursor-based (not offset)
- Default limit: 20
- Max limit: 100

---

## 🚀 Deployment URLs

### Development
- Frontend: `http://localhost:3000`
- Backend: `http://localhost:4000`
- GraphQL Playground: `http://localhost:4000/graphql`

### Staging
- Frontend: `https://staging.reachcraft.io`
- API: `https://api-staging.reachcraft.io`

### Production
- Frontend: `https://app.reachcraft.io`
- API: `https://api.reachcraft.io`
- Docs: `https://docs.reachcraft.io`

---

## ✅ Integration Test Suite

Each team must pass these integration tests:

### Team 1: Infrastructure
```bash
✓ Database connects and migrations run
✓ Auth endpoints return valid JWTs
✓ Multi-tenant RLS policies enforce isolation
✓ Feature flags system works
```

### Team 2: Backend API
```bash
✓ All GraphQL queries resolve without errors
✓ Mutations update database correctly
✓ Subscriptions emit events
✓ Rate limiting enforced
```

### Team 3: Frontend
```bash
✓ Pages render without errors
✓ Forms submit and validate
✓ Real-time updates display
✓ Responsive design works
```

### Team 4: AI Engine
```bash
✓ Enrichment processes contacts
✓ Lead scoring returns 0-100 values
✓ Intent detection identifies signals
✓ Auto-scraping extracts data
```

### Team 5: Browser Extension
```bash
✓ Extension installs in Chrome
✓ OAuth flow completes
✓ Contact capture from LinkedIn works
✓ Catch folder syncs
```

### Team 6: Marketplace
```bash
✓ Listings create successfully
✓ Stripe payments process
✓ Revenue share calculates correctly
✓ Vertical configs apply
```

---

## 📞 Team Sync Points

### Sync 1: Foundation Complete (Hour 12)
```javascript
// Team 1 provides:
{
  databaseUrl: "postgresql://...",
  supabaseUrl: "https://xxx.supabase.co",
  supabaseAnonKey: "eyJhbGc...",
  apiUrl: "http://localhost:4000"
}
```

### Sync 2: API Ready (Hour 24)
```javascript
// Team 2 provides:
{
  graphqlEndpoint: "http://localhost:4000/graphql",
  wsEndpoint: "ws://localhost:4000/graphql",
  playgroundUrl: "http://localhost:4000/graphql"
}
```

### Sync 3: Integration (Hour 48)
```javascript
// All teams provide:
{
  teamName: "Frontend",
  status: "READY",
  testsPass: true,
  blockers: []
}
```

---

**Document Complete: 500+ lines of API contracts**
**All 6 teams can now build independently against these contracts**