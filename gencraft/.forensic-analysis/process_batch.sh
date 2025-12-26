#!/bin/bash
# Process screenshots in batches for vision analysis

ANALYSIS_DIR="/tmp/gencraft_analysis"
BATCH_SIZE=10

# Get sorted list of all JSON files
find "$ANALYSIS_DIR" -name "doc_*.json" -type f | sort > /tmp/json_files_list.txt

TOTAL=$(wc -l < /tmp/json_files_list.txt)
echo "Total documents to process: $TOTAL"
echo "Processing in batches of $BATCH_SIZE"

# Create batch files
split -l $BATCH_SIZE /tmp/json_files_list.txt /tmp/batch_

echo "Created batch files in /tmp/batch_*"
ls -1 /tmp/batch_* | wc -l
