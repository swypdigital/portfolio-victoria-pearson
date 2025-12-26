# GenCraft v3.0 Media Generation Engine Specification
**Version**: 1.0.0
**Date**: 2025-12-10
**Engine Number**: #21 (of 21 total engines)
**Status**: Planning
**Author**: groklyGroup™ LLC

---

## Executive Summary

The Media Generation Engine (Engine #21) extends GenCraft v3.0's capabilities from text/code generation to multi-modal content creation through integration with diffusion models (Stable Diffusion, DALL-E 3, Midjourney, Flux) and other media generation technologies. This engine enables GenCraft to generate, transform, and optimize images, videos, and other visual assets as part of comprehensive website/application builds.

### Key Capabilities
- **Text-to-Image**: Generate images from textual descriptions
- **Image-to-Image**: Transform existing images with style transfer, variations
- **Inpainting/Outpainting**: Edit specific regions or extend image boundaries
- **Upscaling**: Enhance resolution (2x, 4x, 8x)
- **Image-to-Video**: Animate static images
- **Batch Generation**: Process multiple requests in parallel
- **Cost Optimization**: Intelligent model selection based on quality/cost tradeoffs

---

## Architecture Overview

### Integration Points

```
GenCraft v3.0 Ecosystem
├── Core Engines (1-20)
│   ├── Universal Model Router (#2) ← Routes media requests
│   ├── Token Cost Calculator (#18) ← Estimates generation costs
│   ├── Quality Engine (#4) ← Validates generated assets
│   └── Asset Storage ← Manages media files
│
└── Media Generation Engine (#21) [NEW]
    ├── Diffusion Provider Registry
    │   ├── Stability AI (Stable Diffusion XL/3.0)
    │   ├── OpenAI (DALL-E 3)
    │   ├── Midjourney (API when available)
    │   ├── Black Forest Labs (Flux.1)
    │   └── Custom Fine-tuned Models
    │
    ├── Generation Workflow Manager
    │   ├── Async Job Queue (Bull/BullMQ)
    │   ├── Progress Tracking
    │   ├── Webhook Callbacks
    │   └── Retry Logic
    │
    ├── Asset Management Service
    │   ├── S3/R2 Blob Storage
    │   ├── CDN Distribution (CloudFlare/CloudFront)
    │   ├── Automatic Compression (WebP/AVIF)
    │   ├── Version Management
    │   └── Gallery/Collection System
    │
    └── Cost Estimation Module
        ├── Per-Image Pricing
        ├── Resolution Tier Calc
        ├── Batch Discounts
        └── ROI Analysis
```

### System Flow

```
User Request → GenCraft → Model Router → Media Generation Engine
                                              ↓
                                    [Select Optimal Model]
                                              ↓
                                    [Create Job in Queue]
                                              ↓
                                [Diffusion Provider API Call]
                                              ↓
                                    [Poll for Completion]
                                              ↓
                                [Download Generated Asset]
                                              ↓
                                [Upload to S3 + CDN]
                                              ↓
                                    [Quality Validation]
                                              ↓
                                [Update Database Record]
                                              ↓
                                [Trigger Webhook/Callback]
                                              ↓
                                    [Return CDN URL]
```

---

## Technical Specification

### 1. Diffusion Provider Integration

#### Stability AI (Stable Diffusion)
```typescript
interface StabilityAIConfig {
    apiKey: string;
    model: 'sd-xl-1.0' | 'sd-3.0' | 'sd-3.5-large' | 'sd-3.5-turbo';
    endpoint: 'https://api.stability.ai/v2beta';
    rateLimit: {
        requestsPerMinute: 50;
        tokensPerMinute: 150000;
    };
    pricing: {
        'sd-xl-1.0': 0.04; // per image
        'sd-3.0': 0.065;
        'sd-3.5-large': 0.08;
        'sd-3.5-turbo': 0.04;
    };
}

interface GenerationRequest {
    prompt: string;
    negativePrompt?: string;
    width: 512 | 768 | 1024 | 1536 | 2048;
    height: 512 | 768 | 1024 | 1536 | 2048;
    steps: number; // 20-50 typical
    cfgScale: number; // 7.0 default
    sampler: 'euler' | 'ddpm' | 'ddim' | 'lms';
    seed?: number;
    stylePreset?: string;
}
```

#### OpenAI DALL-E 3
```typescript
interface DALLE3Config {
    apiKey: string;
    model: 'dall-e-3';
    endpoint: 'https://api.openai.com/v1/images/generations';
    pricing: {
        '1024x1024': 0.040;
        '1024x1792': 0.080;
        '1792x1024': 0.080;
    };
}

interface DALLE3Request {
    prompt: string;
    size: '1024x1024' | '1024x1792' | '1792x1024';
    quality: 'standard' | 'hd';
    style: 'vivid' | 'natural';
    n: 1 | 2 | 3 | 4; // number of images
}
```

#### Flux.1 (Black Forest Labs)
```typescript
interface FluxConfig {
    apiKey: string;
    model: 'flux-pro' | 'flux-dev' | 'flux-schnell';
    endpoint: 'https://api.bfl.ml/v1';
    pricing: {
        'flux-pro': 0.05;
        'flux-dev': 0.025;
        'flux-schnell': 0.01; // fastest
    };
}
```

### 2. Async Job Queue System

```typescript
// Using BullMQ for robust job processing
import { Queue, Worker, Job } from 'bullmq';

interface MediaGenerationJob {
    id: string;
    userId: string;
    projectId: string;
    provider: 'stability' | 'openai' | 'flux' | 'custom';
    operation: 'text-to-image' | 'image-to-image' | 'upscale' | 'inpaint';
    params: GenerationRequest;
    status: 'queued' | 'processing' | 'completed' | 'failed';
    progress: number; // 0-100
    result?: {
        assetId: string;
        cdnUrl: string;
        thumbnailUrl: string;
        metadata: AssetMetadata;
    };
    error?: {
        code: string;
        message: string;
        retryable: boolean;
    };
    createdAt: Date;
    completedAt?: Date;
}

const mediaQueue = new Queue('media-generation', {
    connection: redis,
    defaultJobOptions: {
        attempts: 3,
        backoff: {
            type: 'exponential',
            delay: 2000
        },
        removeOnComplete: false,
        removeOnFail: false
    }
});

const worker = new Worker('media-generation', async (job: Job<MediaGenerationJob>) => {
    const { provider, operation, params } = job.data;

    // Update progress
    await job.updateProgress(10);

    // Call provider API
    const result = await callProvider(provider, operation, params);

    await job.updateProgress(50);

    // Upload to S3
    const uploadedAsset = await uploadToS3(result.imageBlob);

    await job.updateProgress(75);

    // Generate CDN URL
    const cdnUrl = await generateCDNUrl(uploadedAsset);

    await job.updateProgress(90);

    // Quality validation
    await validateQuality(cdnUrl);

    await job.updateProgress(100);

    return { assetId: uploadedAsset.id, cdnUrl };
}, { connection: redis });
```

### 3. Asset Management Service

```typescript
interface AssetMetadata {
    id: string;
    userId: string;
    projectId: string;
    filename: string;
    mimeType: 'image/png' | 'image/jpeg' | 'image/webp' | 'image/avif';
    size: number; // bytes
    width: number;
    height: number;
    generationParams: GenerationRequest;
    provider: string;
    model: string;
    cost: number;
    s3Key: string;
    s3Bucket: string;
    cdnUrl: string;
    thumbnailUrl: string;
    tags: string[];
    collectionId?: string;
    version: number;
    parentAssetId?: string; // for variations
    createdAt: Date;
    expiresAt?: Date; // optional TTL
}

class AssetManagementService {
    async uploadToS3(imageBlob: Buffer, metadata: Partial<AssetMetadata>): Promise<Asset> {
        // Compress to WebP/AVIF
        const compressed = await compressImage(imageBlob, 'webp');

        // Generate S3 key
        const s3Key = `media/${metadata.userId}/${metadata.projectId}/${uuid()}.webp`;

        // Upload to S3
        await s3.putObject({
            Bucket: process.env.S3_BUCKET,
            Key: s3Key,
            Body: compressed,
            ContentType: 'image/webp',
            CacheControl: 'public, max-age=31536000'
        });

        // Generate thumbnail
        const thumbnail = await generateThumbnail(compressed, 256);
        const thumbnailKey = s3Key.replace('.webp', '_thumb.webp');
        await s3.putObject({
            Bucket: process.env.S3_BUCKET,
            Key: thumbnailKey,
            Body: thumbnail,
            ContentType: 'image/webp'
        });

        // Invalidate CDN cache and get URL
        const cdnUrl = await generateCDNUrl(s3Key);
        const thumbnailUrl = await generateCDNUrl(thumbnailKey);

        // Save to database
        const asset = await db.assets.create({
            ...metadata,
            s3Key,
            cdnUrl,
            thumbnailUrl,
            size: compressed.length,
            mimeType: 'image/webp'
        });

        return asset;
    }

    async createCollection(userId: string, name: string): Promise<Collection> {
        return db.collections.create({ userId, name });
    }

    async addToCollection(assetId: string, collectionId: string): Promise<void> {
        await db.assets.update(assetId, { collectionId });
    }

    async createVariation(parentAssetId: string, params: GenerationRequest): Promise<Job> {
        const parent = await db.assets.findById(parentAssetId);
        return mediaQueue.add('variation', {
            operation: 'image-to-image',
            params: {
                ...params,
                initImage: parent.cdnUrl
            },
            parentAssetId
        });
    }
}
```

### 4. Cost Estimation Module

```typescript
interface CostEstimate {
    provider: string;
    model: string;
    operation: string;
    resolution: string;
    baseCost: number;
    qualityCost: number;
    batchDiscount: number;
    totalCost: number;
    estimatedTime: number; // seconds
    creditsRequired: number;
}

class MediaCostCalculator {
    estimateImageCost(
        provider: string,
        model: string,
        width: number,
        height: number,
        quality: string = 'standard',
        batchSize: number = 1
    ): CostEstimate {
        const resolution = `${width}x${height}`;

        // Base cost from provider pricing
        const providerPricing = this.providerPricing[provider][model];
        let baseCost = providerPricing[resolution] || providerPricing.default;

        // Quality multiplier
        const qualityMultiplier = quality === 'hd' ? 2.0 : 1.0;
        const qualityCost = baseCost * (qualityMultiplier - 1);

        // Batch discount (5% per additional image, max 25%)
        const discount = Math.min(0.25, (batchSize - 1) * 0.05);
        const batchDiscount = baseCost * batchSize * discount;

        const totalCost = (baseCost * qualityMultiplier * batchSize) - batchDiscount;

        // Estimated time (empirical data)
        const estimatedTime = this.estimateGenerationTime(provider, model, resolution);

        // Convert to internal credits (1 credit = $0.01)
        const creditsRequired = Math.ceil(totalCost * 100);

        return {
            provider,
            model,
            operation: 'text-to-image',
            resolution,
            baseCost,
            qualityCost,
            batchDiscount,
            totalCost,
            estimatedTime,
            creditsRequired
        };
    }

    estimateVideoCost(duration: number, fps: number, model: string): CostEstimate {
        const frames = duration * fps;
        const costPerFrame = 0.002; // Example pricing
        const totalCost = frames * costPerFrame;

        return {
            provider: 'runway',
            model,
            operation: 'image-to-video',
            resolution: '1080p',
            baseCost: totalCost,
            qualityCost: 0,
            batchDiscount: 0,
            totalCost,
            estimatedTime: duration * 10, // 10 seconds per second of video
            creditsRequired: Math.ceil(totalCost * 100)
        };
    }
}
```

---

## SuperAdmin Dashboard Integration

### Configuration UI Components

```typescript
// SuperAdmin > Settings > Media Generation
interface MediaGenerationSettings {
    providers: {
        stabilityAI: {
            enabled: boolean;
            apiKey: string;
            defaultModel: 'sd-xl-1.0' | 'sd-3.0' | 'sd-3.5-large';
            rateLimit: number;
        };
        openai: {
            enabled: boolean;
            apiKey: string;
            organization?: string;
        };
        flux: {
            enabled: boolean;
            apiKey: string;
            defaultModel: 'flux-pro' | 'flux-dev' | 'flux-schnell';
        };
        midjourney: {
            enabled: boolean;
            discordToken?: string; // Until official API
        };
    };

    storage: {
        s3Bucket: string;
        s3Region: string;
        s3AccessKey: string;
        s3SecretKey: string;
        cdnUrl: string;
        cdnProvider: 'cloudflare' | 'cloudfront' | 'custom';
    };

    defaults: {
        quality: 'standard' | 'hd';
        format: 'png' | 'jpeg' | 'webp' | 'avif';
        compression: 0-100;
        maxResolution: 2048;
        defaultModel: string;
    };

    quotas: {
        perUser: {
            daily: number;
            monthly: number;
        };
        perPlan: {
            free: 10;
            starter: 100;
            pro: 1000;
            enterprise: -1; // unlimited
        };
    };

    pricing: {
        markupPercentage: number; // 0-100, applied to provider costs
        creditPackages: Array<{
            credits: number;
            price: number;
            discount: number;
        }>;
    };
}
```

---

## DAOS (Dynamic Adaptive Overlay System) Integration

### Runtime Configuration via Prompts

```typescript
// SuperAdmin can configure media generation via natural language prompts
interface DAOSMediaConfig {
    runtimePrompts: {
        "enable-ai-images": {
            prompt: "Enable AI image generation for all projects";
            action: async () => {
                await db.tenantSettings.updateAll({
                    mediaGeneration: { enabled: true }
                });
            };
        };

        "set-default-quality-hd": {
            prompt: "Set default image quality to HD for premium users";
            action: async () => {
                await db.tenantSettings.update({
                    where: { plan: 'pro' },
                    data: { mediaDefaults: { quality: 'hd' } }
                });
            };
        };

        "enable-batch-discounts": {
            prompt: "Enable 5% discount for batch image generation";
            action: async () => {
                await db.systemConfig.update({
                    key: 'media.batchDiscount',
                    value: 0.05
                });
            };
        };
    };
}
```

---

## Implementation Phases

### Phase 2.0.5: Media Generation Engine (Weeks 9-10)

#### Week 9: Core Diffusion Integration
**Days 1-2**: Provider SDK Integration
- Integrate Stability AI SDK
- Integrate OpenAI DALL-E 3 SDK
- Create provider abstraction layer
- Implement API key management

**Days 3-4**: Job Queue System
- Setup BullMQ with Redis
- Create job types and schemas
- Implement retry logic
- Build progress tracking

**Day 5**: Basic Generation Workflow
- Text-to-image endpoint
- Simple UI for testing
- Job status polling
- Error handling

#### Week 10: Asset Management & Advanced Features
**Days 1-2**: S3/CDN Integration
- S3 bucket configuration
- CDN distribution setup
- Automatic compression (WebP/AVIF)
- Thumbnail generation

**Days 3-4**: Cost Estimation
- Provider pricing database
- Cost calculator module
- Credit system integration
- Usage tracking

**Day 5**: SuperAdmin UI
- Provider configuration panel
- Quota management
- Pricing controls
- Usage analytics dashboard

---

## Database Schema

```sql
-- Assets table
CREATE TABLE media_assets (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    project_id UUID REFERENCES projects(id) ON DELETE CASCADE,
    filename VARCHAR(255) NOT NULL,
    mime_type VARCHAR(50) NOT NULL,
    size INTEGER NOT NULL,
    width INTEGER NOT NULL,
    height INTEGER NOT NULL,
    provider VARCHAR(50) NOT NULL,
    model VARCHAR(100) NOT NULL,
    cost DECIMAL(10,4) NOT NULL,
    s3_key VARCHAR(500) NOT NULL,
    s3_bucket VARCHAR(100) NOT NULL,
    cdn_url VARCHAR(1000) NOT NULL,
    thumbnail_url VARCHAR(1000),
    generation_params JSONB,
    tags VARCHAR(50)[],
    collection_id UUID REFERENCES media_collections(id) ON DELETE SET NULL,
    version INTEGER DEFAULT 1,
    parent_asset_id UUID REFERENCES media_assets(id) ON DELETE SET NULL,
    created_at TIMESTAMP DEFAULT NOW(),
    expires_at TIMESTAMP,
    INDEX idx_user_project (user_id, project_id),
    INDEX idx_collection (collection_id),
    INDEX idx_created (created_at DESC)
);

-- Collections table
CREATE TABLE media_collections (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    is_public BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT NOW(),
    INDEX idx_user (user_id)
);

-- Generation jobs table
CREATE TABLE media_generation_jobs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    project_id UUID REFERENCES projects(id) ON DELETE CASCADE,
    provider VARCHAR(50) NOT NULL,
    operation VARCHAR(50) NOT NULL,
    params JSONB NOT NULL,
    status VARCHAR(20) NOT NULL,
    progress INTEGER DEFAULT 0,
    result JSONB,
    error JSONB,
    created_at TIMESTAMP DEFAULT NOW(),
    completed_at TIMESTAMP,
    INDEX idx_user_status (user_id, status),
    INDEX idx_created (created_at DESC)
);

-- Usage tracking
CREATE TABLE media_usage (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    asset_id UUID REFERENCES media_assets(id) ON DELETE CASCADE,
    provider VARCHAR(50) NOT NULL,
    operation VARCHAR(50) NOT NULL,
    cost DECIMAL(10,4) NOT NULL,
    credits_used INTEGER NOT NULL,
    created_at TIMESTAMP DEFAULT NOW(),
    INDEX idx_user_date (user_id, created_at),
    INDEX idx_provider (provider)
);
```

---

## API Endpoints

```typescript
// Generate Image
POST /api/media/generate
{
    "provider": "stability" | "openai" | "flux",
    "operation": "text-to-image",
    "prompt": string,
    "negativePrompt"?: string,
    "width": number,
    "height": number,
    "quality": "standard" | "hd",
    "batchSize": number
}

// Get Job Status
GET /api/media/jobs/:jobId

// List Assets
GET /api/media/assets?projectId=...&page=1&limit=20

// Create Collection
POST /api/media/collections
{
    "name": string,
    "description": string
}

// Add to Collection
POST /api/media/collections/:id/assets
{
    "assetIds": string[]
}

// Create Variation
POST /api/media/assets/:id/variations
{
    "prompt": string,
    "strength": 0-1
}

// Upscale
POST /api/media/assets/:id/upscale
{
    "factor": 2 | 4 | 8
}

// Get Cost Estimate
POST /api/media/estimate
{
    "provider": string,
    "operation": string,
    "params": object
}
```

---

## Testing Requirements

### Unit Tests
- Provider SDK wrappers
- Cost calculation logic
- Asset compression/optimization
- Job queue processing

### Integration Tests
- End-to-end generation flow
- S3/CDN upload and retrieval
- Webhook callbacks
- Error handling and retries

### Performance Tests
- Concurrent job processing (100+ simultaneous)
- Large batch generation (50+ images)
- High-resolution upscaling (8K images)
- CDN cache hit rates

---

## Success Metrics

- **Generation Time**: < 30 seconds for standard 1024x1024 image
- **Uptime**: 99.9% availability
- **Cost Accuracy**: Within 1% of actual provider costs
- **Quality Score**: > 95% user satisfaction (via ratings)
- **Batch Efficiency**: 20% cost savings vs individual generation

---

## Future Enhancements (v3.1.0+)

1. **Video Generation** (Runway, Pika)
2. **3D Model Generation** (Point-E, Shap-E)
3. **Audio Generation** (AudioCraft, MusicGen)
4. **Custom Model Training** (LoRA, DreamBooth)
5. **Brand Consistency Enforcement** (Color palette, style matching)
6. **A/B Testing for Generated Assets**
7. **Real-time Collaboration** (Multi-user editing)
8. **AI-Powered Asset Recommendations**

---

**Status**: Ready for implementation
**Dependencies**: Universal Model Router (#2), Token Cost Calculator (#18), Asset Storage, S3/CDN infrastructure
**Estimated Implementation**: 2 weeks (10 working days)
