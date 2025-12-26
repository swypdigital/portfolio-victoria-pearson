# GenCraft v3.0 - Document Management & Dependency System
**Version**: 1.0.0
**Created**: 2025-12-01
**Status**: MANDATORY - Core Infrastructure
**Author**: System Architecture Team

---

## 🎯 EXECUTIVE SUMMARY

The Document Management & Dependency System is the foundational infrastructure for GenCraft v3.0's knowledge management, version control, and platform evolution. This system ensures:

- **Complete Version History**: Git-like storage with infinite retention
- **Intelligent Lineage Tracking**: 4 types of relationships (temporal, hierarchical, inheritance, dependency)
- **Auto-Deprecation Workflow**: Zero manual intervention (publish → 90 days → archive)
- **Multi-Level Rollback**: Document, vertical, platform, and point-in-time recovery
- **Legal Compliance**: Subpoena-ready with immutable audit trails
- **Template-Based Inheritance**: Golden source templates → vertical instances
- **User-Friendly Feedback**: Context-aware limits (pages/minutes, not MB)

---

## 📋 TABLE OF CONTENTS

1. [File Naming Protocol](#file-naming-protocol)
2. [Document Types & Classification](#document-types--classification)
3. [Versioning Strategy](#versioning-strategy)
4. [Golden Source Architecture](#golden-source-architecture)
5. [Storage Architecture](#storage-architecture)
6. [Lineage Tracking](#lineage-tracking)
7. [Auto-Deprecation Workflow](#auto-deprecation-workflow)
8. [Rollback Capabilities](#rollback-capabilities)
9. [Legal Compliance & Retention](#legal-compliance--retention)
10. [User Upload Limits & Feedback](#user-upload-limits--feedback)
11. [Database Schema](#database-schema)
12. [Implementation Roadmap](#implementation-roadmap)

---

## 1. FILE NAMING PROTOCOL

### 1.1 Standard Format

```
<DOCTYPE>_v<GENCRAFT_VERSION>_<VERTICAL>_<DESCRIPTION>_<DOC_VERSION>.<EXT>
```

### 1.2 Component Breakdown

| Component | Description | Format | Examples |
|-----------|-------------|--------|----------|
| **DOCTYPE** | Document type code | `DOC00`, `DOC01-06`, `DOC07`, `DOCxx` | `DOC01`, `DOC02` |
| **GENCRAFT_VERSION** | GenCraft platform version | `v3.0.0`, `v3.1.2`, `v4.0.0` | `v3.0.0` |
| **VERTICAL** | Product vertical | `gencraft`, `newslettercraft`, `blogcraft` | `gencraft` |
| **DESCRIPTION** | Semantic name (lowercase, underscores) | `architecture`, `pricing_model` | `architecture` |
| **DOC_VERSION** | Document semantic version | `1.0.0`, `1.2.3`, `2.0.0` | `1.0.0` |
| **EXT** | File extension | `md`, `pdf`, `json`, `yaml` | `md` |

### 1.3 Complete Examples

```
DOC01_v3.0.0_gencraft_architecture_1.0.0.md
DOC02_v3.0.0_gencraft_pricing_model_1.0.0.md
DOC03_v3.1.2_newslettercraft_schema_2.1.0.json
DOC04_v4.0.0_blogcraft_workflow_3.0.0.md
DOC00_v3.0.0_gencraft_master_plan_1.5.0.md
```

### 1.4 Document Type Codes

| Code | Purpose | Example |
|------|---------|---------|
| **DOC00** | Master planning documents | Master rebuild plan, roadmap |
| **DOC01** | Architecture documents | System architecture, component design |
| **DOC02** | Business logic documents | Pricing models, workflows |
| **DOC03** | Schema/data documents | Database schemas, API contracts |
| **DOC04** | Process documents | Workflows, procedures |
| **DOC05** | Requirements documents | User stories, specifications |
| **DOC06** | Implementation documents | Code documentation, guides |
| **DOC07** | Legal/compliance documents | Terms of service, privacy policy |
| **DOCxx** | Custom vertical-specific | Varies by vertical needs |

### 1.5 Version Increment Rules

**GenCraft Version** (Platform-level):
- **Major (v3 → v4)**: Breaking changes to platform architecture
- **Minor (v3.0 → v3.1)**: New features, backward compatible
- **Patch (v3.0.0 → v3.0.1)**: Bug fixes, small improvements

**Document Version** (Document-level):
- **Major (1.x.x → 2.x.x)**: Complete restructure, incompatible changes
- **Minor (1.0.x → 1.1.x)**: New sections, enhanced content
- **Patch (1.0.0 → 1.0.1)**: Typo fixes, clarifications

---

## 2. DOCUMENT TYPES & CLASSIFICATION

### 2.1 Document Hierarchy

```
GenCraft Platform (v3.0.0)
├── GenCraft Vertical
│   ├── DOC00: Master Plan
│   ├── DOC01: Architecture
│   ├── DOC02: Business Logic
│   ├── DOC03: Schemas
│   └── ...
├── NewsletterCraft Vertical
│   ├── DOC00: NewsletterCraft Plan
│   ├── DOC01: NewsletterCraft Architecture
│   └── ...
└── BlogCraft Vertical
    ├── DOC00: BlogCraft Plan
    └── ...
```

### 2.2 Template vs Instance Classification

| Type | Purpose | Scope | Inheritance |
|------|---------|-------|-------------|
| **Template** | GenCraft golden source | Platform-wide | Templates define structure |
| **Instance** | Vertical-specific implementation | Single vertical | Instances inherit from templates |

**Example**:
- **Template**: `DOC01_v3.0.0_gencraft_architecture_1.0.0.md` (defines architecture pattern)
- **Instance**: `DOC01_v3.0.0_newslettercraft_architecture_1.0.0.md` (implements pattern for newsletters)

### 2.3 Metadata Classification

Every document includes YAML front matter:

```yaml
---
document_id: "DOC01"
gencraft_version: "3.0.0"
vertical: "gencraft"
document_version: "1.0.0"
document_type: "template"  # or "instance"
template_parent: null      # or "DOC01_v3.0.0_gencraft_architecture_1.0.0.md"
status: "published"        # draft, published, deprecated, archived
created_at: "2025-12-01T10:00:00Z"
updated_at: "2025-12-01T10:00:00Z"
deprecated_at: null
archived_at: null
author: "System"
reviewers: ["User", "AI"]
tags: ["architecture", "core", "v3"]
dependencies:
  - "DOC00_v3.0.0_gencraft_master_plan_1.0.0.md"
  - "DOC02_v3.0.0_gencraft_pricing_model_1.0.0.md"
lineage:
  parent_version: null
  child_versions: []
  template_source: null
  instances: []
checksum: "sha256:abc123..."
---
```

---

## 3. VERSIONING STRATEGY

### 3.1 Dual Versioning Model

GenCraft uses **dual semantic versioning**:

1. **GenCraft Platform Version** (`v3.0.0`): Entire platform release
2. **Document Version** (`1.0.0`): Individual document evolution

**Why Dual Versioning?**
- **Platform Version**: Tracks which GenCraft release the document applies to
- **Document Version**: Tracks changes to the document itself over time
- **Compatibility Matrix**: Know exactly which documents work with which platform versions

### 3.2 Version Evolution Examples

**Scenario 1: Platform Upgrade**
```
GenCraft v3.0.0 → v3.1.0 (new features added)

Before:
DOC01_v3.0.0_gencraft_architecture_1.0.0.md

After:
DOC01_v3.1.0_gencraft_architecture_1.0.0.md  (platform version updated)
DOC01_v3.0.0_gencraft_architecture_1.0.0.md  (archived, still available)
```

**Scenario 2: Document Update**
```
Architecture document refined (no platform changes)

Before:
DOC01_v3.0.0_gencraft_architecture_1.0.0.md

After:
DOC01_v3.0.0_gencraft_architecture_1.1.0.md  (document version updated)
DOC01_v3.0.0_gencraft_architecture_1.0.0.md  (deprecated, then archived)
```

**Scenario 3: Both Update**
```
Platform upgrade + major architecture rewrite

Before:
DOC01_v3.0.0_gencraft_architecture_1.5.0.md

After:
DOC01_v4.0.0_gencraft_architecture_2.0.0.md  (both versions updated)
DOC01_v3.0.0_gencraft_architecture_1.5.0.md  (archived forever)
```

### 3.3 Version Compatibility Matrix

| Platform Version | Document Versions | Status |
|------------------|-------------------|--------|
| v3.0.0 | DOC01 v1.0.0 - v1.9.9 | Archived |
| v3.1.0 | DOC01 v1.10.0 - v1.15.0 | Deprecated |
| v3.2.0 | DOC01 v1.16.0 - v2.0.5 | Published |
| v4.0.0 | DOC01 v2.1.0+ | Active Development |

---

## 4. GOLDEN SOURCE ARCHITECTURE

### 4.1 Strategy A: Template-Based Inheritance (SELECTED)

**Concept**: GenCraft documents are **templates**, vertical documents are **instances** that inherit structure and patterns.

**Architecture**:
```
┌─────────────────────────────────────┐
│ GENCRAFT GOLDEN SOURCE (Template)  │
│ DOC01_v3.0.0_gencraft_arch_1.0.0   │
│                                     │
│ - Defines structure                 │
│ - Establishes patterns              │
│ - Sets standards                    │
└──────────────┬──────────────────────┘
               │ INHERITS FROM
               ├──────────────────────┐
               │                      │
┌──────────────▼─────────┐  ┌────────▼──────────────┐
│ NEWSLETTERCRAFT        │  │ BLOGCRAFT             │
│ Instance               │  │ Instance              │
│ DOC01_v3.0.0_news...   │  │ DOC01_v3.0.0_blog...  │
│                        │  │                       │
│ - Implements template  │  │ - Implements template │
│ - Adds vertical logic  │  │ - Adds vertical logic │
└────────────────────────┘  └───────────────────────┘
```

### 4.2 Template Rules

**Templates MUST**:
1. Define structure (sections, headings, required fields)
2. Establish patterns (naming conventions, formats)
3. Set quality standards (validation rules, constraints)
4. Remain platform-agnostic (no vertical-specific logic)

**Instances MUST**:
1. Reference their template parent in metadata
2. Inherit structure from template
3. Add vertical-specific implementation
4. Maintain compatibility with template version

### 4.3 Template Update Propagation

**When a template updates**:
```typescript
interface TemplatePropagation {
  trigger: 'template_published';
  template: 'DOC01_v3.0.0_gencraft_architecture_2.0.0.md';
  action: 'notify_instances';
  instances: [
    'DOC01_v3.0.0_newslettercraft_architecture_1.5.0.md',
    'DOC01_v3.0.0_blogcraft_architecture_1.2.0.md'
  ];
  recommendation: 'Update instances to match new template structure';
  auto_update: false;  // Manual review required for breaking changes
  compatibility_check: true;
}
```

**Propagation Workflow**:
1. Template published (e.g., GenCraft Architecture v2.0.0)
2. System identifies all instances inheriting from this template
3. System performs compatibility analysis (breaking vs non-breaking)
4. **Non-breaking changes**: Auto-suggest updates to instances
5. **Breaking changes**: Flag instances as "template incompatible", require manual migration
6. All changes logged in lineage tracking

### 4.4 Golden Source Metadata

```yaml
---
document_type: "template"
template_version: "1.0.0"
instances:
  - vertical: "newslettercraft"
    document: "DOC01_v3.0.0_newslettercraft_architecture_1.0.0.md"
    compatibility: "compatible"
    last_synced: "2025-12-01T10:00:00Z"
  - vertical: "blogcraft"
    document: "DOC01_v3.0.0_blogcraft_architecture_1.0.0.md"
    compatibility: "incompatible"  # Breaking change detected
    last_synced: "2025-11-20T08:00:00Z"
    migration_required: true
template_rules:
  - "All instances must include 'System Architecture' section"
  - "All instances must use semantic versioning"
  - "All instances must define scalability requirements"
---
```

---

## 5. STORAGE ARCHITECTURE

### 5.1 Git-Like Hybrid Storage

**Principle**: Current version on disk (fast access), complete history in S3 + Database (archived)

**Architecture**:
```
┌─────────────────────────────────────────────────────────┐
│ FILE SYSTEM (Current Version Only)                     │
│ /gencraft-v3.0/documents/                              │
│   DOC01_v3.0.0_gencraft_architecture_2.0.0.md  ← LIVE  │
└─────────────────────────────────────────────────────────┘
                      │
                      │ PUBLISH EVENT
                      ▼
┌─────────────────────────────────────────────────────────┐
│ DATABASE (Metadata + Lineage)                          │
│ ┌─────────────────────────────────────────────────────┐ │
│ │ documents table                                     │ │
│ │ - id: DOC01_v3.0.0_gencraft_architecture_2.0.0     │ │
│ │ - status: published                                │ │
│ │ - created_at, updated_at                           │ │
│ └─────────────────────────────────────────────────────┘ │
│ ┌─────────────────────────────────────────────────────┐ │
│ │ document_versions table                            │ │
│ │ - version 1.0.0 (status: archived)                 │ │
│ │ - version 1.5.0 (status: deprecated)               │ │
│ │ - version 2.0.0 (status: published)  ← CURRENT     │ │
│ └─────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────┘
                      │
                      │ ARCHIVE
                      ▼
┌─────────────────────────────────────────────────────────┐
│ S3 BLOB STORAGE (Complete History)                     │
│ s3://gencraft-docs/DOC01/gencraft/                     │
│   v1.0.0/content.md          (Hot → Warm → Cold)      │
│   v1.5.0/content.md          (Hot → Warm → Cold)      │
│   v2.0.0/content.md          (Hot - Current)          │
└─────────────────────────────────────────────────────────┘
```

### 5.2 Storage Tier Lifecycle

| Tier | Location | Access Speed | Cost | Retention | Use Case |
|------|----------|--------------|------|-----------|----------|
| **Hot** | Disk + S3 Standard | <10ms | $$$$ | Current version | Active use |
| **Warm** | S3 Standard | <100ms | $$$ | 0-90 days deprecated | Recent history |
| **Cold** | S3 Glacier | Minutes | $$ | 90 days - 7 years | Legal compliance |
| **Frozen** | S3 Deep Glacier | Hours | $ | 7+ years | Long-term archive |

### 5.3 Storage Transition Workflow

```typescript
interface StorageLifecycle {
  published: {
    disk: true,
    s3_tier: 'standard',
    database: 'active',
    access: 'instant'
  },
  deprecated: {
    disk: false,           // Removed from disk after publish
    s3_tier: 'standard',   // Warm storage
    database: 'historical',
    access: 'fast',
    days_remaining: 90
  },
  archived: {
    disk: false,
    s3_tier: 'glacier',    // Cold storage after 90 days
    database: 'archived',
    access: 'slow',
    retention: 'forever'
  },
  frozen: {
    disk: false,
    s3_tier: 'deep_glacier',  // After 7 years
    database: 'archived',
    access: 'very_slow',
    retention: 'forever'
  }
}
```

### 5.4 Publish Event Flow

**When publishing a new document version**:

```bash
# Step 1: Archive current version
1. Read current version from disk: DOC01_v3.0.0_gencraft_architecture_1.0.0.md
2. Upload to S3: s3://gencraft-docs/DOC01/gencraft/v1.0.0/content.md
3. Update database: SET status='deprecated', deprecated_at=NOW()
4. Remove from disk (keep only in S3 + DB)

# Step 2: Publish new version
5. Write new version to disk: DOC01_v3.0.0_gencraft_architecture_2.0.0.md
6. Upload to S3: s3://gencraft-docs/DOC01/gencraft/v2.0.0/content.md
7. Insert to database: status='published', created_at=NOW()
8. Update lineage: parent_version='1.0.0', child_versions=[]

# Step 3: Update metadata
9. Update template instances (if template)
10. Update dependency graph
11. Generate audit log entry
12. Notify subscribers (if any)
```

---

## 6. LINEAGE TRACKING

### 6.1 Four Types of Lineage

GenCraft tracks **4 distinct types** of lineage relationships:

| Type | Purpose | Example |
|------|---------|---------|
| **Temporal** | Version history over time | v1.0.0 → v1.5.0 → v2.0.0 |
| **Hierarchical** | Document tree structure | Master Plan → Architecture → Schema |
| **Inheritance** | Template → Instance | GenCraft template → NewsletterCraft instance |
| **Dependency** | Cross-document references | Architecture depends on Pricing Model |

### 6.2 Temporal Lineage

**Tracks document evolution over time**:

```
DOC01_v3.0.0_gencraft_architecture_1.0.0.md (2025-01-01)
    ↓ Minor update
DOC01_v3.0.0_gencraft_architecture_1.1.0.md (2025-02-15)
    ↓ Patch fix
DOC01_v3.0.0_gencraft_architecture_1.1.1.md (2025-03-01)
    ↓ Major rewrite
DOC01_v3.0.0_gencraft_architecture_2.0.0.md (2025-06-01) ← CURRENT
```

**Database Representation**:
```sql
CREATE TABLE temporal_lineage (
    id UUID PRIMARY KEY,
    document_id VARCHAR(255) NOT NULL,
    version VARCHAR(50) NOT NULL,
    previous_version VARCHAR(50),  -- NULL for first version
    next_version VARCHAR(50),      -- NULL for current version
    change_type VARCHAR(50),       -- 'major', 'minor', 'patch'
    change_summary TEXT,
    created_at TIMESTAMP,
    UNIQUE(document_id, version)
);
```

### 6.3 Hierarchical Lineage

**Tracks document tree relationships**:

```
DOC00_gencraft_master_plan (ROOT)
├── DOC01_gencraft_architecture
│   ├── DOC01_newslettercraft_architecture
│   └── DOC01_blogcraft_architecture
├── DOC02_gencraft_pricing_model
│   ├── DOC02_newslettercraft_pricing
│   └── DOC02_blogcraft_pricing
└── DOC03_gencraft_schema
    └── DOC03_newslettercraft_schema
```

**Database Representation**:
```sql
CREATE TABLE hierarchical_lineage (
    id UUID PRIMARY KEY,
    document_id VARCHAR(255) NOT NULL,
    parent_id VARCHAR(255),        -- NULL for root documents
    depth INTEGER,                 -- 0 for root, 1 for children, etc.
    path LTREE,                    -- PostgreSQL ltree for efficient queries
    created_at TIMESTAMP,
    UNIQUE(document_id)
);

-- Example ltree paths:
-- Root:  'DOC00'
-- Child: 'DOC00.DOC01'
-- Grand: 'DOC00.DOC01.DOC01_newsletter'
```

### 6.4 Inheritance Lineage

**Tracks template → instance relationships**:

```
TEMPLATE: DOC01_v3.0.0_gencraft_architecture_2.0.0.md
    ↓ inherits structure
INSTANCE: DOC01_v3.0.0_newslettercraft_architecture_1.0.0.md
    ↓ inherits structure
INSTANCE: DOC01_v3.0.0_blogcraft_architecture_1.0.0.md
```

**Database Representation**:
```sql
CREATE TABLE inheritance_lineage (
    id UUID PRIMARY KEY,
    instance_id VARCHAR(255) NOT NULL,
    template_id VARCHAR(255) NOT NULL,
    template_version VARCHAR(50) NOT NULL,
    instance_version VARCHAR(50) NOT NULL,
    compatibility_status VARCHAR(50), -- 'compatible', 'incompatible', 'unknown'
    last_synced_at TIMESTAMP,
    migration_required BOOLEAN,
    created_at TIMESTAMP,
    UNIQUE(instance_id, template_id)
);
```

### 6.5 Dependency Lineage

**Tracks cross-document references**:

```
DOC01_gencraft_architecture
    ├─ DEPENDS ON → DOC00_gencraft_master_plan
    ├─ DEPENDS ON → DOC02_gencraft_pricing_model
    └─ DEPENDS ON → DOC03_gencraft_schema

DOC02_gencraft_pricing_model
    └─ DEPENDS ON → DOC00_gencraft_master_plan
```

**Database Representation**:
```sql
CREATE TABLE dependency_lineage (
    id UUID PRIMARY KEY,
    source_document_id VARCHAR(255) NOT NULL,
    target_document_id VARCHAR(255) NOT NULL,
    dependency_type VARCHAR(50),    -- 'hard', 'soft', 'optional'
    description TEXT,
    created_at TIMESTAMP,
    UNIQUE(source_document_id, target_document_id)
);

-- Dependency types:
-- 'hard': Breaking change if target changes
-- 'soft': Warning if target changes
-- 'optional': Informational only
```

### 6.6 Combined Lineage Query

**Example: Get complete lineage for a document**

```sql
WITH RECURSIVE lineage_tree AS (
    -- Temporal lineage
    SELECT 'temporal' as lineage_type,
           version,
           previous_version,
           next_version
    FROM temporal_lineage
    WHERE document_id = 'DOC01_v3.0.0_gencraft_architecture'

    UNION ALL

    -- Hierarchical lineage
    SELECT 'hierarchical',
           document_id,
           parent_id,
           depth
    FROM hierarchical_lineage
    WHERE document_id = 'DOC01_v3.0.0_gencraft_architecture'

    UNION ALL

    -- Inheritance lineage
    SELECT 'inheritance',
           instance_id,
           template_id,
           compatibility_status
    FROM inheritance_lineage
    WHERE instance_id = 'DOC01_v3.0.0_gencraft_architecture'
       OR template_id = 'DOC01_v3.0.0_gencraft_architecture'

    UNION ALL

    -- Dependency lineage
    SELECT 'dependency',
           source_document_id,
           target_document_id,
           dependency_type
    FROM dependency_lineage
    WHERE source_document_id = 'DOC01_v3.0.0_gencraft_architecture'
       OR target_document_id = 'DOC01_v3.0.0_gencraft_architecture'
)
SELECT * FROM lineage_tree;
```

---

## 7. AUTO-DEPRECATION WORKFLOW

### 7.1 Deprecation Lifecycle

**Zero manual intervention - fully automated**:

```
┌──────────────┐  Publish    ┌──────────────┐  90 Days   ┌──────────────┐
│  PUBLISHED   │ ───────────> │  DEPRECATED  │ ────────> │   ARCHIVED   │
│              │              │              │            │              │
│ - On disk    │              │ - S3 only    │            │ - S3 Glacier │
│ - S3 Hot     │              │ - S3 Warm    │            │ - Forever    │
│ - Actively   │              │ - Available  │            │ - Legal hold │
│   used       │              │   on demand  │            │   possible   │
└──────────────┘              └──────────────┘            └──────────────┘
       ↑                             │                           │
       │                             │ 7 Years                   │
       │                             └──────────────────────────>│
       │                                                          ▼
       │                                                   ┌──────────────┐
       │                                                   │    FROZEN    │
       │                                                   │              │
       │                                                   │ - Deep       │
       │                                                   │   Glacier    │
       │                                                   │ - Permanent  │
       └───────────────────────────────────────────────────┤   archive    │
                          ROLLBACK (Admin only)            └──────────────┘
```

### 7.2 Status Definitions

| Status | Description | Storage | Access | Actions Allowed |
|--------|-------------|---------|--------|-----------------|
| **Draft** | Work in progress | Disk only | Edit, preview | Save, publish, delete |
| **Published** | Current active version | Disk + S3 Hot | Read, reference | Deprecate (publish new) |
| **Deprecated** | Superseded, 90-day window | S3 Warm | Read only | Archive (auto after 90 days) |
| **Archived** | Historical record | S3 Glacier | Slow read | Freeze (auto after 7 years) |
| **Frozen** | Permanent archive | S3 Deep Glacier | Very slow read | None (immutable) |

### 7.3 Auto-Deprecation Triggers

**Automatic deprecation occurs when**:

```typescript
interface DeprecationTrigger {
    trigger_type: 'new_version_published';
    source_event: {
        document_id: 'DOC01_v3.0.0_gencraft_architecture',
        old_version: '1.0.0',
        new_version: '2.0.0',
        published_at: '2025-12-01T10:00:00Z'
    };
    auto_actions: [
        {
            action: 'deprecate_old_version',
            document: 'DOC01_v3.0.0_gencraft_architecture_1.0.0.md',
            new_status: 'deprecated',
            deprecated_at: '2025-12-01T10:00:00Z',
            archive_scheduled_at: '2026-03-01T10:00:00Z'  // 90 days later
        },
        {
            action: 'move_to_warm_storage',
            s3_transition: 'hot -> warm',
            remove_from_disk: true
        },
        {
            action: 'update_references',
            notify_dependents: true,
            affected_documents: [
                'DOC02_v3.0.0_gencraft_pricing_1.0.0.md',
                'DOC03_v3.0.0_newslettercraft_architecture_1.0.0.md'
            ]
        }
    ]
}
```

### 7.4 90-Day Deprecation Window

**Why 90 days?**
- **Industry Standard**: Most SaaS platforms use 60-90 day deprecation windows
- **User Transition**: Sufficient time for users to migrate to new version
- **Legal Compliance**: Meets most regulatory requirements for change notification
- **Cost Optimization**: Balances storage costs vs availability needs

**During 90-day window**:
1. **Days 0-30**: "Recently deprecated" - easily accessible, warn users
2. **Days 31-60**: "Deprecation notice" - prompt migration to new version
3. **Days 61-90**: "Final notice" - last chance before archival
4. **Day 91**: Automatic transition to archived status (S3 Glacier)

### 7.5 Automated Archival Process

**Runs daily at 2:00 AM UTC**:

```sql
-- Daily archival job
WITH deprecated_documents AS (
    SELECT id, document_id, version, deprecated_at
    FROM document_versions
    WHERE status = 'deprecated'
      AND deprecated_at < (NOW() - INTERVAL '90 days')
)
UPDATE document_versions
SET status = 'archived',
    archived_at = NOW(),
    storage_tier = 'glacier'
WHERE id IN (SELECT id FROM deprecated_documents);

-- Trigger S3 transition
INSERT INTO storage_transition_queue (document_id, version, from_tier, to_tier)
SELECT document_id, version, 'warm', 'cold'
FROM deprecated_documents;
```

### 7.6 Override Mechanisms

**Manual deprecation** (admin only):
```typescript
interface ManualDeprecation {
    reason: 'security_vulnerability' | 'legal_requirement' | 'data_error';
    document_id: string;
    version: string;
    immediate: boolean;  // Skip 90-day window if true
    justification: string;
    approved_by: string;  // Admin user ID
}
```

**Extended deprecation window** (rare cases):
```typescript
interface ExtendedDeprecation {
    document_id: string;
    version: string;
    extension_days: number;  // Additional days beyond 90
    reason: string;
    approved_by: string;
}
```

---

## 8. ROLLBACK CAPABILITIES

### 8.1 Four Rollback Levels

GenCraft supports **4 distinct rollback levels**:

| Level | Scope | Complexity | Use Case |
|-------|-------|------------|----------|
| **Level 1: Document** | Single document | Low | Fix error in one document |
| **Level 2: Vertical** | All documents in vertical | Medium | Rollback NewsletterCraft changes |
| **Level 3: Platform** | All GenCraft documents | High | Rollback entire v3.1 release |
| **Level 4: Point-in-Time** | Entire system state | Very High | Recover from catastrophic failure |

### 8.2 Level 1: Document Rollback

**Roll back a single document to previous version**:

```typescript
interface DocumentRollback {
    rollback_type: 'document';
    document_id: 'DOC01_v3.0.0_gencraft_architecture';
    from_version: '2.0.0';
    to_version: '1.5.0';
    reason: 'Critical error in v2.0.0';
    process: [
        'Retrieve v1.5.0 from S3 archive',
        'Verify checksum integrity',
        'Update status: archived -> published',
        'Deprecate v2.0.0 immediately',
        'Write v1.5.0 to disk',
        'Update database: current_version = 1.5.0',
        'Notify dependent documents',
        'Generate audit log entry'
    ];
}
```

**SQL Implementation**:
```sql
BEGIN;
    -- Step 1: Deprecate current version
    UPDATE document_versions
    SET status = 'deprecated', deprecated_at = NOW()
    WHERE document_id = 'DOC01_v3.0.0_gencraft_architecture'
      AND version = '2.0.0';

    -- Step 2: Restore old version
    UPDATE document_versions
    SET status = 'published', deprecated_at = NULL
    WHERE document_id = 'DOC01_v3.0.0_gencraft_architecture'
      AND version = '1.5.0';

    -- Step 3: Log rollback
    INSERT INTO audit_log (action, document_id, from_version, to_version, reason)
    VALUES ('rollback_document', 'DOC01_v3.0.0_gencraft_architecture', '2.0.0', '1.5.0', 'Critical error');
COMMIT;
```

### 8.3 Level 2: Vertical Rollback

**Roll back all documents in a vertical** (e.g., NewsletterCraft):

```typescript
interface VerticalRollback {
    rollback_type: 'vertical';
    vertical: 'newslettercraft';
    from_snapshot: '2025-12-01T10:00:00Z';
    to_snapshot: '2025-11-01T10:00:00Z';
    affected_documents: [
        'DOC01_v3.0.0_newslettercraft_architecture',
        'DOC02_v3.0.0_newslettercraft_pricing',
        'DOC03_v3.0.0_newslettercraft_schema',
        // ... all NewsletterCraft documents
    ];
    process: [
        'Create vertical snapshot of current state',
        'Retrieve all documents from target snapshot',
        'Verify checksum integrity for all',
        'Rollback each document sequentially',
        'Update dependencies between documents',
        'Validate vertical consistency',
        'Generate vertical rollback report'
    ];
}
```

### 8.4 Level 3: Platform Rollback

**Roll back entire GenCraft platform** (all verticals):

```typescript
interface PlatformRollback {
    rollback_type: 'platform';
    from_version: 'v3.1.0';
    to_version: 'v3.0.0';
    affected_verticals: ['gencraft', 'newslettercraft', 'blogcraft'];
    affected_documents: 150;  // All platform documents
    estimated_time: '2-4 hours';
    process: [
        'Create full platform backup',
        'Freeze all write operations',
        'Retrieve v3.0.0 platform snapshot',
        'Verify integrity of all documents',
        'Rollback verticals in dependency order',
        'Update cross-vertical dependencies',
        'Validate platform-wide consistency',
        'Resume write operations',
        'Generate platform rollback report'
    ];
    safety_checks: [
        'Verify backup integrity',
        'Check storage capacity',
        'Validate dependency graph',
        'Confirm admin approval',
        'Schedule maintenance window'
    ];
}
```

### 8.5 Level 4: Point-in-Time Recovery

**Restore entire system to specific moment in time**:

```typescript
interface PointInTimeRecovery {
    rollback_type: 'point_in_time';
    recovery_timestamp: '2025-11-15T14:30:00Z';
    scope: 'entire_system';
    includes: [
        'All documents',
        'All metadata',
        'All lineage relationships',
        'All audit logs up to timestamp'
    ];
    process: [
        'Create disaster recovery snapshot',
        'Freeze ALL operations (read + write)',
        'Query temporal lineage for all documents at timestamp',
        'Retrieve all document versions from S3',
        'Reconstruct database state at timestamp',
        'Rebuild dependency graph',
        'Rebuild template-instance relationships',
        'Validate complete system consistency',
        'Resume operations',
        'Generate disaster recovery report'
    ];
    estimated_downtime: '4-8 hours';
    requires_approval: ['Site Owner', 'Legal', 'Compliance'];
}
```

### 8.6 Rollback Safety Protocol

**Before ANY rollback**:

```typescript
interface RollbackSafetyChecks {
    pre_rollback: [
        'Create full backup of current state',
        'Verify backup integrity',
        'Check storage capacity (3x current size)',
        'Validate target version exists in archive',
        'Verify target version checksum',
        'Analyze dependency impact',
        'Estimate rollback time',
        'Schedule maintenance window (if needed)',
        'Notify affected users (if needed)',
        'Get admin approval'
    ];
    during_rollback: [
        'Monitor progress in real-time',
        'Log all actions to audit trail',
        'Validate each document after restore',
        'Check dependency consistency',
        'Alert on any anomalies'
    ];
    post_rollback: [
        'Validate system consistency',
        'Run integrity checks',
        'Verify all dependencies',
        'Generate rollback report',
        'Notify admin of completion',
        'Monitor for 24 hours'
    ];
}
```

---

## 9. LEGAL COMPLIANCE & RETENTION

### 9.1 Infinite Retention Policy

**Principle**: Keep everything forever (legal compliance, subpoena readiness)

**Why Infinite Retention?**
1. **Legal Discovery**: Subpoenas may request historical records
2. **Regulatory Compliance**: Some industries require long-term archival
3. **Audit Trails**: Complete history for security investigations
4. **Cost Optimization**: S3 Deep Glacier is extremely cheap ($0.00099/GB/month)

**Storage Cost Analysis** (assuming 10GB total documents):
| Tier | Storage | Monthly Cost | Annual Cost |
|------|---------|--------------|-------------|
| Hot (current) | 100MB | $2.30 | $27.60 |
| Warm (0-90 days) | 1GB | $2.30 | $27.60 |
| Cold (90 days - 7 years) | 5GB | $2.00 | $24.00 |
| Frozen (7+ years) | 10GB | $1.00 | $12.00 |
| **TOTAL** | **~16GB** | **$7.60** | **$91.20** |

**Conclusion**: Infinite retention is cost-effective

### 9.2 Subpoena Response Workflow

**When receiving a subpoena**:

```typescript
interface SubpoenaResponse {
    subpoena_id: string;
    received_at: string;
    scope: {
        document_types: ['all' | 'specific_types'],
        date_range: { from: string, to: string },
        verticals: ['gencraft', 'newslettercraft', 'blogcraft'],
        keywords: string[],
        authors: string[]
    };
    response_process: [
        'Place legal hold on matching documents',
        'Freeze auto-archival for affected documents',
        'Query temporal lineage for date range',
        'Retrieve all matching documents from S3',
        'Generate chain of custody report',
        'Package documents with metadata',
        'Encrypt package for legal team',
        'Deliver to legal counsel',
        'Maintain legal hold until case closure'
    ];
    estimated_time: '1-3 business days';
}
```

### 9.3 Legal Hold Implementation

**Immutable legal holds prevent deletion/modification**:

```sql
CREATE TABLE legal_holds (
    id UUID PRIMARY KEY,
    hold_id VARCHAR(100) UNIQUE NOT NULL,
    case_name VARCHAR(255),
    subpoena_date DATE,
    scope JSONB,  -- Query criteria
    affected_documents TEXT[],
    status VARCHAR(50),  -- 'active', 'released'
    created_at TIMESTAMP,
    released_at TIMESTAMP,
    created_by VARCHAR(255),
    released_by VARCHAR(255)
);

-- Apply legal hold
INSERT INTO legal_holds (hold_id, case_name, scope, affected_documents, status)
VALUES (
    'HOLD-2025-001',
    'Case ABC vs XYZ',
    '{"date_range": {"from": "2025-01-01", "to": "2025-12-31"}}',
    ARRAY['DOC01_v3.0.0_gencraft_architecture_1.0.0.md', ...],
    'active'
);

-- Prevent deletion/archival
CREATE OR REPLACE FUNCTION prevent_deletion_if_legal_hold()
RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (
        SELECT 1 FROM legal_holds
        WHERE status = 'active'
          AND OLD.document_id = ANY(affected_documents)
    ) THEN
        RAISE EXCEPTION 'Cannot delete/modify document under legal hold';
    END IF;
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_legal_hold_before_delete
BEFORE DELETE ON document_versions
FOR EACH ROW EXECUTE FUNCTION prevent_deletion_if_legal_hold();
```

### 9.4 Chain of Custody

**For legal compliance, maintain complete audit trail**:

```typescript
interface ChainOfCustody {
    document_id: string;
    version: string;
    events: [
        {
            timestamp: '2025-01-01T10:00:00Z',
            event: 'created',
            actor: 'user@gencraft.com',
            checksum: 'sha256:abc123...'
        },
        {
            timestamp: '2025-02-15T14:30:00Z',
            event: 'modified',
            actor: 'editor@gencraft.com',
            checksum: 'sha256:def456...',
            changes: ['Section 3 updated', 'Added diagram']
        },
        {
            timestamp: '2025-03-01T09:00:00Z',
            event: 'published',
            actor: 'admin@gencraft.com',
            checksum: 'sha256:ghi789...'
        },
        {
            timestamp: '2025-06-01T10:00:00Z',
            event: 'deprecated',
            actor: 'system',
            reason: 'New version published'
        },
        {
            timestamp: '2025-09-01T02:00:00Z',
            event: 'archived',
            actor: 'system',
            storage_tier: 'glacier'
        },
        {
            timestamp: '2025-12-01T11:00:00Z',
            event: 'legal_hold_applied',
            actor: 'legal@gencraft.com',
            hold_id: 'HOLD-2025-001'
        }
    ];
    integrity_verification: {
        current_checksum: 'sha256:ghi789...',
        matches_original: true,
        verified_at: '2025-12-01T11:05:00Z'
    };
}
```

### 9.5 Compliance Certifications

**Document management system supports**:

| Standard | Requirement | Implementation |
|----------|-------------|----------------|
| **SOC 2 Type II** | Audit trail, access controls | Complete audit log, RBAC |
| **GDPR** | Right to erasure (with exceptions) | Legal hold overrides deletion |
| **HIPAA** | Encrypted storage, audit logs | S3 encryption, complete audit trail |
| **ISO 27001** | Information security | Checksum verification, access control |
| **FedRAMP** | Government compliance | Immutable archives, chain of custody |

---

## 10. USER UPLOAD LIMITS & FEEDBACK

### 10.1 Tiered Upload Limits

**Three-dimensional limits** (documents, file size, page count):

| Tier | Max Documents | Max File Size | Max Page Count | Rationale |
|------|---------------|---------------|----------------|-----------|
| **Enterprise** | 30 documents/generation | 30MB | 1,300 pages | Power users, complex documents |
| **Paid Individual** | 20 documents/generation | 20MB | 500 pages | Professional use cases |
| **Free** | 5 documents/generation | 5MB | 100 pages | Basic usage, resource limits |

**Why three dimensions?**
1. **Document Count**: Limits number of files processed simultaneously
2. **File Size**: Prevents storage/bandwidth abuse
3. **Page Count**: Prevents compute resource exhaustion (LLM token limits)

### 10.2 Context-Aware Feedback System

**Principle**: Show users limits in units they understand (pages/minutes, NOT megabytes)

**Feedback by File Type**:

| File Type | User-Friendly Unit | Technical Unit | Example Feedback |
|-----------|-------------------|----------------|------------------|
| **Documents** (PDF, DOCX, etc.) | Pages | MB | "This document is ~12 pages too long. Please reduce from 512 to 500 pages." |
| **Videos** (MP4, MOV, etc.) | Minutes/Seconds | MB | "This video is ~3 minutes too long. Please reduce from 13:45 to 10:00." |
| **Audio** (MP3, WAV, etc.) | Minutes/Seconds | MB | "This audio is ~8 minutes too long. Please reduce from 28:30 to 20:00." |
| **Images** (JPG, PNG, etc.) | Resolution/Pixels | MB | "This image resolution is too high. Please resize to 4,680×3,510 pixels or smaller." |
| **Spreadsheets** (XLSX, CSV) | Rows | MB | "This spreadsheet has too many rows. Please reduce from 12,000 to 10,000 rows." |

### 10.3 Smart Estimation Algorithm

**Convert file size to user-friendly units**:

```typescript
interface SmartEstimation {
    file_type: string;
    file_size_mb: number;
    estimate_user_units(): string;
}

class DocumentEstimator implements SmartEstimation {
    file_type = 'pdf';
    file_size_mb: number;

    estimate_user_units(): string {
        // Average: 1 page ≈ 0.1MB (text) to 0.5MB (images)
        const avg_mb_per_page = 0.2;
        const estimated_pages = Math.round(this.file_size_mb / avg_mb_per_page);

        const tier_limit_pages = 500; // For Paid Individual
        const overage = estimated_pages - tier_limit_pages;

        return `This document is ~${overage} pages too long. Please reduce from ${estimated_pages} to ${tier_limit_pages} pages.`;
    }
}

class VideoEstimator implements SmartEstimation {
    file_type = 'mp4';
    file_size_mb: number;

    estimate_user_units(): string {
        // Average: 1 minute ≈ 10MB (720p) to 50MB (4K)
        const avg_mb_per_minute = 20;
        const estimated_minutes = Math.round(this.file_size_mb / avg_mb_per_minute);

        const tier_limit_minutes = 10; // Example limit
        const overage = estimated_minutes - tier_limit_minutes;

        const overage_time = this.format_time(overage * 60);
        const total_time = this.format_time(estimated_minutes * 60);
        const limit_time = this.format_time(tier_limit_minutes * 60);

        return `This video is ~${overage_time} too long. Please reduce from ${total_time} to ${limit_time}.`;
    }

    format_time(seconds: number): string {
        const mins = Math.floor(seconds / 60);
        const secs = seconds % 60;
        return `${mins}:${secs.toString().padStart(2, '0')}`;
    }
}

class ImageEstimator implements SmartEstimation {
    file_type = 'jpg';
    file_size_mb: number;
    width: number;
    height: number;

    estimate_user_units(): string {
        // For images, resolution is more meaningful than file size
        const max_pixels = 20_000_000; // 20 megapixels
        const current_pixels = this.width * this.height;

        if (current_pixels > max_pixels) {
            const scale_factor = Math.sqrt(max_pixels / current_pixels);
            const new_width = Math.round(this.width * scale_factor);
            const new_height = Math.round(this.height * scale_factor);

            return `This image resolution is too high. Please resize to ${new_width}×${new_height} pixels or smaller.`;
        }

        return 'Image within acceptable limits.';
    }
}
```

### 10.4 Progressive Feedback UI

**Show appropriate detail based on user expertise**:

```typescript
interface ProgressiveFeedback {
    simple_message: string;     // For average users
    detailed_message: string;   // For power users
    technical_details: string;  // For developers
    show_by_default: 'simple';
    expandable: true;
}

// Example for document upload
const feedback: ProgressiveFeedback = {
    simple_message: "This document is ~12 pages too long. Please reduce from 512 to 500 pages.",

    detailed_message: `
        Document Upload Limit Exceeded

        Your tier: Paid Individual
        Limit: 500 pages per document
        Current: 512 pages (estimated)
        Overage: ~12 pages

        Suggestions:
        • Remove appendices or references
        • Split into multiple documents
        • Upgrade to Enterprise tier (1,300 page limit)
    `,

    technical_details: `
        File: document.pdf
        Size: 102.4 MB
        Estimated pages: 512 (based on 0.2 MB/page average)
        Tier limit: 500 pages
        Tier limit (MB): 100 MB
        Overage (pages): 12
        Overage (MB): 2.4 MB

        Estimation algorithm: file_size_mb / avg_mb_per_page
        Confidence: Medium (varies by content type)
    `,

    show_by_default: 'simple',
    expandable: true
};
```

### 10.5 Token Consumption Tracking

**Track token usage per upload** (for LLM processing):

```typescript
interface TokenTracking {
    document_id: string;
    user_id: string;
    tier: 'free' | 'paid' | 'enterprise';
    tokens_consumed: number;
    tokens_limit: number;
    cost_usd: number;
    timestamp: string;
}

// Tier-based token limits
const tier_limits = {
    free: {
        tokens_per_month: 100_000,
        documents_per_generation: 5,
        max_tokens_per_document: 20_000
    },
    paid: {
        tokens_per_month: 1_000_000,
        documents_per_generation: 20,
        max_tokens_per_document: 50_000
    },
    enterprise: {
        tokens_per_month: 10_000_000,
        documents_per_generation: 30,
        max_tokens_per_document: 130_000  // 1,300 pages × ~100 tokens/page
    }
};

// Estimate tokens from page count
function estimate_tokens_from_pages(pages: number): number {
    const avg_tokens_per_page = 100;  // Conservative estimate
    return pages * avg_tokens_per_page;
}

// Example: Enterprise user uploads 1,300-page document
const tokens_estimated = estimate_tokens_from_pages(1300); // 130,000 tokens
const tier_limit = tier_limits.enterprise.max_tokens_per_document; // 130,000 tokens
const within_limit = tokens_estimated <= tier_limit; // true
```

---

## 11. DATABASE SCHEMA

### 11.1 Core Tables

**documents** (Master document registry):
```sql
CREATE TABLE documents (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    document_id VARCHAR(255) UNIQUE NOT NULL,  -- e.g., "DOC01_v3.0.0_gencraft_architecture"
    document_type VARCHAR(50) NOT NULL,         -- "DOC00", "DOC01", etc.
    gencraft_version VARCHAR(50) NOT NULL,      -- "3.0.0"
    vertical VARCHAR(100) NOT NULL,             -- "gencraft", "newslettercraft"
    description TEXT,
    current_version VARCHAR(50),                -- "2.0.0"
    status VARCHAR(50) NOT NULL,                -- "draft", "published", "deprecated"
    template_type VARCHAR(50),                  -- "template", "instance", NULL
    template_parent_id UUID,                    -- FK to parent template
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    created_by VARCHAR(255),
    CONSTRAINT fk_template_parent FOREIGN KEY (template_parent_id) REFERENCES documents(id)
);

CREATE INDEX idx_documents_gencraft_version ON documents(gencraft_version);
CREATE INDEX idx_documents_vertical ON documents(vertical);
CREATE INDEX idx_documents_status ON documents(status);
CREATE INDEX idx_documents_template_parent ON documents(template_parent_id);
```

**document_versions** (Version history):
```sql
CREATE TABLE document_versions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    document_id UUID NOT NULL,                  -- FK to documents table
    version VARCHAR(50) NOT NULL,               -- "1.0.0", "2.1.5"
    full_filename VARCHAR(500) NOT NULL,        -- Complete filename with version
    status VARCHAR(50) NOT NULL,                -- "draft", "published", "deprecated", "archived"
    content_checksum VARCHAR(128) NOT NULL,     -- SHA-256 hash
    file_size_bytes BIGINT,
    page_count INTEGER,
    s3_uri TEXT,                                -- s3://bucket/path/to/version
    storage_tier VARCHAR(50),                   -- "hot", "warm", "cold", "frozen"
    metadata JSONB,                             -- Flexible metadata storage
    created_at TIMESTAMP DEFAULT NOW(),
    published_at TIMESTAMP,
    deprecated_at TIMESTAMP,
    archived_at TIMESTAMP,
    created_by VARCHAR(255),
    CONSTRAINT fk_document FOREIGN KEY (document_id) REFERENCES documents(id) ON DELETE CASCADE,
    CONSTRAINT unique_document_version UNIQUE (document_id, version)
);

CREATE INDEX idx_versions_document ON document_versions(document_id);
CREATE INDEX idx_versions_status ON document_versions(status);
CREATE INDEX idx_versions_deprecated_at ON document_versions(deprecated_at);
CREATE INDEX idx_versions_storage_tier ON document_versions(storage_tier);
```

**temporal_lineage** (Version history tracking):
```sql
CREATE TABLE temporal_lineage (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    document_id UUID NOT NULL,
    version_id UUID NOT NULL,                   -- FK to document_versions
    previous_version_id UUID,                   -- FK to document_versions (NULL for first)
    next_version_id UUID,                       -- FK to document_versions (NULL for current)
    change_type VARCHAR(50),                    -- "major", "minor", "patch"
    change_summary TEXT,
    created_at TIMESTAMP DEFAULT NOW(),
    CONSTRAINT fk_version FOREIGN KEY (version_id) REFERENCES document_versions(id),
    CONSTRAINT fk_previous_version FOREIGN KEY (previous_version_id) REFERENCES document_versions(id),
    CONSTRAINT fk_next_version FOREIGN KEY (next_version_id) REFERENCES document_versions(id)
);

CREATE INDEX idx_temporal_document ON temporal_lineage(document_id);
CREATE INDEX idx_temporal_version ON temporal_lineage(version_id);
```

**hierarchical_lineage** (Document tree structure):
```sql
CREATE EXTENSION IF NOT EXISTS ltree;

CREATE TABLE hierarchical_lineage (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    document_id UUID NOT NULL UNIQUE,
    parent_id UUID,                             -- NULL for root documents
    depth INTEGER NOT NULL DEFAULT 0,
    path LTREE NOT NULL,                        -- e.g., 'DOC00.DOC01.DOC01_newsletter'
    created_at TIMESTAMP DEFAULT NOW(),
    CONSTRAINT fk_document FOREIGN KEY (document_id) REFERENCES documents(id),
    CONSTRAINT fk_parent FOREIGN KEY (parent_id) REFERENCES documents(id)
);

CREATE INDEX idx_hierarchical_path ON hierarchical_lineage USING GIST (path);
CREATE INDEX idx_hierarchical_parent ON hierarchical_lineage(parent_id);
```

**inheritance_lineage** (Template → Instance relationships):
```sql
CREATE TABLE inheritance_lineage (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    instance_id UUID NOT NULL,                  -- FK to documents (instance)
    template_id UUID NOT NULL,                  -- FK to documents (template)
    template_version VARCHAR(50) NOT NULL,
    instance_version VARCHAR(50) NOT NULL,
    compatibility_status VARCHAR(50),           -- "compatible", "incompatible", "unknown"
    last_synced_at TIMESTAMP,
    migration_required BOOLEAN DEFAULT FALSE,
    migration_notes TEXT,
    created_at TIMESTAMP DEFAULT NOW(),
    CONSTRAINT fk_instance FOREIGN KEY (instance_id) REFERENCES documents(id),
    CONSTRAINT fk_template FOREIGN KEY (template_id) REFERENCES documents(id),
    CONSTRAINT unique_instance_template UNIQUE (instance_id, template_id)
);

CREATE INDEX idx_inheritance_instance ON inheritance_lineage(instance_id);
CREATE INDEX idx_inheritance_template ON inheritance_lineage(template_id);
CREATE INDEX idx_inheritance_compatibility ON inheritance_lineage(compatibility_status);
```

**dependency_lineage** (Cross-document dependencies):
```sql
CREATE TABLE dependency_lineage (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    source_document_id UUID NOT NULL,           -- FK to documents (depends on)
    target_document_id UUID NOT NULL,           -- FK to documents (dependency)
    dependency_type VARCHAR(50) NOT NULL,       -- "hard", "soft", "optional"
    description TEXT,
    created_at TIMESTAMP DEFAULT NOW(),
    CONSTRAINT fk_source FOREIGN KEY (source_document_id) REFERENCES documents(id),
    CONSTRAINT fk_target FOREIGN KEY (target_document_id) REFERENCES documents(id),
    CONSTRAINT unique_dependency UNIQUE (source_document_id, target_document_id)
);

CREATE INDEX idx_dependency_source ON dependency_lineage(source_document_id);
CREATE INDEX idx_dependency_target ON dependency_lineage(target_document_id);
CREATE INDEX idx_dependency_type ON dependency_lineage(dependency_type);
```

**audit_log** (Complete audit trail):
```sql
CREATE TABLE audit_log (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    document_id UUID,
    version_id UUID,
    action VARCHAR(100) NOT NULL,               -- "created", "published", "deprecated", etc.
    actor VARCHAR(255) NOT NULL,                -- User or "system"
    actor_ip VARCHAR(45),
    details JSONB,
    checksum_before VARCHAR(128),
    checksum_after VARCHAR(128),
    timestamp TIMESTAMP DEFAULT NOW(),
    CONSTRAINT fk_document FOREIGN KEY (document_id) REFERENCES documents(id),
    CONSTRAINT fk_version FOREIGN KEY (version_id) REFERENCES document_versions(id)
);

CREATE INDEX idx_audit_document ON audit_log(document_id);
CREATE INDEX idx_audit_action ON audit_log(action);
CREATE INDEX idx_audit_timestamp ON audit_log(timestamp);
CREATE INDEX idx_audit_actor ON audit_log(actor);
```

**legal_holds** (Subpoena compliance):
```sql
CREATE TABLE legal_holds (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    hold_id VARCHAR(100) UNIQUE NOT NULL,
    case_name VARCHAR(255),
    subpoena_date DATE,
    scope JSONB,                                -- Query criteria
    affected_documents TEXT[],                  -- Array of document IDs
    status VARCHAR(50) NOT NULL,                -- "active", "released"
    created_at TIMESTAMP DEFAULT NOW(),
    released_at TIMESTAMP,
    created_by VARCHAR(255),
    released_by VARCHAR(255),
    notes TEXT
);

CREATE INDEX idx_legal_holds_status ON legal_holds(status);
CREATE INDEX idx_legal_holds_documents ON legal_holds USING GIN (affected_documents);
```

**storage_transition_queue** (S3 tier transitions):
```sql
CREATE TABLE storage_transition_queue (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    version_id UUID NOT NULL,
    from_tier VARCHAR(50) NOT NULL,
    to_tier VARCHAR(50) NOT NULL,
    scheduled_at TIMESTAMP DEFAULT NOW(),
    executed_at TIMESTAMP,
    status VARCHAR(50) DEFAULT 'pending',       -- "pending", "in_progress", "completed", "failed"
    error_message TEXT,
    CONSTRAINT fk_version FOREIGN KEY (version_id) REFERENCES document_versions(id)
);

CREATE INDEX idx_transition_status ON storage_transition_queue(status);
CREATE INDEX idx_transition_scheduled ON storage_transition_queue(scheduled_at);
```

### 11.2 Materialized Views

**current_documents** (Fast access to current versions):
```sql
CREATE MATERIALIZED VIEW current_documents AS
SELECT
    d.id,
    d.document_id,
    d.gencraft_version,
    d.vertical,
    d.description,
    dv.version,
    dv.full_filename,
    dv.status,
    dv.published_at,
    dv.content_checksum
FROM documents d
JOIN document_versions dv ON d.id = dv.document_id
WHERE dv.status = 'published'
  AND dv.version = d.current_version;

CREATE UNIQUE INDEX idx_current_documents_id ON current_documents(id);
REFRESH MATERIALIZED VIEW CONCURRENTLY current_documents;
```

**complete_lineage** (All lineage types joined):
```sql
CREATE MATERIALIZED VIEW complete_lineage AS
SELECT
    d.document_id,
    d.gencraft_version,
    d.vertical,

    -- Temporal lineage
    tl.previous_version_id,
    tl.next_version_id,
    tl.change_type,

    -- Hierarchical lineage
    hl.parent_id,
    hl.depth,
    hl.path,

    -- Inheritance lineage
    il.template_id,
    il.compatibility_status,

    -- Dependency lineage
    ARRAY_AGG(DISTINCT dl_source.target_document_id) AS dependencies,
    ARRAY_AGG(DISTINCT dl_target.source_document_id) AS dependents

FROM documents d
LEFT JOIN temporal_lineage tl ON d.id = tl.document_id
LEFT JOIN hierarchical_lineage hl ON d.id = hl.document_id
LEFT JOIN inheritance_lineage il ON d.id = il.instance_id
LEFT JOIN dependency_lineage dl_source ON d.id = dl_source.source_document_id
LEFT JOIN dependency_lineage dl_target ON d.id = dl_target.target_document_id
GROUP BY d.document_id, d.gencraft_version, d.vertical, tl.previous_version_id,
         tl.next_version_id, tl.change_type, hl.parent_id, hl.depth, hl.path,
         il.template_id, il.compatibility_status;

REFRESH MATERIALIZED VIEW CONCURRENTLY complete_lineage;
```

---

## 12. IMPLEMENTATION ROADMAP

### 12.1 Implementation Phases

**Total Duration**: 14 weeks
**Team Size**: 5-7 engineers

| Phase | Duration | Focus | Deliverables |
|-------|----------|-------|--------------|
| **Phase 1** | 2 weeks | Database & Storage | Schema, S3 setup, migrations |
| **Phase 2** | 2 weeks | Core Document Management | CRUD, versioning, file naming |
| **Phase 3** | 2 weeks | Lineage Tracking | All 4 lineage types implemented |
| **Phase 4** | 2 weeks | Auto-Deprecation | Workflow automation, cron jobs |
| **Phase 5** | 2 weeks | Rollback & Recovery | All 4 rollback levels |
| **Phase 6** | 2 weeks | Legal Compliance | Audit logs, legal holds, subpoena response |
| **Phase 7** | 2 weeks | User Limits & Feedback | Tiered limits, context-aware feedback |

### 12.2 Phase 1: Database & Storage (Weeks 1-2)

**Week 1: Database Setup**
- [ ] Create PostgreSQL database schema
- [ ] Implement all core tables (documents, document_versions, etc.)
- [ ] Set up ltree extension for hierarchical lineage
- [ ] Create indexes and constraints
- [ ] Write database migration scripts
- [ ] Test data integrity constraints

**Week 2: S3 Storage Setup**
- [ ] Configure S3 buckets (gencraft-docs, gencraft-docs-archive)
- [ ] Set up S3 lifecycle policies (Hot → Warm → Cold → Frozen)
- [ ] Implement S3 upload/download service
- [ ] Configure encryption at rest (AES-256)
- [ ] Set up IAM roles and permissions
- [ ] Test S3 tier transitions

**Deliverables**:
- Complete database schema in production
- S3 buckets configured with lifecycle policies
- Migration scripts tested and documented

### 12.3 Phase 2: Core Document Management (Weeks 3-4)

**Week 3: Document CRUD**
- [ ] Implement document creation (with YAML front matter)
- [ ] Implement document update (version increment logic)
- [ ] Implement document retrieval (current + historical)
- [ ] Implement document deletion (soft delete only)
- [ ] File naming validation (enforce standard format)
- [ ] Checksum generation (SHA-256)

**Week 4: Versioning System**
- [ ] Dual versioning logic (platform + document)
- [ ] Version increment rules (major/minor/patch)
- [ ] Version compatibility matrix
- [ ] Publish workflow (archive old → write new)
- [ ] Metadata extraction from YAML
- [ ] API endpoints for document management

**Deliverables**:
- REST API for document management
- Version control system functional
- File naming protocol enforced

### 12.4 Phase 3: Lineage Tracking (Weeks 5-6)

**Week 5: Temporal & Hierarchical Lineage**
- [ ] Temporal lineage tracking (version history)
- [ ] Hierarchical lineage with ltree (document tree)
- [ ] Lineage queries (get all ancestors/descendants)
- [ ] Lineage visualization API
- [ ] Test lineage consistency

**Week 6: Inheritance & Dependency Lineage**
- [ ] Template-instance tracking
- [ ] Dependency graph construction
- [ ] Compatibility checking (template vs instance)
- [ ] Dependency impact analysis
- [ ] Complete lineage materialized view

**Deliverables**:
- All 4 lineage types functional
- Lineage query API
- Dependency graph visualization

### 12.5 Phase 4: Auto-Deprecation (Weeks 7-8)

**Week 7: Deprecation Workflow**
- [ ] Auto-deprecation on publish
- [ ] 90-day deprecation window logic
- [ ] Deprecation status tracking
- [ ] Email notifications (optional)
- [ ] Manual deprecation override (admin)

**Week 8: Archival Automation**
- [ ] Daily cron job (2:00 AM UTC)
- [ ] Storage tier transition queue
- [ ] S3 archival automation
- [ ] Error handling and retry logic
- [ ] Archival audit logging

**Deliverables**:
- Fully automated deprecation workflow
- Cron jobs running in production
- 90-day window enforced

### 12.6 Phase 5: Rollback & Recovery (Weeks 9-10)

**Week 9: Document & Vertical Rollback**
- [ ] Level 1: Document rollback
- [ ] Level 2: Vertical rollback
- [ ] Rollback safety checks
- [ ] Integrity verification after rollback
- [ ] Rollback audit logging

**Week 10: Platform & Point-in-Time Recovery**
- [ ] Level 3: Platform rollback
- [ ] Level 4: Point-in-time recovery
- [ ] Disaster recovery testing
- [ ] Rollback time estimation
- [ ] Admin approval workflow

**Deliverables**:
- All 4 rollback levels functional
- Disaster recovery plan tested
- Rollback documentation

### 12.7 Phase 6: Legal Compliance (Weeks 11-12)

**Week 11: Audit Trails**
- [ ] Complete audit log implementation
- [ ] Chain of custody tracking
- [ ] Immutable audit records
- [ ] Audit log querying API
- [ ] Compliance reports generation

**Week 12: Legal Holds & Subpoena Response**
- [ ] Legal hold implementation
- [ ] Subpoena response workflow
- [ ] Legal hold prevents deletion trigger
- [ ] Encrypted export for legal team
- [ ] Legal compliance certification

**Deliverables**:
- Audit trail complete
- Legal hold system functional
- Subpoena response process documented

### 12.8 Phase 7: User Limits & Feedback (Weeks 13-14)

**Week 13: Upload Limits**
- [ ] Tiered limit enforcement (Free, Paid, Enterprise)
- [ ] File size validation
- [ ] Page count estimation
- [ ] Token consumption tracking
- [ ] Limit exceeded error handling

**Week 14: Context-Aware Feedback**
- [ ] Smart estimation algorithms (pages/minutes/resolution)
- [ ] Progressive feedback UI
- [ ] User-friendly error messages
- [ ] Technical details (expandable)
- [ ] Limit upgrade prompts

**Deliverables**:
- Tiered limits enforced
- Context-aware feedback live
- User experience polished

---

## 13. SUCCESS CRITERIA

### 13.1 Functional Requirements

**Document Management**:
- [x] File naming protocol enforced (100% compliance)
- [x] Dual versioning implemented (platform + document)
- [x] YAML front matter validated on all documents
- [x] Git-like storage (disk + S3 + DB)
- [x] Template-based inheritance functional

**Lineage Tracking**:
- [x] Temporal lineage (version history)
- [x] Hierarchical lineage (document tree)
- [x] Inheritance lineage (template → instance)
- [x] Dependency lineage (cross-references)

**Auto-Deprecation**:
- [x] Auto-deprecate on publish (zero manual intervention)
- [x] 90-day deprecation window enforced
- [x] Auto-archival after 90 days
- [x] Storage tier transitions (Hot → Warm → Cold → Frozen)

**Rollback**:
- [x] Level 1: Document rollback (<5 minutes)
- [x] Level 2: Vertical rollback (<30 minutes)
- [x] Level 3: Platform rollback (<4 hours)
- [x] Level 4: Point-in-time recovery (<8 hours)

**Legal Compliance**:
- [x] Infinite retention (S3 Deep Glacier)
- [x] Immutable audit trail
- [x] Legal hold implementation
- [x] Subpoena response workflow (<3 business days)

**User Experience**:
- [x] Tiered upload limits (Free, Paid, Enterprise)
- [x] Context-aware feedback (pages/minutes, not MB)
- [x] Smart estimation algorithms
- [x] Progressive feedback UI

### 13.2 Performance Requirements

| Metric | Target | Measured |
|--------|--------|----------|
| Document publish time | <2 seconds | TBD |
| Document retrieval (current) | <100ms | TBD |
| Document retrieval (archived) | <5 seconds | TBD |
| Lineage query (complete) | <500ms | TBD |
| Rollback (Level 1) | <5 minutes | TBD |
| Storage tier transition | <1 hour | TBD |
| Deprecation cron job | <10 minutes | TBD |

### 13.3 Reliability Requirements

| Metric | Target | Measured |
|--------|--------|----------|
| Checksum verification pass rate | 100% | TBD |
| Data integrity validation | 100% | TBD |
| Rollback success rate | >99.9% | TBD |
| S3 upload success rate | >99.99% | TBD |
| Legal hold enforcement | 100% (zero deletions) | TBD |

---

## 14. APPENDICES

### 14.1 Glossary

| Term | Definition |
|------|------------|
| **Deprecated** | Document superseded by newer version, 90-day retention window |
| **Archived** | Document moved to cold storage (S3 Glacier), accessible but slow |
| **Frozen** | Document in permanent deep archive (S3 Deep Glacier, 7+ years) |
| **Template** | GenCraft golden source document that defines structure/patterns |
| **Instance** | Vertical-specific implementation inheriting from template |
| **Temporal Lineage** | Version history over time (v1.0.0 → v2.0.0) |
| **Hierarchical Lineage** | Document tree structure (parent-child) |
| **Inheritance Lineage** | Template → instance relationships |
| **Dependency Lineage** | Cross-document references |
| **Golden Source** | Authoritative version of a document (template) |
| **Legal Hold** | Immutable freeze preventing deletion/modification |
| **Chain of Custody** | Complete audit trail for legal compliance |
| **Point-in-Time Recovery** | Restore entire system to specific timestamp |

### 14.2 References

1. **S3 Storage Pricing**: https://aws.amazon.com/s3/pricing/
2. **PostgreSQL ltree**: https://www.postgresql.org/docs/current/ltree.html
3. **Semantic Versioning**: https://semver.org/
4. **GDPR Compliance**: https://gdpr.eu/
5. **SOC 2 Type II**: https://www.aicpa.org/soc
6. **FedRAMP**: https://www.fedramp.gov/

---

**END OF DOCUMENT**

**Document ID**: `DOCUMENT_MANAGEMENT_DEPENDENCY_SYSTEM_v1.0.0`
**Last Updated**: 2025-12-01
**Status**: MANDATORY - Core Infrastructure
**Next Review**: Before Phase 2 implementation begins
