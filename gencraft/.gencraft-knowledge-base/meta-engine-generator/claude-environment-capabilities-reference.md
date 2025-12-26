# Claude Environment Capabilities Reference
## Complete Tool & Command Reference for Maximizing Claude Chat Sessions

---

**Document ID:** CLAUDE-ENVIRONMENT-CAPABILITIES-REFERENCE  
**Version:** 1.0.0  
**Created:** December 24, 2025  
**Author:** groklyGroup LLC  
**Purpose:** Maximize productivity by understanding all available tools

---

## Quick Reference Card

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                        CLAUDE ENVIRONMENT AT A GLANCE                        │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  OPERATING SYSTEM:     Ubuntu 24 Linux                                      │
│  PYTHON:               3.12.3 + pip                                         │
│  NODE.JS:              22.21.0 + npm 10.9.4                                 │
│  GIT:                  2.43.0                                               │
│                                                                             │
│  FILE ACCESS:                                                               │
│    • User uploads:     /mnt/user-data/uploads/ (read-only)                  │
│    • Working dir:      /home/claude/ (read-write, temporary)                │
│    • Final outputs:    /mnt/user-data/outputs/ (downloadable)               │
│    • Skills library:   /mnt/skills/ (read-only)                             │
│                                                                             │
│  NETWORK:              Enabled (can fetch URLs, APIs)                       │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## Part 1: Claude-Specific Tools

### File Operations

#### `view` - Read Files, Directories, and Images

**What It Does:** Displays file contents, lists directory structures, shows images

**Examples:**

```
YOU: "Show me what's in my uploads folder"
CLAUDE: [Uses view on /mnt/user-data/uploads/]
→ Lists all files you've uploaded this session

YOU: "What does line 50-100 of that document say?"
CLAUDE: [Uses view with view_range=[50,100]]
→ Shows just those lines, not entire file

YOU: "Look at this screenshot and tell me what's wrong"
CLAUDE: [Uses view on the image file]
→ Displays image and analyzes it

YOU: "How is the skills folder organized?"
CLAUDE: [Uses view on /mnt/skills/]
→ Shows directory tree 2 levels deep
```

---

#### `create_file` - Generate New Files

**What It Does:** Creates a new file with specified content

**Examples:**

```
YOU: "Create a Python script that converts CSV to JSON"
CLAUDE: [Uses create_file with Python code]
→ Creates script.py ready to run or download

YOU: "Write me a project README"
CLAUDE: [Uses create_file with markdown]
→ Creates README.md with proper formatting

YOU: "Generate a config file for my app"
CLAUDE: [Uses create_file with YAML/JSON]
→ Creates config.yaml with your specifications
```

---

#### `str_replace` - Surgical Edits (TOKEN SAVER!)

**What It Does:** Finds exact text in a file and replaces it with new text

**Examples:**

```
YOU: "Change the version number from 3.0.0 to 4.0.0"
CLAUDE: [Uses str_replace to find "3.0.0" and replace with "4.0.0"]
→ Single edit, document unchanged otherwise
→ Saves regenerating entire 2000-line document

YOU: "The date is wrong - it should say December 24 not December 23"
CLAUDE: [Uses str_replace on the specific date]
→ Fixes just that text

YOU: "Add a new section after the Introduction"
CLAUDE: [Uses str_replace to find end of Introduction, replaces with Introduction + new section]
→ Inserts content at exact location

YOU: "Delete the paragraph about pricing"
CLAUDE: [Uses str_replace with old_str=paragraph, new_str=""]
→ Removes just that paragraph
```

**Pro Tip:** This is your biggest token saver. A 50-line edit on a 2000-line document uses ~50 tokens instead of ~2000.

---

#### `present_files` - Deliver Downloadable Files

**What It Does:** Makes files available for you to download

**Examples:**

```
YOU: "Give me that document"
CLAUDE: [Uses present_files]
→ File appears as downloadable link

YOU: "I need all three files"
CLAUDE: [Uses present_files with array of paths]
→ Multiple download links in one response
```

---

### Search & Research Tools

#### `web_search` - Search the Internet

**What It Does:** Searches the web and returns top results

**Examples:**

```
YOU: "What's the latest on AI regulations in the EU?"
CLAUDE: [Uses web_search for "EU AI regulations 2025"]
→ Returns current news and policy updates

YOU: "Find documentation for the OpenAI API"
CLAUDE: [Uses web_search for "OpenAI API documentation"]
→ Returns official docs and tutorials

YOU: "Who won the game last night?"
CLAUDE: [Uses web_search for specific game/sport]
→ Returns current scores and news
```

---

#### `web_fetch` - Get Full Webpage Content

**What It Does:** Retrieves the complete content of a specific URL

**Examples:**

```
YOU: "Read this article and summarize it: [URL]"
CLAUDE: [Uses web_fetch on the URL]
→ Gets full article text, then summarizes

YOU: "What does the pricing page say?"
CLAUDE: [Uses web_fetch on pricing URL]
→ Extracts all pricing information

YOU: "Check if this documentation covers my use case"
CLAUDE: [Uses web_fetch on docs URL]
→ Reads full documentation page
```

---

#### `google_drive_search` - Search Your Google Drive

**What It Does:** Searches across your connected Google Drive files

**Examples:**

```
YOU: "Find my Q3 sales presentation"
CLAUDE: [Uses google_drive_search with query "Q3 sales presentation"]
→ Returns matching files from your Drive

YOU: "What documents mention Project Atlas?"
CLAUDE: [Uses google_drive_search with fullText contains 'Project Atlas']
→ Finds all docs containing that term

YOU: "Show me files I modified last week"
CLAUDE: [Uses google_drive_search with date filter]
→ Returns recently modified files
```

---

#### `google_drive_fetch` - Read Google Doc Contents

**What It Does:** Retrieves the full content of a specific Google Doc

**Examples:**

```
YOU: "Read my strategy doc and tell me if it addresses competitor analysis"
CLAUDE: [Uses google_drive_fetch with doc ID]
→ Gets full document, analyzes content

YOU: "Pull the content from this Google Doc: [URL]"
CLAUDE: [Extracts ID from URL, uses google_drive_fetch]
→ Returns document content for processing
```

---

#### `conversation_search` - Search Past Claude Chats

**What It Does:** Searches your conversation history with Claude

**Examples:**

```
YOU: "What did we decide about the database schema?"
CLAUDE: [Uses conversation_search for "database schema"]
→ Finds relevant past conversations

YOU: "Find our discussion about pricing strategy"
CLAUDE: [Uses conversation_search for "pricing strategy"]
→ Returns snippets from past chats

YOU: "When did we create the Meta Engine Generator?"
CLAUDE: [Uses conversation_search for "Meta Engine Generator"]
→ Finds origin conversation with date
```

---

#### `recent_chats` - Get Recent Conversations

**What It Does:** Retrieves your most recent Claude conversations

**Examples:**

```
YOU: "What were we working on yesterday?"
CLAUDE: [Uses recent_chats with date filter]
→ Lists yesterday's conversations

YOU: "Continue from our last chat"
CLAUDE: [Uses recent_chats with n=1]
→ Loads most recent conversation context

YOU: "Show me my last 5 conversations"
CLAUDE: [Uses recent_chats with n=5]
→ Lists recent chat summaries
```

---

### Memory & Preferences

#### `memory_user_edits` - Manage Persistent Memory

**What It Does:** View, add, remove, or update what Claude remembers about you

**Examples:**

```
YOU: "What do you remember about me?"
CLAUDE: [Uses memory_user_edits with command="view"]
→ Shows all stored memories

YOU: "Remember that I prefer dark mode examples in code"
CLAUDE: [Uses memory_user_edits with command="add"]
→ Adds preference to memory

YOU: "I no longer work at Acme Corp"
CLAUDE: [Uses memory_user_edits with command="remove" on that line]
→ Removes outdated info

YOU: "Actually, update my title - I'm now CTO not VP"
CLAUDE: [Uses memory_user_edits with command="replace"]
→ Updates existing memory
```

---

## Part 2: Linux Command Line (Bash)

### File Management Commands

#### `mv` - Move or Rename Files

**Examples:**

```bash
# Rename a file (THE NEW CAPABILITY!)
mv old-document-name.md new-document-name.md

# Move file to different directory
mv draft.md /mnt/user-data/outputs/final.md

# Rename multiple files with pattern (batch rename)
for f in *.txt; do mv "$f" "${f%.txt}.md"; done
```

**Real Use Case:**
```
YOU: "Rename the output from 'universal-engine' to 'meta-engine'"
CLAUDE: mv universal-engine-v4.md meta-engine-v4.md
→ File now downloads with new name
```

---

#### `cp` - Copy Files

**Examples:**

```bash
# Create a backup before editing
cp important-doc.md important-doc-backup.md

# Copy to outputs folder
cp /home/claude/work.md /mnt/user-data/outputs/

# Copy entire directory
cp -r project-folder/ project-folder-backup/
```

**Real Use Case:**
```
YOU: "Make a copy of that document for the client version"
CLAUDE: cp internal-strategy.md client-strategy.md
→ Both versions now exist
```

---

#### `rm` - Delete Files

**Examples:**

```bash
# Delete single file
rm unwanted-file.md

# Delete multiple files matching pattern
rm *.tmp

# Delete directory and contents
rm -r old-project/
```

---

#### `mkdir` - Create Directories

**Examples:**

```bash
# Create single directory
mkdir new-project

# Create nested directories
mkdir -p projects/2025/q1/reports
```

---

#### `cat` - Display/Concatenate Files

**Examples:**

```bash
# Display entire file
cat document.md

# Combine multiple files into one
cat part1.md part2.md part3.md > complete-document.md

# Add content to end of file
cat >> document.md << EOF
This text gets added to the end.
EOF
```

**Real Use Case:**
```
YOU: "Combine all three chapters into one document"
CLAUDE: cat chapter1.md chapter2.md chapter3.md > full-book.md
→ Single merged document
```

---

#### `head` / `tail` - View Beginning/End of Files

**Examples:**

```bash
# First 50 lines
head -50 long-document.md

# Last 50 lines
tail -50 long-document.md

# Everything EXCEPT first 10 lines
tail -n +11 file.md

# Watch file for new content (live logs)
tail -f logfile.txt
```

---

#### `grep` - Search Within Files

**Examples:**

```bash
# Find lines containing "error"
grep "error" logfile.txt

# Search recursively in all files
grep -r "TODO" ./

# Case-insensitive search
grep -i "warning" *.md

# Show line numbers
grep -n "function" script.py

# Count matches
grep -c "test" results.txt

# Find files that DON'T contain pattern
grep -L "copyright" *.md
```

**Real Use Case:**
```
YOU: "Which of my documents mention SystemCraft?"
CLAUDE: grep -l "SystemCraft" /mnt/user-data/outputs/*.md
→ Lists all matching files
```

---

#### `find` - Find Files by Criteria

**Examples:**

```bash
# Find by name
find . -name "*.md"

# Find by name (case-insensitive)
find . -iname "readme*"

# Find files modified in last 24 hours
find . -mtime -1

# Find files larger than 1MB
find . -size +1M

# Find and delete
find . -name "*.tmp" -delete

# Find and execute command on each
find . -name "*.md" -exec wc -l {} \;
```

**Real Use Case:**
```
YOU: "Find all my Python files"
CLAUDE: find /mnt/user-data/outputs -name "*.py"
→ Lists all Python files with full paths
```

---

#### `ls` - List Directory Contents

**Examples:**

```bash
# Basic list
ls

# Detailed list with sizes and dates
ls -la

# Sort by modification time (newest first)
ls -lt

# Sort by size (largest first)
ls -lS

# Human-readable sizes
ls -lh

# List only directories
ls -d */
```

---

### Text Processing Commands

#### `sed` - Stream Editor (Find/Replace)

**Examples:**

```bash
# Replace first occurrence per line
sed 's/old/new/' file.txt

# Replace ALL occurrences
sed 's/old/new/g' file.txt

# Replace and save to file
sed -i 's/old/new/g' file.txt

# Delete lines containing pattern
sed '/pattern/d' file.txt

# Delete blank lines
sed '/^$/d' file.txt

# Replace only on specific line
sed '5s/old/new/' file.txt
```

**Real Use Case:**
```
YOU: "Change all instances of 'v3' to 'v4' in the document"
CLAUDE: sed -i 's/v3/v4/g' document.md
→ All versions updated
```

---

#### `awk` - Pattern Processing

**Examples:**

```bash
# Print first column
awk '{print $1}' file.txt

# Print columns 1 and 3
awk '{print $1, $3}' file.txt

# Sum numbers in a column
awk '{sum += $1} END {print sum}' numbers.txt

# Filter rows where column 2 > 100
awk '$2 > 100' data.txt

# Custom delimiter (CSV)
awk -F',' '{print $2}' data.csv
```

**Real Use Case:**
```
YOU: "Extract just the URLs from this list"
CLAUDE: awk '{print $2}' links.txt  # if URL is second column
→ Clean list of URLs only
```

---

#### `sort` - Sort Lines

**Examples:**

```bash
# Alphabetical sort
sort file.txt

# Reverse sort
sort -r file.txt

# Numeric sort
sort -n numbers.txt

# Sort by column 2
sort -k2 file.txt

# Remove duplicates while sorting
sort -u file.txt
```

---

#### `uniq` - Remove Duplicates

**Examples:**

```bash
# Remove adjacent duplicates (use with sort)
sort file.txt | uniq

# Count occurrences
sort file.txt | uniq -c

# Show only duplicates
sort file.txt | uniq -d

# Show only unique lines
sort file.txt | uniq -u
```

**Real Use Case:**
```
YOU: "How many times does each error appear in the log?"
CLAUDE: grep "ERROR" log.txt | sort | uniq -c | sort -rn
→ Ranked list of error frequencies
```

---

#### `wc` - Word/Line/Character Count

**Examples:**

```bash
# Line count
wc -l document.md

# Word count
wc -w document.md

# Character count
wc -c document.md

# All counts
wc document.md

# Count lines in multiple files
wc -l *.md
```

**Real Use Case:**
```
YOU: "How long is each document?"
CLAUDE: wc -l /mnt/user-data/outputs/*.md
→ Line count for each file
```

---

#### `cut` - Extract Columns

**Examples:**

```bash
# Extract column by delimiter
cut -d',' -f2 data.csv

# Extract multiple columns
cut -d',' -f1,3,5 data.csv

# Extract character positions
cut -c1-10 file.txt
```

---

#### `tr` - Translate Characters

**Examples:**

```bash
# Convert to uppercase
tr 'a-z' 'A-Z' < file.txt

# Convert to lowercase
tr 'A-Z' 'a-z' < file.txt

# Delete characters
tr -d '0-9' < file.txt

# Squeeze repeated characters
tr -s ' ' < file.txt
```

---

#### `diff` - Compare Files

**Examples:**

```bash
# Show differences
diff file1.md file2.md

# Side-by-side comparison
diff -y file1.md file2.md

# Unified format (like git diff)
diff -u file1.md file2.md
```

**Real Use Case:**
```
YOU: "What changed between v3 and v4?"
CLAUDE: diff -u meta-engine-v3.md meta-engine-v4.md
→ Shows exact additions and deletions
```

---

### Archive & Compression

#### `tar` - Archive Files

**Examples:**

```bash
# Create compressed archive
tar -czvf archive.tar.gz folder/

# Extract archive
tar -xzvf archive.tar.gz

# List contents without extracting
tar -tzvf archive.tar.gz

# Extract to specific directory
tar -xzvf archive.tar.gz -C /destination/
```

---

#### `zip` / `unzip` - ZIP Archives

**Examples:**

```bash
# Create zip of folder
zip -r project.zip project-folder/

# Create zip of specific files
zip documents.zip *.md *.pdf

# Extract zip
unzip archive.zip

# Extract to specific directory
unzip archive.zip -d /destination/

# List contents without extracting
unzip -l archive.zip
```

**Real Use Case:**
```
YOU: "Bundle all my outputs into one download"
CLAUDE: cd /mnt/user-data/outputs && zip -r all-documents.zip *.md
→ Single zip file with everything
```

---

#### `gzip` / `gunzip` - Compress Single Files

**Examples:**

```bash
# Compress file (replaces original)
gzip large-file.txt

# Decompress
gunzip large-file.txt.gz

# Keep original while compressing
gzip -k large-file.txt
```

---

### Network & Download

#### `curl` - Transfer Data from URLs

**Examples:**

```bash
# Download file
curl -O https://example.com/file.pdf

# Download and rename
curl -o myfile.pdf https://example.com/file.pdf

# Get just the headers
curl -I https://example.com

# POST request with data
curl -X POST -d "param=value" https://api.example.com/endpoint

# POST JSON
curl -X POST -H "Content-Type: application/json" -d '{"key":"value"}' https://api.example.com

# Follow redirects
curl -L https://example.com/redirect

# Show response headers and body
curl -i https://example.com
```

**Real Use Case:**
```
YOU: "Download the latest release from that GitHub repo"
CLAUDE: curl -LO https://github.com/user/repo/archive/refs/heads/main.zip
→ Downloads the repo as zip
```

---

#### `wget` - Download Files

**Examples:**

```bash
# Simple download
wget https://example.com/file.pdf

# Download with different name
wget -O newname.pdf https://example.com/file.pdf

# Download entire website (mirror)
wget -m https://example.com

# Continue interrupted download
wget -c https://example.com/large-file.zip

# Download quietly (no progress)
wget -q https://example.com/file.pdf
```

---

### Version Control (Git)

#### Common Git Commands

**Examples:**

```bash
# Clone a repository
git clone https://github.com/user/repo.git

# Initialize new repo
git init

# Check status
git status

# Add files to staging
git add .
git add specific-file.md

# Commit changes
git commit -m "Description of changes"

# View commit history
git log --oneline

# Show differences
git diff
git diff file.md

# Create branch
git branch new-feature

# Switch branch
git checkout new-feature
# or
git switch new-feature

# View all branches
git branch -a
```

**Real Use Case:**
```
YOU: "Clone that open source project so we can analyze it"
CLAUDE: git clone https://github.com/project/repo.git
→ Full repo available locally for analysis
```

---

## Part 3: Document Processing Power Tools

### Pandoc - Universal Document Converter

**What It Does:** Converts between almost ANY document format

**Supported Formats:**
- INPUT: markdown, docx, html, latex, epub, odt, rst, textile, mediawiki, json, csv
- OUTPUT: markdown, docx, html, pdf, latex, epub, odt, pptx, rtf, plain text

**Examples:**

```bash
# Markdown to Word
pandoc document.md -o document.docx

# Markdown to PDF
pandoc document.md -o document.pdf

# Markdown to HTML
pandoc document.md -o document.html

# Markdown to HTML with CSS styling
pandoc document.md -o document.html --css=style.css

# Word to Markdown
pandoc input.docx -o output.md

# HTML to Markdown
pandoc webpage.html -o content.md

# Markdown to PowerPoint
pandoc slides.md -o presentation.pptx

# With table of contents
pandoc document.md --toc -o document.pdf

# Standalone HTML (includes header)
pandoc document.md -s -o document.html

# Multiple files to one output
pandoc chapter1.md chapter2.md chapter3.md -o book.pdf
```

**Real Use Cases:**

```
YOU: "Convert my specification to a Word doc for the client"
CLAUDE: pandoc meta-engine-generator-v4.md -o meta-engine-generator-v4.docx
→ Professional Word document

YOU: "I need a PDF version for printing"
CLAUDE: pandoc document.md -o document.pdf --toc
→ PDF with table of contents

YOU: "Turn this HTML page into markdown"
CLAUDE: pandoc webpage.html -o content.md
→ Clean markdown version
```

---

### PDF Tools

#### `pdftotext` - Extract Text from PDF

**Examples:**

```bash
# Extract text to stdout
pdftotext input.pdf -

# Extract to text file
pdftotext input.pdf output.txt

# Maintain layout
pdftotext -layout input.pdf output.txt

# Specific pages
pdftotext -f 1 -l 5 input.pdf output.txt
```

**Real Use Case:**
```
YOU: "Extract the text from this PDF so we can analyze it"
CLAUDE: pdftotext uploaded-document.pdf extracted-text.txt
→ Searchable, editable text
```

---

#### `pdftk` - PDF Toolkit

**Examples:**

```bash
# Merge PDFs
pdftk file1.pdf file2.pdf file3.pdf cat output merged.pdf

# Merge all PDFs in directory
pdftk *.pdf cat output combined.pdf

# Extract specific pages
pdftk input.pdf cat 1-5 output first-five-pages.pdf

# Extract pages 1, 3, 5-10
pdftk input.pdf cat 1 3 5-10 output selected.pdf

# Split into individual pages
pdftk input.pdf burst

# Rotate all pages 90° right
pdftk input.pdf rotate 1-endright output rotated.pdf

# Rotate specific page
pdftk input.pdf rotate 3right output rotated.pdf

# Add background/watermark
pdftk input.pdf background watermark.pdf output watermarked.pdf

# Stamp (overlay) on each page
pdftk input.pdf stamp letterhead.pdf output stamped.pdf

# Extract metadata
pdftk input.pdf dump_data

# Encrypt with password
pdftk input.pdf output protected.pdf user_pw secret

# Decrypt
pdftk protected.pdf input_pw secret output decrypted.pdf
```

**Real Use Cases:**

```
YOU: "Merge these three reports into one PDF"
CLAUDE: pdftk report1.pdf report2.pdf report3.pdf cat output combined-report.pdf
→ Single merged document

YOU: "Extract just pages 5-15 for the summary"
CLAUDE: pdftk full-report.pdf cat 5-15 output summary.pdf
→ Extracted section

YOU: "Split this PDF into individual pages"
CLAUDE: pdftk document.pdf burst
→ Creates pg_0001.pdf, pg_0002.pdf, etc.
```

---

### Image Tools (ImageMagick + FFmpeg)

#### `convert` - Image Conversion & Manipulation

**Examples:**

```bash
# Convert format
convert input.png output.jpg

# Resize by percentage
convert input.png -resize 50% output.png

# Resize to specific dimensions
convert input.png -resize 800x600 output.png

# Resize to fit within bounds (maintain aspect ratio)
convert input.png -resize 800x600\> output.png

# Compress JPEG quality
convert input.jpg -quality 80 output.jpg

# Convert to grayscale
convert input.png -colorspace Gray output.png

# Add border
convert input.png -border 10x10 -bordercolor black output.png

# Rotate
convert input.png -rotate 90 output.png

# Create thumbnail
convert input.png -thumbnail 200x200 thumb.png

# Combine images horizontally
convert image1.png image2.png +append combined.png

# Combine images vertically
convert image1.png image2.png -append combined.png

# Create animated GIF from multiple images
convert -delay 100 -loop 0 frame*.png animation.gif

# Add text to image
convert input.png -pointsize 36 -annotate +50+50 'Hello World' output.png
```

**Real Use Cases:**

```
YOU: "Make this image smaller for the web"
CLAUDE: convert large-image.png -resize 800x600 -quality 85 web-image.jpg
→ Optimized web image

YOU: "Convert all PNGs to JPGs"
CLAUDE: for f in *.png; do convert "$f" "${f%.png}.jpg"; done
→ Batch conversion

YOU: "Create a GIF from these screenshots"
CLAUDE: convert -delay 50 -loop 0 screen*.png animation.gif
→ Animated GIF
```

---

#### `identify` - Get Image Information

**Examples:**

```bash
# Basic info
identify image.png

# Verbose info
identify -verbose image.png

# Just dimensions
identify -format "%wx%h" image.png
```

---

#### `ffmpeg` - Video & Audio Processing

**Examples:**

```bash
# Extract audio from video
ffmpeg -i video.mp4 -vn audio.mp3

# Convert video format
ffmpeg -i input.avi output.mp4

# Resize video
ffmpeg -i input.mp4 -vf scale=1280:720 output.mp4

# Extract frames as images
ffmpeg -i video.mp4 -r 1 frame_%04d.png

# Create video from images
ffmpeg -framerate 30 -i frame_%04d.png output.mp4

# Trim video (start at 10s, duration 30s)
ffmpeg -i input.mp4 -ss 10 -t 30 output.mp4

# Extract thumbnail at specific time
ffmpeg -i video.mp4 -ss 00:01:30 -vframes 1 thumbnail.png

# Compress video
ffmpeg -i input.mp4 -crf 28 compressed.mp4
```

**Real Use Case:**
```
YOU: "Extract the audio from this video"
CLAUDE: ffmpeg -i presentation.mp4 -vn audio.mp3
→ Audio file only
```

---

## Part 4: Python Libraries Available

These are pre-installed and ready to use for complex document operations:

### pandas - Data Analysis

**Examples:**

```python
import pandas as pd

# Read CSV
df = pd.read_csv('data.csv')

# Read Excel
df = pd.read_excel('data.xlsx')

# Basic analysis
print(df.describe())
print(df.head())

# Filter data
filtered = df[df['column'] > 100]

# Group and aggregate
summary = df.groupby('category')['value'].sum()

# Export to different formats
df.to_csv('output.csv', index=False)
df.to_excel('output.xlsx', index=False)
df.to_json('output.json', orient='records')
df.to_markdown('output.md')
```

**Real Use Case:**
```
YOU: "Analyze this CSV and give me a summary"
CLAUDE: Uses pandas to read, analyze, and output statistics
→ Professional data analysis
```

---

### openpyxl - Excel Files

**Examples:**

```python
from openpyxl import Workbook, load_workbook
from openpyxl.styles import Font, Fill, PatternFill, Alignment

# Create new workbook
wb = Workbook()
ws = wb.active

# Write data
ws['A1'] = 'Header'
ws['A1'].font = Font(bold=True)

# Add formulas
ws['B10'] = '=SUM(B1:B9)'

# Styling
ws['A1'].fill = PatternFill(start_color='FFFF00', fill_type='solid')

# Save
wb.save('output.xlsx')

# Read existing
wb = load_workbook('existing.xlsx')
ws = wb.active
value = ws['A1'].value
```

**Real Use Case:**
```
YOU: "Create a budget spreadsheet with formulas and formatting"
CLAUDE: Uses openpyxl to create styled Excel with working formulas
→ Professional spreadsheet
```

---

### python-docx - Word Documents

**Examples:**

```python
from docx import Document
from docx.shared import Inches, Pt
from docx.enum.text import WD_ALIGN_PARAGRAPH

# Create document
doc = Document()

# Add heading
doc.add_heading('Document Title', 0)

# Add paragraph with formatting
para = doc.add_paragraph()
run = para.add_run('Bold text')
run.bold = True

# Add table
table = doc.add_table(rows=3, cols=3)
table.style = 'Table Grid'
cell = table.cell(0, 0)
cell.text = 'Header'

# Add image
doc.add_picture('image.png', width=Inches(4))

# Add page break
doc.add_page_break()

# Save
doc.save('output.docx')

# Read existing
doc = Document('existing.docx')
for para in doc.paragraphs:
    print(para.text)
```

**Real Use Case:**
```
YOU: "Create a formatted report with tables and images"
CLAUDE: Uses python-docx to create professional Word document
→ Styled document with corporate formatting
```

---

### python-pptx - PowerPoint Presentations

**Examples:**

```python
from pptx import Presentation
from pptx.util import Inches, Pt
from pptx.enum.shapes import MSO_SHAPE

# Create presentation
prs = Presentation()

# Add title slide
slide_layout = prs.slide_layouts[0]  # Title slide
slide = prs.slides.add_slide(slide_layout)
title = slide.shapes.title
title.text = "Presentation Title"

# Add content slide
slide_layout = prs.slide_layouts[1]  # Title and content
slide = prs.slides.add_slide(slide_layout)
title = slide.shapes.title
title.text = "Section Title"

# Add bullet points
body = slide.shapes.placeholders[1]
tf = body.text_frame
tf.text = "First bullet"
p = tf.add_paragraph()
p.text = "Second bullet"
p.level = 1

# Add image
slide.shapes.add_picture('image.png', Inches(1), Inches(2), width=Inches(4))

# Add shape
shape = slide.shapes.add_shape(MSO_SHAPE.RECTANGLE, Inches(1), Inches(1), Inches(2), Inches(1))

# Save
prs.save('output.pptx')
```

**Real Use Case:**
```
YOU: "Create a 10-slide pitch deck from this content"
CLAUDE: Uses python-pptx to create professional presentation
→ Ready-to-present PowerPoint
```

---

### pypdf - PDF Manipulation

**Examples:**

```python
from pypdf import PdfReader, PdfWriter

# Read PDF
reader = PdfReader('input.pdf')
print(f"Pages: {len(reader.pages)}")

# Extract text
text = reader.pages[0].extract_text()

# Merge PDFs
writer = PdfWriter()
for pdf in ['file1.pdf', 'file2.pdf']:
    reader = PdfReader(pdf)
    for page in reader.pages:
        writer.add_page(page)
writer.write('merged.pdf')

# Extract specific pages
writer = PdfWriter()
reader = PdfReader('input.pdf')
writer.add_page(reader.pages[0])  # First page only
writer.write('first_page.pdf')

# Rotate pages
writer = PdfWriter()
reader = PdfReader('input.pdf')
page = reader.pages[0]
page.rotate(90)
writer.add_page(page)
writer.write('rotated.pdf')
```

---

### pillow - Image Processing

**Examples:**

```python
from PIL import Image, ImageDraw, ImageFont

# Open image
img = Image.open('input.png')

# Resize
img = img.resize((800, 600))

# Crop
img = img.crop((left, top, right, bottom))

# Rotate
img = img.rotate(45)

# Convert format
img.save('output.jpg', 'JPEG', quality=85)

# Convert to grayscale
gray = img.convert('L')

# Add text
draw = ImageDraw.Draw(img)
draw.text((50, 50), "Hello World", fill='black')

# Create new image
img = Image.new('RGB', (400, 300), color='white')

# Combine images
img1 = Image.open('image1.png')
img2 = Image.open('image2.png')
img1.paste(img2, (100, 100))
```

---

## Part 5: Skills Library

Skills are pre-built instruction sets that contain best practices, workflows, and tools for specific tasks. Before creating documents of certain types, Claude should read the relevant SKILL.md file to produce higher-quality outputs.

---

### PUBLIC SKILLS (Always Available)

These skills are always loaded and available in every session.

---

#### `docx` - Word Document Creation & Editing

**Location:** `/mnt/skills/public/docx/SKILL.md`

**Description:** Comprehensive document creation, editing, and analysis with support for tracked changes, comments, formatting preservation, and text extraction.

**Use When:**
- Creating new Word documents
- Modifying or editing existing .docx content
- Working with tracked changes (redlining)
- Adding comments to documents
- Extracting text from Word files

**Key Capabilities:**
- Text extraction via pandoc
- Raw XML access for comments, formatting, metadata
- Redlining workflow for editing others' documents
- OOXML direct editing for complex formatting
- Professional document creation with python-docx

**Example Trigger:**
```
YOU: "Create a professional proposal document with headers, tables, and formatting"
CLAUDE: [Reads /mnt/skills/public/docx/SKILL.md first]
→ Follows best practices for Word document creation
```

---

#### `xlsx` - Excel Spreadsheet Creation & Analysis

**Location:** `/mnt/skills/public/xlsx/SKILL.md`

**Description:** Comprehensive spreadsheet creation, editing, and analysis with support for formulas, formatting, data analysis, and visualization.

**Use When:**
- Creating new spreadsheets with formulas
- Reading or analyzing data from Excel/CSV
- Modifying existing spreadsheets while preserving formulas
- Data analysis and visualization
- Building financial models

**Key Capabilities:**
- Zero formula errors requirement
- Industry-standard color coding (blue=inputs, black=formulas, etc.)
- Number formatting standards
- Formula construction rules
- Recalculating formulas
- Preserving existing template conventions

**Example Trigger:**
```
YOU: "Create a financial model with revenue projections"
CLAUDE: [Reads /mnt/skills/public/xlsx/SKILL.md first]
→ Uses proper color coding, formula standards, and formatting
```

---

#### `pptx` - PowerPoint Presentation Creation

**Location:** `/mnt/skills/public/pptx/SKILL.md`

**Description:** Presentation creation, editing, and analysis with support for layouts, speaker notes, comments, and professional styling.

**Use When:**
- Creating new presentations
- Modifying existing PowerPoint content
- Working with slide layouts and masters
- Adding speaker notes
- Extracting content from presentations

**Key Capabilities:**
- HTML-to-PPTX conversion workflow
- CSS styling for presentations
- Raw XML access for complex elements
- Typography and color extraction from themes
- Template-based creation
- Speaker notes and comments handling

**Example Trigger:**
```
YOU: "Create a 10-slide pitch deck for investors"
CLAUDE: [Reads /mnt/skills/public/pptx/SKILL.md first]
→ Follows professional presentation standards
```

---

#### `pdf` - PDF Processing & Manipulation

**Location:** `/mnt/skills/public/pdf/SKILL.md`

**Description:** Comprehensive PDF manipulation toolkit for extracting text and tables, creating new PDFs, merging/splitting documents, and handling forms.

**Use When:**
- Filling in PDF forms
- Extracting text or tables from PDFs
- Merging multiple PDFs
- Splitting PDFs into pages
- Creating new PDFs programmatically
- Processing PDFs at scale

**Key Capabilities:**
- pypdf for basic operations (merge, split, rotate)
- pdfplumber for table extraction
- Form filling workflows
- Text extraction with layout preservation
- PDF creation from various sources

**Example Trigger:**
```
YOU: "Fill out this PDF form with the following information..."
CLAUDE: [Reads /mnt/skills/public/pdf/SKILL.md and FORMS.md]
→ Follows proper form-filling workflow
```

---

#### `frontend-design` - Web UI/UX Design

**Location:** `/mnt/skills/public/frontend-design/SKILL.md`

**Description:** Create distinctive, production-grade frontend interfaces with high design quality. Avoids generic "AI slop" aesthetics.

**Use When:**
- Building web components or pages
- Creating artifacts, posters, or applications
- Designing websites, landing pages, or dashboards
- Creating React components
- Styling or beautifying any web UI

**Key Capabilities:**
- Bold aesthetic direction (brutalist, maximalist, minimal, retro-futuristic, etc.)
- Distinctive typography choices (avoiding generic fonts like Arial, Inter)
- Motion and micro-interactions
- Spatial composition with asymmetry, overlap, diagonal flow
- Background textures and visual details
- Production-grade, functional code

**Design Philosophy:**
- Match implementation complexity to aesthetic vision
- Never use generic AI-generated aesthetics
- Every design should be unique and memorable
- Commit fully to a distinctive creative direction

**Example Trigger:**
```
YOU: "Create a landing page for my SaaS product"
CLAUDE: [Reads /mnt/skills/public/frontend-design/SKILL.md first]
→ Creates distinctive, memorable design (not generic templates)
```

---

#### `product-self-knowledge` - Anthropic Product Information

**Location:** `/mnt/skills/public/product-self-knowledge/SKILL.md`

**Description:** Authoritative reference for Anthropic products. Provides source-backed answers to prevent hallucinations about Claude.ai, Claude Code, and Claude API.

**Use When:**
- User asks about Claude capabilities
- Questions about pricing, limits, or features
- Installation or access questions
- API documentation queries
- Claude Code questions

**Key Capabilities:**
- Distinguishes between Claude.ai, Claude Code, and Claude API
- Routes to correct documentation
- Provides verified source URLs
- Prevents hallucination about product features

**Example Trigger:**
```
YOU: "How do I use Claude Code?"
CLAUDE: [Checks /mnt/skills/public/product-self-knowledge/SKILL.md]
→ Provides accurate, sourced information
```

---

### EXAMPLE SKILLS (Available to Enable)

These skills demonstrate patterns that can be used or adapted.

---

#### `algorithmic-art` - Generative Art Creation

**Location:** `/mnt/skills/examples/algorithmic-art/SKILL.md`

**Description:** Creating algorithmic art using p5.js with seeded randomness and interactive parameter exploration.

**Use When:**
- Creating art using code
- Generative art projects
- Flow fields or particle systems
- Interactive visual experiences

**Key Capabilities:**
- Algorithmic philosophy creation (manifesto for generative movement)
- p5.js implementation with seeded randomness
- Interactive parameter exploration
- Outputs: .md (philosophy), .html (viewer), .js (algorithms)

**Example Trigger:**
```
YOU: "Create generative art that looks like flowing water"
CLAUDE: [Reads algorithmic-art skill]
→ Creates philosophy, then implements as p5.js sketch
```

---

#### `brand-guidelines` - Anthropic Brand Styling

**Location:** `/mnt/skills/examples/brand-guidelines/SKILL.md`

**Description:** Applies Anthropic's official brand colors and typography to artifacts.

**Use When:**
- Creating Anthropic-branded content
- Applying official brand colors
- Using company design standards

---

#### `canvas-design` - Visual Art & Poster Creation

**Location:** `/mnt/skills/examples/canvas-design/SKILL.md`

**Description:** Create beautiful visual art in .png and .pdf documents using design philosophy.

**Use When:**
- Creating posters
- Designing static visual pieces
- Art creation with design philosophy

**Key Capabilities:**
- Design philosophy creation
- Visual expression in PNG and PDF
- Original visual designs

---

#### `doc-coauthoring` - Documentation Workflow

**Location:** `/mnt/skills/examples/doc-coauthoring/SKILL.md`

**Description:** Guide users through a structured workflow for co-authoring documentation.

**Use When:**
- Writing documentation
- Creating proposals
- Drafting technical specs
- Decision documents
- Structured content creation

**Key Capabilities:**
- Three-stage workflow: Context Gathering, Refinement & Structure, Reader Testing
- Efficient context transfer
- Iterative refinement
- Reader verification

---

#### `internal-comms` - Internal Communications

**Location:** `/mnt/skills/examples/internal-comms/SKILL.md`

**Description:** Resources for writing internal communications using company-preferred formats.

**Use When:**
- Status reports
- Leadership updates
- 3P updates (Progress, Plans, Problems)
- Company newsletters
- FAQs
- Incident reports
- Project updates

---

#### `mcp-builder` - MCP Server Development

**Location:** `/mnt/skills/examples/mcp-builder/SKILL.md`

**Description:** Guide for creating high-quality MCP (Model Context Protocol) servers that enable LLMs to interact with external services.

**Use When:**
- Building MCP servers
- Integrating external APIs
- Creating tools for LLM interaction
- Python (FastMCP) or Node/TypeScript implementations

---

#### `skill-creator` - Create New Skills

**Location:** `/mnt/skills/examples/skill-creator/SKILL.md`

**Description:** Guide for creating effective skills that extend Claude's capabilities.

**Use When:**
- Creating a new skill
- Updating existing skills
- Extending Claude with specialized knowledge
- Building custom workflows or tool integrations

**Key Principles:**
- Concise is key (context window is a shared resource)
- Set appropriate degrees of freedom
- Include SKILL.md + optional bundled resources

---

#### `slack-gif-creator` - Animated GIFs for Slack

**Location:** `/mnt/skills/examples/slack-gif-creator/SKILL.md`

**Description:** Knowledge and utilities for creating animated GIFs optimized for Slack.

**Use When:**
- Creating GIFs for Slack
- Optimizing animations for messaging platforms

**Key Capabilities:**
- Slack-specific constraints
- Validation tools
- Animation concepts

---

#### `theme-factory` - Design Themes

**Location:** `/mnt/skills/examples/theme-factory/SKILL.md`

**Description:** Toolkit for styling artifacts with pre-set or custom themes.

**Use When:**
- Styling slides, docs, reports
- Creating HTML landing pages
- Applying consistent color/font themes

**Key Capabilities:**
- 10 pre-set professional themes
- Custom theme generation
- Color palettes and font pairings

---

#### `web-artifacts-builder` - Complex Web Artifacts

**Location:** `/mnt/skills/examples/web-artifacts-builder/SKILL.md`

**Description:** Suite of tools for creating elaborate, multi-component Claude.ai HTML artifacts.

**Use When:**
- Complex artifacts requiring state management
- Multi-component React applications
- Artifacts needing routing
- shadcn/ui component integration

**Key Capabilities:**
- React + Tailwind CSS + shadcn/ui
- State management
- Multi-file artifact structure
- Initialization scripts

---

### How to Use Skills

**Before creating a document, tell Claude to read the skill:**

```
YOU: "Create a Word document. Follow the docx skill."
CLAUDE: [Reads /mnt/skills/public/docx/SKILL.md]
→ Uses best practices from skill

YOU: "Make a pitch deck. Check the pptx skill first."
CLAUDE: [Reads /mnt/skills/public/pptx/SKILL.md]
→ Follows presentation guidelines

YOU: "Build a landing page with great design"
CLAUDE: [Reads /mnt/skills/public/frontend-design/SKILL.md]
→ Creates distinctive, non-generic design
```

**Pro Tip:** You can ask Claude to read multiple skills if your task spans categories:
```
YOU: "Create a branded presentation with custom styling"
CLAUDE: [Reads pptx skill + brand-guidelines skill + theme-factory skill]
→ Combines best practices from all three
```

---

## Part 6: Key Workflows

### Workflow 1: Rename a File (NEW CAPABILITY!)

```bash
mv /mnt/user-data/outputs/old-name.md /mnt/user-data/outputs/new-name.md
```
Then `present_files` serves it with the new name.

### Workflow 2: Surgical Document Edit

Instead of regenerating entire document:
```
str_replace(
  path="/mnt/user-data/outputs/doc.md",
  old_str="exact text to find",
  new_str="replacement text"
)
```

### Workflow 3: Batch File Operations

```bash
# Create a zip of all markdown files
cd /mnt/user-data/outputs && zip -r all-docs.zip *.md
```

### Workflow 4: Convert Document Formats

```bash
# Markdown to Word
pandoc document.md -o document.docx

# Markdown to PDF
pandoc document.md -o document.pdf
```

### Workflow 5: Merge Multiple Documents

```bash
# Combine markdown files
cat part1.md part2.md part3.md > combined.md

# Merge PDFs
pdftk doc1.pdf doc2.pdf doc3.pdf cat output merged.pdf
```

### Workflow 6: Search Across Files

**Use Case (Natural Language):**
"I've created dozens of documents over this session and past sessions. Now I need to find which ones mention a specific client, project, or concept - but I don't remember which files contain what. I want to search INSIDE the files, not just by filename."

**What This Solves:**
When you have many outputs and need to find specific content without opening each file individually.

```bash
# Find all files containing "Meta Engine"
grep -r "Meta Engine" /mnt/user-data/outputs/

# Same but show line numbers
grep -rn "Meta Engine" /mnt/user-data/outputs/

# Find files containing BOTH "SystemCraft" AND "v4"
grep -l "SystemCraft" /mnt/user-data/outputs/*.md | xargs grep -l "v4"

# Find all markdown files modified today
find /mnt/user-data/outputs -name "*.md" -mtime 0

# Count how many files mention each term
for term in "SystemCraft" "Meta Engine" "grokly"; do
  count=$(grep -rl "$term" /mnt/user-data/outputs/ 2>/dev/null | wc -l)
  echo "$term: $count files"
done
```

**Example Scenario:**
```
YOU: "Which of my documents mention the Hardened Architecture?"
CLAUDE: grep -rl "Hardened" /mnt/user-data/outputs/*.md
→ Returns: meta-engine-generator-v4-0-0.md
           claude-environment-capabilities-reference.md
           
YOU: "Show me the context around those mentions"
CLAUDE: grep -B2 -A2 "Hardened" /mnt/user-data/outputs/meta-engine-generator-v4-0-0.md
→ Shows 2 lines before and after each match
```

---

## Part 7: Limitations & Boundaries

### What I CAN'T Do

| Limitation | Reason |
|------------|--------|
| Access files outside defined paths | Security sandbox |
| Persist files between sessions | Container resets |
| Execute arbitrary system commands that affect host | Sandboxed environment |
| Access authenticated/private URLs | No credential storage |
| Run long-running background processes | Session-bound |

### Directory Permissions

| Path | Permission | Notes |
|------|------------|-------|
| `/mnt/user-data/uploads/` | Read-only | Your uploaded files |
| `/home/claude/` | Read-write | My workspace (temporary) |
| `/mnt/user-data/outputs/` | Read-write | **Downloadable files go here** |
| `/mnt/skills/` | Read-only | Skills library |
| `/mnt/transcripts/` | Read-only | Conversation transcripts |

---

## Part 8: Pro Tips for Maximum Efficiency

### 1. Use Surgical Edits
Don't say: "Regenerate the document with this change"
Do say: "Change line X from Y to Z" → Uses `str_replace`, saves tokens

### 2. Batch Requests
Don't say: "Create file A" then "Create file B" then "Create file C"
Do say: "Create files A, B, and C" → Parallel processing

### 3. Reference Past Work
"Continue from where we left off on [project]" → Triggers `conversation_search`

### 4. Request Specific Formats
"Create as .xlsx with formulas" → Triggers skill lookup for best practices

### 5. Ask for Zipped Bundles
"Zip all the outputs together" → Single download for multiple files

### 6. Leverage Skills
"Follow the pptx skill" → I'll read best practices before generating

---

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.0.0 | December 24, 2025 | Initial comprehensive reference |
| 1.1.0 | December 24, 2025 | Added detailed examples for all tools; Added User Hacks section |
| 1.2.0 | December 24, 2025 | Expanded Workflow 6 with NL use case; Added comprehensive Skills documentation (all 14 skills); Added 20 more User Hacks (#21-40); Added 10 more Pro Tips |

---

## Part 9: USER HACKS — Creative Tool Combinations

This section contains creative ways to combine tools for powerful outcomes. These are "power user" techniques that leverage multiple capabilities together.

---

### HACK #1: The "Document Factory"
**Combine:** `create_file` + `str_replace` + `mv` + `zip`

**What It Does:** Generate multiple customized versions of a document from a single template

**Scenario:** You need 10 versions of a proposal, each customized for a different client

```
Step 1: Create master template
CLAUDE: [create_file] proposal-template.md with {CLIENT_NAME}, {PROJECT_SCOPE} placeholders

Step 2: Generate variants
CLAUDE: [bash loop]
for client in "Acme Corp" "Globex" "Initech"; do
  cp proposal-template.md "proposal-$client.md"
  sed -i "s/{CLIENT_NAME}/$client/g" "proposal-$client.md"
done

Step 3: Convert all to Word
CLAUDE: [bash]
for f in proposal-*.md; do
  pandoc "$f" -o "${f%.md}.docx"
done

Step 4: Bundle for delivery
CLAUDE: zip all-proposals.zip proposal-*.docx
```

**Result:** 10 customized Word documents in one zip file

---

### HACK #2: The "Research Synthesizer"
**Combine:** `web_search` + `web_fetch` + `conversation_search` + `google_drive_search` + `create_file`

**What It Does:** Comprehensive research combining web, your past work, and your Drive documents

**Scenario:** You're writing a report that needs current web data, your company's internal docs, AND context from past Claude conversations

```
Step 1: Search web for current data
CLAUDE: [web_search] "AI market trends 2025"
CLAUDE: [web_fetch] on top 3 results for full content

Step 2: Search your Drive for internal context
CLAUDE: [google_drive_search] "AI strategy" or "market analysis"
CLAUDE: [google_drive_fetch] on relevant documents

Step 3: Find what you've already discussed
CLAUDE: [conversation_search] "AI strategy" "market analysis"

Step 4: Synthesize everything
CLAUDE: [create_file] comprehensive-report.md combining all sources

Step 5: Convert to client format
CLAUDE: pandoc comprehensive-report.md -o comprehensive-report.docx
```

**Result:** Single report that integrates web research, internal docs, and your prior thinking

---

### HACK #3: The "PDF Assembly Line"
**Combine:** `pdftk` + `pdftotext` + `grep` + `create_file`

**What It Does:** Extract specific content from multiple PDFs, analyze it, and create a summary

**Scenario:** You have 20 PDF reports and need to find all mentions of "revenue" and summarize findings

```
Step 1: Extract text from all PDFs
CLAUDE: [bash]
for pdf in *.pdf; do
  pdftotext "$pdf" "${pdf%.pdf}.txt"
done

Step 2: Find all revenue mentions with context
CLAUDE: grep -h -B2 -A2 "revenue" *.txt > revenue-mentions.txt

Step 3: Analyze and summarize
CLAUDE: [create_file] revenue-analysis.md (synthesized from findings)

Step 4: Merge relevant PDFs into one
CLAUDE: pdftk report1.pdf report5.pdf report12.pdf cat output relevant-reports.pdf
```

**Result:** Analysis document + merged PDF of relevant source reports

---

### HACK #4: The "Bulk Converter"
**Combine:** `find` + `pandoc` + `zip`

**What It Does:** Convert all documents of one type to another format

**Scenario:** You have 50 markdown files and need them all as Word documents

```
Step 1: Find and convert all
CLAUDE: [bash]
find . -name "*.md" -exec sh -c 'pandoc "$1" -o "${1%.md}.docx"' _ {} \;

Step 2: Organize outputs
CLAUDE: mkdir word-docs && mv *.docx word-docs/

Step 3: Bundle
CLAUDE: zip -r all-word-docs.zip word-docs/
```

**Result:** All 50 documents converted and zipped

---

### HACK #5: The "Diff Report Generator"
**Combine:** `diff` + `create_file` + `pandoc`

**What It Does:** Create a formal change report between document versions

**Scenario:** You need to show stakeholders what changed between v3 and v4

```
Step 1: Generate diff
CLAUDE: diff -u old-version.md new-version.md > changes.diff

Step 2: Create formatted report
CLAUDE: [create_file] change-report.md
- Summary of changes
- Added sections (lines starting with +)
- Removed sections (lines starting with -)
- Unchanged context

Step 3: Convert to Word
CLAUDE: pandoc change-report.md -o change-report.docx
```

**Result:** Professional change report document

---

### HACK #6: The "Image Documentation Pipeline"
**Combine:** `view` (images) + `convert` + `create_file` + `python-docx`

**What It Does:** Analyze images, process them, and create documented output

**Scenario:** You have screenshots that need to be resized, annotated, and put in a document

```
Step 1: View and analyze images
CLAUDE: [view] on each screenshot to understand content

Step 2: Process images
CLAUDE: [bash]
for img in screenshot*.png; do
  convert "$img" -resize 800x600 -quality 85 "processed-$img"
done

Step 3: Create documented output
CLAUDE: [Python with python-docx]
- Create Word document
- Insert each processed image
- Add captions based on analysis
- Add page breaks between sections

Step 4: Deliver
CLAUDE: [present_files] documentation.docx
```

**Result:** Professional documentation with embedded, processed images

---

### HACK #7: The "Data to Presentation Pipeline"
**Combine:** `pandas` + `python-pptx` + analysis

**What It Does:** Turn raw data into a presentation with charts and insights

**Scenario:** You have a CSV of sales data and need a board presentation

```
Step 1: Analyze data
CLAUDE: [Python with pandas]
df = pd.read_csv('sales.csv')
summary = df.groupby('region')['revenue'].sum()
top_products = df.nlargest(10, 'units_sold')

Step 2: Generate presentation
CLAUDE: [Python with python-pptx]
- Title slide: "Q4 Sales Analysis"
- Summary slide: Key metrics
- Regional breakdown slide
- Top products slide
- Recommendations slide

Step 3: Deliver
CLAUDE: [present_files] sales-presentation.pptx
```

**Result:** Board-ready presentation generated from raw data

---

### HACK #8: The "Multi-Format Publisher"
**Combine:** `create_file` + `pandoc` + `zip`

**What It Does:** Create content once, publish in multiple formats

**Scenario:** You need the same document as MD, DOCX, PDF, and HTML

```
Step 1: Create master content
CLAUDE: [create_file] master-document.md

Step 2: Generate all formats
CLAUDE: [bash]
pandoc master-document.md -o document.docx
pandoc master-document.md -o document.pdf --toc
pandoc master-document.md -s -o document.html --css=style.css
cp master-document.md document.md

Step 3: Bundle by format
CLAUDE: zip multi-format-package.zip document.md document.docx document.pdf document.html
```

**Result:** Same content in 4 formats, single download

---

### HACK #9: The "Intelligent File Organizer"
**Combine:** `find` + `grep` + `mv` + `mkdir`

**What It Does:** Automatically organize files based on their content

**Scenario:** You have 100 documents and want to sort them by topic

```
Step 1: Create category folders
CLAUDE: mkdir -p sorted/{finance,technical,marketing,other}

Step 2: Categorize by content
CLAUDE: [bash]
for f in *.md; do
  if grep -qi "revenue\|budget\|financial" "$f"; then
    mv "$f" sorted/finance/
  elif grep -qi "api\|code\|technical" "$f"; then
    mv "$f" sorted/technical/
  elif grep -qi "campaign\|brand\|customer" "$f"; then
    mv "$f" sorted/marketing/
  else
    mv "$f" sorted/other/
  fi
done

Step 3: Generate index
CLAUDE: [create_file] sorted/INDEX.md listing all files by category
```

**Result:** Automatically organized file structure with index

---

### HACK #10: The "Session Exporter"
**Combine:** `recent_chats` + `conversation_search` + `create_file` + `zip`

**What It Does:** Export and summarize your Claude conversation history on a topic

**Scenario:** You want to extract everything you've discussed about a project

```
Step 1: Find relevant conversations
CLAUDE: [conversation_search] "Project Atlas"
CLAUDE: [recent_chats] for context

Step 2: Create summary document
CLAUDE: [create_file] project-atlas-history.md
- Timeline of discussions
- Key decisions made
- Links to original conversations
- Action items identified

Step 3: Export related files
CLAUDE: Find and copy all Project Atlas outputs
CLAUDE: zip project-atlas-complete.zip *.md outputs/
```

**Result:** Complete project history with all artifacts

---

### HACK #11: The "Version Control Snapshot"
**Combine:** `cp` + `diff` + `tar` + timestamp

**What It Does:** Create versioned backups with change tracking

**Scenario:** You want to preserve document history without full git

```
Step 1: Create timestamped backup
CLAUDE: [bash]
timestamp=$(date +%Y%m%d_%H%M%S)
cp document.md "backups/document_$timestamp.md"

Step 2: Generate diff from previous
CLAUDE: diff backups/document_previous.md document.md > "backups/changes_$timestamp.diff"

Step 3: Archive old versions periodically
CLAUDE: tar -czvf backups/archive_$(date +%Y%m).tar.gz backups/*.md backups/*.diff
```

**Result:** Full version history with diffs, archived by month

---

### HACK #12: The "Meeting Minutes to Actions Pipeline"
**Combine:** `grep` + `awk` + `create_file` + `pandoc`

**What It Does:** Extract action items from meeting notes automatically

**Scenario:** You have meeting notes and need to extract all action items

```
Step 1: Extract action items
CLAUDE: grep -i "action:\|todo:\|@\w*\s*will\|assigned to" meeting-notes.md > raw-actions.txt

Step 2: Parse and structure
CLAUDE: [Python]
- Parse assignees
- Parse due dates
- Categorize by type

Step 3: Create tracking document
CLAUDE: [create_file] action-items.md
| Action | Assignee | Due Date | Status |
|--------|----------|----------|--------|
...

Step 4: Convert to Excel for tracking
CLAUDE: [Python with openpyxl] Create styled spreadsheet with filters
```

**Result:** Structured action item tracker from unstructured notes

---

### HACK #13: The "Competitive Analysis Compiler"
**Combine:** `web_search` + `web_fetch` + `pandas` + `python-pptx`

**What It Does:** Research competitors and create comparison presentation

**Scenario:** You need to analyze 5 competitors quickly

```
Step 1: Research each competitor
CLAUDE: [loop for each competitor]
- web_search for company info, news, pricing
- web_fetch on key pages (about, pricing, features)

Step 2: Structure data
CLAUDE: [Python with pandas]
df = pd.DataFrame({
    'Competitor': names,
    'Pricing': pricing,
    'Key Features': features,
    'Strengths': strengths,
    'Weaknesses': weaknesses
})

Step 3: Generate comparison presentation
CLAUDE: [Python with python-pptx]
- Overview slide
- Feature comparison matrix
- Pricing comparison
- SWOT for each
- Recommendations

Step 4: Also export as Excel
CLAUDE: df.to_excel('competitor-data.xlsx')
```

**Result:** Presentation + raw data spreadsheet

---

### HACK #14: The "Document Merger with TOC"
**Combine:** `cat` + `pandoc` + table of contents

**What It Does:** Merge multiple documents into one with auto-generated TOC

**Scenario:** You have 10 chapter files and need one complete document

```
Step 1: Prepare files with proper headings
CLAUDE: Ensure each chapter starts with # Chapter N: Title

Step 2: Merge in order
CLAUDE: cat chapter-*.md > complete-book.md

Step 3: Convert with TOC
CLAUDE: pandoc complete-book.md --toc --toc-depth=2 -o complete-book.pdf

# Or for Word with TOC
CLAUDE: pandoc complete-book.md --toc -o complete-book.docx
```

**Result:** Single document with working table of contents

---

### HACK #15: The "Smart Archive Creator"
**Combine:** `find` + `wc` + `tar` + `create_file`

**What It Does:** Create an archive with a manifest and statistics

**Scenario:** You're archiving a project and need documentation of what's included

```
Step 1: Generate manifest
CLAUDE: [bash]
find project/ -type f > manifest.txt
wc -l manifest.txt  # Count files
du -sh project/  # Total size

Step 2: Generate statistics
CLAUDE: [bash]
echo "## Archive Statistics" > ARCHIVE-INFO.md
echo "Files: $(find project/ -type f | wc -l)" >> ARCHIVE-INFO.md
echo "Total Size: $(du -sh project/ | cut -f1)" >> ARCHIVE-INFO.md
echo "" >> ARCHIVE-INFO.md
echo "## File Types" >> ARCHIVE-INFO.md
find project/ -type f | sed 's/.*\.//' | sort | uniq -c | sort -rn >> ARCHIVE-INFO.md

Step 3: Create archive with manifest
CLAUDE: tar -czvf project-archive.tar.gz project/ manifest.txt ARCHIVE-INFO.md
```

**Result:** Archive with complete documentation of contents

---

### HACK #16: The "Cross-Reference Validator"
**Combine:** `grep` + `diff` + analysis

**What It Does:** Verify that references between documents are consistent

**Scenario:** You have a main doc and appendix that should reference each other correctly

```
Step 1: Extract references from main doc
CLAUDE: grep -o "Appendix [A-Z]" main-document.md | sort -u > main-refs.txt

Step 2: Extract actual appendix headings
CLAUDE: grep "^# Appendix" appendix.md | sed 's/# //' > appendix-headings.txt

Step 3: Compare
CLAUDE: diff main-refs.txt appendix-headings.txt

Step 4: Generate report
CLAUDE: [create_file] reference-validation.md
- Missing references
- Orphaned appendices
- Recommendations
```

**Result:** Validation report ensuring document integrity

---

### HACK #17: The "Localization Prep Kit"
**Combine:** `grep` + `create_file` + structure

**What It Does:** Extract all user-facing text for translation

**Scenario:** You need to prepare a document for translation into 5 languages

```
Step 1: Extract translatable strings
CLAUDE: Identify all headings, UI labels, button text

Step 2: Create translation template
CLAUDE: [create_file] translation-template.xlsx
| String ID | English | Spanish | French | German | Japanese |
|-----------|---------|---------|--------|--------|----------|
| title_001 | Welcome | | | | |
| btn_002 | Submit | | | | |

Step 3: Create language-specific folders
CLAUDE: mkdir -p translations/{es,fr,de,ja}

Step 4: Generate placeholder files
CLAUDE: [loop] Create document structure in each language folder
```

**Result:** Complete translation kit ready for localizers

---

### HACK #18: The "Audit Trail Generator"
**Combine:** `ls -la` + `diff` + `git log` + `create_file`

**What It Does:** Create a complete audit trail of document changes

**Scenario:** Compliance requires documenting all changes to a policy document

```
Step 1: Capture file metadata
CLAUDE: ls -la --time=ctime policy.md > audit-metadata.txt

Step 2: Generate change history
CLAUDE: [if git available]
git log --oneline --follow policy.md > change-history.txt

Step 3: Create audit document
CLAUDE: [create_file] audit-trail.md
## Document Audit Trail
- Document: policy.md
- Last Modified: [date]
- Modification History: [from git or manual tracking]
- Change Summary: [from diffs]
- Approvers: [from commit messages or manual]

Step 4: Convert to official format
CLAUDE: pandoc audit-trail.md -o audit-trail.pdf
```

**Result:** Compliance-ready audit documentation

---

### HACK #19: The "Quick API Documentation"
**Combine:** `grep` + `awk` + `create_file` + `pandoc`

**What It Does:** Extract and format API documentation from code

**Scenario:** You have Python code with docstrings and need API docs

```
Step 1: Extract function signatures and docstrings
CLAUDE: [Python script]
import ast
# Parse Python file
# Extract all function definitions
# Extract docstrings

Step 2: Generate markdown documentation
CLAUDE: [create_file] api-documentation.md
## Functions
### function_name(param1, param2)
Description from docstring
**Parameters:**
- param1: description
- param2: description
**Returns:** description

Step 3: Convert to multiple formats
CLAUDE: pandoc api-documentation.md -o api-docs.html
CLAUDE: pandoc api-documentation.md -o api-docs.pdf
```

**Result:** Professional API documentation from code

---

### HACK #20: The "Personal Knowledge Base Builder"
**Combine:** `conversation_search` + `google_drive_search` + `web_search` + `create_file` + persistent memory

**What It Does:** Build a comprehensive knowledge base on a topic from all your sources

**Scenario:** You want everything you know about "machine learning" in one place

```
Step 1: Search Claude conversations
CLAUDE: [conversation_search] "machine learning"
→ Extract insights, decisions, learnings

Step 2: Search Google Drive
CLAUDE: [google_drive_search] "machine learning"
→ Find your notes, documents, research

Step 3: Search web for updates
CLAUDE: [web_search] "machine learning latest developments 2025"
→ Get current context

Step 4: Synthesize into knowledge base
CLAUDE: [create_file] knowledge-base-ml.md
# Machine Learning Knowledge Base

## My Understanding (from conversations)
...

## My Documents (from Drive)
- [Doc 1](link): Summary
- [Doc 2](link): Summary

## Current State of Field (from web)
...

## Key Decisions I've Made
...

## Open Questions
...

Step 5: Store key facts in memory
CLAUDE: [memory_user_edits] Add key ML preferences/decisions for future reference
```

**Result:** Comprehensive, personalized knowledge base

---

## Key Principles for Creating Your Own Hacks

1. **Chain outputs to inputs:** The output of one tool becomes the input to another
2. **Use loops for scale:** `for f in *.md` processes unlimited files
3. **Leverage multiple search tools:** Web + Drive + History = comprehensive
4. **Format convert at the end:** Work in markdown, deliver in client's preferred format
5. **Always bundle related outputs:** Zip files for clean delivery
6. **Generate metadata:** Manifests, indexes, and summaries add professional polish
7. **Validate before deliver:** Diff, grep, and compare to catch issues

---

## Part 10: 20 MORE USER HACKS

---

### HACK #21: The "Template Variable System"
**Combine:** `sed` + `cp` + loop + `zip`

**Use Case (Natural Language):**
"I have a contract template and need to generate 50 personalized versions for different clients, each with their name, company, and custom terms inserted automatically."

**What It Does:** Mass-produces personalized documents from a single template with variable substitution

```bash
# Create template with variables
cat > template.md << 'EOF'
# Agreement for {{CLIENT_NAME}}
Company: {{COMPANY}}
Date: {{DATE}}
Amount: {{AMOUNT}}
EOF

# Data file (CSV-like)
cat > clients.txt << 'EOF'
John Smith,Acme Corp,2025-01-15,$50000
Jane Doe,Globex Inc,2025-01-20,$75000
EOF

# Generate all versions
while IFS=',' read -r name company date amount; do
  filename=$(echo "$name" | tr ' ' '-' | tr '[:upper:]' '[:lower:]')
  sed -e "s/{{CLIENT_NAME}}/$name/g" \
      -e "s/{{COMPANY}}/$company/g" \
      -e "s/{{DATE}}/$date/g" \
      -e "s/{{AMOUNT}}/$amount/g" \
      template.md > "contract-$filename.md"
done < clients.txt

# Bundle all
zip contracts-batch.zip contract-*.md
```

**Result:** 50 personalized contracts in one zip

---

### HACK #22: The "Dead Link Detector"
**Combine:** `grep` + `curl` + reporting

**Use Case (Natural Language):**
"I have documentation with hundreds of URLs. I need to find which links are broken before publishing."

**What It Does:** Extracts all URLs from documents and checks if they're still valid

```bash
# Extract all URLs from markdown files
grep -ohE 'https?://[^)">]+' *.md | sort -u > all-urls.txt

# Check each URL (with timeout)
while read url; do
  status=$(curl -o /dev/null -s -w "%{http_code}" --max-time 5 "$url" 2>/dev/null)
  if [ "$status" != "200" ]; then
    echo "BROKEN ($status): $url"
  fi
done < all-urls.txt > broken-links.txt

# Generate report
echo "# Link Validation Report" > link-report.md
echo "Total URLs checked: $(wc -l < all-urls.txt)" >> link-report.md
echo "Broken links: $(wc -l < broken-links.txt)" >> link-report.md
echo "" >> link-report.md
cat broken-links.txt >> link-report.md
```

**Result:** Report of all broken links with status codes

---

### HACK #23: The "Changelog Generator"
**Combine:** `git log` + `awk` + `create_file`

**Use Case (Natural Language):**
"Generate a professional changelog from my git commit history, organized by date and type of change."

**What It Does:** Transforms git history into a formatted changelog document

```bash
# Generate changelog from git
git log --pretty=format:"%ad|%s" --date=short | \
awk -F'|' '
  {
    if ($1 != current_date) {
      if (current_date != "") print ""
      print "## " $1
      current_date = $1
    }
    # Categorize by commit prefix
    if ($2 ~ /^feat/) print "- ✨ " substr($2, 6)
    else if ($2 ~ /^fix/) print "- 🐛 " substr($2, 5)
    else if ($2 ~ /^docs/) print "- 📚 " substr($2, 6)
    else if ($2 ~ /^refactor/) print "- ♻️ " substr($2, 10)
    else print "- " $2
  }
' > CHANGELOG.md
```

**Result:** Professional changelog with emoji categories

---

### HACK #24: The "Document Statistics Dashboard"
**Combine:** `wc` + `grep` + `awk` + reporting

**Use Case (Natural Language):**
"Give me a complete statistical overview of all my documents - word counts, section counts, TODO items, and complexity metrics."

**What It Does:** Generates a comprehensive statistics report for all documents

```bash
echo "# Document Statistics Dashboard" > stats-report.md
echo "Generated: $(date)" >> stats-report.md
echo "" >> stats-report.md

echo "## Summary" >> stats-report.md
echo "| Document | Lines | Words | Sections | TODOs |" >> stats-report.md
echo "|----------|-------|-------|----------|-------|" >> stats-report.md

for f in *.md; do
  lines=$(wc -l < "$f")
  words=$(wc -w < "$f")
  sections=$(grep -c "^#" "$f" || echo 0)
  todos=$(grep -ci "TODO\|FIXME\|XXX" "$f" || echo 0)
  echo "| $f | $lines | $words | $sections | $todos |" >> stats-report.md
done

echo "" >> stats-report.md
echo "## Totals" >> stats-report.md
echo "- Total documents: $(ls -1 *.md | wc -l)" >> stats-report.md
echo "- Total lines: $(cat *.md | wc -l)" >> stats-report.md
echo "- Total words: $(cat *.md | wc -w)" >> stats-report.md
```

**Result:** Statistical dashboard of your document library

---

### HACK #25: The "Markdown Link Indexer"
**Combine:** `grep` + `sort` + `awk` + `create_file`

**Use Case (Natural Language):**
"Create an index of all internal links between my documents to understand how they reference each other."

**What It Does:** Maps the relationship between documents via their internal links

```bash
echo "# Document Link Index" > link-index.md
echo "" >> link-index.md

for f in *.md; do
  links=$(grep -oE '\[.*\]\([^)]+\.md\)' "$f" 2>/dev/null | sort -u)
  if [ -n "$links" ]; then
    echo "## $f" >> link-index.md
    echo "Links to:" >> link-index.md
    echo "$links" | while read link; do
      echo "- $link" >> link-index.md
    done
    echo "" >> link-index.md
  fi
done
```

**Result:** Visual map of document interconnections

---

### HACK #26: The "Glossary Extractor"
**Combine:** `grep` + `sort` + formatting

**Use Case (Natural Language):**
"Extract all defined terms from my technical documentation and create a consolidated glossary."

**What It Does:** Finds term definitions and compiles them into a glossary

```bash
echo "# Consolidated Glossary" > glossary.md
echo "" >> glossary.md

# Find patterns like "**Term**: definition" or "Term - definition"
grep -hE '^\*\*[^*]+\*\*:|\*\*[^*]+\*\* -' *.md | \
sort -u | \
while read line; do
  echo "- $line" >> glossary.md
done
```

**Result:** Alphabetized glossary from all documents

---

### HACK #27: The "Image Asset Catalog"
**Combine:** `find` + `identify` + `create_file`

**Use Case (Natural Language):**
"Create a catalog of all images in my project with their dimensions, file sizes, and thumbnails."

**What It Does:** Generates an image asset inventory

```bash
echo "# Image Asset Catalog" > image-catalog.md
echo "" >> image-catalog.md
echo "| File | Dimensions | Size | Type |" >> image-catalog.md
echo "|------|------------|------|------|" >> image-catalog.md

find . -type f \( -name "*.png" -o -name "*.jpg" -o -name "*.gif" \) | while read img; do
  dims=$(identify -format "%wx%h" "$img" 2>/dev/null || echo "unknown")
  size=$(ls -lh "$img" | awk '{print $5}')
  type=$(identify -format "%m" "$img" 2>/dev/null || echo "unknown")
  echo "| $img | $dims | $size | $type |" >> image-catalog.md
done
```

**Result:** Complete image inventory with metadata

---

### HACK #28: The "Config File Validator"
**Combine:** Python + `find` + validation

**Use Case (Natural Language):**
"Check all my JSON and YAML config files for syntax errors before deployment."

**What It Does:** Validates configuration file syntax across a project

```python
import json
import yaml
from pathlib import Path

results = []

# Validate JSON files
for f in Path('.').glob('**/*.json'):
    try:
        json.loads(f.read_text())
        results.append(f"✓ {f}: Valid JSON")
    except json.JSONDecodeError as e:
        results.append(f"✗ {f}: {e}")

# Validate YAML files
for f in Path('.').glob('**/*.yaml'):
    try:
        yaml.safe_load(f.read_text())
        results.append(f"✓ {f}: Valid YAML")
    except yaml.YAMLError as e:
        results.append(f"✗ {f}: {e}")

# Write report
with open('config-validation.md', 'w') as report:
    report.write("# Configuration Validation Report\n\n")
    for r in results:
        report.write(f"- {r}\n")
```

**Result:** Validation report for all config files

---

### HACK #29: The "Meeting Notes Consolidator"
**Combine:** `find` + `cat` + `grep` + organization

**Use Case (Natural Language):**
"I have meeting notes scattered across multiple files. Consolidate them by project, extract all action items, and create a master document."

**What It Does:** Merges meeting notes and extracts action items

```bash
# Create consolidated document
echo "# Meeting Notes Consolidation" > meetings-master.md
echo "Generated: $(date)" >> meetings-master.md

# Add all meeting notes chronologically
echo "" >> meetings-master.md
echo "## All Meeting Notes" >> meetings-master.md
for f in $(ls -t meeting-*.md 2>/dev/null); do
  echo "---" >> meetings-master.md
  echo "### From: $f" >> meetings-master.md
  cat "$f" >> meetings-master.md
  echo "" >> meetings-master.md
done

# Extract all action items
echo "---" >> meetings-master.md
echo "## All Action Items" >> meetings-master.md
grep -hE "ACTION:|TODO:|@\w+ will|ASSIGNED:" meeting-*.md >> meetings-master.md
```

**Result:** Master document with all notes + action item summary

---

### HACK #30: The "Code Comment Extractor"
**Combine:** `grep` + `awk` + documentation

**Use Case (Natural Language):**
"Extract all TODO, FIXME, and HACK comments from my codebase and create a technical debt report."

**What It Does:** Creates a technical debt inventory from code comments

```bash
echo "# Technical Debt Report" > tech-debt.md
echo "" >> tech-debt.md

echo "## TODOs" >> tech-debt.md
grep -rn "TODO:" --include="*.py" --include="*.js" . >> tech-debt.md 2>/dev/null
echo "" >> tech-debt.md

echo "## FIXMEs" >> tech-debt.md
grep -rn "FIXME:" --include="*.py" --include="*.js" . >> tech-debt.md 2>/dev/null
echo "" >> tech-debt.md

echo "## HACKs" >> tech-debt.md
grep -rn "HACK:" --include="*.py" --include="*.js" . >> tech-debt.md 2>/dev/null

# Summary
echo "" >> tech-debt.md
echo "## Summary" >> tech-debt.md
echo "- TODOs: $(grep -r 'TODO:' --include='*.py' --include='*.js' . 2>/dev/null | wc -l)" >> tech-debt.md
echo "- FIXMEs: $(grep -r 'FIXME:' --include='*.py' --include='*.js' . 2>/dev/null | wc -l)" >> tech-debt.md
echo "- HACKs: $(grep -r 'HACK:' --include='*.py' --include='*.js' . 2>/dev/null | wc -l)" >> tech-debt.md
```

**Result:** Categorized technical debt report

---

### HACK #31: The "Bilingual Document Generator"
**Combine:** `create_file` + structure + translation placeholders

**Use Case (Natural Language):**
"Create a document structure that supports side-by-side bilingual content for translation workflows."

**What It Does:** Creates documents with parallel language structure

```bash
# Create bilingual template
cat > bilingual-template.md << 'EOF'
# Document Title / Título del Documento

## Section 1 / Sección 1

| English | Español |
|---------|---------|
| [EN content here] | [ES contenido aquí] |

## Section 2 / Sección 2

| English | Español |
|---------|---------|
| [EN content here] | [ES contenido aquí] |
EOF

# Can be extended to extract one language:
grep -E "^\| \[EN" bilingual-doc.md | sed 's/.*\[EN \(.*\)\].*/\1/' > english-only.md
```

**Result:** Translation-ready bilingual document structure

---

### HACK #32: The "Presentation to Blog Post Converter"
**Combine:** `python` + `pptx` processing + `create_file`

**Use Case (Natural Language):**
"Convert my PowerPoint presentation into a blog post, using slide titles as headers and bullet points as content."

**What It Does:** Transforms presentations into readable articles

```python
from pptx import Presentation
from pathlib import Path

prs = Presentation('presentation.pptx')

with open('blog-post.md', 'w') as blog:
    blog.write("# Blog Post from Presentation\n\n")
    
    for i, slide in enumerate(prs.slides):
        # Get title
        if slide.shapes.title:
            blog.write(f"## {slide.shapes.title.text}\n\n")
        
        # Get content
        for shape in slide.shapes:
            if hasattr(shape, "text") and shape != slide.shapes.title:
                text = shape.text.strip()
                if text:
                    # Convert bullets to paragraphs
                    for line in text.split('\n'):
                        if line.strip():
                            blog.write(f"{line.strip()}\n\n")
        
        blog.write("---\n\n")
```

**Result:** Blog-ready article from presentation content

---

### HACK #33: The "Dependency Tree Visualizer"
**Combine:** analysis + `create_file` + mermaid

**Use Case (Natural Language):**
"Create a visual diagram of how my documents depend on each other."

**What It Does:** Generates a Mermaid diagram of document dependencies

```bash
echo "# Document Dependency Tree" > dependencies.md
echo "" >> dependencies.md
echo '```mermaid' >> dependencies.md
echo "graph TD" >> dependencies.md

# Find all document references
for f in *.md; do
  basename="${f%.md}"
  refs=$(grep -oE '\[[^]]+\]\([^)]+\.md\)' "$f" 2>/dev/null | grep -oE '\([^)]+\.md\)' | tr -d '()')
  for ref in $refs; do
    refbase="${ref%.md}"
    echo "    $basename --> $refbase" >> dependencies.md
  done
done

echo '```' >> dependencies.md
```

**Result:** Visual dependency graph in Mermaid format

---

### HACK #34: The "Smart Backup System"
**Combine:** `tar` + timestamp + rotation

**Use Case (Natural Language):**
"Create a backup of my work that automatically rotates old backups and keeps only the last 5 versions."

**What It Does:** Implements automatic backup rotation

```bash
BACKUP_DIR="backups"
MAX_BACKUPS=5

mkdir -p "$BACKUP_DIR"

# Create timestamped backup
timestamp=$(date +%Y%m%d_%H%M%S)
tar -czvf "$BACKUP_DIR/backup_$timestamp.tar.gz" /mnt/user-data/outputs/*.md

# Rotate old backups (keep only last 5)
cd "$BACKUP_DIR"
ls -t backup_*.tar.gz | tail -n +$((MAX_BACKUPS + 1)) | xargs -r rm

# Generate backup log
echo "# Backup Log" > ../backup-log.md
echo "Latest backup: backup_$timestamp.tar.gz" >> ../backup-log.md
echo "" >> ../backup-log.md
echo "## Current Backups:" >> ../backup-log.md
ls -lh backup_*.tar.gz >> ../backup-log.md
```

**Result:** Rotating backup system with log

---

### HACK #35: The "Reading Time Estimator"
**Combine:** `wc` + calculation + metadata injection

**Use Case (Natural Language):**
"Add estimated reading time to all my blog posts automatically."

**What It Does:** Calculates and injects reading time into documents

```bash
for f in *.md; do
  words=$(wc -w < "$f")
  minutes=$(( (words + 199) / 200 ))  # 200 wpm average
  
  # Add reading time after title
  sed -i "1a\\
\\
*Estimated reading time: $minutes minutes*\\
" "$f"
done
```

**Result:** All documents have reading time estimates

---

### HACK #36: The "Sensitive Data Scrubber"
**Combine:** `sed` + patterns + validation

**Use Case (Natural Language):**
"Before sharing documents, automatically redact email addresses, phone numbers, and SSNs."

**What It Does:** Scrubs sensitive data patterns from documents

```bash
for f in *.md; do
  # Create scrubbed version
  sed -E \
    -e 's/[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}/[EMAIL REDACTED]/g' \
    -e 's/\b[0-9]{3}-[0-9]{2}-[0-9]{4}\b/[SSN REDACTED]/g' \
    -e 's/\b[0-9]{3}[-.]?[0-9]{3}[-.]?[0-9]{4}\b/[PHONE REDACTED]/g' \
    "$f" > "scrubbed-$f"
done

# Verify what was scrubbed
diff original.md scrubbed-original.md > scrub-report.txt
```

**Result:** Safely shareable versions with sensitive data removed

---

### HACK #37: The "Quote Collector"
**Combine:** `grep` + formatting + `create_file`

**Use Case (Natural Language):**
"Extract all blockquotes from my documents and compile them into a quotation collection."

**What It Does:** Collects all quotes into a curated document

```bash
echo "# Quote Collection" > quotes.md
echo "" >> quotes.md

for f in *.md; do
  quotes=$(grep "^>" "$f" 2>/dev/null)
  if [ -n "$quotes" ]; then
    echo "## From: $f" >> quotes.md
    echo "$quotes" >> quotes.md
    echo "" >> quotes.md
  fi
done
```

**Result:** Compiled quotation document

---

### HACK #38: The "Table of Contents Injector"
**Combine:** `grep` + `awk` + `sed`

**Use Case (Natural Language):**
"Automatically generate and inject a table of contents into my long documents."

**What It Does:** Creates clickable TOC from headers

```bash
generate_toc() {
  file=$1
  echo "## Table of Contents"
  echo ""
  grep "^##" "$file" | while read line; do
    # Extract header text
    text=$(echo "$line" | sed 's/^##* //')
    # Create anchor link
    anchor=$(echo "$text" | tr '[:upper:]' '[:lower:]' | tr ' ' '-' | tr -cd 'a-z0-9-')
    # Determine indent level
    level=$(echo "$line" | grep -o "^#*" | wc -c)
    indent=$(printf '%*s' $(( (level - 2) * 2 )) '')
    echo "${indent}- [$text](#$anchor)"
  done
  echo ""
}

# Generate TOC and inject after first header
toc=$(generate_toc document.md)
sed -i "/^# /a\\
$toc" document.md
```

**Result:** Auto-generated, clickable table of contents

---

### HACK #39: The "Markdown Linter Report"
**Combine:** validation + reporting

**Use Case (Natural Language):**
"Check all my markdown files for common issues like broken links, missing alt text, inconsistent headers."

**What It Does:** Lints markdown files and reports issues

```bash
echo "# Markdown Lint Report" > lint-report.md

for f in *.md; do
  echo "## $f" >> lint-report.md
  
  # Check for images without alt text
  no_alt=$(grep -c '!\[\](' "$f" 2>/dev/null || echo 0)
  [ "$no_alt" -gt 0 ] && echo "- ⚠️ Images without alt text: $no_alt" >> lint-report.md
  
  # Check for TODO items
  todos=$(grep -c 'TODO' "$f" 2>/dev/null || echo 0)
  [ "$todos" -gt 0 ] && echo "- 📝 TODO items remaining: $todos" >> lint-report.md
  
  # Check for broken internal links
  for link in $(grep -oE '\]\([^)]+\.md\)' "$f" | tr -d '()[]'); do
    [ ! -f "$link" ] && echo "- ❌ Broken link: $link" >> lint-report.md
  done
  
  # Check header hierarchy
  first_h2=$(grep -n "^## " "$f" | head -1 | cut -d: -f1)
  first_h1=$(grep -n "^# " "$f" | head -1 | cut -d: -f1)
  [ -n "$first_h2" ] && [ -n "$first_h1" ] && [ "$first_h2" -lt "$first_h1" ] && \
    echo "- ⚠️ H2 appears before H1" >> lint-report.md
  
  echo "" >> lint-report.md
done
```

**Result:** Quality report for all markdown files

---

### HACK #40: The "Multi-Session Project Compiler"
**Combine:** `conversation_search` + `google_drive_search` + `create_file` + `zip`

**Use Case (Natural Language):**
"Compile everything I've ever created about a specific project across all Claude sessions and my Google Drive into one complete package."

**What It Does:** Creates a comprehensive project archive from all sources

```
Step 1: Search Claude conversations
CLAUDE: [conversation_search] "Project Atlas"
→ Collect all discussion snippets

Step 2: Search Google Drive
CLAUDE: [google_drive_search] "Project Atlas"
→ Find all related documents

Step 3: Search current outputs
CLAUDE: grep -rl "Project Atlas" /mnt/user-data/outputs/
→ Find current session documents

Step 4: Create compilation
CLAUDE: [create_file] project-atlas-complete.md
- Executive summary
- Timeline of development
- All decisions made
- Related documents (with links)
- Current status

Step 5: Bundle everything
CLAUDE: 
- Copy relevant outputs
- Generate manifest
- Create README
- zip project-atlas-archive.zip *

Step 6: Add to memory for future reference
CLAUDE: [memory_user_edits] "Project Atlas archive created Dec 2025"
```

**Result:** Complete project archive with full history

---

## Additional Pro Tips

### Pro Tip #21: Use `tee` to See Output While Saving
```bash
command | tee output.txt
# Shows output on screen AND saves to file
```

### Pro Tip #22: Use `xargs` for Parallel Processing
```bash
find . -name "*.md" | xargs -P4 -I{} pandoc {} -o {}.docx
# Converts 4 files in parallel
```

### Pro Tip #23: Use `watch` Pattern for Progress
```bash
# Check progress of long operation
ls -la /mnt/user-data/outputs/ | wc -l
# Run periodically to see file count growing
```

### Pro Tip #24: Combine Skills for Complex Tasks
```
"Read the docx skill AND the frontend-design skill, then create a Word document with exceptional visual design"
```

### Pro Tip #25: Use `head -c` for Large File Preview
```bash
head -c 1000 largefile.txt  # First 1000 bytes only
```

### Pro Tip #26: Create Self-Documenting Scripts
```bash
# Add help text that grep can find
echo "# USAGE: This script does X, Y, Z" > script.sh
# Later: grep "^# USAGE" *.sh
```

### Pro Tip #27: Use `column` for Pretty Tables
```bash
cat data.csv | column -t -s,
# Formats CSV as aligned columns
```

### Pro Tip #28: Chain `&&` for Dependent Operations
```bash
mkdir output && cd output && create files
# Only continues if previous command succeeds
```

### Pro Tip #29: Use Process Substitution
```bash
diff <(sort file1.txt) <(sort file2.txt)
# Compare sorted versions without temp files
```

### Pro Tip #30: Request Explicit Skill Reading
```
"Before creating this presentation, read the pptx skill file completely, then proceed"
```

---

*Claude Environment Capabilities Reference v1.2.0*
*© 2025 groklyGroup LLC. All rights reserved.*
