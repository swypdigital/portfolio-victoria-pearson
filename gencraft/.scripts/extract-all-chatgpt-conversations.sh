#!/usr/bin/env bash
# GenCraft v3.0 - Extract ALL ChatGPT Conversations in Parallel
# Phase 1 Data Gathering - ChatGPT Conversation Extraction
#
# Extracts all 16 unique ChatGPT conversations using BOTH methods:
# - Method 1: gpt-dialogues-extractor (npm package)
# - Method 2: Puppeteer custom extractor (parallel redundancy)
#
# User Directive: "BOTH IN PARALLEL" for guaranteed success

set -euo pipefail

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
OUTPUT_DIR="$PROJECT_ROOT/.gencraft-knowledge-base/chatgpt-conversations"
LOG_DIR="$PROJECT_ROOT/.logs/chatgpt-extraction"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

# Create directories
mkdir -p "$OUTPUT_DIR" "$LOG_DIR"

# ChatGPT URLs (16 unique - duplicates removed)
CHATGPT_URLS=(
  "https://chatgpt.com/share/692c9959-129c-800a-83e6-e444e93556cc"
  "https://chatgpt.com/share/692c97b8-bf10-800a-bf69-255ada581d75"
  "https://chatgpt.com/share/692c985b-3c3c-800a-943f-1e41bab77ed0"
  "https://chatgpt.com/share/692c9877-fee0-800a-837e-b8071e65c7a9"
  "https://chatgpt.com/share/692c9891-7284-800a-9155-33bc0510f926"
  "https://chatgpt.com/share/692c9924-d7c4-800a-b123-d44c6b99a8c4"
  "https://chatgpt.com/share/692c993c-d028-800a-908d-f3c58d519af7"
  "https://chatgpt.com/share/692c9b27-1ce8-800a-acfe-27973fd02ca0"
  "https://chatgpt.com/share/692c9b49-3d94-800a-9f76-ecbadf1a1fc8"
  "https://chatgpt.com/share/692c9c62-2150-800a-abdf-c9dacf48521c"
  "https://chatgpt.com/share/692c9cee-fbc4-800a-b8db-547b55fbd50a"
  "https://chatgpt.com/share/6913f1c0-4ad0-800a-a2d8-3c3abf16ef9f"
  "https://chatgpt.com/share/69225e2b-6ff8-800a-b2ac-c9bd1163a904"
  "https://chatgpt.com/share/692c9e64-6270-800a-8dc0-e91ef5b9ea89"
  "https://chatgpt.com/share/692c9e7e-9d4c-800a-8dc0-e91ef5b9ea89"
  "https://chatgpt.com/share/692c9f39-57a0-800a-836e-b80ac0545604"
  "https://chatgpt.com/share/692c9f4d-b738-800a-a49e-5cb235ea3270"
  "https://chatgpt.com/share/692c9f62-06e4-800a-abc7-8b9bd1706c9e"
  "https://chatgpt.com/share/692c96e2-effc-800a-adbc-f0e22715333d"
)

# Total URLs
TOTAL_URLS=${#CHATGPT_URLS[@]}

echo "════════════════════════════════════════════════════════════════"
echo "  GenCraft v3.0 - ChatGPT Conversation Extraction"
echo "════════════════════════════════════════════════════════════════"
echo "Total URLs: $TOTAL_URLS"
echo "Methods: BOTH (gpt-dialogues-extractor + Puppeteer)"
echo "Output: $OUTPUT_DIR"
echo "Logs: $LOG_DIR"
echo "════════════════════════════════════════════════════════════════"
echo

# Check dependencies
echo "🔍 Checking dependencies..."

# Check Node.js
if ! command -v node &> /dev/null; then
  echo "❌ Node.js not found"
  exit 1
fi
echo "✅ Node.js: $(node --version)"

# Check npm
if ! command -v npm &> /dev/null; then
  echo "❌ npm not found"
  exit 1
fi
echo "✅ npm: $(npm --version)"

# Install dependencies if needed
echo
echo "📦 Installing/checking dependencies..."

cd "$PROJECT_ROOT"

# Check if package.json exists
if [ ! -f "package.json" ]; then
  echo "Creating package.json..."
  npm init -y
fi

# Install Puppeteer if not present
if ! npm list puppeteer &> /dev/null; then
  echo "Installing Puppeteer..."
  npm install puppeteer
fi

# Try to install gpt-dialogues-extractor (might not be available)
echo "Checking for gpt-dialogues-extractor..."
if npm list gpt-dialogues-extractor &> /dev/null; then
  echo "✅ gpt-dialogues-extractor already installed"
  GPT_DIALOGUES_AVAILABLE=true
elif npm install gpt-dialogues-extractor &> /dev/null; then
  echo "✅ gpt-dialogues-extractor installed"
  GPT_DIALOGUES_AVAILABLE=true
else
  echo "⚠️  gpt-dialogues-extractor not available - will use Puppeteer only"
  GPT_DIALOGUES_AVAILABLE=false
fi

echo
echo "════════════════════════════════════════════════════════════════"
echo "  Starting Extraction (Parallel Processing)"
echo "════════════════════════════════════════════════════════════════"
echo

# Function to extract URL ID
extract_url_id() {
  local url="$1"
  echo "$url" | grep -oP '\/share\/\K[a-f0-9-]+'
}

# Function to extract using Puppeteer
extract_puppeteer() {
  local url="$1"
  local url_id="$2"
  local output_file="$OUTPUT_DIR/chatgpt_${url_id}_puppeteer.json"
  local log_file="$LOG_DIR/${url_id}_puppeteer_${TIMESTAMP}.log"

  echo "[Puppeteer] Processing: $url_id" | tee -a "$log_file"

  node "$SCRIPT_DIR/chatgpt-puppeteer-extractor.js" "$url" "$output_file" >> "$log_file" 2>&1

  if [ $? -eq 0 ]; then
    echo "[Puppeteer] ✅ Success: $url_id" | tee -a "$log_file"
    return 0
  else
    echo "[Puppeteer] ❌ Failed: $url_id" | tee -a "$log_file"
    return 1
  fi
}

# Function to extract using gpt-dialogues-extractor
extract_gpt_dialogues() {
  local url="$1"
  local url_id="$2"
  local output_file="$OUTPUT_DIR/chatgpt_${url_id}_gpt-dialogues.json"
  local log_file="$LOG_DIR/${url_id}_gpt-dialogues_${TIMESTAMP}.log"

  echo "[gpt-dialogues] Processing: $url_id" | tee -a "$log_file"

  # Run gpt-dialogues-extractor (command varies by package)
  npx gpt-dialogues-extractor "$url" -o "$output_file" >> "$log_file" 2>&1

  if [ $? -eq 0 ]; then
    echo "[gpt-dialogues] ✅ Success: $url_id" | tee -a "$log_file"
    return 0
  else
    echo "[gpt-dialogues] ❌ Failed: $url_id" | tee -a "$log_file"
    return 1
  fi
}

# Process all URLs in parallel (BOTH methods for each URL)
PIDS=()
SUCCESS_COUNT=0
FAIL_COUNT=0

for url in "${CHATGPT_URLS[@]}"; do
  url_id=$(extract_url_id "$url")

  echo "🚀 Launching extraction for: $url_id"

  # Launch Puppeteer extraction in background
  extract_puppeteer "$url" "$url_id" &
  PIDS+=($!)

  # Launch gpt-dialogues extraction in background (if available)
  if [ "$GPT_DIALOGUES_AVAILABLE" = true ]; then
    extract_gpt_dialogues "$url" "$url_id" &
    PIDS+=($!)
  fi

  # Small delay to avoid overwhelming system
  sleep 1
done

echo
echo "⏳ Waiting for all extractions to complete..."
echo "   Running ${#PIDS[@]} parallel extraction processes..."
echo

# Wait for all background processes
for pid in "${PIDS[@]}"; do
  if wait "$pid"; then
    ((SUCCESS_COUNT++))
  else
    ((FAIL_COUNT++))
  fi
done

echo
echo "════════════════════════════════════════════════════════════════"
echo "  Extraction Complete"
echo "════════════════════════════════════════════════════════════════"
echo "✅ Successful: $SUCCESS_COUNT"
echo "❌ Failed: $FAIL_COUNT"
echo "📁 Output: $OUTPUT_DIR"
echo "📋 Logs: $LOG_DIR"
echo "════════════════════════════════════════════════════════════════"

# List extracted files
echo
echo "📂 Extracted files:"
ls -lh "$OUTPUT_DIR"

# Generate summary report
SUMMARY_FILE="$OUTPUT_DIR/EXTRACTION_SUMMARY_${TIMESTAMP}.md"

cat > "$SUMMARY_FILE" << EOF
# ChatGPT Conversation Extraction Summary

**Date**: $(date)
**Total URLs**: $TOTAL_URLS
**Methods Used**: Puppeteer + gpt-dialogues-extractor (parallel redundancy)

## Results

- **Successful Extractions**: $SUCCESS_COUNT
- **Failed Extractions**: $FAIL_COUNT

## Files

\`\`\`
$(ls -lh "$OUTPUT_DIR")
\`\`\`

## Logs

See \`$LOG_DIR\` for detailed logs of each extraction.

## Next Steps

1. Analyze extracted conversations for GenCraft v3.0 insights
2. Extract key decisions, requirements, and architecture details
3. Identify reusable patterns and frameworks
4. Create comprehensive analysis reports

EOF

echo
echo "📄 Summary report: $SUMMARY_FILE"
echo

if [ $FAIL_COUNT -gt 0 ]; then
  echo "⚠️  Some extractions failed. Check logs in $LOG_DIR"
  exit 1
else
  echo "🎉 All extractions completed successfully!"
  exit 0
fi
