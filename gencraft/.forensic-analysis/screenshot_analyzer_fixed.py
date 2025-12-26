#!/usr/bin/env python3
"""
GENCRAFT V3.0 FORENSIC SCREENSHOT ANALYZER
Comprehensive multi-part document detection and analysis
"""

import os
import json
import re
from datetime import datetime, timedelta
from pathlib import Path
from typing import List, Dict, Tuple, Optional
from collections import defaultdict

class ScreenshotDocument:
    """Represents a logical document (may contain multiple screenshot parts)"""
    
    def __init__(self, doc_id: str):
        self.doc_id = doc_id
        self.title = ""
        self.screenshots = []
        self.is_multipart = False
        self.total_parts = 0
        
    def add_screenshot(self, filepath: str, timestamp: datetime, part_number: int):
        self.screenshots.append({
            'filename': os.path.basename(filepath),
            'filepath': filepath,
            'timestamp': timestamp.strftime('%Y-%m-%d %H:%M:%S'),
            'timestamp_obj': timestamp,  # Keep datetime object
            'part_number': part_number
        })
        self.total_parts = len(self.screenshots)
        self.is_multipart = self.total_parts > 1
        
    def to_dict(self) -> dict:
        # Remove timestamp_obj from output
        screenshots_clean = []
        for s in self.screenshots:
            s_clean = {k: v for k, v in s.items() if k != 'timestamp_obj'}
            screenshots_clean.append(s_clean)
            
        return {
            'document_id': self.doc_id,
            'document_title': self.title,
            'is_multipart': self.is_multipart,
            'total_parts': self.total_parts,
            'screenshots': screenshots_clean
        }

class ScreenshotAnalyzer:
    """Main analyzer for processing screenshots chronologically"""
    
    def __init__(self, input_file: str, output_dir: str):
        self.input_file = input_file
        self.output_dir = output_dir
        self.screenshots = []
        self.documents = []
        self.multipart_threshold = timedelta(seconds=30)
        
    def parse_timestamp(self, timestamp_str: str) -> datetime:
        """Parse timestamp from format: 2025-11-25+11:12:02.0011696000"""
        clean_ts = timestamp_str.split('.')[0]  # Remove nanoseconds
        return datetime.strptime(clean_ts, '%Y-%m-%d+%H:%M:%S')
    
    def load_screenshots(self):
        """Load and parse all screenshots from input file"""
        print(f"Loading screenshots from {self.input_file}...")
        with open(self.input_file, 'r') as f:
            for line in f:
                line = line.strip()
                if not line:
                    continue
                parts = line.split(' ', 1)
                if len(parts) == 2:
                    timestamp_str, filepath = parts
                    timestamp = self.parse_timestamp(timestamp_str)
                    self.screenshots.append({
                        'timestamp': timestamp,
                        'filepath': filepath,
                        'filename': os.path.basename(filepath)
                    })
        print(f"Loaded {len(self.screenshots)} screenshots")
        
    def extract_sequential_number(self, filename: str) -> Optional[int]:
        """Extract sequential number from filenames like 'Screenshot (3585).png'"""
        match = re.search(r'\((\d+)\)', filename)
        if match:
            return int(match.group(1))
        return None
    
    def is_sequential_filename(self, filename1: str, filename2: str) -> bool:
        """Check if filenames are sequential (e.g., (3585), (3586))"""
        num1 = self.extract_sequential_number(filename1)
        num2 = self.extract_sequential_number(filename2)
        if num1 and num2:
            return abs(num2 - num1) == 1
        return False
    
    def extract_title_from_filename(self, filename: str) -> Optional[str]:
        """Extract descriptive title from filename if present"""
        # Remove extension
        name = os.path.splitext(filename)[0]
        
        # Check for named screenshots (e.g., "CLAUDE CODE GENESIS PROMPT Screenshot...")
        if 'Screenshot' in name:
            parts = name.split('Screenshot')
            if parts[0].strip():
                return parts[0].strip()
        
        return None
    
    def detect_multipart_documents(self) -> List[ScreenshotDocument]:
        """Detect and group multi-part documents"""
        documents = []
        processed = set()
        
        for i, screenshot in enumerate(self.screenshots):
            if i in processed:
                continue
            
            # Start a new document
            timestamp = screenshot['timestamp']
            doc_id = f"DOC_{timestamp.strftime('%Y%m%d_%H%M%S')}_{len(documents)+1:03d}"
            document = ScreenshotDocument(doc_id)
            
            # Add first part
            document.add_screenshot(screenshot['filepath'], timestamp, 1)
            processed.add(i)
            
            # Extract title if present
            title = self.extract_title_from_filename(screenshot['filename'])
            if title:
                document.title = title
            
            # Look for subsequent parts (within 30 seconds)
            part_number = 2
            for j in range(i+1, len(self.screenshots)):
                if j in processed:
                    continue
                    
                next_screenshot = self.screenshots[j]
                next_timestamp = next_screenshot['timestamp']
                time_diff = next_timestamp - timestamp
                
                # Check if within multipart threshold
                if time_diff <= self.multipart_threshold:
                    # Additional checks for same document
                    is_same_doc = False
                    
                    # 1. Sequential numbering
                    if self.is_sequential_filename(
                        self.screenshots[j-1]['filename'], 
                        next_screenshot['filename']
                    ):
                        is_same_doc = True
                    
                    # 2. Same title prefix
                    next_title = self.extract_title_from_filename(next_screenshot['filename'])
                    if title and next_title and title == next_title:
                        is_same_doc = True
                    
                    # 3. Timestamps very close (<30 sec)
                    if time_diff.total_seconds() < 30:
                        # Check if previous screenshot was part of this doc
                        if j == i + len(document.screenshots):
                            is_same_doc = True
                    
                    if is_same_doc:
                        document.add_screenshot(next_screenshot['filepath'], next_timestamp, part_number)
                        processed.add(j)
                        part_number += 1
                        timestamp = next_timestamp  # Update for next iteration
                    else:
                        break
                else:
                    break
            
            documents.append(document)
        
        return documents
    
    def analyze_document(self, document: ScreenshotDocument) -> dict:
        """Analyze a document (placeholder - will read actual screenshot content)"""
        # This is where we'd use OCR/vision to extract actual content
        # For now, creating the structure with metadata
        
        analysis = {
            'document_metadata': document.to_dict(),
            'analysis_timestamp': datetime.now().strftime('%Y-%m-%d %H:%M:%S'),
            'extracted_content': {
                'full_text': f"[Content from {document.total_parts} screenshot(s) - requires vision analysis]",
                'architecture': {
                    'components': [],
                    'services': [],
                    'engines': [],
                    'integrations': [],
                    'tech_stack': []
                },
                'requirements': {
                    'functional': [],
                    'non_functional': []
                },
                'security': {
                    'measures': [],
                    'deadlines': [],
                    'threats': []
                },
                'code_snippets': [],
                'decisions': [],
                'scope': {
                    'verticals': [],
                    'overlays': [],
                    'capabilities': [],
                    'languages': ""
                },
                'pain_points': [],
                'timeline': {
                    'phases': [],
                    'total_weeks': 0,
                    'critical_milestones': []
                },
                'user_instructions': []
            }
        }
        
        # Add title to metadata if available
        if document.title:
            analysis['document_metadata']['document_title'] = document.title
        
        return analysis
    
    def save_document_analysis(self, analysis: dict):
        """Save individual document analysis as JSON"""
        doc_metadata = analysis['document_metadata']
        timestamp_str = doc_metadata['screenshots'][0]['timestamp']
        timestamp = datetime.strptime(timestamp_str, '%Y-%m-%d %H:%M:%S')
        
        # Determine date folder
        date_folder = timestamp.strftime('%Y%m%d')
        date_path = os.path.join(self.output_dir, date_folder)
        os.makedirs(date_path, exist_ok=True)
        
        # Create filename
        doc_id = doc_metadata['document_id']
        filename = f"doc_{timestamp.strftime('%H%M%S')}_{doc_id}.json"
        filepath = os.path.join(date_path, filename)
        
        # Save JSON
        with open(filepath, 'w') as f:
            json.dump(analysis, f, indent=2)
        
        return filepath
    
    def generate_daily_summary(self, date: str, documents: List[dict]) -> str:
        """Generate markdown summary for a specific date"""
        date_obj = datetime.strptime(date, '%Y%m%d')
        date_formatted = date_obj.strftime('%B %d, %Y')
        
        if not documents:
            return ""
        
        # Sort by timestamp
        documents.sort(key=lambda d: d['document_metadata']['screenshots'][0]['timestamp'])
        
        first_time = documents[0]['document_metadata']['screenshots'][0]['timestamp'].split(' ')[1]
        last_time = documents[-1]['document_metadata']['screenshots'][0]['timestamp'].split(' ')[1]
        
        total_screenshots = sum(doc['document_metadata']['total_parts'] for doc in documents)
        multipart_count = sum(1 for doc in documents if doc['document_metadata']['is_multipart'])
        single_count = len(documents) - multipart_count
        
        markdown = f"""# GENCRAFT V3.0 SESSION ANALYSIS - {date_formatted}

## Session Overview
- Date: {date_formatted}
- Time Span: {first_time} - {last_time}
- Total Screenshots: {total_screenshots}
- Multi-part Documents: {multipart_count}
- Single Screenshots: {single_count}
- Total Logical Documents: {len(documents)}

## Chronological Timeline

"""
        
        for doc in documents:
            metadata = doc['document_metadata']
            timestamp = metadata['screenshots'][0]['timestamp']
            doc_id = metadata['document_id']
            title = metadata.get('document_title', 'Untitled')
            
            if metadata['is_multipart']:
                screenshot_list = ', '.join([s['filename'] for s in metadata['screenshots']])
                markdown += f"""### {timestamp} - {title} ({metadata['total_parts']}-part document)
**Document ID:** {doc_id}
**Screenshots:** {screenshot_list}
**Key Content:**
[Requires vision analysis of actual screenshots]

"""
            else:
                screenshot = metadata['screenshots'][0]['filename']
                markdown += f"""### {timestamp} - {screenshot}
**Document ID:** {doc_id}
**Single Screenshot**
**Key Content:**
[Requires vision analysis of actual screenshot]

"""
        
        markdown += """## Daily Summary

### Architecture Decisions
[To be extracted from screenshot content]

### Requirements Identified
[To be extracted from screenshot content]

### Security Considerations
[To be extracted from screenshot content]

### Scope Clarifications
[To be extracted from screenshot content]

### Pain Points Identified
[To be extracted from screenshot content]

## Cumulative Progress
[To be determined from screenshot analysis]
"""
        
        return markdown
    
    def process_all(self):
        """Main processing pipeline"""
        print("\n" + "="*80)
        print("GENCRAFT V3.0 FORENSIC SCREENSHOT ANALYSIS")
        print("="*80 + "\n")
        
        # Load screenshots
        self.load_screenshots()
        
        # Detect multi-part documents
        print("\nDetecting multi-part documents...")
        self.documents = self.detect_multipart_documents()
        
        multipart_count = sum(1 for doc in self.documents if doc.is_multipart)
        total_parts = sum(doc.total_parts for doc in self.documents)
        
        print(f"  Total logical documents: {len(self.documents)}")
        print(f"  Multi-part documents: {multipart_count}")
        print(f"  Single screenshots: {len(self.documents) - multipart_count}")
        print(f"  Total screenshot parts: {total_parts}")
        
        # Analyze and save each document
        print("\nAnalyzing documents...")
        analyses_by_date = defaultdict(list)
        
        for i, document in enumerate(self.documents, 1):
            if i % 50 == 0:
                print(f"  Processed {i}/{len(self.documents)} documents...")
            
            analysis = self.analyze_document(document)
            filepath = self.save_document_analysis(analysis)
            
            # Group by date for daily summaries (use timestamp_obj from first screenshot)
            timestamp = document.screenshots[0]['timestamp_obj']
            date_key = timestamp.strftime('%Y%m%d')
            analyses_by_date[date_key].append(analysis)
        
        print(f"  Completed {len(self.documents)} document analyses")
        
        # Generate daily summaries
        print("\nGenerating daily summaries...")
        for date, documents in sorted(analyses_by_date.items()):
            date_obj = datetime.strptime(date, '%Y%m%d')
            month_abbr = date_obj.strftime('%b').lower()
            day = date_obj.strftime('%d')
            
            summary_filename = f"consolidated_{month_abbr}{day}.md"
            summary_path = os.path.join(self.output_dir, summary_filename)
            
            markdown = self.generate_daily_summary(date, documents)
            with open(summary_path, 'w') as f:
                f.write(markdown)
            
            print(f"  Generated {summary_filename} ({len(documents)} documents)")
        
        # Generate statistics report
        self.generate_statistics_report()
        
        print("\n" + "="*80)
        print("ANALYSIS COMPLETE")
        print("="*80)
        print(f"\nOutput directory: {self.output_dir}")
        print(f"  - Individual JSON files: {len(self.documents)}")
        print(f"  - Daily summaries: {len(analyses_by_date)}")
        print(f"  - Statistics report: statistics_report.json")
        
    def generate_statistics_report(self):
        """Generate overall statistics report"""
        stats = {
            'analysis_timestamp': datetime.now().strftime('%Y-%m-%d %H:%M:%S'),
            'total_screenshots': len(self.screenshots),
            'total_documents': len(self.documents),
            'multipart_documents': sum(1 for doc in self.documents if doc.is_multipart),
            'single_documents': sum(1 for doc in self.documents if not doc.is_multipart),
            'date_range': {
                'start': self.screenshots[0]['timestamp'].strftime('%Y-%m-%d %H:%M:%S'),
                'end': self.screenshots[-1]['timestamp'].strftime('%Y-%m-%d %H:%M:%S')
            },
            'by_date': {}
        }
        
        # Group statistics by date
        by_date = defaultdict(lambda: {'screenshots': 0, 'documents': 0, 'multipart': 0})
        
        for doc in self.documents:
            timestamp = doc.screenshots[0]['timestamp_obj']
            date_key = timestamp.strftime('%Y-%m-%d')
            
            by_date[date_key]['screenshots'] += doc.total_parts
            by_date[date_key]['documents'] += 1
            if doc.is_multipart:
                by_date[date_key]['multipart'] += 1
        
        stats['by_date'] = dict(by_date)
        
        # Save statistics
        stats_path = os.path.join(self.output_dir, 'statistics_report.json')
        with open(stats_path, 'w') as f:
            json.dump(stats, f, indent=2)

def main():
    input_file = '/tmp/gencraft_logs/all_screenshots_sorted.txt'
    output_dir = '/tmp/gencraft_analysis'
    
    analyzer = ScreenshotAnalyzer(input_file, output_dir)
    analyzer.process_all()

if __name__ == '__main__':
    main()
