#!/usr/bin/env python3
"""
GENCRAFT V3.0 VISION-BASED CONTENT EXTRACTOR
Reads screenshots and extracts comprehensive content
"""

import os
import json
from datetime import datetime
from pathlib import Path

def extract_content_from_screenshots(json_file_path):
    """
    Extract actual content from screenshots referenced in JSON file.
    This is a placeholder - actual extraction would use Claude's vision API.
    For now, we'll mark which files need vision analysis.
    """
    
    with open(json_file_path, 'r') as f:
        doc_data = json.load(f)
    
    screenshots = doc_data['document_metadata']['screenshots']
    
    # Create a vision analysis request list
    vision_request = {
        'document_id': doc_data['document_metadata']['document_id'],
        'timestamp': doc_data['document_metadata']['screenshots'][0]['timestamp'],
        'screenshots_to_analyze': [
            {
                'filepath': s['filepath'],
                'filename': s['filename'],
                'part_number': s['part_number']
            }
            for s in screenshots
        ],
        'analysis_prompt': """
        Extract ALL visible content from this screenshot:
        
        1. Full text transcription
        2. Architecture components (services, engines, schemas, tech stack)
        3. Requirements (functional and non-functional)
        4. Security measures and threats
        5. Code snippets (with language identification)
        6. Decisions made and rationale
        7. Scope details (verticals, capabilities, languages)
        8. Pain points or problems mentioned
        9. Timeline information (phases, weeks, milestones)
        10. User instructions or corrections
        
        Be comprehensive - extract EVERYTHING visible.
        """
    }
    
    return vision_request

def main():
    analysis_dir = '/tmp/gencraft_analysis'
    
    # Find all JSON files
    json_files = []
    for date_dir in sorted(os.listdir(analysis_dir)):
        date_path = os.path.join(analysis_dir, date_dir)
        if os.path.isdir(date_path) and date_dir.startswith('2025'):
            for filename in sorted(os.listdir(date_path)):
                if filename.endswith('.json'):
                    json_files.append(os.path.join(date_path, filename))
    
    print(f"Found {len(json_files)} documents to analyze")
    
    # Create vision analysis requests
    vision_requests_dir = os.path.join(analysis_dir, 'vision_requests')
    os.makedirs(vision_requests_dir, exist_ok=True)
    
    for json_file in json_files:
        vision_request = extract_content_from_screenshots(json_file)
        
        # Save vision request
        request_filename = os.path.basename(json_file).replace('.json', '_vision_request.json')
        request_path = os.path.join(vision_requests_dir, request_filename)
        
        with open(request_path, 'w') as f:
            json.dump(vision_request, f, indent=2)
    
    print(f"Created {len(json_files)} vision analysis requests in {vision_requests_dir}")
    print("\nNext step: Process vision requests using Claude's Read tool on each screenshot")

if __name__ == '__main__':
    main()
