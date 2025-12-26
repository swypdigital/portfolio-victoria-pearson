#!/usr/bin/env node
/**
 * ChatGPT Share URL Conversation Extractor (Puppeteer Method)
 * GenCraft v3.0 - Phase 1 Data Gathering
 *
 * Extracts conversation content from ChatGPT share URLs using Puppeteer browser automation.
 * Runs in parallel with gpt-dialogues-extractor for redundancy.
 *
 * Usage: node chatgpt-puppeteer-extractor.js <url> [output-file]
 */

const puppeteer = require('puppeteer');
const fs = require('fs');
const path = require('path');

// Configuration
const DEFAULT_OUTPUT_DIR = path.join(__dirname, '../.gencraft-knowledge-base/chatgpt-conversations');
const WAIT_TIMEOUT = 30000; // 30 seconds
const NAVIGATION_TIMEOUT = 60000; // 60 seconds

/**
 * Extract conversation from ChatGPT share URL
 * @param {string} url - ChatGPT share URL
 * @param {string} outputPath - Optional output file path
 * @returns {Promise<object>} Extracted conversation data
 */
async function extractConversation(url, outputPath) {
  console.log(`\n🔍 Extracting ChatGPT conversation from: ${url}`);

  let browser;
  try {
    // Launch headless browser
    browser = await puppeteer.launch({
      headless: true,
      args: [
        '--no-sandbox',
        '--disable-setuid-sandbox',
        '--disable-dev-shm-usage',
        '--disable-accelerated-2d-canvas',
        '--disable-gpu'
      ]
    });

    const page = await browser.newPage();

    // Set realistic user agent
    await page.setUserAgent('Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/119.0.0.0 Safari/537.36');

    // Set viewport
    await page.setViewport({ width: 1280, height: 720 });

    console.log('📡 Loading page...');

    // Navigate to URL
    await page.goto(url, {
      waitUntil: 'networkidle2',
      timeout: NAVIGATION_TIMEOUT
    });

    // Wait for main content to load
    console.log('⏳ Waiting for conversation content...');

    // Try multiple selectors (ChatGPT's DOM structure may vary)
    const selectors = [
      '[data-testid^="conversation-turn"]',
      '.text-base',
      '[class*="markdown"]',
      'main article',
      'main div[class*="group"]'
    ];

    let contentLoaded = false;
    for (const selector of selectors) {
      try {
        await page.waitForSelector(selector, { timeout: WAIT_TIMEOUT });
        contentLoaded = true;
        console.log(`✅ Content loaded using selector: ${selector}`);
        break;
      } catch (e) {
        console.log(`⚠️  Selector failed: ${selector}`);
      }
    }

    if (!contentLoaded) {
      throw new Error('Failed to load conversation content with any known selector');
    }

    // Extract conversation data
    console.log('📊 Extracting conversation data...');

    const conversationData = await page.evaluate(() => {
      const extractText = (element) => {
        // Remove script and style elements
        const clone = element.cloneNode(true);
        const scripts = clone.querySelectorAll('script, style');
        scripts.forEach(s => s.remove());
        return clone.textContent.trim();
      };

      const messages = [];

      // Try to find conversation turns
      const turns = document.querySelectorAll('[data-testid^="conversation-turn"]');

      if (turns.length > 0) {
        // Modern ChatGPT structure
        turns.forEach((turn, index) => {
          const role = turn.getAttribute('data-testid').includes('user') ? 'user' : 'assistant';
          const content = extractText(turn);

          messages.push({
            index,
            role,
            content,
            timestamp: null // ChatGPT share pages don't include timestamps
          });
        });
      } else {
        // Fallback: Try to extract all text blocks
        const textBlocks = document.querySelectorAll('.text-base, [class*="markdown"], main article > div');

        textBlocks.forEach((block, index) => {
          const content = extractText(block);
          if (content && content.length > 20) { // Filter out short/empty blocks
            messages.push({
              index,
              role: index % 2 === 0 ? 'user' : 'assistant', // Guess based on alternation
              content,
              timestamp: null
            });
          }
        });
      }

      // Extract metadata
      const titleElement = document.querySelector('title');
      const title = titleElement ? titleElement.textContent : 'Untitled Conversation';

      return {
        title,
        url: window.location.href,
        messageCount: messages.length,
        messages,
        extractedAt: new Date().toISOString(),
        method: 'puppeteer'
      };
    });

    console.log(`✅ Extracted ${conversationData.messageCount} messages`);
    console.log(`📝 Title: ${conversationData.title}`);

    // Save to file if output path provided
    if (outputPath) {
      // Ensure output directory exists
      const outputDir = path.dirname(outputPath);
      if (!fs.existsSync(outputDir)) {
        fs.mkdirSync(outputDir, { recursive: true });
      }

      // Save as JSON
      fs.writeFileSync(
        outputPath,
        JSON.stringify(conversationData, null, 2),
        'utf8'
      );

      console.log(`💾 Saved to: ${outputPath}`);

      // Also save as Markdown for easy reading
      const mdPath = outputPath.replace('.json', '.md');
      const markdown = generateMarkdown(conversationData);
      fs.writeFileSync(mdPath, markdown, 'utf8');
      console.log(`📄 Markdown saved to: ${mdPath}`);
    }

    return conversationData;

  } catch (error) {
    console.error(`❌ Error extracting conversation: ${error.message}`);
    throw error;
  } finally {
    if (browser) {
      await browser.close();
    }
  }
}

/**
 * Generate Markdown from conversation data
 * @param {object} data - Conversation data
 * @returns {string} Markdown content
 */
function generateMarkdown(data) {
  let md = `# ${data.title}\n\n`;
  md += `**Source**: ${data.url}\n`;
  md += `**Extracted**: ${data.extractedAt}\n`;
  md += `**Method**: ${data.method}\n`;
  md += `**Messages**: ${data.messageCount}\n\n`;
  md += `---\n\n`;

  data.messages.forEach((msg, idx) => {
    const roleLabel = msg.role === 'user' ? '**User**' : '**Assistant**';
    md += `## Message ${idx + 1} - ${roleLabel}\n\n`;
    md += `${msg.content}\n\n`;
    md += `---\n\n`;
  });

  return md;
}

/**
 * Extract URL ID from ChatGPT share URL
 * @param {string} url - ChatGPT share URL
 * @returns {string} URL ID
 */
function extractUrlId(url) {
  const match = url.match(/\/share\/([a-f0-9-]+)/);
  return match ? match[1] : 'unknown';
}

// Main execution
if (require.main === module) {
  const args = process.argv.slice(2);

  if (args.length === 0) {
    console.error('Usage: node chatgpt-puppeteer-extractor.js <url> [output-file]');
    process.exit(1);
  }

  const url = args[0];
  const urlId = extractUrlId(url);
  const outputFile = args[1] || path.join(
    DEFAULT_OUTPUT_DIR,
    `chatgpt_${urlId}_puppeteer.json`
  );

  extractConversation(url, outputFile)
    .then(() => {
      console.log('\n✅ Extraction complete!\n');
      process.exit(0);
    })
    .catch((error) => {
      console.error('\n❌ Extraction failed:', error.message);
      process.exit(1);
    });
}

module.exports = { extractConversation, extractUrlId };
