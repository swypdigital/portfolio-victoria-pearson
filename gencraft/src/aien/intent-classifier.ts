/**
 * AIEN Intent Classifier
 * Classifies user prompts to determine vertical and feature access
 * 
 * Performance requirement: <200ms classification time
 * Accuracy target: >85% confidence for valid requests
 */

import { AIENClassificationResult } from './types';

export class IntentClassifier {
  private verticalPatterns: Map<string, RegExp[]>;
  private featurePatterns: Map<string, Map<string, RegExp[]>>;

  constructor() {
    this.verticalPatterns = new Map();
    this.featurePatterns = new Map();
    this.initializePatterns();
  }

  /**
   * Initialize keyword patterns for each vertical and feature
   * This is a simple keyword-based system that can be enhanced with ML later
   */
  private initializePatterns(): void {
    // SaleswriterCraft patterns
    this.verticalPatterns.set('SaleswriterCraft', [
      /sales\s+(letter|email|copy|pitch|page)/i,
      /(landing|squeeze)\s+page/i,
      /email\s+campaign/i,
      /(write|create|generate).*(sales|marketing|promotional)/i,
      /copywriting/i,
      /sales\s+copy/i,
    ]);

    const saleswriterFeatures = new Map<string, RegExp[]>();
    saleswriterFeatures.set('generate_sales_letter', [
      /sales\s+letter/i,
      /write.*letter.*sales/i,
    ]);
    saleswriterFeatures.set('generate_email_campaign', [
      /email\s+campaign/i,
      /(write|create|generate).*email.*series/i,
    ]);
    saleswriterFeatures.set('generate_landing_page', [
      /landing\s+page/i,
      /squeeze\s+page/i,
    ]);
    this.featurePatterns.set('SaleswriterCraft', saleswriterFeatures);

    // AppCraft patterns (Phase 3)
    this.verticalPatterns.set('AppCraft', [
      /(build|create|generate).*app/i,
      /mobile\s+app/i,
      /web\s+app(lication)?/i,
      /react.*app/i,
    ]);

    // LegalCraft patterns (Phase 3)
    this.verticalPatterns.set('LegalCraft', [
      /(legal|contract|agreement)/i,
      /(nda|terms|privacy)/i,
      /draft.*contract/i,
    ]);

    // ContentCraft patterns (Phase 3)
    this.verticalPatterns.set('ContentCraft', [
      /(blog|article|content)/i,
      /write.*(blog|article|post)/i,
      /seo.*content/i,
    ]);
  }

  /**
   * Classify a user prompt to determine which vertical and feature they want
   * 
   * @param prompt - User's input prompt
   * @param hint - Optional vertical hint from client
   * @returns Classification result with confidence score
   */
  async classify(
    prompt: string,
    hint?: string
  ): Promise<AIENClassificationResult> {
    const startTime = Date.now();

    // Normalize prompt for matching
    const normalizedPrompt = prompt.toLowerCase().trim();

    // If hint provided, prioritize that vertical
    if (hint && this.verticalPatterns.has(hint)) {
      const result = this.matchVertical(normalizedPrompt, hint);
      if (result.confidence > 0.7) {
        result.processingTimeMs = Date.now() - startTime;
        return result;
      }
    }

    // Try each vertical in order of likelihood
    const results: AIENClassificationResult[] = [];
    
    for (const [vertical, patterns] of this.verticalPatterns.entries()) {
      const result = this.matchVertical(normalizedPrompt, vertical);
      if (result.confidence > 0.5) {
        results.push(result);
      }
    }

    // Sort by confidence and return best match
    results.sort((a, b) => b.confidence - a.confidence);

    if (results.length === 0) {
      // No match found - return generic result with low confidence
      return {
        vertical: 'unknown',
        feature: 'unknown',
        confidence: 0.0,
        processingTimeMs: Date.now() - startTime,
        alternatives: Array.from(this.verticalPatterns.keys()),
      };
    }

    const bestMatch = results[0];
    bestMatch.processingTimeMs = Date.now() - startTime;
    
    // Add alternatives (next 2 best matches)
    bestMatch.alternatives = results
      .slice(1, 3)
      .map(r => r.vertical);

    return bestMatch;
  }

  /**
   * Match a prompt against a specific vertical's patterns
   */
  private matchVertical(
    normalizedPrompt: string,
    vertical: string
  ): AIENClassificationResult {
    const verticalPatterns = this.verticalPatterns.get(vertical) || [];
    let verticalConfidence = 0;

    // Calculate vertical confidence based on pattern matches
    for (const pattern of verticalPatterns) {
      if (pattern.test(normalizedPrompt)) {
        verticalConfidence += 0.3;  // Each pattern match adds confidence
      }
    }

    // Cap at 1.0
    verticalConfidence = Math.min(verticalConfidence, 1.0);

    // Try to match feature within vertical
    const featureResult = this.matchFeature(normalizedPrompt, vertical);

    return {
      vertical,
      feature: featureResult.feature,
      confidence: Math.max(verticalConfidence, featureResult.confidence),
      processingTimeMs: 0,  // Will be set by caller
    };
  }

  /**
   * Match a prompt against features within a vertical
   */
  private matchFeature(
    normalizedPrompt: string,
    vertical: string
  ): { feature: string; confidence: number } {
    const features = this.featurePatterns.get(vertical);
    if (!features) {
      return { feature: 'default', confidence: 0.5 };
    }

    let bestMatch = { feature: 'default', confidence: 0.5 };

    for (const [feature, patterns] of features.entries()) {
      let featureConfidence = 0;
      
      for (const pattern of patterns) {
        if (pattern.test(normalizedPrompt)) {
          featureConfidence += 0.4;
        }
      }

      if (featureConfidence > bestMatch.confidence) {
        bestMatch = { feature, confidence: Math.min(featureConfidence, 1.0) };
      }
    }

    return bestMatch;
  }

  /**
   * Get all available verticals
   */
  getAvailableVerticals(): string[] {
    return Array.from(this.verticalPatterns.keys());
  }

  /**
   * Get features available in a vertical
   */
  getVerticalFeatures(vertical: string): string[] {
    const features = this.featurePatterns.get(vertical);
    if (!features) return [];
    return Array.from(features.keys());
  }
}
