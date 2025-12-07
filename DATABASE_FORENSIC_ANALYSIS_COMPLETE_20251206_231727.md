# FORENSIC DATABASE ECOSYSTEM ANALYSIS
**Generated**: Sat Dec  6 23:17:27 PST 2025
**Purpose**: Pixel-by-pixel analysis of ALL database dependencies

---

## PART 1: COMPLETE DATABASE INVENTORY

### Active Production Databases (Non-Backup Locations)

#### Database: `./.chat-registry/chat-registry.db`

**File Stats:**
-rw-r--r-- 1 groklygroup groklygroup 28K Aug  9 22:22 ./.chat-registry/chat-registry.db

**Size:** 28K

**Modified:** 2025-08-09 22:22:17.663919700 -0700

**Accessed:** 2025-08-09 22:22:28.028235400 -0700

**Tables:**
chat_files

**Schema Sample (first 50 lines):**
```sql
CREATE TABLE chat_files (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    file_path TEXT UNIQUE NOT NULL,
    file_name TEXT NOT NULL,
    file_type TEXT,
    file_size INTEGER,
    file_modified TIMESTAMP,
    file_hash TEXT,
    content_preview TEXT,
    todo_count INTEGER DEFAULT 0,
    imported BOOLEAN DEFAULT 0,
    import_date TIMESTAMP,
    discovered_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE sqlite_sequence(name,seq);
CREATE INDEX idx_file_hash ON chat_files(file_hash);
CREATE INDEX idx_file_type ON chat_files(file_type);
CREATE INDEX idx_imported ON chat_files(imported);
```

---

#### Database: `./.cleanup-analysis/file_analysis.db`

**File Stats:**
-rwxrwxrwx 1 groklygroup groklygroup 44K Jul 15 13:52 ./.cleanup-analysis/file_analysis.db

**Size:** 44K

**Modified:** 2025-07-15 13:52:14.999462500 -0700

**Accessed:** 2025-07-15 21:15:23.159109200 -0700

**Tables:**
cleanup_categories  duplicate_groups    file_inventory    

**Schema Sample (first 50 lines):**
```sql
CREATE TABLE file_inventory (
    file_path TEXT PRIMARY KEY,
    content_hash TEXT,
    file_size INTEGER,
    modified_time INTEGER,
    mime_type TEXT,
    category TEXT,
    is_duplicate BOOLEAN DEFAULT 0,
    duplicate_group_id INTEGER,
    keep_file BOOLEAN DEFAULT 1,
    safety_score INTEGER DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE duplicate_groups (
    group_id INTEGER PRIMARY KEY AUTOINCREMENT,
    content_hash TEXT UNIQUE,
    file_count INTEGER,
    total_size INTEGER,
    category TEXT,
    keep_file TEXT,
    remove_files TEXT,
    space_saved INTEGER
);
CREATE TABLE sqlite_sequence(name,seq);
CREATE TABLE cleanup_categories (
    category TEXT PRIMARY KEY,
    description TEXT,
    safety_level INTEGER, -- 1=safe, 2=caution, 3=dangerous
    auto_clean BOOLEAN DEFAULT 0,
    file_count INTEGER DEFAULT 0,
    total_size INTEGER DEFAULT 0
);
CREATE INDEX idx_content_hash ON file_inventory(content_hash);
CREATE INDEX idx_category ON file_inventory(category);
CREATE INDEX idx_duplicate ON file_inventory(is_duplicate);
```

---

#### Database: `./.cleanup-state/rollback-20251117_191418/quantum-todo-backup.db`

**File Stats:**
-rwxrwxrwx 1 groklygroup groklygroup 22M Nov 17 19:14 ./.cleanup-state/rollback-20251117_191418/quantum-todo-backup.db

**Size:** 22M

**Modified:** 2025-11-17 19:14:25.263485500 -0800

**Accessed:** 2025-11-17 19:15:08.005789500 -0800

**Tables:**
alert_history        performance_metrics  roles              
alert_rules          quantum_fts          tenant_config      
api_keys             quantum_fts_config   todo_dependencies  
audit_log            quantum_fts_data     user_roles         
cache_config         quantum_fts_docsize  webhook_events     
csrf_tokens          quantum_fts_idx      webhooks           
dependency_counts    quantum_todos        white_label_config 

**Schema Sample (first 50 lines):**
```sql
CREATE TABLE tenant_config (
    tenant_id TEXT PRIMARY KEY,
    max_todos INTEGER DEFAULT 10000,
    max_storage_mb INTEGER DEFAULT 100,
    features TEXT DEFAULT '{}',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE api_keys (
    key_hash TEXT PRIMARY KEY,
    tenant_id TEXT NOT NULL,
    user_id TEXT NOT NULL,
    permissions TEXT DEFAULT '{}',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_used TIMESTAMP,
    expires_at TIMESTAMP,
    FOREIGN KEY (tenant_id) REFERENCES tenant_config(tenant_id)
);
CREATE TABLE audit_log (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    tenant_id TEXT NOT NULL,
    user_id TEXT,
    action TEXT NOT NULL,
    resource_type TEXT,
    resource_id TEXT,
    details TEXT,
    ip_address TEXT,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE sqlite_sequence(name,seq);
CREATE TABLE roles (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    role_name TEXT NOT NULL UNIQUE,
    permissions TEXT NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE user_roles (
    user_id TEXT NOT NULL,
    role_id INTEGER NOT NULL,
    tenant_id TEXT NOT NULL,
    assigned_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id, role_id, tenant_id),
    FOREIGN KEY (role_id) REFERENCES roles(id)
);
CREATE TABLE white_label_config (
    tenant_id TEXT PRIMARY KEY,
    brand_name TEXT NOT NULL DEFAULT 'Quantum TODO',
    brand_tagline TEXT DEFAULT 'Enterprise Task Management',
    primary_color TEXT DEFAULT '#3498db',
```

---

#### Database: `./.enforcement/core/time-waste.db`

**File Stats:**
-rwxrwxrwx 1 groklygroup groklygroup 0 Nov 17 02:11 ./.enforcement/core/time-waste.db

**Size:** 0

**Modified:** 2025-11-17 02:11:37.000000000 -0800

**Accessed:** 2025-11-24 19:33:45.000000000 -0800

**Tables:**

**Schema Sample (first 50 lines):**
```sql
```

---

#### Database: `./.enforcement/core/violation-tracking.db`

**File Stats:**
-rwxrwxrwx 1 groklygroup groklygroup 81 Nov 17 02:11 ./.enforcement/core/violation-tracking.db

**Size:** 0

**Modified:** 2025-11-17 02:11:37.000000000 -0800

**Accessed:** 2025-12-05 12:11:40.000000000 -0800

**Tables:**
Cannot read tables

**Schema Sample (first 50 lines):**
```sql
```

---

#### Database: `./.extraction-progress.db`

**File Stats:**
-rw-r--r-- 1 groklygroup groklygroup 20K Aug 10 04:45 ./.extraction-progress.db

**Size:** 20K

**Modified:** 2025-08-10 04:45:28.146573300 -0700

**Accessed:** 2025-08-10 04:45:35.794835200 -0700

**Tables:**
extracted_files   extraction_state

**Schema Sample (first 50 lines):**
```sql
CREATE TABLE extracted_files (
    file_path TEXT PRIMARY KEY,
    file_hash TEXT,
    extraction_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    todos_found INTEGER DEFAULT 0,
    completed_count INTEGER DEFAULT 0,
    pending_count INTEGER DEFAULT 0,
    uncertain_count INTEGER DEFAULT 0
);
CREATE TABLE extraction_state (
    key TEXT PRIMARY KEY,
    value TEXT
);
```

---

#### Database: `./.index-system/content-analysis.db`

**File Stats:**
-rw-r--r-- 1 groklygroup groklygroup 652K Nov 19 21:39 ./.index-system/content-analysis.db

**Size:** 652K

**Modified:** 2025-11-19 21:39:08.228487800 -0800

**Accessed:** 2025-11-19 21:39:40.794554000 -0800

**Tables:**
content_analysis

**Schema Sample (first 50 lines):**
```sql
CREATE TABLE content_analysis (
    doc_id TEXT PRIMARY KEY,
    file_path TEXT NOT NULL,
    content_type TEXT,
    keywords TEXT,
    tags TEXT,
    summary TEXT,
    language TEXT,
    analyzed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX idx_content_path ON content_analysis(file_path);
CREATE INDEX idx_content_type ON content_analysis(content_type);
```

---

#### Database: `./.index-system/database/quantum-index.db`

**File Stats:**
-rwxr-xr-x 1 groklygroup groklygroup 36M Sep 12 16:16 ./.index-system/database/quantum-index.db

**Size:** 36M

**Modified:** 2025-09-12 16:16:55.373521600 -0700

**Accessed:** 2025-09-12 16:17:02.894489400 -0700

**Tables:**
file_registry            quantum_fts_docsize      todo_dependency_view   
quantum_fts              quantum_fts_idx          todos_archived_20250726
quantum_fts_config       quantum_todos            todos_by_category      
quantum_fts_content      quantum_todos_trash      todos_by_priority      
quantum_fts_data         todo_dependencies        todos_critical_path    

**Schema Sample (first 50 lines):**
```sql
CREATE TABLE quantum_todos (
    id TEXT PRIMARY KEY,
    content TEXT NOT NULL,
    status TEXT NOT NULL,
    priority TEXT NOT NULL,
    source TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    completed_at TIMESTAMP,
    session_id TEXT,
    tags TEXT,
    quantum_state TEXT DEFAULT 'superposition'
, depends_on TEXT, blocks TEXT, dependency_status TEXT DEFAULT 'ready', estimated_hours REAL, actual_hours REAL, dependency_chain_length INTEGER DEFAULT 0, content_hash TEXT, source_file_hash TEXT, source_line_number INTEGER, confidence_level TEXT DEFAULT 'medium', completion_evidence TEXT, auto_completed BOOLEAN DEFAULT 0, completion_reason TEXT, review_date TIMESTAMP);
CREATE TABLE IF NOT EXISTS 'quantum_fts_data'(id INTEGER PRIMARY KEY, block BLOB);
CREATE TABLE IF NOT EXISTS 'quantum_fts_idx'(segid, term, pgno, PRIMARY KEY(segid, term)) WITHOUT ROWID;
CREATE TABLE IF NOT EXISTS 'quantum_fts_content'(id INTEGER PRIMARY KEY, c0, c1);
CREATE TABLE IF NOT EXISTS 'quantum_fts_docsize'(id INTEGER PRIMARY KEY, sz BLOB);
CREATE TABLE IF NOT EXISTS 'quantum_fts_config'(k PRIMARY KEY, v) WITHOUT ROWID;
CREATE TABLE IF NOT EXISTS "todos_archived_20250726" (
    id TEXT PRIMARY KEY,
    content TEXT NOT NULL,
    status TEXT DEFAULT 'pending',
    priority TEXT DEFAULT 'medium',
    source TEXT DEFAULT 'import',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    completed_at DATETIME,
    session_id TEXT,
    tags TEXT,
    quantum_state TEXT DEFAULT 'superposition',
    hash TEXT UNIQUE
);
CREATE TABLE todo_dependencies (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    todo_id TEXT NOT NULL,
    depends_on_id TEXT NOT NULL,
    dependency_type TEXT DEFAULT 'blocks', -- blocks, requires, related
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (todo_id) REFERENCES quantum_todos(id),
    FOREIGN KEY (depends_on_id) REFERENCES quantum_todos(id),
    UNIQUE(todo_id, depends_on_id)
);
CREATE TABLE sqlite_sequence(name,seq);
CREATE TABLE file_registry (file_hash TEXT PRIMARY KEY, current_path TEXT NOT NULL, filename TEXT NOT NULL, last_seen TIMESTAMP DEFAULT CURRENT_TIMESTAMP, file_size INTEGER, file_modified TIMESTAMP, project TEXT, file_type TEXT);
CREATE INDEX idx_status ON quantum_todos(status);
CREATE INDEX idx_priority ON quantum_todos(priority);
CREATE INDEX idx_session ON quantum_todos(session_id);
CREATE INDEX idx_todos_status ON "todos_archived_20250726"(status);
CREATE INDEX idx_todos_priority ON "todos_archived_20250726"(priority);
CREATE INDEX idx_todos_created ON "todos_archived_20250726"(created_at);
CREATE INDEX idx_todos_hash ON "todos_archived_20250726"(hash);
CREATE INDEX idx_hash ON "todos_archived_20250726"(hash);
```

---

#### Database: `./.index-system/nl-index.db`

**File Stats:**
-rw-r--r-- 1 groklygroup groklygroup 56K Oct 11 21:02 ./.index-system/nl-index.db

**Size:** 56K

**Modified:** 2025-10-11 21:02:17.788916300 -0700

**Accessed:** 2025-10-15 11:04:22.854984800 -0700

**Tables:**
file_content_fts          file_content_fts_docsize  indexing_stats          
file_content_fts_config   file_content_fts_idx      write_queue_stats       
file_content_fts_data     file_index              

**Schema Sample (first 50 lines):**
```sql
CREATE TABLE file_index (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    file_path TEXT UNIQUE NOT NULL,
    file_name TEXT,
    file_size INTEGER,
    file_type TEXT,
    mime_type TEXT,
    encoding TEXT,
    content TEXT,
    content_hash TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    modified_at TIMESTAMP,
    indexed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    metadata TEXT,
    error_msg TEXT,
    retry_count INTEGER DEFAULT 0
);
CREATE TABLE sqlite_sequence(name,seq);
CREATE INDEX idx_file_path ON file_index(file_path);
CREATE INDEX idx_file_name ON file_index(file_name);
CREATE INDEX idx_content_hash ON file_index(content_hash);
CREATE INDEX idx_indexed_at ON file_index(indexed_at);
CREATE TABLE indexing_stats (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    files_processed INTEGER DEFAULT 0,
    bytes_processed INTEGER DEFAULT 0,
    errors INTEGER DEFAULT 0,
    avg_processing_time_ms INTEGER DEFAULT 0
);
CREATE TABLE write_queue_stats (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    queue_size INTEGER DEFAULT 0,
    batch_size INTEGER DEFAULT 0,
    write_time_ms INTEGER DEFAULT 0
);
CREATE VIRTUAL TABLE file_content_fts USING fts5(
    file_path,
    content,
    content=file_index,
    content_rowid=id
)
/* file_content_fts(file_path,content) */;
CREATE TABLE IF NOT EXISTS 'file_content_fts_data'(id INTEGER PRIMARY KEY, block BLOB);
CREATE TABLE IF NOT EXISTS 'file_content_fts_idx'(segid, term, pgno, PRIMARY KEY(segid, term)) WITHOUT ROWID;
CREATE TABLE IF NOT EXISTS 'file_content_fts_docsize'(id INTEGER PRIMARY KEY, sz BLOB);
CREATE TABLE IF NOT EXISTS 'file_content_fts_config'(k PRIMARY KEY, v) WITHOUT ROWID;
CREATE TRIGGER file_index_ai AFTER INSERT ON file_index BEGIN
    INSERT INTO file_content_fts(rowid, file_path, content)
```

---

#### Database: `./.index-system/quantum-index.db`

**File Stats:**
-rw-r--r-- 1 groklygroup groklygroup 16K Sep 13 17:23 ./.index-system/quantum-index.db

**Size:** 16K

**Modified:** 2025-09-13 17:23:05.588491900 -0700

**Accessed:** 2025-09-13 17:23:11.722264400 -0700

**Tables:**
process_patterns

**Schema Sample (first 50 lines):**
```sql
CREATE TABLE process_patterns (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    pattern TEXT UNIQUE,
    avg_runtime INTEGER DEFAULT 0,
    timeout INTEGER DEFAULT 300,
    optimization TEXT,
    kill_count INTEGER DEFAULT 0,
    last_seen TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE sqlite_sequence(name,seq);
```

---

#### Database: `./.index-system/test-file-index.db`

**File Stats:**
-rw-r--r-- 1 groklygroup groklygroup 80K Aug 11 21:18 ./.index-system/test-file-index.db

**Size:** 80K

**Modified:** 2025-08-11 21:18:52.295909100 -0700

**Accessed:** 2025-08-11 21:18:58.877002400 -0700

**Tables:**
file_index              file_index_fts_config   file_index_fts_idx    
file_index_basic        file_index_fts_data     simple_test           
file_index_fts          file_index_fts_docsize

**Schema Sample (first 50 lines):**
```sql
CREATE TABLE simple_test (id INTEGER PRIMARY KEY);
CREATE TABLE file_index_basic (
    id TEXT PRIMARY KEY,
    file_path TEXT NOT NULL,
    filename TEXT,
    extension TEXT,
    file_size INTEGER
);
CREATE VIRTUAL TABLE file_index_fts USING fts5(
    file_path,
    filename,
    content_preview,
    content_full,
    tags,
    keywords,
    content=file_index
)
/* file_index_fts(file_path,filename,content_preview,content_full,tags,keywords) */;
CREATE TABLE IF NOT EXISTS 'file_index_fts_data'(id INTEGER PRIMARY KEY, block BLOB);
CREATE TABLE IF NOT EXISTS 'file_index_fts_idx'(segid, term, pgno, PRIMARY KEY(segid, term)) WITHOUT ROWID;
CREATE TABLE IF NOT EXISTS 'file_index_fts_docsize'(id INTEGER PRIMARY KEY, sz BLOB);
CREATE TABLE IF NOT EXISTS 'file_index_fts_config'(k PRIMARY KEY, v) WITHOUT ROWID;
CREATE TABLE file_index (
    id TEXT PRIMARY KEY,
    file_path TEXT NOT NULL,
    filename TEXT,
    extension TEXT,
    file_size INTEGER,
    modified_at TIMESTAMP,
    indexed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    mime_type TEXT,
    encoding TEXT,
    is_binary BOOLEAN DEFAULT FALSE,
    content_preview TEXT,
    content_full TEXT,
    content_hash TEXT,
    sha256_hash TEXT,
    line_count INTEGER,
    word_count INTEGER,
    char_count INTEGER
);
```

---

#### Database: `./.index-system/universal-file-index.db`

**File Stats:**
-rwxrwxrwx 1 groklygroup groklygroup 21M Dec  6 19:08 ./.index-system/universal-file-index.db

**Size:** 21M

**Modified:** 2025-12-06 19:08:06.845804400 -0800

**Accessed:** 2025-12-06 19:08:06.845804400 -0800

**Tables:**
ai_content_view         file_index_fts_docsize  files_fts_docsize     
file_index              file_index_fts_idx      files_fts_idx         
file_index_fts          files                   index_config          
file_index_fts_config   files_fts               stats                 
file_index_fts_content  files_fts_config      
file_index_fts_data     files_fts_data        

**Schema Sample (first 50 lines):**
```sql
CREATE TABLE file_index (
    -- Core File Information
    id TEXT PRIMARY KEY,                    -- DOC-{SHA256_8}-{TIMESTAMP}
    file_path TEXT NOT NULL,
    filename TEXT,
    extension TEXT,
    file_size INTEGER,
    created_at TIMESTAMP,
    modified_at TIMESTAMP,
    indexed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- Copyright and Authorship
    copyright_owner TEXT DEFAULT 'groklyGroup™ LLC 2025',
    authors JSON,                           -- Detected content creators
    
    -- Enhanced File Type Information
    mime_type TEXT,
    encoding TEXT,
    is_binary BOOLEAN DEFAULT FALSE,
    
    -- File System Metadata
    permissions TEXT,
    owner TEXT,
    group_owner TEXT,
    symlink_target TEXT,
    
    -- Content & Hashing
    sha256_hash TEXT UNIQUE,
    content_hash TEXT,
    content_preview TEXT,                   -- First 2000 chars (increased from 500)
    content_full TEXT,                      -- Full text for FTS
    line_count INTEGER,
    word_count INTEGER,
    char_count INTEGER,
    
    -- AI-Powered Tags & Classification
    tags TEXT,                              -- AI-generated tags
    categories JSON,                        -- Multiple categories support
    keywords JSON,                          -- AI-extracted with relevance scores
    languages JSON,                         -- Multiple languages support
    
    -- Relationships & References
    parent_id TEXT,
    related_ids JSON,
    imports JSON,
    imported_by JSON,
    cross_refs JSON,
    semantic_embeddings BLOB,               -- Vector embeddings
    similar_files JSON,
    dependency_graph JSON,
```

---

#### Database: `./.index-system/universal-index.db`

**File Stats:**
-rwxrwxrwx 1 groklygroup groklygroup 21M Dec  6 20:58 ./.index-system/universal-index.db

**Size:** 21M

**Modified:** 2025-12-06 20:58:16.757330000 -0800

**Accessed:** 2025-12-06 20:58:16.757330000 -0800

**Tables:**
ai_content_view         file_index_fts_docsize  files_fts_docsize     
file_index              file_index_fts_idx      files_fts_idx         
file_index_fts          files                   index_config          
file_index_fts_config   files_fts               stats                 
file_index_fts_content  files_fts_config      
file_index_fts_data     files_fts_data        

**Schema Sample (first 50 lines):**
```sql
CREATE TABLE file_index (
    -- Core File Information
    id TEXT PRIMARY KEY,                    -- DOC-{SHA256_8}-{TIMESTAMP}
    file_path TEXT NOT NULL,
    filename TEXT,
    extension TEXT,
    file_size INTEGER,
    created_at TIMESTAMP,
    modified_at TIMESTAMP,
    indexed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- Copyright and Authorship
    copyright_owner TEXT DEFAULT 'groklyGroup™ LLC 2025',
    authors JSON,                           -- Detected content creators
    
    -- Enhanced File Type Information
    mime_type TEXT,
    encoding TEXT,
    is_binary BOOLEAN DEFAULT FALSE,
    
    -- File System Metadata
    permissions TEXT,
    owner TEXT,
    group_owner TEXT,
    symlink_target TEXT,
    
    -- Content & Hashing
    sha256_hash TEXT UNIQUE,
    content_hash TEXT,
    content_preview TEXT,                   -- First 2000 chars (increased from 500)
    content_full TEXT,                      -- Full text for FTS
    line_count INTEGER,
    word_count INTEGER,
    char_count INTEGER,
    
    -- AI-Powered Tags & Classification
    tags TEXT,                              -- AI-generated tags
    categories JSON,                        -- Multiple categories support
    keywords JSON,                          -- AI-extracted with relevance scores
    languages JSON,                         -- Multiple languages support
    
    -- Relationships & References
    parent_id TEXT,
    related_ids JSON,
    imports JSON,
    imported_by JSON,
    cross_refs JSON,
    semantic_embeddings BLOB,               -- Vector embeddings
    similar_files JSON,
    dependency_graph JSON,
```

---

#### Database: `./.logs/hash-fortress/security/database-snapshot-hash-fortress-20251012-170553.db`

**File Stats:**
-rw-r--r-- 1 groklygroup groklygroup 122M Oct 12 17:05 ./.logs/hash-fortress/security/database-snapshot-hash-fortress-20251012-170553.db

**Size:** 122M

**Modified:** 2025-10-12 17:05:59.208568500 -0700

**Accessed:** 2025-10-15 11:17:03.121790500 -0700

**Tables:**
anomaly_detections       ml_processing_progress   quantum_todos_optimized
api_keys                 ml_training_data         roles                  
audit_log                nlp_patterns             tenant_config          
audit_trail              performance_metrics      tenant_usage           
cache_config             quantum_execution_plan   theme_presets          
csrf_tokens              quantum_fts              todo_dependencies      
custom_domains           quantum_fts_config       todo_file_links        
dependency_counts        quantum_fts_data         ui_components          
email_templates          quantum_fts_docsize      user_behavior          
file_index               quantum_fts_idx          user_roles             
ml_models                quantum_todos            white_label_config     
ml_predictions           quantum_todos_archive  

**Schema Sample (first 50 lines):**
```sql
CREATE TABLE quantum_todos (
    id TEXT PRIMARY KEY,
    content TEXT NOT NULL,
    status TEXT NOT NULL DEFAULT 'pending',
    priority TEXT NOT NULL DEFAULT 'medium',
    source TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    completed_at TIMESTAMP,
    session_id TEXT,
    tags TEXT,
    quantum_state TEXT DEFAULT 'superposition',
    dependency_status TEXT DEFAULT 'ready',
    dependency_chain_length INTEGER DEFAULT 0
, craft_framework TEXT, project_tags TEXT, ml_priority_score REAL, content_hash TEXT, composite_content TEXT, tenant_id TEXT DEFAULT 'default', priority_order INTEGER DEFAULT 3, depends_on TEXT, blocks TEXT, estimated_hours REAL, actual_hours REAL, source_file_hash TEXT, source_line_number INTEGER, confidence_level TEXT, completion_evidence TEXT, auto_completed INTEGER, completion_reason TEXT, review_date INTEGER, predicted_duration INTEGER, actual_duration INTEGER);
CREATE TABLE todo_dependencies (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    todo_id TEXT NOT NULL,
    depends_on_id TEXT NOT NULL,
    dependency_type TEXT DEFAULT 'blocks',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (todo_id) REFERENCES quantum_todos (id),
    FOREIGN KEY (depends_on_id) REFERENCES quantum_todos (id),
    UNIQUE(todo_id, depends_on_id)
);
CREATE TABLE sqlite_sequence(name,seq);
CREATE TABLE IF NOT EXISTS 'quantum_fts_data'(id INTEGER PRIMARY KEY, block BLOB);
CREATE TABLE IF NOT EXISTS 'quantum_fts_idx'(segid, term, pgno, PRIMARY KEY(segid, term)) WITHOUT ROWID;
CREATE TABLE IF NOT EXISTS 'quantum_fts_docsize'(id INTEGER PRIMARY KEY, sz BLOB);
CREATE TABLE IF NOT EXISTS 'quantum_fts_config'(k PRIMARY KEY, v) WITHOUT ROWID;
CREATE TABLE sqlite_stat1(tbl,idx,stat);
CREATE TABLE file_index (
    file_path TEXT PRIMARY KEY,
    last_referenced TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    reference_count INTEGER DEFAULT 1
);
CREATE TABLE todo_file_links (
    todo_id TEXT,
    file_path TEXT,
    FOREIGN KEY (todo_id) REFERENCES quantum_todos(id),
    FOREIGN KEY (file_path) REFERENCES file_index(file_path)
);
CREATE TABLE ml_processing_progress (
    content_type TEXT PRIMARY KEY,
    last_processed_id TEXT,
    last_processed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    items_processed INTEGER DEFAULT 0,
    tenant_id TEXT DEFAULT 'default'
);
CREATE TABLE audit_trail (
    audit_id TEXT PRIMARY KEY,
```

---

#### Database: `./.logs/hash-fortress/security/database-snapshot-hash-fortress-20251012-171520.db`

**File Stats:**
-rw-r--r-- 1 groklygroup groklygroup 127M Oct 12 17:15 ./.logs/hash-fortress/security/database-snapshot-hash-fortress-20251012-171520.db

**Size:** 127M

**Modified:** 2025-10-12 17:15:23.246531400 -0700

**Accessed:** 2025-10-15 11:17:16.631582700 -0700

**Tables:**
anomaly_detections       ml_processing_progress   quantum_todos_optimized
api_keys                 ml_training_data         roles                  
audit_log                nlp_patterns             tenant_config          
audit_trail              performance_metrics      tenant_usage           
cache_config             quantum_execution_plan   theme_presets          
csrf_tokens              quantum_fts              todo_dependencies      
custom_domains           quantum_fts_config       todo_file_links        
dependency_counts        quantum_fts_data         ui_components          
email_templates          quantum_fts_docsize      user_behavior          
file_index               quantum_fts_idx          user_roles             
ml_models                quantum_todos            white_label_config     
ml_predictions           quantum_todos_archive  

**Schema Sample (first 50 lines):**
```sql
CREATE TABLE quantum_todos (
    id TEXT PRIMARY KEY,
    content TEXT NOT NULL,
    status TEXT NOT NULL DEFAULT 'pending',
    priority TEXT NOT NULL DEFAULT 'medium',
    source TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    completed_at TIMESTAMP,
    session_id TEXT,
    tags TEXT,
    quantum_state TEXT DEFAULT 'superposition',
    dependency_status TEXT DEFAULT 'ready',
    dependency_chain_length INTEGER DEFAULT 0
, craft_framework TEXT, project_tags TEXT, ml_priority_score REAL, content_hash TEXT, composite_content TEXT, tenant_id TEXT DEFAULT 'default', priority_order INTEGER DEFAULT 3, depends_on TEXT, blocks TEXT, estimated_hours REAL, actual_hours REAL, source_file_hash TEXT, source_line_number INTEGER, confidence_level TEXT, completion_evidence TEXT, auto_completed INTEGER, completion_reason TEXT, review_date INTEGER, predicted_duration INTEGER, actual_duration INTEGER);
CREATE TABLE todo_dependencies (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    todo_id TEXT NOT NULL,
    depends_on_id TEXT NOT NULL,
    dependency_type TEXT DEFAULT 'blocks',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (todo_id) REFERENCES quantum_todos (id),
    FOREIGN KEY (depends_on_id) REFERENCES quantum_todos (id),
    UNIQUE(todo_id, depends_on_id)
);
CREATE TABLE sqlite_sequence(name,seq);
CREATE TABLE IF NOT EXISTS 'quantum_fts_data'(id INTEGER PRIMARY KEY, block BLOB);
CREATE TABLE IF NOT EXISTS 'quantum_fts_idx'(segid, term, pgno, PRIMARY KEY(segid, term)) WITHOUT ROWID;
CREATE TABLE IF NOT EXISTS 'quantum_fts_docsize'(id INTEGER PRIMARY KEY, sz BLOB);
CREATE TABLE IF NOT EXISTS 'quantum_fts_config'(k PRIMARY KEY, v) WITHOUT ROWID;
CREATE TABLE sqlite_stat1(tbl,idx,stat);
CREATE TABLE file_index (
    file_path TEXT PRIMARY KEY,
    last_referenced TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    reference_count INTEGER DEFAULT 1
);
CREATE TABLE todo_file_links (
    todo_id TEXT,
    file_path TEXT,
    FOREIGN KEY (todo_id) REFERENCES quantum_todos(id),
    FOREIGN KEY (file_path) REFERENCES file_index(file_path)
);
CREATE TABLE ml_processing_progress (
    content_type TEXT PRIMARY KEY,
    last_processed_id TEXT,
    last_processed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    items_processed INTEGER DEFAULT 0,
    tenant_id TEXT DEFAULT 'default'
);
CREATE TABLE audit_trail (
    audit_id TEXT PRIMARY KEY,
```

---

#### Database: `./.logs/hash-fortress/security/working-database-hash-fortress-20251012-170553.db`

**File Stats:**
-rw-r--r-- 1 groklygroup groklygroup 129M Oct 12 17:09 ./.logs/hash-fortress/security/working-database-hash-fortress-20251012-170553.db

**Size:** 129M

**Modified:** 2025-10-12 17:09:05.528247900 -0700

**Accessed:** 2025-10-15 11:17:42.186241200 -0700

**Tables:**
anomaly_detections          quantum_fts               
api_keys                    quantum_fts_config        
audit_log                   quantum_fts_data          
audit_trail                 quantum_fts_docsize       
cache_config                quantum_fts_idx           
cross_reference_validation  quantum_todos             
csrf_tokens                 quantum_todos_archive     
custom_domains              quantum_todos_optimized   
dependency_counts           roles                     
email_templates             tenant_config             
file_index                  tenant_usage              
hash_verification           theme_presets             
ml_models                   todo_dependencies         
ml_predictions              todo_file_links           
ml_processing_progress      ui_components             
ml_training_data            user_behavior             
nlp_patterns                user_roles                
performance_metrics         white_label_config        
quantum_execution_plan    

**Schema Sample (first 50 lines):**
```sql
CREATE TABLE quantum_todos (
    id TEXT PRIMARY KEY,
    content TEXT NOT NULL,
    status TEXT NOT NULL DEFAULT 'pending',
    priority TEXT NOT NULL DEFAULT 'medium',
    source TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    completed_at TIMESTAMP,
    session_id TEXT,
    tags TEXT,
    quantum_state TEXT DEFAULT 'superposition',
    dependency_status TEXT DEFAULT 'ready',
    dependency_chain_length INTEGER DEFAULT 0
, craft_framework TEXT, project_tags TEXT, ml_priority_score REAL, content_hash TEXT, composite_content TEXT, tenant_id TEXT DEFAULT 'default', priority_order INTEGER DEFAULT 3, depends_on TEXT, blocks TEXT, estimated_hours REAL, actual_hours REAL, source_file_hash TEXT, source_line_number INTEGER, confidence_level TEXT, completion_evidence TEXT, auto_completed INTEGER, completion_reason TEXT, review_date INTEGER, predicted_duration INTEGER, actual_duration INTEGER);
CREATE TABLE todo_dependencies (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    todo_id TEXT NOT NULL,
    depends_on_id TEXT NOT NULL,
    dependency_type TEXT DEFAULT 'blocks',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (todo_id) REFERENCES quantum_todos (id),
    FOREIGN KEY (depends_on_id) REFERENCES quantum_todos (id),
    UNIQUE(todo_id, depends_on_id)
);
CREATE TABLE sqlite_sequence(name,seq);
CREATE TABLE IF NOT EXISTS 'quantum_fts_data'(id INTEGER PRIMARY KEY, block BLOB);
CREATE TABLE IF NOT EXISTS 'quantum_fts_idx'(segid, term, pgno, PRIMARY KEY(segid, term)) WITHOUT ROWID;
CREATE TABLE IF NOT EXISTS 'quantum_fts_docsize'(id INTEGER PRIMARY KEY, sz BLOB);
CREATE TABLE IF NOT EXISTS 'quantum_fts_config'(k PRIMARY KEY, v) WITHOUT ROWID;
CREATE TABLE sqlite_stat1(tbl,idx,stat);
CREATE TABLE file_index (
    file_path TEXT PRIMARY KEY,
    last_referenced TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    reference_count INTEGER DEFAULT 1
);
CREATE TABLE todo_file_links (
    todo_id TEXT,
    file_path TEXT,
    FOREIGN KEY (todo_id) REFERENCES quantum_todos(id),
    FOREIGN KEY (file_path) REFERENCES file_index(file_path)
);
CREATE TABLE ml_processing_progress (
    content_type TEXT PRIMARY KEY,
    last_processed_id TEXT,
    last_processed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    items_processed INTEGER DEFAULT 0,
    tenant_id TEXT DEFAULT 'default'
);
CREATE TABLE audit_trail (
    audit_id TEXT PRIMARY KEY,
```

---

#### Database: `./.ml-training/daemon-commands.db`

**File Stats:**
-rw-r--r-- 1 groklygroup groklygroup 16K Oct 31 14:37 ./.ml-training/daemon-commands.db

**Size:** 16K

**Modified:** 2025-10-31 14:37:13.482480800 -0700

**Accessed:** 2025-10-31 14:37:42.690171600 -0700

**Tables:**
command_mappings

**Schema Sample (first 50 lines):**
```sql
CREATE TABLE command_mappings (
    id INTEGER PRIMARY KEY,
    input TEXT,
    command TEXT,
    success INTEGER,
    timestamp INTEGER
);
CREATE INDEX idx_input ON command_mappings(input);
CREATE INDEX idx_timestamp ON command_mappings(timestamp);
```

---

#### Database: `./.protection/protected-files.db`

**File Stats:**
-rwxrwxrwx 1 groklygroup groklygroup 24K Jul 12 22:11 ./.protection/protected-files.db

**Size:** 24K

**Modified:** 2025-07-12 22:11:48.721498900 -0700

**Accessed:** 2025-07-13 03:26:09.374920900 -0700

**Tables:**
protected_files

**Schema Sample (first 50 lines):**
```sql
CREATE TABLE protected_files (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    file_path TEXT UNIQUE NOT NULL,
    hash TEXT NOT NULL,
    protection_level TEXT DEFAULT 'standard',
    protected_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    reason TEXT
);
CREATE TABLE sqlite_sequence(name,seq);
CREATE INDEX idx_file_path ON protected_files(file_path);
CREATE INDEX idx_protection_level ON protected_files(protection_level);
```

---

#### Database: `./.quantum-todo/.e2e-test.db`

**File Stats:**
-rw-r--r-- 1 groklygroup groklygroup 8.0K Sep 16 16:59 ./.quantum-todo/.e2e-test.db

**Size:** 8.0K

**Modified:** 2025-09-16 16:59:18.121829100 -0700

**Accessed:** 2025-10-01 17:49:13.090160400 -0700

**Tables:**
test_results

**Schema Sample (first 50 lines):**
```sql
CREATE TABLE test_results (
    id INTEGER PRIMARY KEY,
    test_suite TEXT,
    test_name TEXT,
    status TEXT,
    duration REAL,
    error_message TEXT,
    timestamp TEXT DEFAULT CURRENT_TIMESTAMP
);
```

---

#### Database: `./.quantum-todo/.quantum-behavior.db`

**File Stats:**
-rw-r--r-- 1 groklygroup groklygroup 208K Sep 17 17:45 ./.quantum-todo/.quantum-behavior.db

**Size:** 208K

**Modified:** 2025-09-17 17:45:30.559621400 -0700

**Accessed:** 2025-10-01 17:49:08.386231400 -0700

**Tables:**
command_sequences    performance_metrics  user_patterns      
error_predictions    task_predictions   

**Schema Sample (first 50 lines):**
```sql
CREATE TABLE user_patterns (
    id INTEGER PRIMARY KEY,
    pattern_type TEXT,
    pattern_data TEXT,
    frequency INTEGER DEFAULT 1,
    last_seen TEXT DEFAULT CURRENT_TIMESTAMP,
    prediction_accuracy REAL DEFAULT 0.0
);
CREATE TABLE command_sequences (
    id INTEGER PRIMARY KEY,
    command TEXT,
    next_command TEXT,
    frequency INTEGER DEFAULT 1,
    confidence REAL DEFAULT 0.0
);
CREATE TABLE task_predictions (
    id INTEGER PRIMARY KEY,
    context TEXT,
    predicted_task TEXT,
    actual_task TEXT,
    accuracy REAL,
    created_at TEXT DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE performance_metrics (
    id INTEGER PRIMARY KEY,
    metric_type TEXT,
    metric_value REAL,
    timestamp TEXT DEFAULT CURRENT_TIMESTAMP,
    prediction TEXT
);
CREATE TABLE error_predictions (
    id INTEGER PRIMARY KEY,
    error_pattern TEXT,
    prediction_time TEXT,
    actual_time TEXT,
    prevented BOOLEAN DEFAULT 0
);
CREATE INDEX idx_patterns_type ON user_patterns(pattern_type);
CREATE INDEX idx_commands_seq ON command_sequences(command);
CREATE INDEX idx_metrics_type ON performance_metrics(metric_type);
```

---

#### Database: `./.quantum-todo/.quantum-immunity.db`

**File Stats:**
-rw-r--r-- 1 groklygroup groklygroup 44K Sep 16 16:34 ./.quantum-todo/.quantum-immunity.db

**Size:** 44K

**Modified:** 2025-09-16 16:34:29.244023100 -0700

**Accessed:** 2025-10-01 17:49:12.823404300 -0700

**Tables:**
antibodies                 threats                  
immune_responses           vulnerability_predictions
system_health            

**Schema Sample (first 50 lines):**
```sql
CREATE TABLE threats (
    id INTEGER PRIMARY KEY,
    threat_type TEXT,
    threat_signature TEXT UNIQUE,
    severity INTEGER,
    first_detected TEXT DEFAULT CURRENT_TIMESTAMP,
    last_seen TEXT,
    occurrence_count INTEGER DEFAULT 1,
    status TEXT DEFAULT 'active'
);
CREATE TABLE antibodies (
    id INTEGER PRIMARY KEY,
    antibody_id TEXT UNIQUE,
    threat_signature TEXT,
    prevention_code TEXT,
    cure_code TEXT,
    effectiveness REAL DEFAULT 1.0,
    deployment_count INTEGER DEFAULT 0,
    created_at TEXT DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE immune_responses (
    id INTEGER PRIMARY KEY,
    threat_id INTEGER,
    antibody_id TEXT,
    response_type TEXT,
    success BOOLEAN,
    response_time REAL,
    timestamp TEXT DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE system_health (
    id INTEGER PRIMARY KEY,
    component TEXT,
    health_score REAL,
    last_check TEXT DEFAULT CURRENT_TIMESTAMP,
    issues_detected INTEGER DEFAULT 0,
    auto_healed INTEGER DEFAULT 0
);
CREATE TABLE vulnerability_predictions (
    id INTEGER PRIMARY KEY,
    vulnerability_type TEXT,
    component TEXT,
    risk_score REAL,
    predicted_exploit_time TEXT,
    patch_available BOOLEAN DEFAULT 0,
    timestamp TEXT DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX idx_threat_sig ON threats(threat_signature);
CREATE INDEX idx_antibody_threat ON antibodies(threat_signature);
CREATE INDEX idx_health_component ON system_health(component);
```

---

#### Database: `./.quantum-todo/.quantum-predictions.db`

**File Stats:**
-rw-r--r-- 1 groklygroup groklygroup 56K Sep 16 16:28 ./.quantum-todo/.quantum-predictions.db

**Size:** 56K

**Modified:** 2025-09-16 16:28:42.834995100 -0700

**Accessed:** 2025-10-01 17:49:11.172435900 -0700

**Tables:**
cache_predictions     predictions           workflow_patterns   
error_patterns        resource_predictions
ml_models             user_intents        

**Schema Sample (first 50 lines):**
```sql
CREATE TABLE predictions (
    id INTEGER PRIMARY KEY,
    prediction_type TEXT,
    prediction_data JSON,
    confidence REAL,
    created_at TEXT DEFAULT CURRENT_TIMESTAMP,
    expires_at TEXT,
    actual_outcome TEXT,
    accuracy_score REAL
);
CREATE TABLE user_intents (
    id INTEGER PRIMARY KEY,
    session_id TEXT,
    detected_intent TEXT,
    confidence REAL,
    context JSON,
    predicted_next_action TEXT,
    actual_next_action TEXT,
    timestamp TEXT DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE workflow_patterns (
    id INTEGER PRIMARY KEY,
    pattern_hash TEXT UNIQUE,
    workflow_sequence JSON,
    frequency INTEGER DEFAULT 1,
    avg_duration REAL,
    success_rate REAL,
    optimized_sequence JSON
);
CREATE TABLE resource_predictions (
    id INTEGER PRIMARY KEY,
    resource_type TEXT,
    current_usage REAL,
    predicted_usage REAL,
    prediction_window TEXT,
    alert_threshold REAL,
    timestamp TEXT DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE error_patterns (
    id INTEGER PRIMARY KEY,
    error_signature TEXT,
    occurrence_pattern JSON,
    prediction_model JSON,
    prevention_strategy JSON,
    success_count INTEGER DEFAULT 0
);
CREATE TABLE cache_predictions (
    id INTEGER PRIMARY KEY,
    query_pattern TEXT,
    predicted_result JSON,
```

---

#### Database: `./.quantum-todo/.test-backup-20250917-224155/quantum-todo.db`

**File Stats:**
-rw-r--r-- 1 groklygroup groklygroup 184K Sep 17 22:41 ./.quantum-todo/.test-backup-20250917-224155/quantum-todo.db

**Size:** 184K

**Modified:** 2025-09-17 22:41:53.231787100 -0700

**Accessed:** 2025-10-01 17:49:11.839275100 -0700

**Tables:**
alert_history        performance_metrics  roles              
alert_rules          quantum_fts          tenant_config      
api_keys             quantum_fts_config   todo_dependencies  
audit_log            quantum_fts_data     user_roles         
cache_config         quantum_fts_docsize  webhook_events     
csrf_tokens          quantum_fts_idx      webhooks           
dependency_counts    quantum_todos        white_label_config 

**Schema Sample (first 50 lines):**
```sql
CREATE TABLE quantum_todos (
    id TEXT PRIMARY KEY,
    content TEXT NOT NULL,
    status TEXT NOT NULL DEFAULT 'pending',
    priority TEXT NOT NULL DEFAULT 'medium',
    priority_order INTEGER DEFAULT 999,
    source TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    completed_at TIMESTAMP,
    session_id TEXT,
    tags TEXT,
    quantum_state TEXT DEFAULT 'superposition',
    dependency_status TEXT DEFAULT 'ready',
    dependency_chain_length INTEGER DEFAULT 0,
    tenant_id TEXT DEFAULT 'default',
    content_hash TEXT,
    ml_priority_score REAL DEFAULT 0.5,
    predicted_duration INTEGER,
    actual_duration INTEGER
);
CREATE TABLE tenant_config (
    tenant_id TEXT PRIMARY KEY,
    max_todos INTEGER DEFAULT 10000,
    max_storage_mb INTEGER DEFAULT 100,
    features TEXT DEFAULT '{}',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE api_keys (
    key_hash TEXT PRIMARY KEY,
    tenant_id TEXT NOT NULL,
    user_id TEXT NOT NULL,
    permissions TEXT DEFAULT '{}',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_used TIMESTAMP,
    expires_at TIMESTAMP,
    FOREIGN KEY (tenant_id) REFERENCES tenant_config(tenant_id)
);
CREATE TABLE audit_log (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    tenant_id TEXT NOT NULL,
    user_id TEXT,
    action TEXT NOT NULL,
    resource_type TEXT,
    resource_id TEXT,
    details TEXT,
    ip_address TEXT,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE sqlite_sequence(name,seq);
```

---

#### Database: `./.quantum-todo/auto-backup-20250916-142107.db`

**File Stats:**
-rw-r--r-- 1 groklygroup groklygroup 44M Oct  9 23:59 ./.quantum-todo/auto-backup-20250916-142107.db

**Size:** 44M

**Modified:** 2025-10-09 23:59:02.772972000 -0700

**Accessed:** 2025-10-09 23:59:13.465771200 -0700

**Tables:**
quantum_fts          quantum_fts_docsize  todo_dependencies  
quantum_fts_config   quantum_fts_idx    
quantum_fts_data     quantum_todos      

**Schema Sample (first 50 lines):**
```sql
CREATE TABLE quantum_todos (
    id TEXT PRIMARY KEY,
    content TEXT NOT NULL,
    status TEXT NOT NULL DEFAULT 'pending',
    priority TEXT NOT NULL DEFAULT 'medium',
    source TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    completed_at TIMESTAMP,
    session_id TEXT,
    tags TEXT,
    quantum_state TEXT DEFAULT 'superposition',
    dependency_status TEXT DEFAULT 'ready',
    dependency_chain_length INTEGER DEFAULT 0
);
CREATE TABLE todo_dependencies (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    todo_id TEXT NOT NULL,
    depends_on_id TEXT NOT NULL,
    dependency_type TEXT DEFAULT 'blocks',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (todo_id) REFERENCES quantum_todos (id),
    FOREIGN KEY (depends_on_id) REFERENCES quantum_todos (id),
    UNIQUE(todo_id, depends_on_id)
);
CREATE TABLE sqlite_sequence(name,seq);
CREATE INDEX idx_status ON quantum_todos(status);
CREATE INDEX idx_priority ON quantum_todos(priority);
CREATE INDEX idx_dependency_status ON quantum_todos(dependency_status);
CREATE INDEX idx_dependency_todo ON todo_dependencies(todo_id);
CREATE INDEX idx_dependency_depends ON todo_dependencies(depends_on_id);
CREATE VIRTUAL TABLE quantum_fts USING fts5(content, content=quantum_todos)
/* quantum_fts(content) */;
CREATE TABLE IF NOT EXISTS 'quantum_fts_data'(id INTEGER PRIMARY KEY, block BLOB);
CREATE TABLE IF NOT EXISTS 'quantum_fts_idx'(segid, term, pgno, PRIMARY KEY(segid, term)) WITHOUT ROWID;
CREATE TABLE IF NOT EXISTS 'quantum_fts_docsize'(id INTEGER PRIMARY KEY, sz BLOB);
CREATE TABLE IF NOT EXISTS 'quantum_fts_config'(k PRIMARY KEY, v) WITHOUT ROWID;
```

---

#### Database: `./.quantum-todo/HOT_MIGRATION_SAFETY_20251010_031354_auto-backup.db`

**File Stats:**
-rw-r--r-- 1 groklygroup groklygroup 44M Oct 10 03:13 ./.quantum-todo/HOT_MIGRATION_SAFETY_20251010_031354_auto-backup.db

**Size:** 44M

**Modified:** 2025-10-10 03:13:56.826771500 -0700

**Accessed:** 2025-10-10 03:15:20.585002000 -0700

**Tables:**
quantum_fts          quantum_fts_docsize  todo_dependencies  
quantum_fts_config   quantum_fts_idx    
quantum_fts_data     quantum_todos      

**Schema Sample (first 50 lines):**
```sql
CREATE TABLE quantum_todos (
    id TEXT PRIMARY KEY,
    content TEXT NOT NULL,
    status TEXT NOT NULL DEFAULT 'pending',
    priority TEXT NOT NULL DEFAULT 'medium',
    source TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    completed_at TIMESTAMP,
    session_id TEXT,
    tags TEXT,
    quantum_state TEXT DEFAULT 'superposition',
    dependency_status TEXT DEFAULT 'ready',
    dependency_chain_length INTEGER DEFAULT 0
);
CREATE TABLE todo_dependencies (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    todo_id TEXT NOT NULL,
    depends_on_id TEXT NOT NULL,
    dependency_type TEXT DEFAULT 'blocks',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (todo_id) REFERENCES quantum_todos (id),
    FOREIGN KEY (depends_on_id) REFERENCES quantum_todos (id),
    UNIQUE(todo_id, depends_on_id)
);
CREATE TABLE sqlite_sequence(name,seq);
CREATE INDEX idx_status ON quantum_todos(status);
CREATE INDEX idx_priority ON quantum_todos(priority);
CREATE INDEX idx_dependency_status ON quantum_todos(dependency_status);
CREATE INDEX idx_dependency_todo ON todo_dependencies(todo_id);
CREATE INDEX idx_dependency_depends ON todo_dependencies(depends_on_id);
CREATE VIRTUAL TABLE quantum_fts USING fts5(content, content=quantum_todos)
/* quantum_fts(content) */;
CREATE TABLE IF NOT EXISTS 'quantum_fts_data'(id INTEGER PRIMARY KEY, block BLOB);
CREATE TABLE IF NOT EXISTS 'quantum_fts_idx'(segid, term, pgno, PRIMARY KEY(segid, term)) WITHOUT ROWID;
CREATE TABLE IF NOT EXISTS 'quantum_fts_docsize'(id INTEGER PRIMARY KEY, sz BLOB);
CREATE TABLE IF NOT EXISTS 'quantum_fts_config'(k PRIMARY KEY, v) WITHOUT ROWID;
```

---

#### Database: `./.quantum-todo/HOT_MIGRATION_SAFETY_20251010_031354_quantum-index.db`

**File Stats:**
-rw-r--r-- 1 groklygroup groklygroup 66M Oct 10 03:13 ./.quantum-todo/HOT_MIGRATION_SAFETY_20251010_031354_quantum-index.db

**Size:** 66M

**Modified:** 2025-10-10 03:13:57.698318100 -0700

**Accessed:** 2025-10-10 03:15:39.278549900 -0700

**Tables:**
anomaly_detections       ml_processing_progress   quantum_todos_optimized
api_keys                 ml_training_data         roles                  
audit_log                nlp_patterns             tenant_config          
audit_trail              performance_metrics      tenant_usage           
cache_config             quantum_execution_plan   theme_presets          
csrf_tokens              quantum_fts              todo_dependencies      
custom_domains           quantum_fts_config       todo_file_links        
dependency_counts        quantum_fts_data         ui_components          
email_templates          quantum_fts_docsize      user_behavior          
file_index               quantum_fts_idx          user_roles             
ml_models                quantum_todos            white_label_config     
ml_predictions           quantum_todos_archive  

**Schema Sample (first 50 lines):**
```sql
CREATE TABLE quantum_todos (
    id TEXT PRIMARY KEY,
    content TEXT NOT NULL,
    status TEXT NOT NULL DEFAULT 'pending',
    priority TEXT NOT NULL DEFAULT 'medium',
    source TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    completed_at TIMESTAMP,
    session_id TEXT,
    tags TEXT,
    quantum_state TEXT DEFAULT 'superposition',
    dependency_status TEXT DEFAULT 'ready',
    dependency_chain_length INTEGER DEFAULT 0
, craft_framework TEXT, project_tags TEXT, ml_priority_score REAL, content_hash TEXT, composite_content TEXT, tenant_id TEXT DEFAULT 'default', priority_order INTEGER DEFAULT 3);
CREATE TABLE todo_dependencies (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    todo_id TEXT NOT NULL,
    depends_on_id TEXT NOT NULL,
    dependency_type TEXT DEFAULT 'blocks',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (todo_id) REFERENCES quantum_todos (id),
    FOREIGN KEY (depends_on_id) REFERENCES quantum_todos (id),
    UNIQUE(todo_id, depends_on_id)
);
CREATE TABLE sqlite_sequence(name,seq);
CREATE TABLE IF NOT EXISTS 'quantum_fts_data'(id INTEGER PRIMARY KEY, block BLOB);
CREATE TABLE IF NOT EXISTS 'quantum_fts_idx'(segid, term, pgno, PRIMARY KEY(segid, term)) WITHOUT ROWID;
CREATE TABLE IF NOT EXISTS 'quantum_fts_docsize'(id INTEGER PRIMARY KEY, sz BLOB);
CREATE TABLE IF NOT EXISTS 'quantum_fts_config'(k PRIMARY KEY, v) WITHOUT ROWID;
CREATE TABLE sqlite_stat1(tbl,idx,stat);
CREATE TABLE file_index (
    file_path TEXT PRIMARY KEY,
    last_referenced TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    reference_count INTEGER DEFAULT 1
);
CREATE TABLE todo_file_links (
    todo_id TEXT,
    file_path TEXT,
    FOREIGN KEY (todo_id) REFERENCES quantum_todos(id),
    FOREIGN KEY (file_path) REFERENCES file_index(file_path)
);
CREATE TABLE ml_processing_progress (
    content_type TEXT PRIMARY KEY,
    last_processed_id TEXT,
    last_processed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    items_processed INTEGER DEFAULT 0,
    tenant_id TEXT DEFAULT 'default'
);
CREATE TABLE audit_trail (
    audit_id TEXT PRIMARY KEY,
```

---

#### Database: `./.quantum-todo/HOT_MIGRATION_SAFETY_20251010_031354_quantum-todo.db`

**File Stats:**
-rw-r--r-- 1 groklygroup groklygroup 22M Oct 10 03:13 ./.quantum-todo/HOT_MIGRATION_SAFETY_20251010_031354_quantum-todo.db

**Size:** 22M

**Modified:** 2025-10-10 03:13:55.595472800 -0700

**Accessed:** 2025-10-10 03:14:50.064598700 -0700

**Tables:**
alert_history        performance_metrics  roles              
alert_rules          quantum_fts          tenant_config      
api_keys             quantum_fts_config   todo_dependencies  
audit_log            quantum_fts_data     user_roles         
cache_config         quantum_fts_docsize  webhook_events     
csrf_tokens          quantum_fts_idx      webhooks           
dependency_counts    quantum_todos        white_label_config 

**Schema Sample (first 50 lines):**
```sql
CREATE TABLE tenant_config (
    tenant_id TEXT PRIMARY KEY,
    max_todos INTEGER DEFAULT 10000,
    max_storage_mb INTEGER DEFAULT 100,
    features TEXT DEFAULT '{}',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE api_keys (
    key_hash TEXT PRIMARY KEY,
    tenant_id TEXT NOT NULL,
    user_id TEXT NOT NULL,
    permissions TEXT DEFAULT '{}',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_used TIMESTAMP,
    expires_at TIMESTAMP,
    FOREIGN KEY (tenant_id) REFERENCES tenant_config(tenant_id)
);
CREATE TABLE audit_log (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    tenant_id TEXT NOT NULL,
    user_id TEXT,
    action TEXT NOT NULL,
    resource_type TEXT,
    resource_id TEXT,
    details TEXT,
    ip_address TEXT,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE sqlite_sequence(name,seq);
CREATE TABLE roles (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    role_name TEXT NOT NULL UNIQUE,
    permissions TEXT NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE user_roles (
    user_id TEXT NOT NULL,
    role_id INTEGER NOT NULL,
    tenant_id TEXT NOT NULL,
    assigned_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id, role_id, tenant_id),
    FOREIGN KEY (role_id) REFERENCES roles(id)
);
CREATE TABLE white_label_config (
    tenant_id TEXT PRIMARY KEY,
    brand_name TEXT NOT NULL DEFAULT 'Quantum TODO',
    brand_tagline TEXT DEFAULT 'Enterprise Task Management',
    primary_color TEXT DEFAULT '#3498db',
```

---

#### Database: `./.quantum-todo/HOT_MIGRATION_SAFETY_20251010_031354_quantum_todos.db`

**File Stats:**
-rw-r--r-- 1 groklygroup groklygroup 504K Oct 10 03:13 ./.quantum-todo/HOT_MIGRATION_SAFETY_20251010_031354_quantum_todos.db

**Size:** 504K

**Modified:** 2025-10-10 03:13:54.912237900 -0700

**Accessed:** 2025-10-10 03:14:01.262832600 -0700

**Tables:**
quantum_fts          quantum_fts_docsize  todo_dependencies  
quantum_fts_config   quantum_fts_idx    
quantum_fts_data     quantum_todos      

**Schema Sample (first 50 lines):**
```sql
CREATE TABLE quantum_todos (
    id TEXT PRIMARY KEY,
    content TEXT NOT NULL,
    status TEXT NOT NULL DEFAULT 'pending',
    priority TEXT NOT NULL DEFAULT 'medium',
    source TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    completed_at TIMESTAMP,
    session_id TEXT,
    tags TEXT,
    quantum_state TEXT DEFAULT 'superposition',
    dependency_status TEXT DEFAULT 'ready',
    dependency_chain_length INTEGER DEFAULT 0
);
CREATE TABLE todo_dependencies (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    todo_id TEXT NOT NULL,
    depends_on_id TEXT NOT NULL,
    dependency_type TEXT DEFAULT 'blocks',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (todo_id) REFERENCES quantum_todos (id),
    FOREIGN KEY (depends_on_id) REFERENCES quantum_todos (id),
    UNIQUE(todo_id, depends_on_id)
);
CREATE TABLE sqlite_sequence(name,seq);
CREATE INDEX idx_status ON quantum_todos(status);
CREATE INDEX idx_priority ON quantum_todos(priority);
CREATE INDEX idx_dependency_status ON quantum_todos(dependency_status);
CREATE INDEX idx_dependency_todo ON todo_dependencies(todo_id);
CREATE INDEX idx_dependency_depends ON todo_dependencies(depends_on_id);
CREATE VIRTUAL TABLE quantum_fts USING fts5(content, content=quantum_todos)
/* quantum_fts(content) */;
CREATE TABLE IF NOT EXISTS 'quantum_fts_data'(id INTEGER PRIMARY KEY, block BLOB);
CREATE TABLE IF NOT EXISTS 'quantum_fts_idx'(segid, term, pgno, PRIMARY KEY(segid, term)) WITHOUT ROWID;
CREATE TABLE IF NOT EXISTS 'quantum_fts_docsize'(id INTEGER PRIMARY KEY, sz BLOB);
CREATE TABLE IF NOT EXISTS 'quantum_fts_config'(k PRIMARY KEY, v) WITHOUT ROWID;
```

---

#### Database: `./.quantum-todo/quantum-index.db`

**File Stats:**
-rwxrwxrwx 1 groklygroup groklygroup 129M Dec  6 12:31 ./.quantum-todo/quantum-index.db

**Size:** 129M

**Modified:** 2025-12-06 12:31:43.811829900 -0800

**Accessed:** 2025-12-06 12:31:43.811829900 -0800

**Tables:**
anomaly_detections          quantum_execution_plan    
api_keys                    quantum_fts               
audit_log                   quantum_fts_config        
audit_trail                 quantum_fts_data          
cache_config                quantum_fts_docsize       
cross_reference_validation  quantum_fts_idx           
csrf_tokens                 quantum_todos             
custom_domains              quantum_todos_archive     
dependency_counts           quantum_todos_optimized   
email_templates             roles                     
file_index                  tenant_config             
hash_verification           tenant_usage              
ml_models                   theme_presets             
ml_predictions              todo_dependencies         
ml_processing_progress      todo_file_links           
ml_training_data            ui_components             
nlp_patterns                user_behavior             
performance_metrics         user_roles                
plans_consolidated          white_label_config        

**Schema Sample (first 50 lines):**
```sql
CREATE TABLE quantum_todos (
    id TEXT PRIMARY KEY,
    content TEXT NOT NULL,
    status TEXT NOT NULL DEFAULT 'pending',
    priority TEXT NOT NULL DEFAULT 'medium',
    source TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    completed_at TIMESTAMP,
    session_id TEXT,
    tags TEXT,
    quantum_state TEXT DEFAULT 'superposition',
    dependency_status TEXT DEFAULT 'ready',
    dependency_chain_length INTEGER DEFAULT 0
, craft_framework TEXT, project_tags TEXT, ml_priority_score REAL, content_hash TEXT, composite_content TEXT, tenant_id TEXT DEFAULT 'default', priority_order INTEGER DEFAULT 3, depends_on TEXT, blocks TEXT, estimated_hours REAL, actual_hours REAL, source_file_hash TEXT, source_line_number INTEGER, confidence_level TEXT, completion_evidence TEXT, auto_completed INTEGER, completion_reason TEXT, review_date INTEGER, predicted_duration INTEGER, actual_duration INTEGER);
CREATE TABLE todo_dependencies (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    todo_id TEXT NOT NULL,
    depends_on_id TEXT NOT NULL,
    dependency_type TEXT DEFAULT 'blocks',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (todo_id) REFERENCES quantum_todos (id),
    FOREIGN KEY (depends_on_id) REFERENCES quantum_todos (id),
    UNIQUE(todo_id, depends_on_id)
);
CREATE TABLE sqlite_sequence(name,seq);
CREATE TABLE IF NOT EXISTS 'quantum_fts_data'(id INTEGER PRIMARY KEY, block BLOB);
CREATE TABLE IF NOT EXISTS 'quantum_fts_idx'(segid, term, pgno, PRIMARY KEY(segid, term)) WITHOUT ROWID;
CREATE TABLE IF NOT EXISTS 'quantum_fts_docsize'(id INTEGER PRIMARY KEY, sz BLOB);
CREATE TABLE IF NOT EXISTS 'quantum_fts_config'(k PRIMARY KEY, v) WITHOUT ROWID;
CREATE TABLE sqlite_stat1(tbl,idx,stat);
CREATE TABLE file_index (
    file_path TEXT PRIMARY KEY,
    last_referenced TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    reference_count INTEGER DEFAULT 1
);
CREATE TABLE todo_file_links (
    todo_id TEXT,
    file_path TEXT,
    FOREIGN KEY (todo_id) REFERENCES quantum_todos(id),
    FOREIGN KEY (file_path) REFERENCES file_index(file_path)
);
CREATE TABLE ml_processing_progress (
    content_type TEXT PRIMARY KEY,
    last_processed_id TEXT,
    last_processed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    items_processed INTEGER DEFAULT 0,
    tenant_id TEXT DEFAULT 'default'
);
CREATE TABLE audit_trail (
    audit_id TEXT PRIMARY KEY,
```

---

#### Database: `./.quantum-todo/quantum-test.db`

**File Stats:**
-rwxrwxrwx 1 groklygroup groklygroup 0 Sep 17 22:42 ./.quantum-todo/quantum-test.db

**Size:** 0

**Modified:** 2025-09-17 22:42:40.368000000 -0700

**Accessed:** 2025-09-17 22:42:40.368000000 -0700

**Tables:**

**Schema Sample (first 50 lines):**
```sql
```

---

#### Database: `./.quantum-todo/quantum-todo.db`

**File Stats:**
-rw-r--r-- 1 groklygroup groklygroup 22M Nov 28 23:22 ./.quantum-todo/quantum-todo.db

**Size:** 22M

**Modified:** 2025-11-28 23:22:07.613042200 -0800

**Accessed:** 2025-11-28 23:22:07.613042200 -0800

**Tables:**
alert_history        performance_metrics  roles              
alert_rules          quantum_fts          tenant_config      
api_keys             quantum_fts_config   todo_dependencies  
audit_log            quantum_fts_data     user_roles         
cache_config         quantum_fts_docsize  webhook_events     
csrf_tokens          quantum_fts_idx      webhooks           
dependency_counts    quantum_todos        white_label_config 

**Schema Sample (first 50 lines):**
```sql
CREATE TABLE tenant_config (
    tenant_id TEXT PRIMARY KEY,
    max_todos INTEGER DEFAULT 10000,
    max_storage_mb INTEGER DEFAULT 100,
    features TEXT DEFAULT '{}',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE api_keys (
    key_hash TEXT PRIMARY KEY,
    tenant_id TEXT NOT NULL,
    user_id TEXT NOT NULL,
    permissions TEXT DEFAULT '{}',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_used TIMESTAMP,
    expires_at TIMESTAMP,
    FOREIGN KEY (tenant_id) REFERENCES tenant_config(tenant_id)
);
CREATE TABLE audit_log (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    tenant_id TEXT NOT NULL,
    user_id TEXT,
    action TEXT NOT NULL,
    resource_type TEXT,
    resource_id TEXT,
    details TEXT,
    ip_address TEXT,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE sqlite_sequence(name,seq);
CREATE TABLE roles (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    role_name TEXT NOT NULL UNIQUE,
    permissions TEXT NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE user_roles (
    user_id TEXT NOT NULL,
    role_id INTEGER NOT NULL,
    tenant_id TEXT NOT NULL,
    assigned_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id, role_id, tenant_id),
    FOREIGN KEY (role_id) REFERENCES roles(id)
);
CREATE TABLE white_label_config (
    tenant_id TEXT PRIMARY KEY,
    brand_name TEXT NOT NULL DEFAULT 'Quantum TODO',
    brand_tagline TEXT DEFAULT 'Enterprise Task Management',
    primary_color TEXT DEFAULT '#3498db',
```

---

#### Database: `./.quantum-todo/quantum-todos.db`

**File Stats:**
-rw-r--r-- 1 groklygroup groklygroup 0 Aug 16 21:25 ./.quantum-todo/quantum-todos.db

**Size:** 0

**Modified:** 2025-08-16 21:25:25.557705400 -0700

**Accessed:** 2025-08-16 21:25:25.557705400 -0700

**Tables:**

**Schema Sample (first 50 lines):**
```sql
```

---

#### Database: `./.quantum-todo/quantum_todos.db`

**File Stats:**
-rw-r--r-- 1 groklygroup groklygroup 504K Oct  9 15:01 ./.quantum-todo/quantum_todos.db

**Size:** 504K

**Modified:** 2025-10-09 15:01:33.970562700 -0700

**Accessed:** 2025-10-09 15:01:50.659512100 -0700

**Tables:**
quantum_fts          quantum_fts_docsize  todo_dependencies  
quantum_fts_config   quantum_fts_idx    
quantum_fts_data     quantum_todos      

**Schema Sample (first 50 lines):**
```sql
CREATE TABLE quantum_todos (
    id TEXT PRIMARY KEY,
    content TEXT NOT NULL,
    status TEXT NOT NULL DEFAULT 'pending',
    priority TEXT NOT NULL DEFAULT 'medium',
    source TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    completed_at TIMESTAMP,
    session_id TEXT,
    tags TEXT,
    quantum_state TEXT DEFAULT 'superposition',
    dependency_status TEXT DEFAULT 'ready',
    dependency_chain_length INTEGER DEFAULT 0
);
CREATE TABLE todo_dependencies (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    todo_id TEXT NOT NULL,
    depends_on_id TEXT NOT NULL,
    dependency_type TEXT DEFAULT 'blocks',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (todo_id) REFERENCES quantum_todos (id),
    FOREIGN KEY (depends_on_id) REFERENCES quantum_todos (id),
    UNIQUE(todo_id, depends_on_id)
);
CREATE TABLE sqlite_sequence(name,seq);
CREATE INDEX idx_status ON quantum_todos(status);
CREATE INDEX idx_priority ON quantum_todos(priority);
CREATE INDEX idx_dependency_status ON quantum_todos(dependency_status);
CREATE INDEX idx_dependency_todo ON todo_dependencies(todo_id);
CREATE INDEX idx_dependency_depends ON todo_dependencies(depends_on_id);
CREATE VIRTUAL TABLE quantum_fts USING fts5(content, content=quantum_todos)
/* quantum_fts(content) */;
CREATE TABLE IF NOT EXISTS 'quantum_fts_data'(id INTEGER PRIMARY KEY, block BLOB);
CREATE TABLE IF NOT EXISTS 'quantum_fts_idx'(segid, term, pgno, PRIMARY KEY(segid, term)) WITHOUT ROWID;
CREATE TABLE IF NOT EXISTS 'quantum_fts_docsize'(id INTEGER PRIMARY KEY, sz BLOB);
CREATE TABLE IF NOT EXISTS 'quantum_fts_config'(k PRIMARY KEY, v) WITHOUT ROWID;
```

---

#### Database: `./.quantum-todo/SAFETY_BACKUP_20251009_235633.db`

**File Stats:**
-rw-r--r-- 1 groklygroup groklygroup 66M Oct  9 23:56 ./.quantum-todo/SAFETY_BACKUP_20251009_235633.db

**Size:** 66M

**Modified:** 2025-10-09 23:56:37.300100300 -0700

**Accessed:** 2025-10-09 23:57:37.918224700 -0700

**Tables:**
anomaly_detections       ml_processing_progress   quantum_todos_optimized
api_keys                 ml_training_data         roles                  
audit_log                nlp_patterns             tenant_config          
audit_trail              performance_metrics      tenant_usage           
cache_config             quantum_execution_plan   theme_presets          
csrf_tokens              quantum_fts              todo_dependencies      
custom_domains           quantum_fts_config       todo_file_links        
dependency_counts        quantum_fts_data         ui_components          
email_templates          quantum_fts_docsize      user_behavior          
file_index               quantum_fts_idx          user_roles             
ml_models                quantum_todos            white_label_config     
ml_predictions           quantum_todos_archive  

**Schema Sample (first 50 lines):**
```sql
CREATE TABLE quantum_todos (
    id TEXT PRIMARY KEY,
    content TEXT NOT NULL,
    status TEXT NOT NULL DEFAULT 'pending',
    priority TEXT NOT NULL DEFAULT 'medium',
    source TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    completed_at TIMESTAMP,
    session_id TEXT,
    tags TEXT,
    quantum_state TEXT DEFAULT 'superposition',
    dependency_status TEXT DEFAULT 'ready',
    dependency_chain_length INTEGER DEFAULT 0
, craft_framework TEXT, project_tags TEXT, ml_priority_score REAL, content_hash TEXT, composite_content TEXT, tenant_id TEXT DEFAULT 'default', priority_order INTEGER DEFAULT 3);
CREATE TABLE todo_dependencies (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    todo_id TEXT NOT NULL,
    depends_on_id TEXT NOT NULL,
    dependency_type TEXT DEFAULT 'blocks',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (todo_id) REFERENCES quantum_todos (id),
    FOREIGN KEY (depends_on_id) REFERENCES quantum_todos (id),
    UNIQUE(todo_id, depends_on_id)
);
CREATE TABLE sqlite_sequence(name,seq);
CREATE TABLE IF NOT EXISTS 'quantum_fts_data'(id INTEGER PRIMARY KEY, block BLOB);
CREATE TABLE IF NOT EXISTS 'quantum_fts_idx'(segid, term, pgno, PRIMARY KEY(segid, term)) WITHOUT ROWID;
CREATE TABLE IF NOT EXISTS 'quantum_fts_docsize'(id INTEGER PRIMARY KEY, sz BLOB);
CREATE TABLE IF NOT EXISTS 'quantum_fts_config'(k PRIMARY KEY, v) WITHOUT ROWID;
CREATE TABLE sqlite_stat1(tbl,idx,stat);
CREATE TABLE file_index (
    file_path TEXT PRIMARY KEY,
    last_referenced TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    reference_count INTEGER DEFAULT 1
);
CREATE TABLE todo_file_links (
    todo_id TEXT,
    file_path TEXT,
    FOREIGN KEY (todo_id) REFERENCES quantum_todos(id),
    FOREIGN KEY (file_path) REFERENCES file_index(file_path)
);
CREATE TABLE ml_processing_progress (
    content_type TEXT PRIMARY KEY,
    last_processed_id TEXT,
    last_processed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    items_processed INTEGER DEFAULT 0,
    tenant_id TEXT DEFAULT 'default'
);
CREATE TABLE audit_trail (
    audit_id TEXT PRIMARY KEY,
```

---

#### Database: `./.repair-snapshots/20251120_204830/windows_mirror_backup/.chat-registry/chat-registry.db`

**File Stats:**
-rwxrwxrwx 1 groklygroup groklygroup 28K Aug  9 22:22 ./.repair-snapshots/20251120_204830/windows_mirror_backup/.chat-registry/chat-registry.db

**Size:** 28K

**Modified:** 2025-08-09 22:22:17.000000000 -0700

**Accessed:** 2025-11-22 23:46:01.247977800 -0800

**Tables:**
chat_files

**Schema Sample (first 50 lines):**
```sql
CREATE TABLE chat_files (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    file_path TEXT UNIQUE NOT NULL,
    file_name TEXT NOT NULL,
    file_type TEXT,
    file_size INTEGER,
    file_modified TIMESTAMP,
    file_hash TEXT,
    content_preview TEXT,
    todo_count INTEGER DEFAULT 0,
    imported BOOLEAN DEFAULT 0,
    import_date TIMESTAMP,
    discovered_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE sqlite_sequence(name,seq);
CREATE INDEX idx_file_hash ON chat_files(file_hash);
CREATE INDEX idx_file_type ON chat_files(file_type);
CREATE INDEX idx_imported ON chat_files(imported);
```

---

#### Database: `./.repair-snapshots/20251120_204830/windows_mirror_backup/.cleanup-analysis/file_analysis.db`

**File Stats:**
-rwxrwxrwx 1 groklygroup groklygroup 44K Jul 15 13:52 ./.repair-snapshots/20251120_204830/windows_mirror_backup/.cleanup-analysis/file_analysis.db

**Size:** 44K

**Modified:** 2025-07-15 13:52:14.000000000 -0700

**Accessed:** 2025-11-23 00:06:57.151125800 -0800

**Tables:**
cleanup_categories  duplicate_groups    file_inventory    

**Schema Sample (first 50 lines):**
```sql
CREATE TABLE file_inventory (
    file_path TEXT PRIMARY KEY,
    content_hash TEXT,
    file_size INTEGER,
    modified_time INTEGER,
    mime_type TEXT,
    category TEXT,
    is_duplicate BOOLEAN DEFAULT 0,
    duplicate_group_id INTEGER,
    keep_file BOOLEAN DEFAULT 1,
    safety_score INTEGER DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE duplicate_groups (
    group_id INTEGER PRIMARY KEY AUTOINCREMENT,
    content_hash TEXT UNIQUE,
    file_count INTEGER,
    total_size INTEGER,
    category TEXT,
    keep_file TEXT,
    remove_files TEXT,
    space_saved INTEGER
);
CREATE TABLE sqlite_sequence(name,seq);
CREATE TABLE cleanup_categories (
    category TEXT PRIMARY KEY,
    description TEXT,
    safety_level INTEGER, -- 1=safe, 2=caution, 3=dangerous
    auto_clean BOOLEAN DEFAULT 0,
    file_count INTEGER DEFAULT 0,
    total_size INTEGER DEFAULT 0
);
CREATE INDEX idx_content_hash ON file_inventory(content_hash);
CREATE INDEX idx_category ON file_inventory(category);
CREATE INDEX idx_duplicate ON file_inventory(is_duplicate);
```

---

#### Database: `./.repair-snapshots/20251120_204830/windows_mirror_backup/.cleanup-state/rollback-20251117_191418/quantum-todo-backup.db`

**File Stats:**
-rwxrwxrwx 1 groklygroup groklygroup 22M Nov 17 19:14 ./.repair-snapshots/20251120_204830/windows_mirror_backup/.cleanup-state/rollback-20251117_191418/quantum-todo-backup.db

**Size:** 22M

**Modified:** 2025-11-17 19:14:25.000000000 -0800

**Accessed:** 2025-11-23 00:07:42.202806400 -0800

**Tables:**
alert_history        performance_metrics  roles              
alert_rules          quantum_fts          tenant_config      
api_keys             quantum_fts_config   todo_dependencies  
audit_log            quantum_fts_data     user_roles         
cache_config         quantum_fts_docsize  webhook_events     
csrf_tokens          quantum_fts_idx      webhooks           
dependency_counts    quantum_todos        white_label_config 

**Schema Sample (first 50 lines):**
```sql
CREATE TABLE tenant_config (
    tenant_id TEXT PRIMARY KEY,
    max_todos INTEGER DEFAULT 10000,
    max_storage_mb INTEGER DEFAULT 100,
    features TEXT DEFAULT '{}',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE api_keys (
    key_hash TEXT PRIMARY KEY,
    tenant_id TEXT NOT NULL,
    user_id TEXT NOT NULL,
    permissions TEXT DEFAULT '{}',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_used TIMESTAMP,
    expires_at TIMESTAMP,
    FOREIGN KEY (tenant_id) REFERENCES tenant_config(tenant_id)
);
CREATE TABLE audit_log (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    tenant_id TEXT NOT NULL,
    user_id TEXT,
    action TEXT NOT NULL,
    resource_type TEXT,
    resource_id TEXT,
    details TEXT,
    ip_address TEXT,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE sqlite_sequence(name,seq);
CREATE TABLE roles (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    role_name TEXT NOT NULL UNIQUE,
    permissions TEXT NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE user_roles (
    user_id TEXT NOT NULL,
    role_id INTEGER NOT NULL,
    tenant_id TEXT NOT NULL,
    assigned_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id, role_id, tenant_id),
    FOREIGN KEY (role_id) REFERENCES roles(id)
);
CREATE TABLE white_label_config (
    tenant_id TEXT PRIMARY KEY,
    brand_name TEXT NOT NULL DEFAULT 'Quantum TODO',
    brand_tagline TEXT DEFAULT 'Enterprise Task Management',
    primary_color TEXT DEFAULT '#3498db',
```

---

#### Database: `./.repair-snapshots/20251120_204830/windows_mirror_backup/.enforcement/core/time-waste.db`

**File Stats:**
-rwxrwxrwx 1 groklygroup groklygroup 0 Sep 24 21:32 ./.repair-snapshots/20251120_204830/windows_mirror_backup/.enforcement/core/time-waste.db

**Size:** 0

**Modified:** 2025-09-24 21:32:02.000000000 -0700

**Accessed:** 2025-11-20 22:16:08.627485000 -0800

**Tables:**

**Schema Sample (first 50 lines):**
```sql
```

---

#### Database: `./.repair-snapshots/20251120_204830/windows_mirror_backup/.enforcement/core/violation-tracking.db`

**File Stats:**
-rwxrwxrwx 1 groklygroup groklygroup 81 Sep 24 22:01 ./.repair-snapshots/20251120_204830/windows_mirror_backup/.enforcement/core/violation-tracking.db

**Size:** 0

**Modified:** 2025-09-24 22:01:06.000000000 -0700

**Accessed:** 2025-11-23 00:07:54.411296500 -0800

**Tables:**
Cannot read tables

**Schema Sample (first 50 lines):**
```sql
```

---

#### Database: `./.repair-snapshots/20251120_204830/windows_mirror_backup/.extraction-progress.db`

**File Stats:**
-rwxrwxrwx 1 groklygroup groklygroup 20K Aug 10 04:45 ./.repair-snapshots/20251120_204830/windows_mirror_backup/.extraction-progress.db

**Size:** 20K

**Modified:** 2025-08-10 04:45:28.000000000 -0700

**Accessed:** 2025-11-23 00:09:01.383591100 -0800

**Tables:**
extracted_files   extraction_state

**Schema Sample (first 50 lines):**
```sql
CREATE TABLE extracted_files (
    file_path TEXT PRIMARY KEY,
    file_hash TEXT,
    extraction_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    todos_found INTEGER DEFAULT 0,
    completed_count INTEGER DEFAULT 0,
    pending_count INTEGER DEFAULT 0,
    uncertain_count INTEGER DEFAULT 0
);
CREATE TABLE extraction_state (
    key TEXT PRIMARY KEY,
    value TEXT
);
```

---

#### Database: `./.repair-snapshots/20251120_204830/windows_mirror_backup/.index-system/content-analysis.db`

**File Stats:**
-rwxrwxrwx 1 groklygroup groklygroup 652K Nov 19 21:39 ./.repair-snapshots/20251120_204830/windows_mirror_backup/.index-system/content-analysis.db

**Size:** 652K

**Modified:** 2025-11-19 21:39:08.000000000 -0800

**Accessed:** 2025-11-23 00:10:39.980485500 -0800

**Tables:**
content_analysis

**Schema Sample (first 50 lines):**
```sql
CREATE TABLE content_analysis (
    doc_id TEXT PRIMARY KEY,
    file_path TEXT NOT NULL,
    content_type TEXT,
    keywords TEXT,
    tags TEXT,
    summary TEXT,
    language TEXT,
    analyzed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX idx_content_path ON content_analysis(file_path);
CREATE INDEX idx_content_type ON content_analysis(content_type);
```

---

#### Database: `./.repair-snapshots/20251120_204830/windows_mirror_backup/.index-system/database/file-index.db`

**File Stats:**
-rwxrwxrwx 1 groklygroup groklygroup 0 Aug 16 04:11 ./.repair-snapshots/20251120_204830/windows_mirror_backup/.index-system/database/file-index.db

**Size:** 0

**Modified:** 2025-08-16 04:11:35.000000000 -0700

**Accessed:** 2025-11-20 22:16:50.833535200 -0800

**Tables:**

**Schema Sample (first 50 lines):**
```sql
```

---

#### Database: `./.repair-snapshots/20251120_204830/windows_mirror_backup/.index-system/database/quantum-index.db`

**File Stats:**
-rwxrwxrwx 1 groklygroup groklygroup 36M Sep 12 16:16 ./.repair-snapshots/20251120_204830/windows_mirror_backup/.index-system/database/quantum-index.db

**Size:** 36M

**Modified:** 2025-09-12 16:16:55.000000000 -0700

**Accessed:** 2025-11-23 00:14:40.230015800 -0800

**Tables:**
file_registry            quantum_fts_docsize      todo_dependency_view   
quantum_fts              quantum_fts_idx          todos_archived_20250726
quantum_fts_config       quantum_todos            todos_by_category      
quantum_fts_content      quantum_todos_trash      todos_by_priority      
quantum_fts_data         todo_dependencies        todos_critical_path    

**Schema Sample (first 50 lines):**
```sql
CREATE TABLE quantum_todos (
    id TEXT PRIMARY KEY,
    content TEXT NOT NULL,
    status TEXT NOT NULL,
    priority TEXT NOT NULL,
    source TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    completed_at TIMESTAMP,
    session_id TEXT,
    tags TEXT,
    quantum_state TEXT DEFAULT 'superposition'
, depends_on TEXT, blocks TEXT, dependency_status TEXT DEFAULT 'ready', estimated_hours REAL, actual_hours REAL, dependency_chain_length INTEGER DEFAULT 0, content_hash TEXT, source_file_hash TEXT, source_line_number INTEGER, confidence_level TEXT DEFAULT 'medium', completion_evidence TEXT, auto_completed BOOLEAN DEFAULT 0, completion_reason TEXT, review_date TIMESTAMP);
CREATE TABLE IF NOT EXISTS 'quantum_fts_data'(id INTEGER PRIMARY KEY, block BLOB);
CREATE TABLE IF NOT EXISTS 'quantum_fts_idx'(segid, term, pgno, PRIMARY KEY(segid, term)) WITHOUT ROWID;
CREATE TABLE IF NOT EXISTS 'quantum_fts_content'(id INTEGER PRIMARY KEY, c0, c1);
CREATE TABLE IF NOT EXISTS 'quantum_fts_docsize'(id INTEGER PRIMARY KEY, sz BLOB);
CREATE TABLE IF NOT EXISTS 'quantum_fts_config'(k PRIMARY KEY, v) WITHOUT ROWID;
CREATE TABLE IF NOT EXISTS "todos_archived_20250726" (
    id TEXT PRIMARY KEY,
    content TEXT NOT NULL,
    status TEXT DEFAULT 'pending',
    priority TEXT DEFAULT 'medium',
    source TEXT DEFAULT 'import',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    completed_at DATETIME,
    session_id TEXT,
    tags TEXT,
    quantum_state TEXT DEFAULT 'superposition',
    hash TEXT UNIQUE
);
CREATE TABLE todo_dependencies (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    todo_id TEXT NOT NULL,
    depends_on_id TEXT NOT NULL,
    dependency_type TEXT DEFAULT 'blocks', -- blocks, requires, related
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (todo_id) REFERENCES quantum_todos(id),
    FOREIGN KEY (depends_on_id) REFERENCES quantum_todos(id),
    UNIQUE(todo_id, depends_on_id)
);
CREATE TABLE sqlite_sequence(name,seq);
CREATE TABLE file_registry (file_hash TEXT PRIMARY KEY, current_path TEXT NOT NULL, filename TEXT NOT NULL, last_seen TIMESTAMP DEFAULT CURRENT_TIMESTAMP, file_size INTEGER, file_modified TIMESTAMP, project TEXT, file_type TEXT);
CREATE INDEX idx_status ON quantum_todos(status);
CREATE INDEX idx_priority ON quantum_todos(priority);
CREATE INDEX idx_session ON quantum_todos(session_id);
CREATE INDEX idx_todos_status ON "todos_archived_20250726"(status);
CREATE INDEX idx_todos_priority ON "todos_archived_20250726"(priority);
CREATE INDEX idx_todos_created ON "todos_archived_20250726"(created_at);
CREATE INDEX idx_todos_hash ON "todos_archived_20250726"(hash);
CREATE INDEX idx_hash ON "todos_archived_20250726"(hash);
```

---

#### Database: `./.repair-snapshots/20251120_204830/windows_mirror_backup/.index-system/file-index.db`

**File Stats:**
-rwxrwxrwx 1 groklygroup groklygroup 0 Aug 29 07:55 ./.repair-snapshots/20251120_204830/windows_mirror_backup/.index-system/file-index.db

**Size:** 0

**Modified:** 2025-08-29 07:55:51.000000000 -0700

**Accessed:** 2025-11-20 22:16:54.804592300 -0800

**Tables:**

**Schema Sample (first 50 lines):**
```sql
```

---

#### Database: `./.repair-snapshots/20251120_204830/windows_mirror_backup/.index-system/nl-index.db`

**File Stats:**
-rwxrwxrwx 1 groklygroup groklygroup 56K Oct 11 21:02 ./.repair-snapshots/20251120_204830/windows_mirror_backup/.index-system/nl-index.db

**Size:** 56K

**Modified:** 2025-10-11 21:02:17.000000000 -0700

**Accessed:** 2025-11-23 00:15:36.203244100 -0800

**Tables:**
file_content_fts          file_content_fts_docsize  indexing_stats          
file_content_fts_config   file_content_fts_idx      write_queue_stats       
file_content_fts_data     file_index              

**Schema Sample (first 50 lines):**
```sql
CREATE TABLE file_index (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    file_path TEXT UNIQUE NOT NULL,
    file_name TEXT,
    file_size INTEGER,
    file_type TEXT,
    mime_type TEXT,
    encoding TEXT,
    content TEXT,
    content_hash TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    modified_at TIMESTAMP,
    indexed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    metadata TEXT,
    error_msg TEXT,
    retry_count INTEGER DEFAULT 0
);
CREATE TABLE sqlite_sequence(name,seq);
CREATE INDEX idx_file_path ON file_index(file_path);
CREATE INDEX idx_file_name ON file_index(file_name);
CREATE INDEX idx_content_hash ON file_index(content_hash);
CREATE INDEX idx_indexed_at ON file_index(indexed_at);
CREATE TABLE indexing_stats (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    files_processed INTEGER DEFAULT 0,
    bytes_processed INTEGER DEFAULT 0,
    errors INTEGER DEFAULT 0,
    avg_processing_time_ms INTEGER DEFAULT 0
);
CREATE TABLE write_queue_stats (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    queue_size INTEGER DEFAULT 0,
    batch_size INTEGER DEFAULT 0,
    write_time_ms INTEGER DEFAULT 0
);
CREATE VIRTUAL TABLE file_content_fts USING fts5(
    file_path,
    content,
    content=file_index,
    content_rowid=id
)
/* file_content_fts(file_path,content) */;
CREATE TABLE IF NOT EXISTS 'file_content_fts_data'(id INTEGER PRIMARY KEY, block BLOB);
CREATE TABLE IF NOT EXISTS 'file_content_fts_idx'(segid, term, pgno, PRIMARY KEY(segid, term)) WITHOUT ROWID;
CREATE TABLE IF NOT EXISTS 'file_content_fts_docsize'(id INTEGER PRIMARY KEY, sz BLOB);
CREATE TABLE IF NOT EXISTS 'file_content_fts_config'(k PRIMARY KEY, v) WITHOUT ROWID;
CREATE TRIGGER file_index_ai AFTER INSERT ON file_index BEGIN
    INSERT INTO file_content_fts(rowid, file_path, content)
```

---

#### Database: `./.repair-snapshots/20251120_204830/windows_mirror_backup/.index-system/quantum-index.db`

**File Stats:**
-rwxrwxrwx 1 groklygroup groklygroup 16K Sep 13 17:23 ./.repair-snapshots/20251120_204830/windows_mirror_backup/.index-system/quantum-index.db

**Size:** 16K

**Modified:** 2025-09-13 17:23:05.000000000 -0700

**Accessed:** 2025-11-23 00:16:09.221674800 -0800

**Tables:**
process_patterns

**Schema Sample (first 50 lines):**
```sql
CREATE TABLE process_patterns (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    pattern TEXT UNIQUE,
    avg_runtime INTEGER DEFAULT 0,
    timeout INTEGER DEFAULT 300,
    optimization TEXT,
    kill_count INTEGER DEFAULT 0,
    last_seen TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE sqlite_sequence(name,seq);
```

---

#### Database: `./.repair-snapshots/20251120_204830/windows_mirror_backup/.index-system/test-file-index.db`

**File Stats:**
-rwxrwxrwx 1 groklygroup groklygroup 80K Aug 11 21:18 ./.repair-snapshots/20251120_204830/windows_mirror_backup/.index-system/test-file-index.db

**Size:** 80K

**Modified:** 2025-08-11 21:18:52.000000000 -0700

**Accessed:** 2025-11-23 00:16:25.600360700 -0800

**Tables:**
file_index              file_index_fts_config   file_index_fts_idx    
file_index_basic        file_index_fts_data     simple_test           
file_index_fts          file_index_fts_docsize

**Schema Sample (first 50 lines):**
```sql
CREATE TABLE simple_test (id INTEGER PRIMARY KEY);
CREATE TABLE file_index_basic (
    id TEXT PRIMARY KEY,
    file_path TEXT NOT NULL,
    filename TEXT,
    extension TEXT,
    file_size INTEGER
);
CREATE VIRTUAL TABLE file_index_fts USING fts5(
    file_path,
    filename,
    content_preview,
    content_full,
    tags,
    keywords,
    content=file_index
)
/* file_index_fts(file_path,filename,content_preview,content_full,tags,keywords) */;
CREATE TABLE IF NOT EXISTS 'file_index_fts_data'(id INTEGER PRIMARY KEY, block BLOB);
CREATE TABLE IF NOT EXISTS 'file_index_fts_idx'(segid, term, pgno, PRIMARY KEY(segid, term)) WITHOUT ROWID;
CREATE TABLE IF NOT EXISTS 'file_index_fts_docsize'(id INTEGER PRIMARY KEY, sz BLOB);
CREATE TABLE IF NOT EXISTS 'file_index_fts_config'(k PRIMARY KEY, v) WITHOUT ROWID;
CREATE TABLE file_index (
    id TEXT PRIMARY KEY,
    file_path TEXT NOT NULL,
    filename TEXT,
    extension TEXT,
    file_size INTEGER,
    modified_at TIMESTAMP,
    indexed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    mime_type TEXT,
    encoding TEXT,
    is_binary BOOLEAN DEFAULT FALSE,
    content_preview TEXT,
    content_full TEXT,
    content_hash TEXT,
    sha256_hash TEXT,
    line_count INTEGER,
    word_count INTEGER,
    char_count INTEGER
);
```

---

#### Database: `./.repair-snapshots/20251120_204830/windows_mirror_backup/.index-system/universal-index.db`

**File Stats:**
-rwxrwxrwx 1 groklygroup groklygroup 16K Oct 12 16:27 ./.repair-snapshots/20251120_204830/windows_mirror_backup/.index-system/universal-index.db

**Size:** 16K

**Modified:** 2025-10-12 16:27:21.000000000 -0700

**Accessed:** 2025-11-23 00:17:16.352711700 -0800

**Tables:**
universal_index

**Schema Sample (first 50 lines):**
```sql
CREATE TABLE universal_index (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    file_path TEXT UNIQUE NOT NULL,
    file_name TEXT NOT NULL,
    file_type TEXT NOT NULL,
    content_hash TEXT NOT NULL,
    file_size INTEGER NOT NULL,
    line_count INTEGER NOT NULL,
    created_at TEXT NOT NULL,
    indexed_at TEXT NOT NULL,
    category TEXT NOT NULL,
    description TEXT,
    tags TEXT,
    enterprise_features TEXT,
    compliance_status TEXT
);
CREATE TABLE sqlite_sequence(name,seq);
```

---

#### Database: `./.repair-snapshots/20251120_204830/windows_mirror_backup/.logs/hash-fortress/security/database-snapshot-hash-fortress-20251012-170553.db`

**File Stats:**
-rwxrwxrwx 1 groklygroup groklygroup 122M Oct 12 17:05 ./.repair-snapshots/20251120_204830/windows_mirror_backup/.logs/hash-fortress/security/database-snapshot-hash-fortress-20251012-170553.db

**Size:** 122M

**Modified:** 2025-10-12 17:05:59.000000000 -0700

**Accessed:** 2025-11-23 00:31:02.693450400 -0800

**Tables:**
anomaly_detections       ml_processing_progress   quantum_todos_optimized
api_keys                 ml_training_data         roles                  
audit_log                nlp_patterns             tenant_config          
audit_trail              performance_metrics      tenant_usage           
cache_config             quantum_execution_plan   theme_presets          
csrf_tokens              quantum_fts              todo_dependencies      
custom_domains           quantum_fts_config       todo_file_links        
dependency_counts        quantum_fts_data         ui_components          
email_templates          quantum_fts_docsize      user_behavior          
file_index               quantum_fts_idx          user_roles             
ml_models                quantum_todos            white_label_config     
ml_predictions           quantum_todos_archive  

**Schema Sample (first 50 lines):**
```sql
CREATE TABLE quantum_todos (
    id TEXT PRIMARY KEY,
    content TEXT NOT NULL,
    status TEXT NOT NULL DEFAULT 'pending',
    priority TEXT NOT NULL DEFAULT 'medium',
    source TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    completed_at TIMESTAMP,
    session_id TEXT,
    tags TEXT,
    quantum_state TEXT DEFAULT 'superposition',
    dependency_status TEXT DEFAULT 'ready',
    dependency_chain_length INTEGER DEFAULT 0
, craft_framework TEXT, project_tags TEXT, ml_priority_score REAL, content_hash TEXT, composite_content TEXT, tenant_id TEXT DEFAULT 'default', priority_order INTEGER DEFAULT 3, depends_on TEXT, blocks TEXT, estimated_hours REAL, actual_hours REAL, source_file_hash TEXT, source_line_number INTEGER, confidence_level TEXT, completion_evidence TEXT, auto_completed INTEGER, completion_reason TEXT, review_date INTEGER, predicted_duration INTEGER, actual_duration INTEGER);
CREATE TABLE todo_dependencies (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    todo_id TEXT NOT NULL,
    depends_on_id TEXT NOT NULL,
    dependency_type TEXT DEFAULT 'blocks',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (todo_id) REFERENCES quantum_todos (id),
    FOREIGN KEY (depends_on_id) REFERENCES quantum_todos (id),
    UNIQUE(todo_id, depends_on_id)
);
CREATE TABLE sqlite_sequence(name,seq);
CREATE TABLE IF NOT EXISTS 'quantum_fts_data'(id INTEGER PRIMARY KEY, block BLOB);
CREATE TABLE IF NOT EXISTS 'quantum_fts_idx'(segid, term, pgno, PRIMARY KEY(segid, term)) WITHOUT ROWID;
CREATE TABLE IF NOT EXISTS 'quantum_fts_docsize'(id INTEGER PRIMARY KEY, sz BLOB);
CREATE TABLE IF NOT EXISTS 'quantum_fts_config'(k PRIMARY KEY, v) WITHOUT ROWID;
CREATE TABLE sqlite_stat1(tbl,idx,stat);
CREATE TABLE file_index (
    file_path TEXT PRIMARY KEY,
    last_referenced TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    reference_count INTEGER DEFAULT 1
);
CREATE TABLE todo_file_links (
    todo_id TEXT,
    file_path TEXT,
    FOREIGN KEY (todo_id) REFERENCES quantum_todos(id),
    FOREIGN KEY (file_path) REFERENCES file_index(file_path)
);
CREATE TABLE ml_processing_progress (
    content_type TEXT PRIMARY KEY,
    last_processed_id TEXT,
    last_processed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    items_processed INTEGER DEFAULT 0,
    tenant_id TEXT DEFAULT 'default'
);
CREATE TABLE audit_trail (
    audit_id TEXT PRIMARY KEY,
```

---

#### Database: `./.repair-snapshots/20251120_204830/windows_mirror_backup/.logs/hash-fortress/security/database-snapshot-hash-fortress-20251012-171520.db`

**File Stats:**
-rwxrwxrwx 1 groklygroup groklygroup 127M Oct 12 17:15 ./.repair-snapshots/20251120_204830/windows_mirror_backup/.logs/hash-fortress/security/database-snapshot-hash-fortress-20251012-171520.db

**Size:** 127M

**Modified:** 2025-10-12 17:15:23.000000000 -0700

**Accessed:** 2025-11-23 00:32:37.016547900 -0800

**Tables:**
anomaly_detections       ml_processing_progress   quantum_todos_optimized
api_keys                 ml_training_data         roles                  
audit_log                nlp_patterns             tenant_config          
audit_trail              performance_metrics      tenant_usage           
cache_config             quantum_execution_plan   theme_presets          
csrf_tokens              quantum_fts              todo_dependencies      
custom_domains           quantum_fts_config       todo_file_links        
dependency_counts        quantum_fts_data         ui_components          
email_templates          quantum_fts_docsize      user_behavior          
file_index               quantum_fts_idx          user_roles             
ml_models                quantum_todos            white_label_config     
ml_predictions           quantum_todos_archive  

**Schema Sample (first 50 lines):**
```sql
CREATE TABLE quantum_todos (
    id TEXT PRIMARY KEY,
    content TEXT NOT NULL,
    status TEXT NOT NULL DEFAULT 'pending',
    priority TEXT NOT NULL DEFAULT 'medium',
    source TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    completed_at TIMESTAMP,
    session_id TEXT,
    tags TEXT,
    quantum_state TEXT DEFAULT 'superposition',
    dependency_status TEXT DEFAULT 'ready',
    dependency_chain_length INTEGER DEFAULT 0
, craft_framework TEXT, project_tags TEXT, ml_priority_score REAL, content_hash TEXT, composite_content TEXT, tenant_id TEXT DEFAULT 'default', priority_order INTEGER DEFAULT 3, depends_on TEXT, blocks TEXT, estimated_hours REAL, actual_hours REAL, source_file_hash TEXT, source_line_number INTEGER, confidence_level TEXT, completion_evidence TEXT, auto_completed INTEGER, completion_reason TEXT, review_date INTEGER, predicted_duration INTEGER, actual_duration INTEGER);
CREATE TABLE todo_dependencies (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    todo_id TEXT NOT NULL,
    depends_on_id TEXT NOT NULL,
    dependency_type TEXT DEFAULT 'blocks',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (todo_id) REFERENCES quantum_todos (id),
    FOREIGN KEY (depends_on_id) REFERENCES quantum_todos (id),
    UNIQUE(todo_id, depends_on_id)
);
CREATE TABLE sqlite_sequence(name,seq);
CREATE TABLE IF NOT EXISTS 'quantum_fts_data'(id INTEGER PRIMARY KEY, block BLOB);
CREATE TABLE IF NOT EXISTS 'quantum_fts_idx'(segid, term, pgno, PRIMARY KEY(segid, term)) WITHOUT ROWID;
CREATE TABLE IF NOT EXISTS 'quantum_fts_docsize'(id INTEGER PRIMARY KEY, sz BLOB);
CREATE TABLE IF NOT EXISTS 'quantum_fts_config'(k PRIMARY KEY, v) WITHOUT ROWID;
CREATE TABLE sqlite_stat1(tbl,idx,stat);
CREATE TABLE file_index (
    file_path TEXT PRIMARY KEY,
    last_referenced TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    reference_count INTEGER DEFAULT 1
);
CREATE TABLE todo_file_links (
    todo_id TEXT,
    file_path TEXT,
    FOREIGN KEY (todo_id) REFERENCES quantum_todos(id),
    FOREIGN KEY (file_path) REFERENCES file_index(file_path)
);
CREATE TABLE ml_processing_progress (
    content_type TEXT PRIMARY KEY,
    last_processed_id TEXT,
    last_processed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    items_processed INTEGER DEFAULT 0,
    tenant_id TEXT DEFAULT 'default'
);
CREATE TABLE audit_trail (
    audit_id TEXT PRIMARY KEY,
```

---

#### Database: `./.repair-snapshots/20251120_204830/windows_mirror_backup/.logs/hash-fortress/security/working-database-hash-fortress-20251012-170553.db`

**File Stats:**
-rwxrwxrwx 1 groklygroup groklygroup 129M Oct 12 17:09 ./.repair-snapshots/20251120_204830/windows_mirror_backup/.logs/hash-fortress/security/working-database-hash-fortress-20251012-170553.db

**Size:** 129M

**Modified:** 2025-10-12 17:09:05.000000000 -0700

**Accessed:** 2025-11-23 00:33:25.137810400 -0800

**Tables:**
anomaly_detections          quantum_fts               
api_keys                    quantum_fts_config        
audit_log                   quantum_fts_data          
audit_trail                 quantum_fts_docsize       
cache_config                quantum_fts_idx           
cross_reference_validation  quantum_todos             
csrf_tokens                 quantum_todos_archive     
custom_domains              quantum_todos_optimized   
dependency_counts           roles                     
email_templates             tenant_config             
file_index                  tenant_usage              
hash_verification           theme_presets             
ml_models                   todo_dependencies         
ml_predictions              todo_file_links           
ml_processing_progress      ui_components             
ml_training_data            user_behavior             
nlp_patterns                user_roles                
performance_metrics         white_label_config        
quantum_execution_plan    

**Schema Sample (first 50 lines):**
```sql
CREATE TABLE quantum_todos (
    id TEXT PRIMARY KEY,
    content TEXT NOT NULL,
    status TEXT NOT NULL DEFAULT 'pending',
    priority TEXT NOT NULL DEFAULT 'medium',
    source TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    completed_at TIMESTAMP,
    session_id TEXT,
    tags TEXT,
    quantum_state TEXT DEFAULT 'superposition',
    dependency_status TEXT DEFAULT 'ready',
    dependency_chain_length INTEGER DEFAULT 0
, craft_framework TEXT, project_tags TEXT, ml_priority_score REAL, content_hash TEXT, composite_content TEXT, tenant_id TEXT DEFAULT 'default', priority_order INTEGER DEFAULT 3, depends_on TEXT, blocks TEXT, estimated_hours REAL, actual_hours REAL, source_file_hash TEXT, source_line_number INTEGER, confidence_level TEXT, completion_evidence TEXT, auto_completed INTEGER, completion_reason TEXT, review_date INTEGER, predicted_duration INTEGER, actual_duration INTEGER);
CREATE TABLE todo_dependencies (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    todo_id TEXT NOT NULL,
    depends_on_id TEXT NOT NULL,
    dependency_type TEXT DEFAULT 'blocks',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (todo_id) REFERENCES quantum_todos (id),
    FOREIGN KEY (depends_on_id) REFERENCES quantum_todos (id),
    UNIQUE(todo_id, depends_on_id)
);
CREATE TABLE sqlite_sequence(name,seq);
CREATE TABLE IF NOT EXISTS 'quantum_fts_data'(id INTEGER PRIMARY KEY, block BLOB);
CREATE TABLE IF NOT EXISTS 'quantum_fts_idx'(segid, term, pgno, PRIMARY KEY(segid, term)) WITHOUT ROWID;
CREATE TABLE IF NOT EXISTS 'quantum_fts_docsize'(id INTEGER PRIMARY KEY, sz BLOB);
CREATE TABLE IF NOT EXISTS 'quantum_fts_config'(k PRIMARY KEY, v) WITHOUT ROWID;
CREATE TABLE sqlite_stat1(tbl,idx,stat);
CREATE TABLE file_index (
    file_path TEXT PRIMARY KEY,
    last_referenced TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    reference_count INTEGER DEFAULT 1
);
CREATE TABLE todo_file_links (
    todo_id TEXT,
    file_path TEXT,
    FOREIGN KEY (todo_id) REFERENCES quantum_todos(id),
    FOREIGN KEY (file_path) REFERENCES file_index(file_path)
);
CREATE TABLE ml_processing_progress (
    content_type TEXT PRIMARY KEY,
    last_processed_id TEXT,
    last_processed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    items_processed INTEGER DEFAULT 0,
    tenant_id TEXT DEFAULT 'default'
);
CREATE TABLE audit_trail (
    audit_id TEXT PRIMARY KEY,
```

---

#### Database: `./.repair-snapshots/20251120_204830/windows_mirror_backup/.ml-training/daemon-commands.db`

**File Stats:**
-rwxrwxrwx 1 groklygroup groklygroup 16K Oct 31 14:37 ./.repair-snapshots/20251120_204830/windows_mirror_backup/.ml-training/daemon-commands.db

**Size:** 16K

**Modified:** 2025-10-31 14:37:13.000000000 -0700

**Accessed:** 2025-11-23 00:20:17.547616300 -0800

**Tables:**
command_mappings

**Schema Sample (first 50 lines):**
```sql
CREATE TABLE command_mappings (
    id INTEGER PRIMARY KEY,
    input TEXT,
    command TEXT,
    success INTEGER,
    timestamp INTEGER
);
CREATE INDEX idx_input ON command_mappings(input);
CREATE INDEX idx_timestamp ON command_mappings(timestamp);
```

---

#### Database: `./.repair-snapshots/20251120_204830/windows_mirror_backup/.protection/protected-files.db`

**File Stats:**
-rwxrwxrwx 1 groklygroup groklygroup 24K Jul 12 22:11 ./.repair-snapshots/20251120_204830/windows_mirror_backup/.protection/protected-files.db

**Size:** 24K

**Modified:** 2025-07-12 22:11:48.000000000 -0700

**Accessed:** 2025-11-23 01:04:16.455335800 -0800

**Tables:**
protected_files

**Schema Sample (first 50 lines):**
```sql
CREATE TABLE protected_files (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    file_path TEXT UNIQUE NOT NULL,
    hash TEXT NOT NULL,
    protection_level TEXT DEFAULT 'standard',
    protected_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    reason TEXT
);
CREATE TABLE sqlite_sequence(name,seq);
CREATE INDEX idx_file_path ON protected_files(file_path);
CREATE INDEX idx_protection_level ON protected_files(protection_level);
```

---

#### Database: `./.repair-snapshots/20251120_204830/windows_mirror_backup/.quantum-todo/.e2e-test.db`

**File Stats:**
-rwxrwxrwx 1 groklygroup groklygroup 8.0K Sep 16 16:59 ./.repair-snapshots/20251120_204830/windows_mirror_backup/.quantum-todo/.e2e-test.db

**Size:** 8.0K

**Modified:** 2025-09-16 16:59:18.000000000 -0700

**Accessed:** 2025-11-23 01:04:17.405570600 -0800

**Tables:**
test_results

**Schema Sample (first 50 lines):**
```sql
CREATE TABLE test_results (
    id INTEGER PRIMARY KEY,
    test_suite TEXT,
    test_name TEXT,
    status TEXT,
    duration REAL,
    error_message TEXT,
    timestamp TEXT DEFAULT CURRENT_TIMESTAMP
);
```

---

#### Database: `./.repair-snapshots/20251120_204830/windows_mirror_backup/.quantum-todo/.quantum-behavior.db`

**File Stats:**
-rwxrwxrwx 1 groklygroup groklygroup 208K Sep 17 17:45 ./.repair-snapshots/20251120_204830/windows_mirror_backup/.quantum-todo/.quantum-behavior.db

**Size:** 208K

**Modified:** 2025-09-17 17:45:30.000000000 -0700

**Accessed:** 2025-11-23 01:04:24.226313100 -0800

**Tables:**
command_sequences    performance_metrics  user_patterns      
error_predictions    task_predictions   

**Schema Sample (first 50 lines):**
```sql
CREATE TABLE user_patterns (
    id INTEGER PRIMARY KEY,
    pattern_type TEXT,
    pattern_data TEXT,
    frequency INTEGER DEFAULT 1,
    last_seen TEXT DEFAULT CURRENT_TIMESTAMP,
    prediction_accuracy REAL DEFAULT 0.0
);
CREATE TABLE command_sequences (
    id INTEGER PRIMARY KEY,
    command TEXT,
    next_command TEXT,
    frequency INTEGER DEFAULT 1,
    confidence REAL DEFAULT 0.0
);
CREATE TABLE task_predictions (
    id INTEGER PRIMARY KEY,
    context TEXT,
    predicted_task TEXT,
    actual_task TEXT,
    accuracy REAL,
    created_at TEXT DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE performance_metrics (
    id INTEGER PRIMARY KEY,
    metric_type TEXT,
    metric_value REAL,
    timestamp TEXT DEFAULT CURRENT_TIMESTAMP,
    prediction TEXT
);
CREATE TABLE error_predictions (
    id INTEGER PRIMARY KEY,
    error_pattern TEXT,
    prediction_time TEXT,
    actual_time TEXT,
    prevented BOOLEAN DEFAULT 0
);
CREATE INDEX idx_patterns_type ON user_patterns(pattern_type);
CREATE INDEX idx_commands_seq ON command_sequences(command);
CREATE INDEX idx_metrics_type ON performance_metrics(metric_type);
```

---

#### Database: `./.repair-snapshots/20251120_204830/windows_mirror_backup/.quantum-todo/.quantum-immunity.db`

**File Stats:**
-rwxrwxrwx 1 groklygroup groklygroup 44K Sep 16 16:34 ./.repair-snapshots/20251120_204830/windows_mirror_backup/.quantum-todo/.quantum-immunity.db

**Size:** 44K

**Modified:** 2025-09-16 16:34:29.000000000 -0700

**Accessed:** 2025-11-23 01:04:16.732444000 -0800

**Tables:**
antibodies                 threats                  
immune_responses           vulnerability_predictions
system_health            

**Schema Sample (first 50 lines):**
```sql
CREATE TABLE threats (
    id INTEGER PRIMARY KEY,
    threat_type TEXT,
    threat_signature TEXT UNIQUE,
    severity INTEGER,
    first_detected TEXT DEFAULT CURRENT_TIMESTAMP,
    last_seen TEXT,
    occurrence_count INTEGER DEFAULT 1,
    status TEXT DEFAULT 'active'
);
CREATE TABLE antibodies (
    id INTEGER PRIMARY KEY,
    antibody_id TEXT UNIQUE,
    threat_signature TEXT,
    prevention_code TEXT,
    cure_code TEXT,
    effectiveness REAL DEFAULT 1.0,
    deployment_count INTEGER DEFAULT 0,
    created_at TEXT DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE immune_responses (
    id INTEGER PRIMARY KEY,
    threat_id INTEGER,
    antibody_id TEXT,
    response_type TEXT,
    success BOOLEAN,
    response_time REAL,
    timestamp TEXT DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE system_health (
    id INTEGER PRIMARY KEY,
    component TEXT,
    health_score REAL,
    last_check TEXT DEFAULT CURRENT_TIMESTAMP,
    issues_detected INTEGER DEFAULT 0,
    auto_healed INTEGER DEFAULT 0
);
CREATE TABLE vulnerability_predictions (
    id INTEGER PRIMARY KEY,
    vulnerability_type TEXT,
    component TEXT,
    risk_score REAL,
    predicted_exploit_time TEXT,
    patch_available BOOLEAN DEFAULT 0,
    timestamp TEXT DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX idx_threat_sig ON threats(threat_signature);
CREATE INDEX idx_antibody_threat ON antibodies(threat_signature);
CREATE INDEX idx_health_component ON system_health(component);
```

---

#### Database: `./.repair-snapshots/20251120_204830/windows_mirror_backup/.quantum-todo/.quantum-predictions.db`

**File Stats:**
-rwxrwxrwx 1 groklygroup groklygroup 56K Sep 16 16:28 ./.repair-snapshots/20251120_204830/windows_mirror_backup/.quantum-todo/.quantum-predictions.db

**Size:** 56K

**Modified:** 2025-09-16 16:28:42.000000000 -0700

**Accessed:** 2025-11-23 01:04:18.277283900 -0800

**Tables:**
cache_predictions     predictions           workflow_patterns   
error_patterns        resource_predictions
ml_models             user_intents        

**Schema Sample (first 50 lines):**
```sql
CREATE TABLE predictions (
    id INTEGER PRIMARY KEY,
    prediction_type TEXT,
    prediction_data JSON,
    confidence REAL,
    created_at TEXT DEFAULT CURRENT_TIMESTAMP,
    expires_at TEXT,
    actual_outcome TEXT,
    accuracy_score REAL
);
CREATE TABLE user_intents (
    id INTEGER PRIMARY KEY,
    session_id TEXT,
    detected_intent TEXT,
    confidence REAL,
    context JSON,
    predicted_next_action TEXT,
    actual_next_action TEXT,
    timestamp TEXT DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE workflow_patterns (
    id INTEGER PRIMARY KEY,
    pattern_hash TEXT UNIQUE,
    workflow_sequence JSON,
    frequency INTEGER DEFAULT 1,
    avg_duration REAL,
    success_rate REAL,
    optimized_sequence JSON
);
CREATE TABLE resource_predictions (
    id INTEGER PRIMARY KEY,
    resource_type TEXT,
    current_usage REAL,
    predicted_usage REAL,
    prediction_window TEXT,
    alert_threshold REAL,
    timestamp TEXT DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE error_patterns (
    id INTEGER PRIMARY KEY,
    error_signature TEXT,
    occurrence_pattern JSON,
    prediction_model JSON,
    prevention_strategy JSON,
    success_count INTEGER DEFAULT 0
);
CREATE TABLE cache_predictions (
    id INTEGER PRIMARY KEY,
    query_pattern TEXT,
    predicted_result JSON,
```

---

#### Database: `./.repair-snapshots/20251120_204830/windows_mirror_backup/.quantum-todo/.test-backup-20250917-224155/quantum-todo.db`

**File Stats:**
-rwxrwxrwx 1 groklygroup groklygroup 184K Sep 17 22:41 ./.repair-snapshots/20251120_204830/windows_mirror_backup/.quantum-todo/.test-backup-20250917-224155/quantum-todo.db

**Size:** 184K

**Modified:** 2025-09-17 22:41:53.000000000 -0700

**Accessed:** 2025-11-23 01:04:37.038725700 -0800

**Tables:**
alert_history        performance_metrics  roles              
alert_rules          quantum_fts          tenant_config      
api_keys             quantum_fts_config   todo_dependencies  
audit_log            quantum_fts_data     user_roles         
cache_config         quantum_fts_docsize  webhook_events     
csrf_tokens          quantum_fts_idx      webhooks           
dependency_counts    quantum_todos        white_label_config 

**Schema Sample (first 50 lines):**
```sql
CREATE TABLE quantum_todos (
    id TEXT PRIMARY KEY,
    content TEXT NOT NULL,
    status TEXT NOT NULL DEFAULT 'pending',
    priority TEXT NOT NULL DEFAULT 'medium',
    priority_order INTEGER DEFAULT 999,
    source TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    completed_at TIMESTAMP,
    session_id TEXT,
    tags TEXT,
    quantum_state TEXT DEFAULT 'superposition',
    dependency_status TEXT DEFAULT 'ready',
    dependency_chain_length INTEGER DEFAULT 0,
    tenant_id TEXT DEFAULT 'default',
    content_hash TEXT,
    ml_priority_score REAL DEFAULT 0.5,
    predicted_duration INTEGER,
    actual_duration INTEGER
);
CREATE TABLE tenant_config (
    tenant_id TEXT PRIMARY KEY,
    max_todos INTEGER DEFAULT 10000,
    max_storage_mb INTEGER DEFAULT 100,
    features TEXT DEFAULT '{}',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE api_keys (
    key_hash TEXT PRIMARY KEY,
    tenant_id TEXT NOT NULL,
    user_id TEXT NOT NULL,
    permissions TEXT DEFAULT '{}',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_used TIMESTAMP,
    expires_at TIMESTAMP,
    FOREIGN KEY (tenant_id) REFERENCES tenant_config(tenant_id)
);
CREATE TABLE audit_log (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    tenant_id TEXT NOT NULL,
    user_id TEXT,
    action TEXT NOT NULL,
    resource_type TEXT,
    resource_id TEXT,
    details TEXT,
    ip_address TEXT,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE sqlite_sequence(name,seq);
```

---

#### Database: `./.repair-snapshots/20251120_204830/windows_mirror_backup/.quantum-todo/auto-backup-20250916-142107.db`

**File Stats:**
-rwxrwxrwx 1 groklygroup groklygroup 44M Oct  9 23:59 ./.repair-snapshots/20251120_204830/windows_mirror_backup/.quantum-todo/auto-backup-20250916-142107.db

**Size:** 44M

**Modified:** 2025-10-09 23:59:02.000000000 -0700

**Accessed:** 2025-11-23 01:12:30.850526200 -0800

**Tables:**
quantum_fts          quantum_fts_docsize  todo_dependencies  
quantum_fts_config   quantum_fts_idx    
quantum_fts_data     quantum_todos      

**Schema Sample (first 50 lines):**
```sql
CREATE TABLE quantum_todos (
    id TEXT PRIMARY KEY,
    content TEXT NOT NULL,
    status TEXT NOT NULL DEFAULT 'pending',
    priority TEXT NOT NULL DEFAULT 'medium',
    source TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    completed_at TIMESTAMP,
    session_id TEXT,
    tags TEXT,
    quantum_state TEXT DEFAULT 'superposition',
    dependency_status TEXT DEFAULT 'ready',
    dependency_chain_length INTEGER DEFAULT 0
);
CREATE TABLE todo_dependencies (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    todo_id TEXT NOT NULL,
    depends_on_id TEXT NOT NULL,
    dependency_type TEXT DEFAULT 'blocks',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (todo_id) REFERENCES quantum_todos (id),
    FOREIGN KEY (depends_on_id) REFERENCES quantum_todos (id),
    UNIQUE(todo_id, depends_on_id)
);
CREATE TABLE sqlite_sequence(name,seq);
CREATE INDEX idx_status ON quantum_todos(status);
CREATE INDEX idx_priority ON quantum_todos(priority);
CREATE INDEX idx_dependency_status ON quantum_todos(dependency_status);
CREATE INDEX idx_dependency_todo ON todo_dependencies(todo_id);
CREATE INDEX idx_dependency_depends ON todo_dependencies(depends_on_id);
CREATE VIRTUAL TABLE quantum_fts USING fts5(content, content=quantum_todos)
/* quantum_fts(content) */;
CREATE TABLE IF NOT EXISTS 'quantum_fts_data'(id INTEGER PRIMARY KEY, block BLOB);
CREATE TABLE IF NOT EXISTS 'quantum_fts_idx'(segid, term, pgno, PRIMARY KEY(segid, term)) WITHOUT ROWID;
CREATE TABLE IF NOT EXISTS 'quantum_fts_docsize'(id INTEGER PRIMARY KEY, sz BLOB);
CREATE TABLE IF NOT EXISTS 'quantum_fts_config'(k PRIMARY KEY, v) WITHOUT ROWID;
```

---

#### Database: `./.repair-snapshots/20251120_204830/windows_mirror_backup/.quantum-todo/HOT_MIGRATION_SAFETY_20251010_031354_auto-backup.db`

**File Stats:**
-rwxrwxrwx 1 groklygroup groklygroup 44M Oct 10 03:13 ./.repair-snapshots/20251120_204830/windows_mirror_backup/.quantum-todo/HOT_MIGRATION_SAFETY_20251010_031354_auto-backup.db

**Size:** 44M

**Modified:** 2025-10-10 03:13:56.000000000 -0700

**Accessed:** 2025-11-23 01:18:03.509115000 -0800

**Tables:**
quantum_fts          quantum_fts_docsize  todo_dependencies  
quantum_fts_config   quantum_fts_idx    
quantum_fts_data     quantum_todos      

**Schema Sample (first 50 lines):**
```sql
CREATE TABLE quantum_todos (
    id TEXT PRIMARY KEY,
    content TEXT NOT NULL,
    status TEXT NOT NULL DEFAULT 'pending',
    priority TEXT NOT NULL DEFAULT 'medium',
    source TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    completed_at TIMESTAMP,
    session_id TEXT,
    tags TEXT,
    quantum_state TEXT DEFAULT 'superposition',
    dependency_status TEXT DEFAULT 'ready',
    dependency_chain_length INTEGER DEFAULT 0
);
CREATE TABLE todo_dependencies (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    todo_id TEXT NOT NULL,
    depends_on_id TEXT NOT NULL,
    dependency_type TEXT DEFAULT 'blocks',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (todo_id) REFERENCES quantum_todos (id),
    FOREIGN KEY (depends_on_id) REFERENCES quantum_todos (id),
    UNIQUE(todo_id, depends_on_id)
);
CREATE TABLE sqlite_sequence(name,seq);
CREATE INDEX idx_status ON quantum_todos(status);
CREATE INDEX idx_priority ON quantum_todos(priority);
CREATE INDEX idx_dependency_status ON quantum_todos(dependency_status);
CREATE INDEX idx_dependency_todo ON todo_dependencies(todo_id);
CREATE INDEX idx_dependency_depends ON todo_dependencies(depends_on_id);
CREATE VIRTUAL TABLE quantum_fts USING fts5(content, content=quantum_todos)
/* quantum_fts(content) */;
CREATE TABLE IF NOT EXISTS 'quantum_fts_data'(id INTEGER PRIMARY KEY, block BLOB);
CREATE TABLE IF NOT EXISTS 'quantum_fts_idx'(segid, term, pgno, PRIMARY KEY(segid, term)) WITHOUT ROWID;
CREATE TABLE IF NOT EXISTS 'quantum_fts_docsize'(id INTEGER PRIMARY KEY, sz BLOB);
CREATE TABLE IF NOT EXISTS 'quantum_fts_config'(k PRIMARY KEY, v) WITHOUT ROWID;
```

---

#### Database: `./.repair-snapshots/20251120_204830/windows_mirror_backup/.quantum-todo/HOT_MIGRATION_SAFETY_20251010_031354_quantum-index.db`

**File Stats:**
-rwxrwxrwx 1 groklygroup groklygroup 66M Oct 10 03:13 ./.repair-snapshots/20251120_204830/windows_mirror_backup/.quantum-todo/HOT_MIGRATION_SAFETY_20251010_031354_quantum-index.db

**Size:** 66M

**Modified:** 2025-10-10 03:13:57.000000000 -0700

**Accessed:** 2025-11-23 01:17:54.218335800 -0800

**Tables:**
anomaly_detections       ml_processing_progress   quantum_todos_optimized
api_keys                 ml_training_data         roles                  
audit_log                nlp_patterns             tenant_config          
audit_trail              performance_metrics      tenant_usage           
cache_config             quantum_execution_plan   theme_presets          
csrf_tokens              quantum_fts              todo_dependencies      
custom_domains           quantum_fts_config       todo_file_links        
dependency_counts        quantum_fts_data         ui_components          
email_templates          quantum_fts_docsize      user_behavior          
file_index               quantum_fts_idx          user_roles             
ml_models                quantum_todos            white_label_config     
ml_predictions           quantum_todos_archive  

**Schema Sample (first 50 lines):**
```sql
CREATE TABLE quantum_todos (
    id TEXT PRIMARY KEY,
    content TEXT NOT NULL,
    status TEXT NOT NULL DEFAULT 'pending',
    priority TEXT NOT NULL DEFAULT 'medium',
    source TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    completed_at TIMESTAMP,
    session_id TEXT,
    tags TEXT,
    quantum_state TEXT DEFAULT 'superposition',
    dependency_status TEXT DEFAULT 'ready',
    dependency_chain_length INTEGER DEFAULT 0
, craft_framework TEXT, project_tags TEXT, ml_priority_score REAL, content_hash TEXT, composite_content TEXT, tenant_id TEXT DEFAULT 'default', priority_order INTEGER DEFAULT 3);
CREATE TABLE todo_dependencies (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    todo_id TEXT NOT NULL,
    depends_on_id TEXT NOT NULL,
    dependency_type TEXT DEFAULT 'blocks',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (todo_id) REFERENCES quantum_todos (id),
    FOREIGN KEY (depends_on_id) REFERENCES quantum_todos (id),
    UNIQUE(todo_id, depends_on_id)
);
CREATE TABLE sqlite_sequence(name,seq);
CREATE TABLE IF NOT EXISTS 'quantum_fts_data'(id INTEGER PRIMARY KEY, block BLOB);
CREATE TABLE IF NOT EXISTS 'quantum_fts_idx'(segid, term, pgno, PRIMARY KEY(segid, term)) WITHOUT ROWID;
CREATE TABLE IF NOT EXISTS 'quantum_fts_docsize'(id INTEGER PRIMARY KEY, sz BLOB);
CREATE TABLE IF NOT EXISTS 'quantum_fts_config'(k PRIMARY KEY, v) WITHOUT ROWID;
CREATE TABLE sqlite_stat1(tbl,idx,stat);
CREATE TABLE file_index (
    file_path TEXT PRIMARY KEY,
    last_referenced TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    reference_count INTEGER DEFAULT 1
);
CREATE TABLE todo_file_links (
    todo_id TEXT,
    file_path TEXT,
    FOREIGN KEY (todo_id) REFERENCES quantum_todos(id),
    FOREIGN KEY (file_path) REFERENCES file_index(file_path)
);
CREATE TABLE ml_processing_progress (
    content_type TEXT PRIMARY KEY,
    last_processed_id TEXT,
    last_processed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    items_processed INTEGER DEFAULT 0,
    tenant_id TEXT DEFAULT 'default'
);
CREATE TABLE audit_trail (
    audit_id TEXT PRIMARY KEY,
```

---

#### Database: `./.repair-snapshots/20251120_204830/windows_mirror_backup/.quantum-todo/HOT_MIGRATION_SAFETY_20251010_031354_quantum-todo.db`

**File Stats:**
-rwxrwxrwx 1 groklygroup groklygroup 22M Oct 10 03:13 ./.repair-snapshots/20251120_204830/windows_mirror_backup/.quantum-todo/HOT_MIGRATION_SAFETY_20251010_031354_quantum-todo.db

**Size:** 22M

**Modified:** 2025-10-10 03:13:55.000000000 -0700

**Accessed:** 2025-11-23 01:10:42.209065800 -0800

**Tables:**
alert_history        performance_metrics  roles              
alert_rules          quantum_fts          tenant_config      
api_keys             quantum_fts_config   todo_dependencies  
audit_log            quantum_fts_data     user_roles         
cache_config         quantum_fts_docsize  webhook_events     
csrf_tokens          quantum_fts_idx      webhooks           
dependency_counts    quantum_todos        white_label_config 

**Schema Sample (first 50 lines):**
```sql
CREATE TABLE tenant_config (
    tenant_id TEXT PRIMARY KEY,
    max_todos INTEGER DEFAULT 10000,
    max_storage_mb INTEGER DEFAULT 100,
    features TEXT DEFAULT '{}',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE api_keys (
    key_hash TEXT PRIMARY KEY,
    tenant_id TEXT NOT NULL,
    user_id TEXT NOT NULL,
    permissions TEXT DEFAULT '{}',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_used TIMESTAMP,
    expires_at TIMESTAMP,
    FOREIGN KEY (tenant_id) REFERENCES tenant_config(tenant_id)
);
CREATE TABLE audit_log (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    tenant_id TEXT NOT NULL,
    user_id TEXT,
    action TEXT NOT NULL,
    resource_type TEXT,
    resource_id TEXT,
    details TEXT,
    ip_address TEXT,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE sqlite_sequence(name,seq);
CREATE TABLE roles (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    role_name TEXT NOT NULL UNIQUE,
    permissions TEXT NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE user_roles (
    user_id TEXT NOT NULL,
    role_id INTEGER NOT NULL,
    tenant_id TEXT NOT NULL,
    assigned_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id, role_id, tenant_id),
    FOREIGN KEY (role_id) REFERENCES roles(id)
);
CREATE TABLE white_label_config (
    tenant_id TEXT PRIMARY KEY,
    brand_name TEXT NOT NULL DEFAULT 'Quantum TODO',
    brand_tagline TEXT DEFAULT 'Enterprise Task Management',
    primary_color TEXT DEFAULT '#3498db',
```

---

#### Database: `./.repair-snapshots/20251120_204830/windows_mirror_backup/.quantum-todo/HOT_MIGRATION_SAFETY_20251010_031354_quantum_todos.db`

**File Stats:**
-rwxrwxrwx 1 groklygroup groklygroup 504K Oct 10 03:13 ./.repair-snapshots/20251120_204830/windows_mirror_backup/.quantum-todo/HOT_MIGRATION_SAFETY_20251010_031354_quantum_todos.db

**Size:** 504K

**Modified:** 2025-10-10 03:13:54.000000000 -0700

**Accessed:** 2025-11-23 01:06:05.195294300 -0800

**Tables:**
quantum_fts          quantum_fts_docsize  todo_dependencies  
quantum_fts_config   quantum_fts_idx    
quantum_fts_data     quantum_todos      

**Schema Sample (first 50 lines):**
```sql
CREATE TABLE quantum_todos (
    id TEXT PRIMARY KEY,
    content TEXT NOT NULL,
    status TEXT NOT NULL DEFAULT 'pending',
    priority TEXT NOT NULL DEFAULT 'medium',
    source TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    completed_at TIMESTAMP,
    session_id TEXT,
    tags TEXT,
    quantum_state TEXT DEFAULT 'superposition',
    dependency_status TEXT DEFAULT 'ready',
    dependency_chain_length INTEGER DEFAULT 0
);
CREATE TABLE todo_dependencies (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    todo_id TEXT NOT NULL,
    depends_on_id TEXT NOT NULL,
    dependency_type TEXT DEFAULT 'blocks',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (todo_id) REFERENCES quantum_todos (id),
    FOREIGN KEY (depends_on_id) REFERENCES quantum_todos (id),
    UNIQUE(todo_id, depends_on_id)
);
CREATE TABLE sqlite_sequence(name,seq);
CREATE INDEX idx_status ON quantum_todos(status);
CREATE INDEX idx_priority ON quantum_todos(priority);
CREATE INDEX idx_dependency_status ON quantum_todos(dependency_status);
CREATE INDEX idx_dependency_todo ON todo_dependencies(todo_id);
CREATE INDEX idx_dependency_depends ON todo_dependencies(depends_on_id);
CREATE VIRTUAL TABLE quantum_fts USING fts5(content, content=quantum_todos)
/* quantum_fts(content) */;
CREATE TABLE IF NOT EXISTS 'quantum_fts_data'(id INTEGER PRIMARY KEY, block BLOB);
CREATE TABLE IF NOT EXISTS 'quantum_fts_idx'(segid, term, pgno, PRIMARY KEY(segid, term)) WITHOUT ROWID;
CREATE TABLE IF NOT EXISTS 'quantum_fts_docsize'(id INTEGER PRIMARY KEY, sz BLOB);
CREATE TABLE IF NOT EXISTS 'quantum_fts_config'(k PRIMARY KEY, v) WITHOUT ROWID;
```

---

#### Database: `./.repair-snapshots/20251120_204830/windows_mirror_backup/.quantum-todo/quantum-index.db`

**File Stats:**
-rwxrwxrwx 1 groklygroup groklygroup 129M Nov 20 10:21 ./.repair-snapshots/20251120_204830/windows_mirror_backup/.quantum-todo/quantum-index.db

**Size:** 129M

**Modified:** 2025-11-20 10:21:59.000000000 -0800

**Accessed:** 2025-11-23 01:34:40.186177700 -0800

**Tables:**
anomaly_detections          quantum_execution_plan    
api_keys                    quantum_fts               
audit_log                   quantum_fts_config        
audit_trail                 quantum_fts_data          
cache_config                quantum_fts_docsize       
cross_reference_validation  quantum_fts_idx           
csrf_tokens                 quantum_todos             
custom_domains              quantum_todos_archive     
dependency_counts           quantum_todos_optimized   
email_templates             roles                     
file_index                  tenant_config             
hash_verification           tenant_usage              
ml_models                   theme_presets             
ml_predictions              todo_dependencies         
ml_processing_progress      todo_file_links           
ml_training_data            ui_components             
nlp_patterns                user_behavior             
performance_metrics         user_roles                
plans_consolidated          white_label_config        

**Schema Sample (first 50 lines):**
```sql
CREATE TABLE quantum_todos (
    id TEXT PRIMARY KEY,
    content TEXT NOT NULL,
    status TEXT NOT NULL DEFAULT 'pending',
    priority TEXT NOT NULL DEFAULT 'medium',
    source TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    completed_at TIMESTAMP,
    session_id TEXT,
    tags TEXT,
    quantum_state TEXT DEFAULT 'superposition',
    dependency_status TEXT DEFAULT 'ready',
    dependency_chain_length INTEGER DEFAULT 0
, craft_framework TEXT, project_tags TEXT, ml_priority_score REAL, content_hash TEXT, composite_content TEXT, tenant_id TEXT DEFAULT 'default', priority_order INTEGER DEFAULT 3, depends_on TEXT, blocks TEXT, estimated_hours REAL, actual_hours REAL, source_file_hash TEXT, source_line_number INTEGER, confidence_level TEXT, completion_evidence TEXT, auto_completed INTEGER, completion_reason TEXT, review_date INTEGER, predicted_duration INTEGER, actual_duration INTEGER);
CREATE TABLE todo_dependencies (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    todo_id TEXT NOT NULL,
    depends_on_id TEXT NOT NULL,
    dependency_type TEXT DEFAULT 'blocks',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (todo_id) REFERENCES quantum_todos (id),
    FOREIGN KEY (depends_on_id) REFERENCES quantum_todos (id),
    UNIQUE(todo_id, depends_on_id)
);
CREATE TABLE sqlite_sequence(name,seq);
CREATE TABLE IF NOT EXISTS 'quantum_fts_data'(id INTEGER PRIMARY KEY, block BLOB);
CREATE TABLE IF NOT EXISTS 'quantum_fts_idx'(segid, term, pgno, PRIMARY KEY(segid, term)) WITHOUT ROWID;
CREATE TABLE IF NOT EXISTS 'quantum_fts_docsize'(id INTEGER PRIMARY KEY, sz BLOB);
CREATE TABLE IF NOT EXISTS 'quantum_fts_config'(k PRIMARY KEY, v) WITHOUT ROWID;
CREATE TABLE sqlite_stat1(tbl,idx,stat);
CREATE TABLE file_index (
    file_path TEXT PRIMARY KEY,
    last_referenced TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    reference_count INTEGER DEFAULT 1
);
CREATE TABLE todo_file_links (
    todo_id TEXT,
    file_path TEXT,
    FOREIGN KEY (todo_id) REFERENCES quantum_todos(id),
    FOREIGN KEY (file_path) REFERENCES file_index(file_path)
);
CREATE TABLE ml_processing_progress (
    content_type TEXT PRIMARY KEY,
    last_processed_id TEXT,
    last_processed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    items_processed INTEGER DEFAULT 0,
    tenant_id TEXT DEFAULT 'default'
);
CREATE TABLE audit_trail (
    audit_id TEXT PRIMARY KEY,
```

---

#### Database: `./.repair-snapshots/20251120_204830/windows_mirror_backup/.quantum-todo/quantum-test.db`

**File Stats:**
-rwxrwxrwx 1 groklygroup groklygroup 0 Sep 17 22:42 ./.repair-snapshots/20251120_204830/windows_mirror_backup/.quantum-todo/quantum-test.db

**Size:** 0

**Modified:** 2025-09-17 22:42:40.000000000 -0700

**Accessed:** 2025-11-20 23:15:24.121401700 -0800

**Tables:**

**Schema Sample (first 50 lines):**
```sql
```

---

#### Database: `./.repair-snapshots/20251120_204830/windows_mirror_backup/.quantum-todo/quantum-todo.db`

**File Stats:**
-rwxrwxrwx 1 groklygroup groklygroup 22M Nov 17 19:14 ./.repair-snapshots/20251120_204830/windows_mirror_backup/.quantum-todo/quantum-todo.db

**Size:** 22M

**Modified:** 2025-11-17 19:14:34.000000000 -0800

**Accessed:** 2025-11-23 01:41:11.762443300 -0800

**Tables:**
alert_history        performance_metrics  roles              
alert_rules          quantum_fts          tenant_config      
api_keys             quantum_fts_config   todo_dependencies  
audit_log            quantum_fts_data     user_roles         
cache_config         quantum_fts_docsize  webhook_events     
csrf_tokens          quantum_fts_idx      webhooks           
dependency_counts    quantum_todos        white_label_config 

**Schema Sample (first 50 lines):**
```sql
CREATE TABLE tenant_config (
    tenant_id TEXT PRIMARY KEY,
    max_todos INTEGER DEFAULT 10000,
    max_storage_mb INTEGER DEFAULT 100,
    features TEXT DEFAULT '{}',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE api_keys (
    key_hash TEXT PRIMARY KEY,
    tenant_id TEXT NOT NULL,
    user_id TEXT NOT NULL,
    permissions TEXT DEFAULT '{}',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_used TIMESTAMP,
    expires_at TIMESTAMP,
    FOREIGN KEY (tenant_id) REFERENCES tenant_config(tenant_id)
);
CREATE TABLE audit_log (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    tenant_id TEXT NOT NULL,
    user_id TEXT,
    action TEXT NOT NULL,
    resource_type TEXT,
    resource_id TEXT,
    details TEXT,
    ip_address TEXT,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE sqlite_sequence(name,seq);
CREATE TABLE roles (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    role_name TEXT NOT NULL UNIQUE,
    permissions TEXT NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE user_roles (
    user_id TEXT NOT NULL,
    role_id INTEGER NOT NULL,
    tenant_id TEXT NOT NULL,
    assigned_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id, role_id, tenant_id),
    FOREIGN KEY (role_id) REFERENCES roles(id)
);
CREATE TABLE white_label_config (
    tenant_id TEXT PRIMARY KEY,
    brand_name TEXT NOT NULL DEFAULT 'Quantum TODO',
    brand_tagline TEXT DEFAULT 'Enterprise Task Management',
    primary_color TEXT DEFAULT '#3498db',
```

---

#### Database: `./.repair-snapshots/20251120_204830/windows_mirror_backup/.quantum-todo/quantum-todos.db`

**File Stats:**
-rwxrwxrwx 1 groklygroup groklygroup 0 Aug 16 21:25 ./.repair-snapshots/20251120_204830/windows_mirror_backup/.quantum-todo/quantum-todos.db

**Size:** 0

**Modified:** 2025-08-16 21:25:25.000000000 -0700

**Accessed:** 2025-11-20 23:15:25.480071700 -0800

**Tables:**

**Schema Sample (first 50 lines):**
```sql
```

---

#### Database: `./.repair-snapshots/20251120_204830/windows_mirror_backup/.quantum-todo/quantum_todos.db`

**File Stats:**
-rwxrwxrwx 1 groklygroup groklygroup 504K Oct  9 15:01 ./.repair-snapshots/20251120_204830/windows_mirror_backup/.quantum-todo/quantum_todos.db

**Size:** 504K

**Modified:** 2025-10-09 15:01:33.000000000 -0700

**Accessed:** 2025-11-23 01:07:07.263706800 -0800

**Tables:**
quantum_fts          quantum_fts_docsize  todo_dependencies  
quantum_fts_config   quantum_fts_idx    
quantum_fts_data     quantum_todos      

**Schema Sample (first 50 lines):**
```sql
CREATE TABLE quantum_todos (
    id TEXT PRIMARY KEY,
    content TEXT NOT NULL,
    status TEXT NOT NULL DEFAULT 'pending',
    priority TEXT NOT NULL DEFAULT 'medium',
    source TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    completed_at TIMESTAMP,
    session_id TEXT,
    tags TEXT,
    quantum_state TEXT DEFAULT 'superposition',
    dependency_status TEXT DEFAULT 'ready',
    dependency_chain_length INTEGER DEFAULT 0
);
CREATE TABLE todo_dependencies (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    todo_id TEXT NOT NULL,
    depends_on_id TEXT NOT NULL,
    dependency_type TEXT DEFAULT 'blocks',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (todo_id) REFERENCES quantum_todos (id),
    FOREIGN KEY (depends_on_id) REFERENCES quantum_todos (id),
    UNIQUE(todo_id, depends_on_id)
);
CREATE TABLE sqlite_sequence(name,seq);
CREATE INDEX idx_status ON quantum_todos(status);
CREATE INDEX idx_priority ON quantum_todos(priority);
CREATE INDEX idx_dependency_status ON quantum_todos(dependency_status);
CREATE INDEX idx_dependency_todo ON todo_dependencies(todo_id);
CREATE INDEX idx_dependency_depends ON todo_dependencies(depends_on_id);
CREATE VIRTUAL TABLE quantum_fts USING fts5(content, content=quantum_todos)
/* quantum_fts(content) */;
CREATE TABLE IF NOT EXISTS 'quantum_fts_data'(id INTEGER PRIMARY KEY, block BLOB);
CREATE TABLE IF NOT EXISTS 'quantum_fts_idx'(segid, term, pgno, PRIMARY KEY(segid, term)) WITHOUT ROWID;
CREATE TABLE IF NOT EXISTS 'quantum_fts_docsize'(id INTEGER PRIMARY KEY, sz BLOB);
CREATE TABLE IF NOT EXISTS 'quantum_fts_config'(k PRIMARY KEY, v) WITHOUT ROWID;
```

---

#### Database: `./.repair-snapshots/20251120_204830/windows_mirror_backup/.quantum-todo/SAFETY_BACKUP_20251009_235633.db`

**File Stats:**
-rwxrwxrwx 1 groklygroup groklygroup 66M Oct  9 23:56 ./.repair-snapshots/20251120_204830/windows_mirror_backup/.quantum-todo/SAFETY_BACKUP_20251009_235633.db

**Size:** 66M

**Modified:** 2025-10-09 23:56:37.000000000 -0700

**Accessed:** 2025-11-23 01:43:07.626566100 -0800

**Tables:**
anomaly_detections       ml_processing_progress   quantum_todos_optimized
api_keys                 ml_training_data         roles                  
audit_log                nlp_patterns             tenant_config          
audit_trail              performance_metrics      tenant_usage           
cache_config             quantum_execution_plan   theme_presets          
csrf_tokens              quantum_fts              todo_dependencies      
custom_domains           quantum_fts_config       todo_file_links        
dependency_counts        quantum_fts_data         ui_components          
email_templates          quantum_fts_docsize      user_behavior          
file_index               quantum_fts_idx          user_roles             
ml_models                quantum_todos            white_label_config     
ml_predictions           quantum_todos_archive  

**Schema Sample (first 50 lines):**
```sql
CREATE TABLE quantum_todos (
    id TEXT PRIMARY KEY,
    content TEXT NOT NULL,
    status TEXT NOT NULL DEFAULT 'pending',
    priority TEXT NOT NULL DEFAULT 'medium',
    source TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    completed_at TIMESTAMP,
    session_id TEXT,
    tags TEXT,
    quantum_state TEXT DEFAULT 'superposition',
    dependency_status TEXT DEFAULT 'ready',
    dependency_chain_length INTEGER DEFAULT 0
, craft_framework TEXT, project_tags TEXT, ml_priority_score REAL, content_hash TEXT, composite_content TEXT, tenant_id TEXT DEFAULT 'default', priority_order INTEGER DEFAULT 3);
CREATE TABLE todo_dependencies (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    todo_id TEXT NOT NULL,
    depends_on_id TEXT NOT NULL,
    dependency_type TEXT DEFAULT 'blocks',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (todo_id) REFERENCES quantum_todos (id),
    FOREIGN KEY (depends_on_id) REFERENCES quantum_todos (id),
    UNIQUE(todo_id, depends_on_id)
);
CREATE TABLE sqlite_sequence(name,seq);
CREATE TABLE IF NOT EXISTS 'quantum_fts_data'(id INTEGER PRIMARY KEY, block BLOB);
CREATE TABLE IF NOT EXISTS 'quantum_fts_idx'(segid, term, pgno, PRIMARY KEY(segid, term)) WITHOUT ROWID;
CREATE TABLE IF NOT EXISTS 'quantum_fts_docsize'(id INTEGER PRIMARY KEY, sz BLOB);
CREATE TABLE IF NOT EXISTS 'quantum_fts_config'(k PRIMARY KEY, v) WITHOUT ROWID;
CREATE TABLE sqlite_stat1(tbl,idx,stat);
CREATE TABLE file_index (
    file_path TEXT PRIMARY KEY,
    last_referenced TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    reference_count INTEGER DEFAULT 1
);
CREATE TABLE todo_file_links (
    todo_id TEXT,
    file_path TEXT,
    FOREIGN KEY (todo_id) REFERENCES quantum_todos(id),
    FOREIGN KEY (file_path) REFERENCES file_index(file_path)
);
CREATE TABLE ml_processing_progress (
    content_type TEXT PRIMARY KEY,
    last_processed_id TEXT,
    last_processed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    items_processed INTEGER DEFAULT 0,
    tenant_id TEXT DEFAULT 'default'
);
CREATE TABLE audit_trail (
    audit_id TEXT PRIMARY KEY,
```

---

#### Database: `./.repair-snapshots/20251120_204830/windows_mirror_backup/.rollback/quantum-20250714-181922/.quantum-todo/quantum-index.db`

**File Stats:**
-rwxrwxrwx 1 groklygroup groklygroup 2.4M Jul 14 06:23 ./.repair-snapshots/20251120_204830/windows_mirror_backup/.rollback/quantum-20250714-181922/.quantum-todo/quantum-index.db

**Size:** 2.4M

**Modified:** 2025-07-14 06:23:49.000000000 -0700

**Accessed:** 2025-11-23 02:11:53.938709600 -0800

**Tables:**
quantum_fts          quantum_fts_docsize  todos_by_category  
quantum_fts_config   quantum_fts_idx      todos_by_priority  
quantum_fts_content  quantum_todos        todos_critical_path
quantum_fts_data     todos              

**Schema Sample (first 50 lines):**
```sql
CREATE TABLE quantum_todos (
    id TEXT PRIMARY KEY,
    content TEXT NOT NULL,
    status TEXT NOT NULL,
    priority TEXT NOT NULL,
    source TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    completed_at TIMESTAMP,
    session_id TEXT,
    tags TEXT,
    quantum_state TEXT DEFAULT 'superposition'
);
CREATE TABLE IF NOT EXISTS 'quantum_fts_data'(id INTEGER PRIMARY KEY, block BLOB);
CREATE TABLE IF NOT EXISTS 'quantum_fts_idx'(segid, term, pgno, PRIMARY KEY(segid, term)) WITHOUT ROWID;
CREATE TABLE IF NOT EXISTS 'quantum_fts_content'(id INTEGER PRIMARY KEY, c0, c1);
CREATE TABLE IF NOT EXISTS 'quantum_fts_docsize'(id INTEGER PRIMARY KEY, sz BLOB);
CREATE TABLE IF NOT EXISTS 'quantum_fts_config'(k PRIMARY KEY, v) WITHOUT ROWID;
CREATE INDEX idx_status ON quantum_todos(status);
CREATE INDEX idx_priority ON quantum_todos(priority);
CREATE INDEX idx_session ON quantum_todos(session_id);
CREATE VIRTUAL TABLE quantum_fts USING fts5(content, tags)
/* quantum_fts(content,tags) */;
CREATE VIEW todos_by_priority AS
SELECT 
    id,
    CASE priority
        WHEN 'critical' THEN '🚨 CRITICAL'
        WHEN 'high' THEN '🔴 HIGH'
        WHEN 'medium' THEN '🟡 MEDIUM'
        WHEN 'low' THEN '🟢 LOW'
        ELSE '⚪ UNSET'
    END as priority_label,
    substr(content, 1, 80) || CASE WHEN length(content) > 80 THEN '...' ELSE '' END as content,
    tags,
    created_at
FROM quantum_todos
WHERE status = 'pending'
ORDER BY 
    CASE priority
        WHEN 'critical' THEN 1
        WHEN 'high' THEN 2
        WHEN 'medium' THEN 3
        WHEN 'low' THEN 4
        ELSE 5
    END,
    created_at
/* todos_by_priority(id,priority_label,content,tags,created_at) */;
CREATE VIEW todos_by_category AS
SELECT 
    CASE 
```

---

#### Database: `./.repair-snapshots/20251120_204830/windows_mirror_backup/.rollback/quantum-20250714-181922/quantum-index.db`

**File Stats:**
-rwxrwxrwx 1 groklygroup groklygroup 4.0K Jul 14 06:27 ./.repair-snapshots/20251120_204830/windows_mirror_backup/.rollback/quantum-20250714-181922/quantum-index.db

**Size:** 4.0K

**Modified:** 2025-07-14 06:27:49.000000000 -0700

**Accessed:** 2025-11-23 02:11:50.483820300 -0800

**Tables:**

**Schema Sample (first 50 lines):**
```sql
```

---

#### Database: `./.repair-snapshots/20251120_204830/windows_mirror_backup/.search-index/analytics/analytics.db`

**File Stats:**
-rwxrwxrwx 1 groklygroup groklygroup 28K Jul 11 10:56 ./.repair-snapshots/20251120_204830/windows_mirror_backup/.search-index/analytics/analytics.db

**Size:** 28K

**Modified:** 2025-07-11 10:56:06.000000000 -0700

**Accessed:** 2025-11-23 02:12:58.402449900 -0800

**Tables:**
query_log    query_stats

**Schema Sample (first 50 lines):**
```sql
CREATE TABLE query_log (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
    query TEXT NOT NULL,
    profile TEXT,
    result_count INTEGER,
    latency_ms REAL,
    user TEXT,
    session_id TEXT
);
CREATE TABLE sqlite_sequence(name,seq);
CREATE TABLE query_stats (
    query_pattern TEXT PRIMARY KEY,
    count INTEGER DEFAULT 1,
    avg_latency_ms REAL,
    last_searched DATETIME,
    success_rate REAL
);
CREATE INDEX idx_timestamp ON query_log(timestamp);
CREATE INDEX idx_query ON query_log(query);
```

---

#### Database: `./.repair-snapshots/20251120_204830/windows_mirror_backup/.search-index/chunks.db`

**File Stats:**
-rwxrwxrwx 1 groklygroup groklygroup 36K Aug 16 13:31 ./.repair-snapshots/20251120_204830/windows_mirror_backup/.search-index/chunks.db

**Size:** 36K

**Modified:** 2025-08-16 13:31:57.000000000 -0700

**Accessed:** 2025-11-23 02:12:49.118130100 -0800

**Tables:**
chunks_fts          chunks_fts_data     chunks_fts_idx    
chunks_fts_config   chunks_fts_docsize  file_chunks       

**Schema Sample (first 50 lines):**
```sql
CREATE TABLE file_chunks (
    chunk_id TEXT PRIMARY KEY,
    doc_id TEXT,
    chunk_index INTEGER,
    start_offset INTEGER,
    end_offset INTEGER,
    content_preview TEXT,
    chunk_hash TEXT,
    indexed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(doc_id, chunk_index)
);
CREATE VIRTUAL TABLE chunks_fts USING fts5(
    chunk_id,
    content,
    content=file_chunks
)
/* chunks_fts(chunk_id,content) */;
CREATE TABLE IF NOT EXISTS 'chunks_fts_data'(id INTEGER PRIMARY KEY, block BLOB);
CREATE TABLE IF NOT EXISTS 'chunks_fts_idx'(segid, term, pgno, PRIMARY KEY(segid, term)) WITHOUT ROWID;
CREATE TABLE IF NOT EXISTS 'chunks_fts_docsize'(id INTEGER PRIMARY KEY, sz BLOB);
CREATE TABLE IF NOT EXISTS 'chunks_fts_config'(k PRIMARY KEY, v) WITHOUT ROWID;
CREATE INDEX idx_doc_chunk ON file_chunks(doc_id, chunk_index);
```

---

#### Database: `./.repair-snapshots/20251120_204830/windows_mirror_backup/.search-index/media.db`

**File Stats:**
-rwxrwxrwx 1 groklygroup groklygroup 32K Aug 16 13:31 ./.repair-snapshots/20251120_204830/windows_mirror_backup/.search-index/media.db

**Size:** 32K

**Modified:** 2025-08-16 13:31:58.000000000 -0700

**Accessed:** 2025-11-23 02:12:50.123566800 -0800

**Tables:**
media_metadata          media_text_fts_content  media_text_fts_idx    
media_text_fts          media_text_fts_data   
media_text_fts_config   media_text_fts_docsize

**Schema Sample (first 50 lines):**
```sql
CREATE TABLE media_metadata (
    doc_id TEXT PRIMARY KEY,
    duration REAL,
    dimensions TEXT,
    codec TEXT,
    bitrate INTEGER,
    extracted_text TEXT,
    tags JSON,
    thumbnails JSON,
    indexed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE VIRTUAL TABLE media_text_fts USING fts5(
    doc_id,
    extracted_text,
    tags
)
/* media_text_fts(doc_id,extracted_text,tags) */;
CREATE TABLE IF NOT EXISTS 'media_text_fts_data'(id INTEGER PRIMARY KEY, block BLOB);
CREATE TABLE IF NOT EXISTS 'media_text_fts_idx'(segid, term, pgno, PRIMARY KEY(segid, term)) WITHOUT ROWID;
CREATE TABLE IF NOT EXISTS 'media_text_fts_content'(id INTEGER PRIMARY KEY, c0, c1, c2);
CREATE TABLE IF NOT EXISTS 'media_text_fts_docsize'(id INTEGER PRIMARY KEY, sz BLOB);
CREATE TABLE IF NOT EXISTS 'media_text_fts_config'(k PRIMARY KEY, v) WITHOUT ROWID;
```

---

#### Database: `./.repair-snapshots/20251120_204830/windows_mirror_backup/.search-index/metadata.db`

**File Stats:**
-rwxrwxrwx 1 groklygroup groklygroup 784K Nov  4 22:22 ./.repair-snapshots/20251120_204830/windows_mirror_backup/.search-index/metadata.db

**Size:** 784K

**Modified:** 2025-11-04 22:22:15.000000000 -0800

**Accessed:** 2025-11-23 02:12:54.946823600 -0800

**Tables:**
file_registry

**Schema Sample (first 50 lines):**
```sql
CREATE TABLE file_registry (
    doc_id TEXT PRIMARY KEY,
    file_path TEXT NOT NULL UNIQUE,
    content_hash TEXT,
    file_size INTEGER,
    index_tier INTEGER,
    mime_type TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    metadata JSON
, tags TEXT DEFAULT '[]', keywords TEXT DEFAULT '[]', topics TEXT DEFAULT '[]', language TEXT, dependencies TEXT DEFAULT '[]', imports TEXT DEFAULT '[]', exports TEXT DEFAULT '[]', last_analyzed TIMESTAMP);
CREATE INDEX idx_file_path ON file_registry(file_path);
CREATE INDEX idx_tier ON file_registry(index_tier);
CREATE INDEX idx_size ON file_registry(file_size);
```

---

#### Database: `./.repair-snapshots/20251120_204830/windows_mirror_backup/.search-index/search.db`

**File Stats:**
-rwxrwxrwx 1 groklygroup groklygroup 0 Aug 16 13:59 ./.repair-snapshots/20251120_204830/windows_mirror_backup/.search-index/search.db

**Size:** 0

**Modified:** 2025-08-16 13:59:21.000000000 -0700

**Accessed:** 2025-11-20 23:19:58.742568600 -0800

**Tables:**

**Schema Sample (first 50 lines):**
```sql
```

---

#### Database: `./.repair-snapshots/20251120_204830/windows_mirror_backup/.search-index/tags.db`

**File Stats:**
-rwxrwxrwx 1 groklygroup groklygroup 64K Aug 16 13:59 ./.repair-snapshots/20251120_204830/windows_mirror_backup/.search-index/tags.db

**Size:** 64K

**Modified:** 2025-08-16 13:59:22.000000000 -0700

**Accessed:** 2025-11-23 02:12:54.493371400 -0800

**Tables:**
file_relationships  file_tags           keyword_cache       tags              

**Schema Sample (first 50 lines):**
```sql
CREATE TABLE tags (
    tag_id INTEGER PRIMARY KEY AUTOINCREMENT,
    tag_name TEXT UNIQUE NOT NULL,
    tag_type TEXT, -- keyword, topic, technology, etc.
    usage_count INTEGER DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE sqlite_sequence(name,seq);
CREATE TABLE file_tags (
    doc_id TEXT,
    tag_id INTEGER,
    relevance_score REAL DEFAULT 1.0,
    context TEXT, -- where/how the tag appears
    PRIMARY KEY (doc_id, tag_id),
    FOREIGN KEY (tag_id) REFERENCES tags(tag_id)
);
CREATE TABLE file_relationships (
    source_doc_id TEXT,
    target_doc_id TEXT,
    relationship_type TEXT, -- imports, includes, references, similar_to
    strength REAL DEFAULT 1.0,
    metadata JSON,
    discovered_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (source_doc_id, target_doc_id, relationship_type)
);
CREATE TABLE keyword_cache (
    doc_id TEXT PRIMARY KEY,
    keywords JSON,
    topics JSON,
    entities JSON,
    extracted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX idx_tag_name ON tags(tag_name);
CREATE INDEX idx_file_tag ON file_tags(doc_id);
CREATE INDEX idx_tag_file ON file_tags(tag_id);
CREATE INDEX idx_rel_source ON file_relationships(source_doc_id);
CREATE INDEX idx_rel_target ON file_relationships(target_doc_id);
CREATE INDEX idx_rel_type ON file_relationships(relationship_type);
```

---

#### Database: `./.repair-snapshots/20251120_204830/windows_mirror_backup/.session-data/misc/chat_sessions.db`

**File Stats:**
-rwxrwxrwx 1 groklygroup groklygroup 64K Jul 24 15:30 ./.repair-snapshots/20251120_204830/windows_mirror_backup/.session-data/misc/chat_sessions.db

**Size:** 64K

**Modified:** 2025-07-24 15:30:43.000000000 -0700

**Accessed:** 2025-11-23 02:13:39.842333900 -0800

**Tables:**
chat_sessions

**Schema Sample (first 50 lines):**
```sql
CREATE TABLE chat_sessions (
    session_id TEXT PRIMARY KEY,
    file_path TEXT NOT NULL,
    start_time TEXT,
    end_time TEXT,
    line_count INTEGER,
    size_bytes INTEGER,
    project TEXT,
    extracted_from TEXT,
    metadata TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX idx_project ON chat_sessions(project);
CREATE INDEX idx_start_time ON chat_sessions(start_time);
```

---

#### Database: `./.repair-snapshots/20251120_204830/windows_mirror_backup/.session-data/misc/claude_sessions.db`

**File Stats:**
-rwxrwxrwx 1 groklygroup groklygroup 24K Jul 22 00:00 ./.repair-snapshots/20251120_204830/windows_mirror_backup/.session-data/misc/claude_sessions.db

**Size:** 24K

**Modified:** 2025-07-22 00:00:22.000000000 -0700

**Accessed:** 2025-11-23 02:14:02.827900300 -0800

**Tables:**
claude_sessions

**Schema Sample (first 50 lines):**
```sql
CREATE TABLE claude_sessions (
    session_id TEXT PRIMARY KEY,
    project TEXT NOT NULL,
    worktree_path TEXT NOT NULL,
    branch TEXT NOT NULL,
    status TEXT DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_active TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    tmux_session TEXT,
    pid INTEGER,
    metadata TEXT
);
CREATE INDEX idx_project ON claude_sessions(project);
CREATE INDEX idx_status ON claude_sessions(status);
CREATE INDEX idx_tmux ON claude_sessions(tmux_session);
```

---

#### Database: `./.repair-snapshots/20251120_204830/windows_mirror_backup/.session-management/sessions.db`

**File Stats:**
-rwxrwxrwx 1 groklygroup groklygroup 100K Jul 24 04:28 ./.repair-snapshots/20251120_204830/windows_mirror_backup/.session-management/sessions.db

**Size:** 100K

**Modified:** 2025-07-24 04:28:28.000000000 -0700

**Accessed:** 2025-11-23 02:23:19.196833000 -0800

**Tables:**
backup_status   sessions_full   sessions_quick

**Schema Sample (first 50 lines):**
```sql
CREATE TABLE sessions_quick (
    session_id TEXT PRIMARY KEY,
    timestamp DATETIME DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE sessions_full (
    session_id TEXT PRIMARY KEY,
    timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
    project TEXT,
    summary TEXT,
    completed_tasks TEXT,  -- JSON array of completed tasks
    pending_tasks TEXT,    -- JSON array of pending tasks
    modified_files TEXT,   -- JSON array of modified file paths
    critical_notes TEXT,
    tmux_session TEXT,
    chat_backup_path TEXT,
    line_count INTEGER DEFAULT 0
);
CREATE TABLE backup_status (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    session_id TEXT NOT NULL,
    backup_timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
    status TEXT CHECK(status IN ('active', 'completed', 'failed', 'warning')) DEFAULT 'active',
    file_path TEXT,
    file_size_bytes INTEGER,
    last_update DATETIME DEFAULT CURRENT_TIMESTAMP,
    error_message TEXT,
    FOREIGN KEY (session_id) REFERENCES sessions_full(session_id)
);
CREATE TABLE sqlite_sequence(name,seq);
CREATE INDEX idx_sessions_quick_timestamp ON sessions_quick(timestamp DESC);
CREATE INDEX idx_sessions_full_timestamp ON sessions_full(timestamp DESC);
CREATE INDEX idx_sessions_full_project ON sessions_full(project);
CREATE INDEX idx_backup_status_session_id ON backup_status(session_id);
CREATE INDEX idx_backup_status_status ON backup_status(status);
CREATE INDEX idx_backup_status_timestamp ON backup_status(backup_timestamp DESC);
CREATE TRIGGER update_backup_status_timestamp 
AFTER UPDATE ON backup_status
BEGIN
    UPDATE backup_status 
    SET last_update = CURRENT_TIMESTAMP 
    WHERE id = NEW.id;
END;
```

---

#### Database: `./.repair-snapshots/20251120_204830/windows_mirror_backup/.session-management/sessions_replica.db`

**File Stats:**
-rwxrwxrwx 1 groklygroup groklygroup 100K Jul 24 04:28 ./.repair-snapshots/20251120_204830/windows_mirror_backup/.session-management/sessions_replica.db

**Size:** 100K

**Modified:** 2025-07-24 04:28:28.000000000 -0700

**Accessed:** 2025-11-23 02:23:21.998968600 -0800

**Tables:**
backup_status   sessions_full   sessions_quick

**Schema Sample (first 50 lines):**
```sql
CREATE TABLE sessions_quick (
    session_id TEXT PRIMARY KEY,
    timestamp DATETIME DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE sessions_full (
    session_id TEXT PRIMARY KEY,
    timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
    project TEXT,
    summary TEXT,
    completed_tasks TEXT,  -- JSON array of completed tasks
    pending_tasks TEXT,    -- JSON array of pending tasks
    modified_files TEXT,   -- JSON array of modified file paths
    critical_notes TEXT,
    tmux_session TEXT,
    chat_backup_path TEXT,
    line_count INTEGER DEFAULT 0
);
CREATE TABLE backup_status (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    session_id TEXT NOT NULL,
    backup_timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
    status TEXT CHECK(status IN ('active', 'completed', 'failed', 'warning')) DEFAULT 'active',
    file_path TEXT,
    file_size_bytes INTEGER,
    last_update DATETIME DEFAULT CURRENT_TIMESTAMP,
    error_message TEXT,
    FOREIGN KEY (session_id) REFERENCES sessions_full(session_id)
);
CREATE TABLE sqlite_sequence(name,seq);
CREATE INDEX idx_sessions_quick_timestamp ON sessions_quick(timestamp DESC);
CREATE INDEX idx_sessions_full_timestamp ON sessions_full(timestamp DESC);
CREATE INDEX idx_sessions_full_project ON sessions_full(project);
CREATE INDEX idx_backup_status_session_id ON backup_status(session_id);
CREATE INDEX idx_backup_status_status ON backup_status(status);
CREATE INDEX idx_backup_status_timestamp ON backup_status(backup_timestamp DESC);
CREATE TRIGGER update_backup_status_timestamp 
AFTER UPDATE ON backup_status
BEGIN
    UPDATE backup_status 
    SET last_update = CURRENT_TIMESTAMP 
    WHERE id = NEW.id;
END;
```

---

#### Database: `./.repair-snapshots/20251120_204830/windows_mirror_backup/.test-environment/.index-system/database/file-index-test.db`

**File Stats:**
-rwxrwxrwx 1 groklygroup groklygroup 0 Sep  3 11:47 ./.repair-snapshots/20251120_204830/windows_mirror_backup/.test-environment/.index-system/database/file-index-test.db

**Size:** 0

**Modified:** 2025-09-03 11:47:05.000000000 -0700

**Accessed:** 2025-11-20 23:21:05.414501400 -0800

**Tables:**

**Schema Sample (first 50 lines):**
```sql
```

---

#### Database: `./.repair-snapshots/20251120_204830/windows_mirror_backup/.test-environment/.quantum-todo/quantum-test.db`

**File Stats:**
-rwxrwxrwx 1 groklygroup groklygroup 100K Sep  3 11:47 ./.repair-snapshots/20251120_204830/windows_mirror_backup/.test-environment/.quantum-todo/quantum-test.db

**Size:** 100K

**Modified:** 2025-09-03 11:47:05.000000000 -0700

**Accessed:** 2025-11-23 02:23:51.008322700 -0800

**Tables:**
quantum_fts        quantum_todos      todo_dependencies

**Schema Sample (first 50 lines):**
```sql
CREATE TABLE quantum_todos(
  id TEXT,
  content TEXT,
  status TEXT,
  priority TEXT,
  source TEXT,
  created_at NUM,
  completed_at NUM,
  session_id TEXT,
  tags TEXT,
  quantum_state TEXT,
  dependency_status TEXT,
  dependency_chain_length INT
);
CREATE TABLE todo_dependencies(
  id INT,
  todo_id TEXT,
  depends_on_id TEXT,
  dependency_type TEXT,
  created_at NUM
);
CREATE TABLE quantum_fts(content);
```

---

#### Database: `./.repair-snapshots/20251120_204830/windows_mirror_backup/.test-environment/checkpoints/checkpoint-20250903-222519-initial/index-db-backup.db`

**File Stats:**
-rwxrwxrwx 1 groklygroup groklygroup 0 Sep  3 22:26 ./.repair-snapshots/20251120_204830/windows_mirror_backup/.test-environment/checkpoints/checkpoint-20250903-222519-initial/index-db-backup.db

**Size:** 0

**Modified:** 2025-09-03 22:26:24.000000000 -0700

**Accessed:** 2025-11-20 23:21:37.731059100 -0800

**Tables:**

**Schema Sample (first 50 lines):**
```sql
```

---

#### Database: `./.repair-snapshots/20251120_204830/windows_mirror_backup/.test-environment/checkpoints/checkpoint-20250903-222519-initial/quantum-db-backup.db`

**File Stats:**
-rwxrwxrwx 1 groklygroup groklygroup 38M Sep  3 22:26 ./.repair-snapshots/20251120_204830/windows_mirror_backup/.test-environment/checkpoints/checkpoint-20250903-222519-initial/quantum-db-backup.db

**Size:** 38M

**Modified:** 2025-09-03 22:26:25.000000000 -0700

**Accessed:** 2025-11-23 02:29:26.779137900 -0800

**Tables:**
quantum_fts          quantum_fts_docsize  todo_dependencies  
quantum_fts_config   quantum_fts_idx    
quantum_fts_data     quantum_todos      

**Schema Sample (first 50 lines):**
```sql
CREATE TABLE quantum_todos (
    id TEXT PRIMARY KEY,
    content TEXT NOT NULL,
    status TEXT NOT NULL DEFAULT 'pending',
    priority TEXT NOT NULL DEFAULT 'medium',
    source TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    completed_at TIMESTAMP,
    session_id TEXT,
    tags TEXT,
    quantum_state TEXT DEFAULT 'superposition',
    dependency_status TEXT DEFAULT 'ready',
    dependency_chain_length INTEGER DEFAULT 0
);
CREATE TABLE todo_dependencies (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    todo_id TEXT NOT NULL,
    depends_on_id TEXT NOT NULL,
    dependency_type TEXT DEFAULT 'blocks',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (todo_id) REFERENCES quantum_todos (id),
    FOREIGN KEY (depends_on_id) REFERENCES quantum_todos (id),
    UNIQUE(todo_id, depends_on_id)
);
CREATE TABLE sqlite_sequence(name,seq);
CREATE INDEX idx_status ON quantum_todos(status);
CREATE INDEX idx_priority ON quantum_todos(priority);
CREATE INDEX idx_dependency_status ON quantum_todos(dependency_status);
CREATE INDEX idx_dependency_todo ON todo_dependencies(todo_id);
CREATE INDEX idx_dependency_depends ON todo_dependencies(depends_on_id);
CREATE VIRTUAL TABLE quantum_fts USING fts5(content, content=quantum_todos)
/* quantum_fts(content) */;
CREATE TABLE IF NOT EXISTS 'quantum_fts_data'(id INTEGER PRIMARY KEY, block BLOB);
CREATE TABLE IF NOT EXISTS 'quantum_fts_idx'(segid, term, pgno, PRIMARY KEY(segid, term)) WITHOUT ROWID;
CREATE TABLE IF NOT EXISTS 'quantum_fts_docsize'(id INTEGER PRIMARY KEY, sz BLOB);
CREATE TABLE IF NOT EXISTS 'quantum_fts_config'(k PRIMARY KEY, v) WITHOUT ROWID;
```

---

#### Database: `./.repair-snapshots/20251120_204830/windows_mirror_backup/.universal-history/universal-history.db`

**File Stats:**
-rwxrwxrwx 1 groklygroup groklygroup 0 Aug  8 23:56 ./.repair-snapshots/20251120_204830/windows_mirror_backup/.universal-history/universal-history.db

**Size:** 0

**Modified:** 2025-08-08 23:56:03.000000000 -0700

**Accessed:** 2025-11-21 00:27:58.512430300 -0800

**Tables:**

**Schema Sample (first 50 lines):**
```sql
```

---

#### Database: `./.repair-snapshots/20251120_204830/windows_mirror_backup/.universal-index/claude-memory.db`

**File Stats:**
-rwxrwxrwx 1 groklygroup groklygroup 68K Oct 12 03:44 ./.repair-snapshots/20251120_204830/windows_mirror_backup/.universal-index/claude-memory.db

**Size:** 68K

**Modified:** 2025-10-12 03:44:52.000000000 -0700

**Accessed:** 2025-11-23 02:55:49.333709300 -0800

**Tables:**
claude_memory_index    content_relationships  usage_analytics      

**Schema Sample (first 50 lines):**
```sql
CREATE TABLE claude_memory_index (
    file_hash TEXT PRIMARY KEY,
    brain_id TEXT UNIQUE,
    category TEXT NOT NULL,
    file_path TEXT NOT NULL,
    inheritance_level INTEGER NOT NULL,
    priority TEXT NOT NULL,
    content_types TEXT NOT NULL,
    line_count INTEGER,
    token_count INTEGER,
    last_modified TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    full_text_content TEXT,
    metadata_json TEXT,
    dependencies TEXT,
    usage_frequency INTEGER DEFAULT 0,
    context_triggers TEXT
);
CREATE INDEX idx_category ON claude_memory_index(category);
CREATE INDEX idx_brain_id ON claude_memory_index(brain_id);
CREATE INDEX idx_inheritance ON claude_memory_index(inheritance_level);
CREATE INDEX idx_priority ON claude_memory_index(priority);
CREATE INDEX idx_modified ON claude_memory_index(last_modified);
CREATE TABLE content_relationships (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    source_brain_id TEXT NOT NULL,
    target_brain_id TEXT NOT NULL,
    relationship_type TEXT NOT NULL,
    strength REAL DEFAULT 1.0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (source_brain_id) REFERENCES claude_memory_index(brain_id),
    FOREIGN KEY (target_brain_id) REFERENCES claude_memory_index(brain_id)
);
CREATE TABLE sqlite_sequence(name,seq);
CREATE INDEX idx_relationships ON content_relationships(source_brain_id, target_brain_id);
CREATE TABLE usage_analytics (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    brain_id TEXT NOT NULL,
    context_type TEXT NOT NULL,
    access_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    user_intent TEXT,
    loading_time_ms INTEGER,
    effectiveness_score REAL,
    FOREIGN KEY (brain_id) REFERENCES claude_memory_index(brain_id)
);
CREATE INDEX idx_usage_analytics ON usage_analytics(brain_id, access_timestamp);
```

---

#### Database: `./.repair-snapshots/20251120_204830/windows_mirror_backup/.universal-index/file-index.db`

**File Stats:**
-rwxrwxrwx 1 groklygroup groklygroup 24K Nov  9 02:04 ./.repair-snapshots/20251120_204830/windows_mirror_backup/.universal-index/file-index.db

**Size:** 24K

**Modified:** 2025-11-09 02:04:15.000000000 -0800

**Accessed:** 2025-11-23 02:55:50.175290400 -0800

**Tables:**
file_index

**Schema Sample (first 50 lines):**
```sql
CREATE TABLE file_index (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    file_path TEXT UNIQUE NOT NULL,
    file_name TEXT NOT NULL,
    file_type TEXT,
    file_hash TEXT,
    file_size INTEGER,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    modified_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    indexed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE sqlite_sequence(name,seq);
CREATE INDEX idx_file_path ON file_index(file_path);
CREATE INDEX idx_file_type ON file_index(file_type);
```

---

#### Database: `./.repair-snapshots/20251120_204830/windows_mirror_backup/.universal-nl/patterns/master.db`

**File Stats:**
-rwxrwxrwx 1 groklygroup groklygroup 40K Jul  9 01:26 ./.repair-snapshots/20251120_204830/windows_mirror_backup/.universal-nl/patterns/master.db

**Size:** 40K

**Modified:** 2025-07-09 01:26:16.000000000 -0700

**Accessed:** 2025-11-23 02:59:38.810924400 -0800

**Tables:**
edge_cases  patterns    synonyms  

**Schema Sample (first 50 lines):**
```sql
CREATE TABLE patterns (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    pattern TEXT NOT NULL,
    command TEXT NOT NULL,
    category TEXT,
    confidence REAL DEFAULT 1.0,
    usage_count INTEGER DEFAULT 0,
    last_used TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    quantum_hash TEXT,
    context_tags TEXT
);
CREATE TABLE sqlite_sequence(name,seq);
CREATE TABLE synonyms (
    word TEXT PRIMARY KEY,
    canonical TEXT NOT NULL,
    weight REAL DEFAULT 1.0
);
CREATE TABLE edge_cases (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    input TEXT NOT NULL,
    expected_output TEXT NOT NULL,
    actual_output TEXT,
    resolved BOOLEAN DEFAULT 0,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX idx_patterns_usage ON patterns(usage_count DESC);
CREATE INDEX idx_patterns_confidence ON patterns(confidence DESC);
```

---

#### Database: `./.repair-snapshots/20251120_204830/windows_mirror_backup/braincraft/CLAUDE-BRAINCRAFT-SYSTEM-v5.0.0/05_PROJECTS/CAPTURED_DATA/captures.db`

**File Stats:**
-rwxrwxrwx 1 groklygroup groklygroup 2.9M Jun 29 20:46 ./.repair-snapshots/20251120_204830/windows_mirror_backup/braincraft/CLAUDE-BRAINCRAFT-SYSTEM-v5.0.0/05_PROJECTS/CAPTURED_DATA/captures.db

**Size:** 2.9M

**Modified:** 2025-06-29 20:46:21.000000000 -0700

**Accessed:** 2025-11-23 04:28:48.041524200 -0800

**Tables:**
artifacts                   file_relationships        
conversation_relationships  message_documents         
conversations               messages                  
documents                 

**Schema Sample (first 50 lines):**
```sql
CREATE TABLE conversations (
                id TEXT PRIMARY KEY,
                created_at TIMESTAMP,
                updated_at TIMESTAMP,
                url TEXT,
                title TEXT,
                metadata TEXT
            , message_count INTEGER DEFAULT 0, artifact_count INTEGER DEFAULT 0, capture_method TEXT DEFAULT 'unknown');
CREATE TABLE messages (
                id TEXT PRIMARY KEY,
                conversation_id TEXT,
                role TEXT,
                content TEXT,
                timestamp TIMESTAMP,
                type TEXT,
                metadata TEXT, sequence_number INTEGER DEFAULT 0, created_at TEXT,
                FOREIGN KEY (conversation_id) REFERENCES conversations(id)
            );
CREATE TABLE documents (
                id TEXT PRIMARY KEY,
                conversation_id TEXT,
                name TEXT,
                size INTEGER,
                type TEXT,
                file_type TEXT,
                extension TEXT,
                local_path TEXT,
                upload_timestamp TIMESTAMP,
                file_hash TEXT,
                source TEXT,  -- 'user_upload', 'claude_generated', 'attachment'
                metadata TEXT,
                FOREIGN KEY (conversation_id) REFERENCES conversations(id)
            );
CREATE TABLE message_documents (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                message_id TEXT,
                document_id TEXT,
                relationship_type TEXT,  -- 'input', 'output', 'reference'
                created_at TIMESTAMP,
                FOREIGN KEY (message_id) REFERENCES messages(id),
                FOREIGN KEY (document_id) REFERENCES documents(id)
            );
CREATE TABLE sqlite_sequence(name,seq);
CREATE TABLE conversation_relationships (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                source_conversation_id TEXT,
                target_conversation_id TEXT,
                relationship_type TEXT,  -- 'continuation', 'fork', 'reference'
                created_at TIMESTAMP,
                metadata TEXT,
```

---

#### Database: `./.repair-snapshots/20251120_204830/windows_mirror_backup/braincraft/CLAUDE-BRAINCRAFT-SYSTEM-v5.0.0/05_PROJECTS/CAPTURED_DATA/fingerprints.db`

**File Stats:**
-rwxrwxrwx 1 groklygroup groklygroup 36K Jun 16 11:32 ./.repair-snapshots/20251120_204830/windows_mirror_backup/braincraft/CLAUDE-BRAINCRAFT-SYSTEM-v5.0.0/05_PROJECTS/CAPTURED_DATA/fingerprints.db

**Size:** 36K

**Modified:** 2025-06-16 11:32:32.000000000 -0700

**Accessed:** 2025-11-23 04:28:45.955050900 -0800

**Tables:**
content_chunks     file_fingerprints  path_history     

**Schema Sample (first 50 lines):**
```sql
CREATE TABLE file_fingerprints (
                fingerprint_id TEXT PRIMARY KEY,
                file_hash TEXT NOT NULL,
                content_hash TEXT,
                metadata_hash TEXT,
                file_size INTEGER,
                mime_type TEXT,
                original_name TEXT,
                original_path TEXT,
                current_path TEXT,
                first_seen TIMESTAMP,
                last_seen TIMESTAMP,
                last_verified TIMESTAMP,
                move_count INTEGER DEFAULT 0,
                access_count INTEGER DEFAULT 0,
                metadata TEXT
            );
CREATE TABLE path_history (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                fingerprint_id TEXT,
                path TEXT,
                name TEXT,
                detected_at TIMESTAMP,
                action TEXT,  -- 'created', 'moved', 'renamed', 'deleted'
                FOREIGN KEY (fingerprint_id) REFERENCES file_fingerprints(fingerprint_id)
            );
CREATE TABLE sqlite_sequence(name,seq);
CREATE TABLE content_chunks (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                fingerprint_id TEXT,
                chunk_index INTEGER,
                chunk_hash TEXT,
                chunk_size INTEGER,
                FOREIGN KEY (fingerprint_id) REFERENCES file_fingerprints(fingerprint_id)
            );
CREATE INDEX idx_file_hash ON file_fingerprints(file_hash);
CREATE INDEX idx_content_hash ON file_fingerprints(content_hash);
CREATE INDEX idx_current_path ON file_fingerprints(current_path);
```

---

#### Database: `./.repair-snapshots/20251120_204830/windows_mirror_backup/braincraft/C:Usersjdhclaude_projectsbraincraftCLAUDE-BRAINCRAFT-SYSTEM-v5.0.005_PROJECTSCAPTURED_DATAcaptures.db`

**File Stats:**

**Size:**

**Modified:**

**Accessed:**

**Tables:**

**Schema Sample (first 50 lines):**
```sql
```

---

#### Database: `./.repair-snapshots/20251120_204830/windows_mirror_backup/braincraft/simple_captures.db`

**File Stats:**
-rwxrwxrwx 1 groklygroup groklygroup 12K Jun 28 19:11 ./.repair-snapshots/20251120_204830/windows_mirror_backup/braincraft/simple_captures.db

**Size:** 12K

**Modified:** 2025-06-28 19:11:29.000000000 -0700

**Accessed:** 2025-11-23 04:28:37.683056700 -0800

**Tables:**
captures

**Schema Sample (first 50 lines):**
```sql
CREATE TABLE captures (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            content TEXT,
            timestamp TEXT
        );
CREATE TABLE sqlite_sequence(name,seq);
```

---

#### Database: `./.repair-snapshots/20251120_204830/windows_mirror_backup/chrome-debug-profile/Default/heavy_ad_intervention_opt_out.db`

**File Stats:**
-rwxrwxrwx 1 groklygroup groklygroup 16K May  4  2025 ./.repair-snapshots/20251120_204830/windows_mirror_backup/chrome-debug-profile/Default/heavy_ad_intervention_opt_out.db

**Size:** 16K

**Modified:** 2025-05-04 04:54:17.000000000 -0700

**Accessed:** 2025-11-23 04:37:05.043260800 -0800

**Tables:**
enabled_previews_v1  previews_v1        

**Schema Sample (first 50 lines):**
```sql
CREATE TABLE previews_v1 (host_name VARCHAR NOT NULL, time INTEGER NOT NULL, opt_out INTEGER NOT NULL, type INTEGER NOT NULL, PRIMARY KEY(host_name, time DESC, opt_out, type));
CREATE TABLE enabled_previews_v1 (type INTEGER NOT NULL, version INTEGER NOT NULL, PRIMARY KEY(type));
```

---

#### Database: `./.repair-snapshots/20251120_204830/windows_mirror_backup/chrome-debug-profile/first_party_sets.db`

**File Stats:**
-rwxrwxrwx 1 groklygroup groklygroup 48K May  4  2025 ./.repair-snapshots/20251120_204830/windows_mirror_backup/chrome-debug-profile/first_party_sets.db

**Size:** 48K

**Modified:** 2025-05-04 06:44:33.000000000 -0700

**Accessed:** 2025-11-23 04:37:16.624225200 -0800

**Tables:**
browser_context_sets_version    meta                          
browser_context_sites_to_clear  policy_configurations         
browser_contexts_cleared        public_sets                   
manual_configurations         

**Schema Sample (first 50 lines):**
```sql
CREATE TABLE meta(key LONGVARCHAR NOT NULL UNIQUE PRIMARY KEY, value LONGVARCHAR);
CREATE TABLE public_sets(version TEXT NOT NULL,site TEXT NOT NULL,primary_site TEXT NOT NULL,site_type INTEGER NOT NULL,PRIMARY KEY(version,site))WITHOUT ROWID;
CREATE TABLE browser_context_sets_version(browser_context_id TEXT PRIMARY KEY NOT NULL,public_sets_version TEXT NOT NULL)WITHOUT ROWID;
CREATE INDEX idx_public_sets_version_browser_contexts ON browser_context_sets_version(public_sets_version);
CREATE TABLE browser_context_sites_to_clear(browser_context_id TEXT NOT NULL,site TEXT NOT NULL,marked_at_run INTEGER NOT NULL,PRIMARY KEY(browser_context_id,site))WITHOUT ROWID;
CREATE INDEX idx_marked_at_run_sites ON browser_context_sites_to_clear(marked_at_run);
CREATE TABLE browser_contexts_cleared(browser_context_id TEXT PRIMARY KEY NOT NULL,cleared_at_run INTEGER NOT NULL)WITHOUT ROWID;
CREATE INDEX idx_cleared_at_run_browser_contexts ON browser_contexts_cleared(cleared_at_run);
CREATE TABLE policy_configurations(browser_context_id TEXT NOT NULL,site TEXT NOT NULL,primary_site TEXT,PRIMARY KEY(browser_context_id,site))WITHOUT ROWID;
CREATE TABLE manual_configurations(browser_context_id TEXT NOT NULL,site TEXT NOT NULL,primary_site TEXT,site_type INTEGER,PRIMARY KEY(browser_context_id,site))WITHOUT ROWID;
```

---

#### Database: `./.repair-snapshots/20251120_204830/windows_mirror_backup/ClaudeNavigatorOrganizer/claude_project_sync/chrome_data/botclaude/heavy_ad_intervention_opt_out.db`

**File Stats:**
-rwxrwxrwx 1 groklygroup groklygroup 16K May  4  2025 ./.repair-snapshots/20251120_204830/windows_mirror_backup/ClaudeNavigatorOrganizer/claude_project_sync/chrome_data/botclaude/heavy_ad_intervention_opt_out.db

**Size:** 16K

**Modified:** 2025-05-04 03:48:03.000000000 -0700

**Accessed:** 2025-11-23 04:43:08.490390200 -0800

**Tables:**
enabled_previews_v1  previews_v1        

**Schema Sample (first 50 lines):**
```sql
CREATE TABLE previews_v1 (host_name VARCHAR NOT NULL, time INTEGER NOT NULL, opt_out INTEGER NOT NULL, type INTEGER NOT NULL, PRIMARY KEY(host_name, time DESC, opt_out, type));
CREATE TABLE enabled_previews_v1 (type INTEGER NOT NULL, version INTEGER NOT NULL, PRIMARY KEY(type));
```

---

#### Database: `./.repair-snapshots/20251120_204830/windows_mirror_backup/ClaudeNavigatorOrganizer/claude_project_sync/chrome_data/first_party_sets.db`

**File Stats:**
-rwxrwxrwx 1 groklygroup groklygroup 48K May  4  2025 ./.repair-snapshots/20251120_204830/windows_mirror_backup/ClaudeNavigatorOrganizer/claude_project_sync/chrome_data/first_party_sets.db

**Size:** 48K

**Modified:** 2025-05-04 03:49:36.000000000 -0700

**Accessed:** 2025-11-23 04:43:02.235280500 -0800

**Tables:**
browser_context_sets_version    meta                          
browser_context_sites_to_clear  policy_configurations         
browser_contexts_cleared        public_sets                   
manual_configurations         

**Schema Sample (first 50 lines):**
```sql
CREATE TABLE meta(key LONGVARCHAR NOT NULL UNIQUE PRIMARY KEY, value LONGVARCHAR);
CREATE TABLE public_sets(version TEXT NOT NULL,site TEXT NOT NULL,primary_site TEXT NOT NULL,site_type INTEGER NOT NULL,PRIMARY KEY(version,site))WITHOUT ROWID;
CREATE TABLE browser_context_sets_version(browser_context_id TEXT PRIMARY KEY NOT NULL,public_sets_version TEXT NOT NULL)WITHOUT ROWID;
CREATE INDEX idx_public_sets_version_browser_contexts ON browser_context_sets_version(public_sets_version);
CREATE TABLE browser_context_sites_to_clear(browser_context_id TEXT NOT NULL,site TEXT NOT NULL,marked_at_run INTEGER NOT NULL,PRIMARY KEY(browser_context_id,site))WITHOUT ROWID;
CREATE INDEX idx_marked_at_run_sites ON browser_context_sites_to_clear(marked_at_run);
CREATE TABLE browser_contexts_cleared(browser_context_id TEXT PRIMARY KEY NOT NULL,cleared_at_run INTEGER NOT NULL)WITHOUT ROWID;
CREATE INDEX idx_cleared_at_run_browser_contexts ON browser_contexts_cleared(cleared_at_run);
CREATE TABLE policy_configurations(browser_context_id TEXT NOT NULL,site TEXT NOT NULL,primary_site TEXT,PRIMARY KEY(browser_context_id,site))WITHOUT ROWID;
CREATE TABLE manual_configurations(browser_context_id TEXT NOT NULL,site TEXT NOT NULL,primary_site TEXT,site_type INTEGER,PRIMARY KEY(browser_context_id,site))WITHOUT ROWID;
```

---

#### Database: `./.repair-snapshots/20251120_204830/windows_mirror_backup/claude_projects_backups/database/file-index.db`

**File Stats:**
-rwxrwxrwx 1 groklygroup groklygroup 0 Sep  5 20:13 ./.repair-snapshots/20251120_204830/windows_mirror_backup/claude_projects_backups/database/file-index.db

**Size:** 0

**Modified:** 2025-09-05 20:13:17.000000000 -0700

**Accessed:** 2025-09-05 20:13:17.000000000 -0700

**Tables:**

**Schema Sample (first 50 lines):**
```sql
```

---

#### Database: `./.repair-snapshots/20251120_204830/windows_mirror_backup/claude_projects_backups/file-index.db`

**File Stats:**
-rwxrwxrwx 1 groklygroup groklygroup 0 Sep  5 20:13 ./.repair-snapshots/20251120_204830/windows_mirror_backup/claude_projects_backups/file-index.db

**Size:** 0

**Modified:** 2025-09-05 20:13:17.000000000 -0700

**Accessed:** 2025-09-05 20:13:17.000000000 -0700

**Tables:**

**Schema Sample (first 50 lines):**
```sql
```

---

#### Database: `./.repair-snapshots/20251120_204830/windows_mirror_backup/enterprise-indexing/data/index/enterprise.db`

**File Stats:**
-rwxrwxrwx 1 groklygroup groklygroup 3.8M Sep  2 01:26 ./.repair-snapshots/20251120_204830/windows_mirror_backup/enterprise-indexing/data/index/enterprise.db

**Size:** 3.8M

**Modified:** 2025-09-02 01:26:16.000000000 -0700

**Accessed:** 2025-11-23 05:26:11.543727500 -0800

**Tables:**
dependencies    documents       file_locations

**Schema Sample (first 50 lines):**
```sql
CREATE TABLE documents (
    id TEXT PRIMARY KEY,
    path TEXT NOT NULL,
    original_path TEXT,
    content_hash TEXT NOT NULL,
    file_size INTEGER,
    category TEXT,
    indexed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    metadata_json TEXT,
    UNIQUE(path, content_hash)
);
CREATE TABLE file_locations (
    id TEXT PRIMARY KEY,
    original_path TEXT NOT NULL,
    new_path TEXT NOT NULL,
    moved_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    category TEXT,
    reason TEXT
);
CREATE INDEX idx_content_hash ON documents(content_hash);
CREATE INDEX idx_category ON documents(category);
CREATE INDEX idx_path ON documents(path);
CREATE TABLE dependencies (
            file_id TEXT,
            depends_on TEXT,
            dependency_type TEXT,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            PRIMARY KEY (file_id, depends_on)
        );
```

---

#### Database: `./.repair-snapshots/20251120_204830/windows_mirror_backup/enterprise-indexing/data/unified_index.db`

**File Stats:**
-rwxrwxrwx 1 groklygroup groklygroup 164K Nov  7 16:42 ./.repair-snapshots/20251120_204830/windows_mirror_backup/enterprise-indexing/data/unified_index.db

**Size:** 164K

**Modified:** 2025-11-07 16:42:41.000000000 -0800

**Accessed:** 2025-11-23 05:25:56.892705300 -0800

**Tables:**
chat_sessions            session_file_operations  session_topics         
session_code_blocks      session_messages       
session_decisions        session_security_audit 

**Schema Sample (first 50 lines):**
```sql
CREATE TABLE chat_sessions (
            id TEXT PRIMARY KEY,
            project_name TEXT,
            session_start TIMESTAMP,
            session_end TIMESTAMP,
            duration_seconds INTEGER,
            
            -- Message counts
            human_message_count INTEGER,
            assistant_message_count INTEGER,
            total_message_count INTEGER,
            
            -- Code statistics
            code_block_count INTEGER,
            code_languages TEXT,  -- JSON array
            total_code_lines INTEGER,
            
            -- File operations
            files_modified TEXT,  -- JSON array
            files_modified_count INTEGER,
            
            -- Decisions and tasks
            decisions TEXT,  -- JSON array
            decisions_count INTEGER,
            completed_tasks INTEGER,
            pending_tasks INTEGER,
            total_tasks INTEGER,
            
            -- Content metadata
            topics TEXT,  -- JSON array
            scrollback_file TEXT,
            content_size_bytes INTEGER,
            
            -- Security tracking
            sanitization_applied BOOLEAN DEFAULT TRUE,
            redaction_count INTEGER DEFAULT 0,
            path_conversion_count INTEGER DEFAULT 0,
            security_flags TEXT,  -- JSON array
            
            -- Hashes for integrity
            original_hash TEXT,
            final_hash TEXT,
            metadata_hash TEXT,
            
            -- Recovery information
            recovered_from_incomplete BOOLEAN DEFAULT FALSE,
            recovery_timestamp TIMESTAMP,
            recovery_version TEXT,
            marker_file TEXT,
            
```

---

#### Database: `./.repair-snapshots/20251120_204830/windows_mirror_backup/enterprise-test/data/test-index.db`

**File Stats:**
-rwxrwxrwx 1 groklygroup groklygroup 40K Aug 13 09:13 ./.repair-snapshots/20251120_204830/windows_mirror_backup/enterprise-test/data/test-index.db

**Size:** 40K

**Modified:** 2025-08-13 09:13:58.000000000 -0700

**Accessed:** 2025-11-23 05:26:23.468668200 -0800

**Tables:**
documents              documents_fts_data     files                
documents_fts          documents_fts_docsize  indexing_stats       
documents_fts_config   documents_fts_idx    

**Schema Sample (first 50 lines):**
```sql
CREATE TABLE files (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    path TEXT NOT NULL UNIQUE,
    name TEXT NOT NULL,
    extension TEXT,
    size INTEGER,
    hash TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    indexed_at TIMESTAMP,
    status TEXT DEFAULT 'pending'
);
CREATE TABLE sqlite_sequence(name,seq);
CREATE TABLE documents (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    file_id INTEGER REFERENCES files(id),
    content TEXT,
    metadata TEXT,
    language TEXT,
    word_count INTEGER,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE VIRTUAL TABLE documents_fts USING fts5(
    content, 
    metadata,
    content=documents,
    content_rowid=id
)
/* documents_fts(content,metadata) */;
CREATE TABLE IF NOT EXISTS 'documents_fts_data'(id INTEGER PRIMARY KEY, block BLOB);
CREATE TABLE IF NOT EXISTS 'documents_fts_idx'(segid, term, pgno, PRIMARY KEY(segid, term)) WITHOUT ROWID;
CREATE TABLE IF NOT EXISTS 'documents_fts_docsize'(id INTEGER PRIMARY KEY, sz BLOB);
CREATE TABLE IF NOT EXISTS 'documents_fts_config'(k PRIMARY KEY, v) WITHOUT ROWID;
CREATE TABLE indexing_stats (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    date DATE NOT NULL,
    files_processed INTEGER DEFAULT 0,
    files_failed INTEGER DEFAULT 0,
    total_size_bytes INTEGER DEFAULT 0,
    avg_processing_time_ms REAL
);
```

---

#### Database: `./.repair-snapshots/20251120_204830/windows_mirror_backup/evolution-framework/quantum/dna-registry.db`

**File Stats:**
-rwxrwxrwx 1 groklygroup groklygroup 40K Sep 15 13:48 ./.repair-snapshots/20251120_204830/windows_mirror_backup/evolution-framework/quantum/dna-registry.db

**Size:** 40K

**Modified:** 2025-09-15 13:48:12.000000000 -0700

**Accessed:** 2025-11-23 05:30:48.591389500 -0800

**Tables:**
dna_registry       evolution_history  gene_pool        

**Schema Sample (first 50 lines):**
```sql
CREATE TABLE dna_registry (
    component_id TEXT PRIMARY KEY,
    dna_sequence TEXT NOT NULL,
    generation INTEGER DEFAULT 1,
    parent_id TEXT,
    fitness_score REAL DEFAULT 0.5,
    mutations TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_evolved TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE evolution_history (
    id TEXT PRIMARY KEY,
    component_id TEXT NOT NULL,
    generation INTEGER NOT NULL,
    mutation_type TEXT NOT NULL,
    before_dna TEXT NOT NULL,
    after_dna TEXT NOT NULL,
    fitness_change REAL,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE gene_pool (
    gene_id TEXT PRIMARY KEY,
    gene_type TEXT NOT NULL,
    gene_data TEXT NOT NULL,
    success_rate REAL DEFAULT 0.5,
    usage_count INTEGER DEFAULT 0,
    origin_component TEXT
);
CREATE INDEX idx_dna_fitness ON dna_registry(fitness_score DESC);
CREATE INDEX idx_evolution_component ON evolution_history(component_id);
CREATE INDEX idx_gene_success ON gene_pool(success_rate DESC);
```

---

#### Database: `./.repair-snapshots/20251120_204830/windows_mirror_backup/evolution-framework/quantum/idea-elevation.db`

**File Stats:**
-rwxrwxrwx 1 groklygroup groklygroup 48K Sep 15 13:48 ./.repair-snapshots/20251120_204830/windows_mirror_backup/evolution-framework/quantum/idea-elevation.db

**Size:** 48K

**Modified:** 2025-09-15 13:48:15.000000000 -0700

**Accessed:** 2025-11-23 05:30:44.585089600 -0800

**Tables:**
elevation_history        ideas                  
idea_connections         implementation_patterns

**Schema Sample (first 50 lines):**
```sql
CREATE TABLE ideas (
    id TEXT PRIMARY KEY,
    concept TEXT NOT NULL,
    category TEXT NOT NULL,
    elevation_level INTEGER DEFAULT 1,
    implementation_readiness REAL DEFAULT 0.0,
    dependencies TEXT,
    parent_ideas TEXT,
    child_ideas TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    elevated_at TIMESTAMP,
    implemented_at TIMESTAMP,
    status TEXT DEFAULT 'raw'
);
CREATE TABLE elevation_history (
    id TEXT PRIMARY KEY,
    idea_id TEXT NOT NULL,
    from_level INTEGER NOT NULL,
    to_level INTEGER NOT NULL,
    elevation_type TEXT NOT NULL,
    transformation TEXT,
    catalyst TEXT,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (idea_id) REFERENCES ideas(id)
);
CREATE TABLE idea_connections (
    id TEXT PRIMARY KEY,
    idea1_id TEXT NOT NULL,
    idea2_id TEXT NOT NULL,
    connection_type TEXT NOT NULL,
    strength REAL DEFAULT 0.5,
    discovered_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (idea1_id) REFERENCES ideas(id),
    FOREIGN KEY (idea2_id) REFERENCES ideas(id)
);
CREATE TABLE implementation_patterns (
    id TEXT PRIMARY KEY,
    pattern_name TEXT NOT NULL,
    pattern_type TEXT NOT NULL,
    success_rate REAL DEFAULT 0.5,
    usage_count INTEGER DEFAULT 0,
    template TEXT,
    prerequisites TEXT
);
CREATE INDEX idx_ideas_level ON ideas(elevation_level DESC);
CREATE INDEX idx_ideas_readiness ON ideas(implementation_readiness DESC);
CREATE INDEX idx_connections_strength ON idea_connections(strength DESC);
```

---

#### Database: `./.repair-snapshots/20251120_204830/windows_mirror_backup/evolution-framework/quantum/natural-interaction.db`

**File Stats:**
-rwxrwxrwx 1 groklygroup groklygroup 64K Sep 15 12:40 ./.repair-snapshots/20251120_204830/windows_mirror_backup/evolution-framework/quantum/natural-interaction.db

**Size:** 64K

**Modified:** 2025-09-15 12:40:51.000000000 -0700

**Accessed:** 2025-11-23 05:30:46.717235500 -0800

**Tables:**
context_memory     interactions       natural_aliases  
intent_patterns    learning_feedback

**Schema Sample (first 50 lines):**
```sql
CREATE TABLE interactions (
    id TEXT PRIMARY KEY,
    interaction_type TEXT NOT NULL,
    input_text TEXT NOT NULL,
    interpreted_intent TEXT,
    confidence_score REAL DEFAULT 0.0,
    context_data TEXT,
    response_generated TEXT,
    satisfaction_score REAL,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE intent_patterns (
    id TEXT PRIMARY KEY,
    pattern_regex TEXT NOT NULL,
    intent_type TEXT NOT NULL,
    priority INTEGER DEFAULT 50,
    success_rate REAL DEFAULT 0.5,
    usage_count INTEGER DEFAULT 0,
    example_phrases TEXT
);
CREATE TABLE context_memory (
    id TEXT PRIMARY KEY,
    session_id TEXT NOT NULL,
    context_key TEXT NOT NULL,
    context_value TEXT NOT NULL,
    importance REAL DEFAULT 0.5,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    expires_at TIMESTAMP
);
CREATE TABLE learning_feedback (
    id TEXT PRIMARY KEY,
    interaction_id TEXT NOT NULL,
    feedback_type TEXT NOT NULL,
    feedback_value TEXT,
    learning_applied BOOLEAN DEFAULT FALSE,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (interaction_id) REFERENCES interactions(id)
);
CREATE TABLE natural_aliases (
    id TEXT PRIMARY KEY,
    natural_phrase TEXT NOT NULL UNIQUE,
    command_mapping TEXT NOT NULL,
    confidence REAL DEFAULT 0.8,
    usage_count INTEGER DEFAULT 0,
    created_by TEXT DEFAULT 'system'
);
CREATE INDEX idx_interactions_timestamp ON interactions(timestamp DESC);
CREATE INDEX idx_patterns_intent ON intent_patterns(intent_type);
CREATE INDEX idx_context_session ON context_memory(session_id);
CREATE INDEX idx_aliases_phrase ON natural_aliases(natural_phrase);
```

---

#### Database: `./.repair-snapshots/20251120_204830/windows_mirror_backup/evolution-framework/quantum/quantum-states.db`

**File Stats:**
-rwxrwxrwx 1 groklygroup groklygroup 36K Sep 15 12:40 ./.repair-snapshots/20251120_204830/windows_mirror_backup/evolution-framework/quantum/quantum-states.db

**Size:** 36K

**Modified:** 2025-09-15 12:40:50.000000000 -0700

**Accessed:** 2025-11-23 05:30:46.583584700 -0800

**Tables:**
entanglements     quantum_patterns  superpositions  

**Schema Sample (first 50 lines):**
```sql
CREATE TABLE superpositions (
    id TEXT PRIMARY KEY,
    problem_id TEXT NOT NULL,
    solutions TEXT NOT NULL,
    probabilities TEXT NOT NULL,
    entangled_with TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    collapsed_at TIMESTAMP,
    collapsed_to TEXT,
    context TEXT
);
CREATE TABLE entanglements (
    id TEXT PRIMARY KEY,
    problem1_id TEXT NOT NULL,
    problem2_id TEXT NOT NULL,
    correlation_strength REAL NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE quantum_patterns (
    id TEXT PRIMARY KEY,
    pattern_type TEXT NOT NULL,
    pattern_data TEXT NOT NULL,
    success_rate REAL,
    usage_count INTEGER DEFAULT 0
);
CREATE INDEX idx_superposition_problem ON superpositions(problem_id);
CREATE INDEX idx_entanglement_problems ON entanglements(problem1_id, problem2_id);
```

---

#### Database: `./.repair-snapshots/20251120_204830/windows_mirror_backup/evolution-framework/quantum/universal-benefit.db`

**File Stats:**
-rwxrwxrwx 1 groklygroup groklygroup 60K Sep 15 13:48 ./.repair-snapshots/20251120_204830/windows_mirror_backup/evolution-framework/quantum/universal-benefit.db

**Size:** 60K

**Modified:** 2025-09-15 13:48:18.000000000 -0700

**Accessed:** 2025-11-23 05:30:46.768026000 -0800

**Tables:**
benefit_propagation      collective_intelligence  ecosystem_health       
benefit_registry         community_contributions

**Schema Sample (first 50 lines):**
```sql
CREATE TABLE benefit_registry (
    id TEXT PRIMARY KEY,
    component_id TEXT NOT NULL,
    benefit_type TEXT NOT NULL,
    benefit_score REAL DEFAULT 0.0,
    impact_radius TEXT DEFAULT 'local',
    beneficiaries INTEGER DEFAULT 1,
    collective_value REAL DEFAULT 0.0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_measured TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE collective_intelligence (
    id TEXT PRIMARY KEY,
    knowledge_type TEXT NOT NULL,
    knowledge_data TEXT NOT NULL,
    contributor_count INTEGER DEFAULT 1,
    quality_score REAL DEFAULT 0.5,
    usage_count INTEGER DEFAULT 0,
    last_accessed TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE benefit_propagation (
    id TEXT PRIMARY KEY,
    source_component TEXT NOT NULL,
    target_component TEXT NOT NULL,
    benefit_type TEXT NOT NULL,
    propagation_strength REAL DEFAULT 0.5,
    propagated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE community_contributions (
    id TEXT PRIMARY KEY,
    contributor_id TEXT NOT NULL,
    contribution_type TEXT NOT NULL,
    contribution_data TEXT NOT NULL,
    impact_score REAL DEFAULT 0.0,
    recognition_level TEXT DEFAULT 'contributor',
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE ecosystem_health (
    id TEXT PRIMARY KEY,
    metric_name TEXT NOT NULL,
    metric_value REAL NOT NULL,
    metric_type TEXT NOT NULL,
    measurement_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    trend_direction TEXT,
    health_status TEXT DEFAULT 'healthy'
);
CREATE INDEX idx_benefit_score ON benefit_registry(benefit_score DESC);
CREATE INDEX idx_collective_quality ON collective_intelligence(quality_score DESC);
CREATE INDEX idx_propagation_time ON benefit_propagation(propagated_at DESC);
CREATE INDEX idx_health_time ON ecosystem_health(measurement_time DESC);
```

---

#### Database: `./.repair-snapshots/20251120_204830/windows_mirror_backup/evolution-framework/state-store/state.db`

**File Stats:**
-rwxrwxrwx 1 groklygroup groklygroup 56K Sep 15 13:44 ./.repair-snapshots/20251120_204830/windows_mirror_backup/evolution-framework/state-store/state.db

**Size:** 56K

**Modified:** 2025-09-15 13:44:57.000000000 -0700

**Accessed:** 2025-11-23 05:30:44.584051900 -0800

**Tables:**
collective_patterns   optimization_history  state_history       
component_state       performance_metrics 

**Schema Sample (first 50 lines):**
```sql
CREATE TABLE component_state (
    component_name TEXT PRIMARY KEY,
    state_data TEXT,
    version INTEGER DEFAULT 1,
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    checksum TEXT
);
CREATE TABLE state_history (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    component_name TEXT,
    state_data TEXT,
    version INTEGER,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    change_type TEXT,
    changed_by TEXT
);
CREATE TABLE sqlite_sequence(name,seq);
CREATE TABLE collective_patterns (
    pattern_id TEXT PRIMARY KEY,
    pattern_type TEXT,
    pattern_data TEXT,
    occurrences INTEGER DEFAULT 1,
    first_seen TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_seen TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    contributing_components TEXT
);
CREATE TABLE performance_metrics (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    component_name TEXT,
    metric_name TEXT,
    metric_value REAL,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE optimization_history (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    component_name TEXT,
    optimization_type TEXT,
    before_value REAL,
    after_value REAL,
    improvement_percent REAL,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    success BOOLEAN
);
CREATE INDEX idx_state_component ON component_state(component_name);
CREATE INDEX idx_history_component ON state_history(component_name, timestamp);
CREATE INDEX idx_patterns_type ON collective_patterns(pattern_type);
CREATE INDEX idx_metrics_time ON performance_metrics(timestamp);
CREATE INDEX idx_component_metric ON performance_metrics(component_name, metric_name, timestamp);
```

---

#### Database: `./.repair-snapshots/20251120_204830/windows_mirror_backup/file_protection.db`

**File Stats:**
-rwxrwxrwx 1 groklygroup groklygroup 36K Jul 21 23:57 ./.repair-snapshots/20251120_204830/windows_mirror_backup/file_protection.db

**Size:** 36K

**Modified:** 2025-07-21 23:57:12.000000000 -0700

**Accessed:** 2025-11-23 05:32:31.409057400 -0800

**Tables:**
file_history     protected_files

**Schema Sample (first 50 lines):**
```sql
CREATE TABLE protected_files (
    file_id TEXT PRIMARY KEY,
    path TEXT NOT NULL UNIQUE,
    sha256_hash TEXT NOT NULL,
    protection_level TEXT DEFAULT 'standard',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_modified TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    backup_path TEXT,
    metadata TEXT
);
CREATE TABLE file_history (
    history_id TEXT PRIMARY KEY,
    file_id TEXT NOT NULL,
    action TEXT NOT NULL,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    old_hash TEXT,
    new_hash TEXT,
    user TEXT,
    reason TEXT,
    FOREIGN KEY (file_id) REFERENCES protected_files(file_id)
);
CREATE INDEX idx_path ON protected_files(path);
CREATE INDEX idx_protection ON protected_files(protection_level);
CREATE INDEX idx_file_history ON file_history(file_id);
```

---

#### Database: `./.repair-snapshots/20251120_204830/windows_mirror_backup/GLOBAL_CHAT_STORAGE.db`

**File Stats:**
-rwxrwxrwx 1 groklygroup groklygroup 240K Jun 18 09:57 ./.repair-snapshots/20251120_204830/windows_mirror_backup/GLOBAL_CHAT_STORAGE.db

**Size:** 240K

**Modified:** 2025-06-18 09:57:20.000000000 -0700

**Accessed:** 2025-11-23 05:35:10.470923200 -0800

**Tables:**
global_sessions         message_search_content  message_search_idx    
message_search          message_search_data     messages              
message_search_config   message_search_docsize  projects              

**Schema Sample (first 50 lines):**
```sql
CREATE TABLE projects (
                    id INTEGER PRIMARY KEY AUTOINCREMENT,
                    project_name TEXT UNIQUE NOT NULL,
                    project_path TEXT NOT NULL,
                    description TEXT,
                    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
                );
CREATE TABLE sqlite_sequence(name,seq);
CREATE TABLE global_sessions (
                    id INTEGER PRIMARY KEY AUTOINCREMENT,
                    session_id TEXT UNIQUE NOT NULL,
                    project_id INTEGER NOT NULL,
                    project_name TEXT NOT NULL,
                    session_name TEXT,
                    conversation_history TEXT NOT NULL,  -- Full JSON with complete fidelity
                    message_count INTEGER DEFAULT 0,
                    total_tokens INTEGER DEFAULT 0,
                    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                    metadata TEXT,  -- JSON metadata
                    tags TEXT,      -- Comma-separated tags
                    FOREIGN KEY (project_id) REFERENCES projects (id)
                );
CREATE TABLE messages (
                    id INTEGER PRIMARY KEY AUTOINCREMENT,
                    session_id TEXT NOT NULL,
                    project_name TEXT NOT NULL,
                    role TEXT NOT NULL,
                    content TEXT NOT NULL,  -- Complete message content
                    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                    metadata TEXT,  -- JSON for tool calls, file refs, etc
                    FOREIGN KEY (session_id) REFERENCES global_sessions (session_id)
                );
CREATE VIRTUAL TABLE message_search 
                USING fts5(session_id, project_name, content, metadata)
/* message_search(session_id,project_name,content,metadata) */;
CREATE TABLE IF NOT EXISTS 'message_search_data'(id INTEGER PRIMARY KEY, block BLOB);
CREATE TABLE IF NOT EXISTS 'message_search_idx'(segid, term, pgno, PRIMARY KEY(segid, term)) WITHOUT ROWID;
CREATE TABLE IF NOT EXISTS 'message_search_content'(id INTEGER PRIMARY KEY, c0, c1, c2, c3);
CREATE TABLE IF NOT EXISTS 'message_search_docsize'(id INTEGER PRIMARY KEY, sz BLOB);
CREATE TABLE IF NOT EXISTS 'message_search_config'(k PRIMARY KEY, v) WITHOUT ROWID;
CREATE INDEX idx_sessions_project ON global_sessions(project_name);
CREATE INDEX idx_sessions_updated ON global_sessions(updated_at DESC);
CREATE INDEX idx_messages_session ON messages(session_id);
CREATE INDEX idx_messages_project ON messages(project_name);
CREATE INDEX idx_messages_timestamp ON messages(timestamp);
```

---

#### Database: `./.repair-snapshots/20251120_204830/windows_mirror_backup/leadcraft/leadcraft_v2/data/database/analytics.db`

**File Stats:**
-rwxrwxrwx 1 groklygroup groklygroup 28K Jun 25 20:28 ./.repair-snapshots/20251120_204830/windows_mirror_backup/leadcraft/leadcraft_v2/data/database/analytics.db

**Size:** 28K

**Modified:** 2025-06-25 20:28:07.000000000 -0700

**Accessed:** 2025-11-23 05:53:30.334545300 -0800

**Tables:**
dashboards  kpis        reports   

**Schema Sample (first 50 lines):**
```sql
CREATE TABLE kpis (
                    id TEXT PRIMARY KEY,
                    name TEXT NOT NULL,
                    description TEXT,
                    category TEXT NOT NULL,
                    current_value REAL NOT NULL,
                    target_value REAL NOT NULL,
                    unit TEXT NOT NULL,
                    trend TEXT NOT NULL,
                    period TEXT NOT NULL,
                    last_updated TEXT NOT NULL
                );
CREATE TABLE reports (
                    id TEXT PRIMARY KEY,
                    name TEXT NOT NULL,
                    description TEXT,
                    report_type TEXT NOT NULL,
                    data TEXT NOT NULL,
                    generated_at TEXT NOT NULL,
                    period_start TEXT NOT NULL,
                    period_end TEXT NOT NULL,
                    format TEXT NOT NULL
                );
CREATE TABLE dashboards (
                    id TEXT PRIMARY KEY,
                    name TEXT NOT NULL,
                    description TEXT,
                    widgets TEXT NOT NULL,
                    layout TEXT NOT NULL,
                    permissions TEXT NOT NULL,
                    created_at TEXT NOT NULL,
                    updated_at TEXT NOT NULL
                );
```

---

#### Database: `./.repair-snapshots/20251120_204830/windows_mirror_backup/leadcraft/leadcraft_v2/data/database/crm.db`

**File Stats:**
-rwxrwxrwx 1 groklygroup groklygroup 44K Jun 25 20:28 ./.repair-snapshots/20251120_204830/windows_mirror_backup/leadcraft/leadcraft_v2/data/database/crm.db

**Size:** 44K

**Modified:** 2025-06-25 20:28:06.000000000 -0700

**Accessed:** 2025-11-23 05:53:30.334545300 -0800

**Tables:**
campaign_leads        interactions          leads               
campaigns             lead_scoring_history

**Schema Sample (first 50 lines):**
```sql
CREATE TABLE leads (
                id TEXT PRIMARY KEY,
                business_name TEXT NOT NULL,
                contact_name TEXT,
                email TEXT,
                phone TEXT,
                website TEXT,
                address TEXT,
                industry TEXT,
                company_size TEXT,
                status TEXT DEFAULT 'new',
                priority TEXT DEFAULT 'medium',
                score INTEGER DEFAULT 0,
                source TEXT,
                notes TEXT,
                created_date TEXT,
                updated_date TEXT,
                last_contact_date TEXT,
                next_follow_up TEXT,
                estimated_value REAL DEFAULT 0.0,
                probability INTEGER DEFAULT 0,
                tags TEXT,
                gdpr_consent BOOLEAN DEFAULT FALSE,
                gdpr_consent_date TEXT
            );
CREATE TABLE interactions (
                id TEXT PRIMARY KEY,
                lead_id TEXT,
                type TEXT,
                subject TEXT,
                content TEXT,
                date TEXT,
                outcome TEXT,
                next_action TEXT,
                created_by TEXT,
                FOREIGN KEY (lead_id) REFERENCES leads (id)
            );
CREATE TABLE campaigns (
                id TEXT PRIMARY KEY,
                name TEXT NOT NULL,
                type TEXT,
                status TEXT DEFAULT 'draft',
                target_audience TEXT,
                start_date TEXT,
                end_date TEXT,
                budget REAL DEFAULT 0.0,
                goals TEXT,
                metrics TEXT,
                created_date TEXT
            );
```

---

#### Database: `./.repair-snapshots/20251120_204830/windows_mirror_backup/leadcraft/leadcraft_v2/data/database/email_campaigns.db`

**File Stats:**
-rwxrwxrwx 1 groklygroup groklygroup 40K Jun 25 21:08 ./.repair-snapshots/20251120_204830/windows_mirror_backup/leadcraft/leadcraft_v2/data/database/email_campaigns.db

**Size:** 40K

**Modified:** 2025-06-25 21:08:44.000000000 -0700

**Accessed:** 2025-11-23 05:53:30.334545300 -0800

**Tables:**
email_campaigns  email_contacts   email_logs       email_templates

**Schema Sample (first 50 lines):**
```sql
CREATE TABLE email_templates (
                    id TEXT PRIMARY KEY,
                    name TEXT NOT NULL,
                    subject TEXT NOT NULL,
                    content TEXT NOT NULL,
                    template_type TEXT NOT NULL,
                    industry TEXT,
                    personalization_fields TEXT,
                    created_at TEXT NOT NULL,
                    updated_at TEXT NOT NULL
                );
CREATE TABLE email_contacts (
                    id TEXT PRIMARY KEY,
                    email TEXT UNIQUE NOT NULL,
                    first_name TEXT,
                    last_name TEXT,
                    company_name TEXT,
                    website_url TEXT,
                    industry TEXT,
                    phone TEXT,
                    status TEXT DEFAULT 'active',
                    tags TEXT,
                    custom_fields TEXT,
                    created_at TEXT NOT NULL,
                    updated_at TEXT NOT NULL
                );
CREATE TABLE email_campaigns (
                    id TEXT PRIMARY KEY,
                    name TEXT NOT NULL,
                    description TEXT,
                    template_id TEXT,
                    contact_list_ids TEXT,
                    scheduled_time TEXT,
                    send_immediately BOOLEAN,
                    status TEXT DEFAULT 'draft',
                    total_recipients INTEGER DEFAULT 0,
                    sent_count INTEGER DEFAULT 0,
                    opened_count INTEGER DEFAULT 0,
                    clicked_count INTEGER DEFAULT 0,
                    bounced_count INTEGER DEFAULT 0,
                    unsubscribed_count INTEGER DEFAULT 0,
                    created_at TEXT NOT NULL,
                    updated_at TEXT NOT NULL
                );
CREATE TABLE email_logs (
                    id TEXT PRIMARY KEY,
                    campaign_id TEXT,
                    contact_id TEXT,
                    template_id TEXT,
                    subject TEXT,
```

---

#### Database: `./.repair-snapshots/20251120_204830/windows_mirror_backup/leadcraft/leadcraft_v2/data/database/leadcraft.db`

**File Stats:**
-rwxrwxrwx 1 groklygroup groklygroup 44K Jun 25 17:42 ./.repair-snapshots/20251120_204830/windows_mirror_backup/leadcraft/leadcraft_v2/data/database/leadcraft.db

**Size:** 44K

**Modified:** 2025-06-25 17:42:03.000000000 -0700

**Accessed:** 2025-11-23 05:53:30.334545300 -0800

**Tables:**
campaigns     interactions  leads         settings      templates   

**Schema Sample (first 50 lines):**
```sql
CREATE TABLE leads (
            id TEXT PRIMARY KEY,
            business_name TEXT NOT NULL,
            website_url TEXT,
            industry TEXT,
            contact_email TEXT,
            contact_phone TEXT,
            address TEXT,
            lead_score INTEGER DEFAULT 0,
            mobile_responsive BOOLEAN DEFAULT FALSE,
            loading_speed REAL DEFAULT 0.0,
            design_issues TEXT,
            status TEXT DEFAULT 'new',
            notes TEXT,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        );
CREATE TABLE interactions (
            id TEXT PRIMARY KEY,
            lead_id TEXT,
            interaction_type TEXT,
            subject TEXT,
            content TEXT,
            outcome TEXT,
            next_action TEXT,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            FOREIGN KEY (lead_id) REFERENCES leads (id)
        );
CREATE TABLE campaigns (
            id TEXT PRIMARY KEY,
            name TEXT NOT NULL,
            type TEXT,
            status TEXT DEFAULT 'draft',
            target_criteria TEXT,
            content_template TEXT,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        );
CREATE TABLE templates (
            id TEXT PRIMARY KEY,
            name TEXT NOT NULL,
            type TEXT,
            subject TEXT,
            content TEXT,
            variables TEXT,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        );
CREATE TABLE settings (
            key TEXT PRIMARY KEY,
```

---

#### Database: `./.repair-snapshots/20251120_204830/windows_mirror_backup/leadcraft/leadcraft_v2/data/database/sales_pipeline.db`

**File Stats:**
-rwxrwxrwx 1 groklygroup groklygroup 36K Jun 25 20:28 ./.repair-snapshots/20251120_204830/windows_mirror_backup/leadcraft/leadcraft_v2/data/database/sales_pipeline.db

**Size:** 36K

**Modified:** 2025-06-25 20:28:06.000000000 -0700

**Accessed:** 2025-11-23 05:53:30.334545300 -0800

**Tables:**
opportunities     pipeline_stages   sales_activities  sales_goals     

**Schema Sample (first 50 lines):**
```sql
CREATE TABLE pipeline_stages (
                    id TEXT PRIMARY KEY,
                    name TEXT NOT NULL,
                    description TEXT,
                    probability REAL NOT NULL,
                    stage_order INTEGER NOT NULL,
                    active BOOLEAN NOT NULL DEFAULT 1,
                    created_at TEXT NOT NULL
                );
CREATE TABLE opportunities (
                    id TEXT PRIMARY KEY,
                    name TEXT NOT NULL,
                    description TEXT,
                    value REAL NOT NULL,
                    currency TEXT DEFAULT 'USD',
                    stage_id TEXT NOT NULL,
                    lead_id TEXT,
                    contact_email TEXT,
                    source TEXT,
                    probability REAL,
                    expected_close_date TEXT,
                    actual_close_date TEXT,
                    status TEXT NOT NULL DEFAULT 'open',
                    created_at TEXT NOT NULL,
                    updated_at TEXT NOT NULL,
                    tags TEXT,
                    notes TEXT,
                    FOREIGN KEY (stage_id) REFERENCES pipeline_stages (id)
                );
CREATE TABLE sales_activities (
                    id TEXT PRIMARY KEY,
                    opportunity_id TEXT NOT NULL,
                    activity_type TEXT NOT NULL,
                    subject TEXT NOT NULL,
                    description TEXT,
                    status TEXT NOT NULL DEFAULT 'planned',
                    scheduled_date TEXT,
                    completed_date TEXT,
                    duration_minutes INTEGER,
                    outcome TEXT,
                    created_at TEXT NOT NULL,
                    FOREIGN KEY (opportunity_id) REFERENCES opportunities (id)
                );
CREATE TABLE sales_goals (
                    id TEXT PRIMARY KEY,
                    name TEXT NOT NULL,
                    goal_type TEXT NOT NULL,
                    target_value REAL NOT NULL,
                    current_value REAL DEFAULT 0,
                    period TEXT NOT NULL,
```

---

#### Database: `./.repair-snapshots/20251120_204830/windows_mirror_backup/leadcraft/leadcraft_v2/data/database/security_compliance.db`

**File Stats:**
-rwxrwxrwx 1 groklygroup groklygroup 44K Jun 25 20:28 ./.repair-snapshots/20251120_204830/windows_mirror_backup/leadcraft/leadcraft_v2/data/database/security_compliance.db

**Size:** 44K

**Modified:** 2025-06-25 20:28:07.000000000 -0700

**Accessed:** 2025-11-23 05:53:29.334157800 -0800

**Tables:**
compliance_checks    data_requests        security_audit_logs
consent_records      encrypted_data     

**Schema Sample (first 50 lines):**
```sql
CREATE TABLE consent_records (
                    id TEXT PRIMARY KEY,
                    email TEXT NOT NULL,
                    consent_type TEXT NOT NULL,
                    consent_given BOOLEAN NOT NULL,
                    consent_date TEXT NOT NULL,
                    consent_method TEXT NOT NULL,
                    ip_address TEXT,
                    user_agent TEXT,
                    withdrawal_date TEXT,
                    lawful_basis TEXT NOT NULL,
                    retention_period TEXT,
                    created_at TEXT NOT NULL
                );
CREATE TABLE data_requests (
                    id TEXT PRIMARY KEY,
                    email TEXT NOT NULL,
                    request_type TEXT NOT NULL,
                    request_date TEXT NOT NULL,
                    status TEXT NOT NULL,
                    completion_date TEXT,
                    notes TEXT,
                    verification_status TEXT NOT NULL,
                    created_at TEXT NOT NULL
                );
CREATE TABLE security_audit_logs (
                    id TEXT PRIMARY KEY,
                    event_type TEXT NOT NULL,
                    user_id TEXT NOT NULL,
                    resource TEXT NOT NULL,
                    action TEXT NOT NULL,
                    ip_address TEXT NOT NULL,
                    user_agent TEXT,
                    success BOOLEAN NOT NULL,
                    risk_level TEXT NOT NULL,
                    details TEXT,
                    timestamp TEXT NOT NULL
                );
CREATE TABLE compliance_checks (
                    id TEXT PRIMARY KEY,
                    check_type TEXT NOT NULL,
                    status TEXT NOT NULL,
                    description TEXT NOT NULL,
                    recommendations TEXT,
                    last_checked TEXT NOT NULL,
                    next_check TEXT NOT NULL
                );
CREATE TABLE encrypted_data (
                    id TEXT PRIMARY KEY,
                    data_type TEXT NOT NULL,
```

---

#### Database: `./.repair-snapshots/20251120_204830/windows_mirror_backup/leadcraft/leadcraft_v2/data/database/website_analysis.db`

**File Stats:**
-rwxrwxrwx 1 groklygroup groklygroup 32K Jun 25 19:29 ./.repair-snapshots/20251120_204830/windows_mirror_backup/leadcraft/leadcraft_v2/data/database/website_analysis.db

**Size:** 32K

**Modified:** 2025-06-25 19:29:49.000000000 -0700

**Accessed:** 2025-11-23 05:53:30.334545300 -0800

**Tables:**
businesses          discovery_sessions  website_analyses  

**Schema Sample (first 50 lines):**
```sql
CREATE TABLE businesses (
                    id TEXT PRIMARY KEY,
                    name TEXT NOT NULL,
                    website_url TEXT NOT NULL,
                    phone TEXT,
                    address TEXT,
                    city TEXT,
                    state TEXT,
                    industry TEXT,
                    source TEXT,
                    discovery_date TEXT,
                    last_analyzed TEXT,
                    analysis_score INTEGER,
                    contact_email TEXT,
                    social_media TEXT,
                    UNIQUE(website_url)
                );
CREATE TABLE website_analyses (
                    id TEXT PRIMARY KEY,
                    business_id TEXT,
                    url TEXT NOT NULL,
                    overall_score INTEGER,
                    mobile_score INTEGER,
                    design_score INTEGER,
                    speed_score INTEGER,
                    content_score INTEGER,
                    technical_score INTEGER,
                    issues_found TEXT,
                    opportunities TEXT,
                    mobile_responsive BOOLEAN,
                    loading_time REAL,
                    has_ssl BOOLEAN,
                    last_updated_estimate TEXT,
                    contact_info_found TEXT,
                    technology_stack TEXT,
                    analysis_date TEXT,
                    screenshot_path TEXT,
                    FOREIGN KEY (business_id) REFERENCES businesses (id)
                );
CREATE TABLE discovery_sessions (
                    id TEXT PRIMARY KEY,
                    business_type TEXT,
                    location TEXT,
                    max_results INTEGER,
                    status TEXT,
                    businesses_found INTEGER,
                    businesses_analyzed INTEGER,
                    high_score_count INTEGER,
                    started_at TEXT,
                    completed_at TEXT,
```

---

#### Database: `./.repair-snapshots/20251120_204830/windows_mirror_backup/leadcraft/leadcraft_v2/data/unified_crm.db`

**File Stats:**
-rwxrwxrwx 1 groklygroup groklygroup 76K Jun 25 20:57 ./.repair-snapshots/20251120_204830/windows_mirror_backup/leadcraft/leadcraft_v2/data/unified_crm.db

**Size:** 76K

**Modified:** 2025-06-25 20:57:41.000000000 -0700

**Accessed:** 2025-11-23 05:53:00.373957000 -0800

**Tables:**
campaign_leads  campaigns       interactions    lead_sources    leads         

**Schema Sample (first 50 lines):**
```sql
CREATE TABLE leads (
                        id TEXT PRIMARY KEY,
                        business_name TEXT NOT NULL,
                        contact_name TEXT,
                        email TEXT,
                        phone TEXT,
                        website TEXT,
                        industry TEXT,
                        company_size TEXT,
                        annual_revenue TEXT,
                        location TEXT,
                        description TEXT,
                        status TEXT DEFAULT 'new',
                        priority TEXT DEFAULT 'medium',
                        source TEXT,
                        assigned_to TEXT,
                        estimated_value REAL DEFAULT 0.0,
                        probability INTEGER DEFAULT 0,
                        created_date TEXT,
                        updated_date TEXT,
                        last_contact_date TEXT,
                        next_follow_up TEXT
                    );
CREATE TABLE interactions (
                        id TEXT PRIMARY KEY,
                        lead_id TEXT,
                        interaction_type TEXT,
                        subject TEXT,
                        description TEXT,
                        outcome TEXT,
                        next_action TEXT,
                        interaction_date TEXT,
                        created_by TEXT,
                        created_date TEXT,
                        FOREIGN KEY (lead_id) REFERENCES leads (id)
                    );
CREATE TABLE campaigns (
                        id TEXT PRIMARY KEY,
                        name TEXT NOT NULL,
                        description TEXT,
                        campaign_type TEXT,
                        status TEXT DEFAULT 'active',
                        target_criteria TEXT,
                        start_date TEXT,
                        end_date TEXT,
                        budget REAL DEFAULT 0.0,
                        leads_generated INTEGER DEFAULT 0,
                        conversion_rate REAL DEFAULT 0.0,
                        created_date TEXT
                    );
```

---

#### Database: `./.repair-snapshots/20251120_204830/windows_mirror_backup/leadcraft/leadcraft_v2/voice_agent_system.db`

**File Stats:**
-rwxrwxrwx 1 groklygroup groklygroup 12K Jun 25 20:28 ./.repair-snapshots/20251120_204830/windows_mirror_backup/leadcraft/leadcraft_v2/voice_agent_system.db

**Size:** 12K

**Modified:** 2025-06-25 20:28:06.000000000 -0700

**Accessed:** 2025-11-23 05:53:16.323770900 -0800

**Tables:**
voice_calls

**Schema Sample (first 50 lines):**
```sql
CREATE TABLE voice_calls (
                    id TEXT PRIMARY KEY,
                    lead_id TEXT NOT NULL,
                    phone_number TEXT NOT NULL,
                    call_status TEXT DEFAULT 'queued',
                    call_duration INTEGER DEFAULT 0,
                    transcript TEXT,
                    outcome TEXT,
                    sentiment_score REAL DEFAULT 0.0,
                    next_action TEXT,
                    ai_agent_platform TEXT,
                    call_cost REAL DEFAULT 0.0,
                    recording_url TEXT,
                    started_at TEXT,
                    completed_at TEXT,
                    created_at TEXT
                );
```

---

#### Database: `./.repair-snapshots/20251120_204830/windows_mirror_backup/localgpt/C:/Users/jdh/claude_projects/GLOBAL_CHAT_STORAGE.db`

**File Stats:**
-rwxrwxrwx 1 groklygroup groklygroup 240K Jun 18 09:57 ./.repair-snapshots/20251120_204830/windows_mirror_backup/localgpt/C:/Users/jdh/claude_projects/GLOBAL_CHAT_STORAGE.db

**Size:** 240K

**Modified:** 2025-06-18 09:57:01.000000000 -0700

**Accessed:** 2025-11-23 05:54:57.375558100 -0800

**Tables:**
global_sessions         message_search_content  message_search_idx    
message_search          message_search_data     messages              
message_search_config   message_search_docsize  projects              

**Schema Sample (first 50 lines):**
```sql
CREATE TABLE projects (
                    id INTEGER PRIMARY KEY AUTOINCREMENT,
                    project_name TEXT UNIQUE NOT NULL,
                    project_path TEXT NOT NULL,
                    description TEXT,
                    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
                );
CREATE TABLE sqlite_sequence(name,seq);
CREATE TABLE global_sessions (
                    id INTEGER PRIMARY KEY AUTOINCREMENT,
                    session_id TEXT UNIQUE NOT NULL,
                    project_id INTEGER NOT NULL,
                    project_name TEXT NOT NULL,
                    session_name TEXT,
                    conversation_history TEXT NOT NULL,  -- Full JSON with complete fidelity
                    message_count INTEGER DEFAULT 0,
                    total_tokens INTEGER DEFAULT 0,
                    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                    metadata TEXT,  -- JSON metadata
                    tags TEXT,      -- Comma-separated tags
                    FOREIGN KEY (project_id) REFERENCES projects (id)
                );
CREATE TABLE messages (
                    id INTEGER PRIMARY KEY AUTOINCREMENT,
                    session_id TEXT NOT NULL,
                    project_name TEXT NOT NULL,
                    role TEXT NOT NULL,
                    content TEXT NOT NULL,  -- Complete message content
                    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                    metadata TEXT,  -- JSON for tool calls, file refs, etc
                    FOREIGN KEY (session_id) REFERENCES global_sessions (session_id)
                );
CREATE VIRTUAL TABLE message_search 
                USING fts5(session_id, project_name, content, metadata)
/* message_search(session_id,project_name,content,metadata) */;
CREATE TABLE IF NOT EXISTS 'message_search_data'(id INTEGER PRIMARY KEY, block BLOB);
CREATE TABLE IF NOT EXISTS 'message_search_idx'(segid, term, pgno, PRIMARY KEY(segid, term)) WITHOUT ROWID;
CREATE TABLE IF NOT EXISTS 'message_search_content'(id INTEGER PRIMARY KEY, c0, c1, c2, c3);
CREATE TABLE IF NOT EXISTS 'message_search_docsize'(id INTEGER PRIMARY KEY, sz BLOB);
CREATE TABLE IF NOT EXISTS 'message_search_config'(k PRIMARY KEY, v) WITHOUT ROWID;
CREATE INDEX idx_sessions_project ON global_sessions(project_name);
CREATE INDEX idx_sessions_updated ON global_sessions(updated_at DESC);
CREATE INDEX idx_messages_session ON messages(session_id);
CREATE INDEX idx_messages_project ON messages(project_name);
CREATE INDEX idx_messages_timestamp ON messages(timestamp);
```

---

#### Database: `./.repair-snapshots/20251120_204830/windows_mirror_backup/localgpt/localgpt_portable.db`

**File Stats:**
-rwxrwxrwx 1 groklygroup groklygroup 168K Jun 18 09:28 ./.repair-snapshots/20251120_204830/windows_mirror_backup/localgpt/localgpt_portable.db

**Size:** 168K

**Modified:** 2025-06-18 09:28:18.000000000 -0700

**Accessed:** 2025-11-23 05:54:58.670780700 -0800

**Tables:**
files     sessions

**Schema Sample (first 50 lines):**
```sql
CREATE TABLE files (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                file_path TEXT UNIQUE,
                file_name TEXT,
                file_size INTEGER,
                file_hash TEXT,
                content_preview TEXT,
                indexed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
            );
CREATE TABLE sqlite_sequence(name,seq);
CREATE TABLE sessions (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                session_data TEXT,
                created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
            );
```

---

#### Database: `./.repair-snapshots/20251120_204830/windows_mirror_backup/localgpt/vector_store.db`

**File Stats:**
-rwxrwxrwx 1 groklygroup groklygroup 28K Jun 19 18:20 ./.repair-snapshots/20251120_204830/windows_mirror_backup/localgpt/vector_store.db

**Size:** 28K

**Modified:** 2025-06-19 18:20:35.000000000 -0700

**Accessed:** 2025-11-23 05:55:24.345524400 -0800

**Tables:**
documents   embeddings

**Schema Sample (first 50 lines):**
```sql
CREATE TABLE documents (
                    id TEXT PRIMARY KEY,
                    file_path TEXT NOT NULL,
                    file_name TEXT NOT NULL,
                    content_hash TEXT NOT NULL,
                    embedding_hash TEXT,
                    chunk_index INTEGER DEFAULT 0,
                    content TEXT NOT NULL,
                    metadata TEXT,
                    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
                );
CREATE TABLE embeddings (
                    id TEXT PRIMARY KEY,
                    document_id TEXT NOT NULL,
                    embedding BLOB NOT NULL,
                    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                    FOREIGN KEY (document_id) REFERENCES documents (id)
                );
CREATE INDEX idx_documents_file_path ON documents(file_path)
            ;
CREATE INDEX idx_documents_content_hash ON documents(content_hash)
            ;
```

---

#### Database: `./.repair-snapshots/20251120_204830/windows_mirror_backup/PERPETUAL_TRASH/todo-files-20250730/claude_projects/.completed-todos/completed-todos.db`

**File Stats:**
-rwxrwxrwx 1 groklygroup groklygroup 20K Jul 26 08:40 ./.repair-snapshots/20251120_204830/windows_mirror_backup/PERPETUAL_TRASH/todo-files-20250730/claude_projects/.completed-todos/completed-todos.db

**Size:** 20K

**Modified:** 2025-07-26 08:40:24.000000000 -0700

**Accessed:** 2025-11-23 05:59:51.822851400 -0800

**Tables:**
completed_todos

**Schema Sample (first 50 lines):**
```sql
CREATE TABLE completed_todos (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    content TEXT NOT NULL,
    session_id TEXT,
    session_date TEXT,
    source_file TEXT,
    completed_date TEXT DEFAULT CURRENT_TIMESTAMP,
    extracted_date TEXT DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE sqlite_sequence(name,seq);
CREATE INDEX idx_session_id ON completed_todos(session_id);
CREATE INDEX idx_session_date ON completed_todos(session_date);
```

---

#### Database: `./.repair-snapshots/20251120_204830/windows_mirror_backup/PERPETUAL_TRASH/todo-files-20250730/claude_projects/.trash/20250727-133126/todo_system.db`

**File Stats:**
-rwxrwxrwx 1 groklygroup groklygroup 0 Jul 10 03:53 ./.repair-snapshots/20251120_204830/windows_mirror_backup/PERPETUAL_TRASH/todo-files-20250730/claude_projects/.trash/20250727-133126/todo_system.db

**Size:** 0

**Modified:** 2025-07-10 03:53:01.000000000 -0700

**Accessed:** 2025-07-10 03:53:01.000000000 -0700

**Tables:**

**Schema Sample (first 50 lines):**
```sql
```

---

#### Database: `./.repair-snapshots/20251120_204830/windows_mirror_backup/PERPETUAL_TRASH/todo-files-20250730/claude_projects/session_history/backup_2025-07-10_03-55-31-236981/todo_system.db`

**File Stats:**
-rwxrwxrwx 1 groklygroup groklygroup 36K Jul 10 03:55 ./.repair-snapshots/20251120_204830/windows_mirror_backup/PERPETUAL_TRASH/todo-files-20250730/claude_projects/session_history/backup_2025-07-10_03-55-31-236981/todo_system.db

**Size:** 36K

**Modified:** 2025-07-10 03:55:32.000000000 -0700

**Accessed:** 2025-11-23 06:00:21.992647000 -0800

**Tables:**
todo_sources  todos       

**Schema Sample (first 50 lines):**
```sql
CREATE TABLE todos (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    content TEXT NOT NULL,
    project TEXT,
    priority INTEGER,
    status TEXT DEFAULT 'pending',
    source_file TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    system_impact INTEGER DEFAULT 0,
    taxonomycraft_impact INTEGER DEFAULT 0,
    data_loss_risk INTEGER DEFAULT 0,
    dependencies INTEGER DEFAULT 0,
    total_score INTEGER GENERATED ALWAYS AS 
        (system_impact * 3 + taxonomycraft_impact * 2 + data_loss_risk * 2 + dependencies) STORED
);
CREATE TABLE sqlite_sequence(name,seq);
CREATE INDEX idx_priority ON todos(total_score DESC);
CREATE INDEX idx_project ON todos(project);
CREATE INDEX idx_status ON todos(status);
CREATE INDEX idx_score ON todos(total_score DESC);
CREATE TABLE todo_sources (
    path TEXT PRIMARY KEY,
    last_scanned TIMESTAMP,
    last_modified TIMESTAMP
);
```

---

#### Database: `./.repair-snapshots/20251120_204830/windows_mirror_backup/PERPETUAL_TRASH/todo-files-20250730/claude_projects/todo_system.db`

**File Stats:**
-rwxrwxrwx 1 groklygroup groklygroup 36K Jul 10 03:52 ./.repair-snapshots/20251120_204830/windows_mirror_backup/PERPETUAL_TRASH/todo-files-20250730/claude_projects/todo_system.db

**Size:** 36K

**Modified:** 2025-07-10 03:52:47.000000000 -0700

**Accessed:** 2025-11-23 05:59:58.406554700 -0800

**Tables:**
todo_sources  todos       

**Schema Sample (first 50 lines):**
```sql
CREATE TABLE todos (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    content TEXT NOT NULL,
    project TEXT,
    priority INTEGER,
    status TEXT DEFAULT 'pending',
    source_file TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    system_impact INTEGER DEFAULT 0,
    taxonomycraft_impact INTEGER DEFAULT 0,
    data_loss_risk INTEGER DEFAULT 0,
    dependencies INTEGER DEFAULT 0,
    total_score INTEGER GENERATED ALWAYS AS 
        (system_impact * 3 + taxonomycraft_impact * 2 + data_loss_risk * 2 + dependencies) STORED
);
CREATE TABLE sqlite_sequence(name,seq);
CREATE INDEX idx_priority ON todos(total_score DESC);
CREATE INDEX idx_project ON todos(project);
CREATE INDEX idx_status ON todos(status);
CREATE INDEX idx_score ON todos(total_score DESC);
CREATE TABLE todo_sources (
    path TEXT PRIMARY KEY,
    last_scanned TIMESTAMP,
    last_modified TIMESTAMP
);
```

---

#### Database: `./.repair-snapshots/20251120_204830/windows_mirror_backup/PERPETUAL_TRASH/todo-files-20250730-0927/OneDrive - purneeds.com/Documents/Wondershare/Wondershare Filmora/AICache/AITaskInfos.db`

**File Stats:**
-rwxrwxrwx 1 groklygroup groklygroup 12K Oct 21  2024 ./.repair-snapshots/20251120_204830/windows_mirror_backup/PERPETUAL_TRASH/todo-files-20250730-0927/OneDrive - purneeds.com/Documents/Wondershare/Wondershare Filmora/AICache/AITaskInfos.db

**Size:** 12K

**Modified:** 2024-10-21 11:21:39.000000000 -0700

**Accessed:** 2025-11-23 06:02:34.771389400 -0800

**Tables:**
aitaskinfo_table

**Schema Sample (first 50 lines):**
```sql
CREATE TABLE aitaskinfo_table (id integer primary key,taskid text unique not null,wsid text not null,context text not null);
```

---

#### Database: `./.repair-snapshots/20251120_204830/windows_mirror_backup/quantum-index.db`

**File Stats:**
-rwxrwxrwx 1 groklygroup groklygroup 4.0K Jul 14 06:27 ./.repair-snapshots/20251120_204830/windows_mirror_backup/quantum-index.db

**Size:** 4.0K

**Modified:** 2025-07-14 06:27:49.000000000 -0700

**Accessed:** 2025-11-23 23:02:46.258852000 -0800

**Tables:**

**Schema Sample (first 50 lines):**
```sql
```

---

#### Database: `./.repair-snapshots/20251120_204830/windows_mirror_backup/quantum-todo.db`

**File Stats:**
-rwxrwxrwx 1 groklygroup groklygroup 0 Aug 29 06:49 ./.repair-snapshots/20251120_204830/windows_mirror_backup/quantum-todo.db

**Size:** 0

**Modified:** 2025-08-29 06:49:45.000000000 -0700

**Accessed:** 2025-11-21 02:10:36.777212300 -0800

**Tables:**

**Schema Sample (first 50 lines):**
```sql
```

---

#### Database: `./.repair-snapshots/20251120_204830/windows_mirror_backup/todo_system.db`

**File Stats:**
-rwxrwxrwx 1 groklygroup groklygroup 0 Aug 31 00:49 ./.repair-snapshots/20251120_204830/windows_mirror_backup/todo_system.db

**Size:** 0

**Modified:** 2025-08-31 00:49:34.000000000 -0700

**Accessed:** 2025-11-21 02:11:54.157709200 -0800

**Tables:**

**Schema Sample (first 50 lines):**
```sql
```

---

#### Database: `./.repair-snapshots/20251120_204830/windows_mirror_backup/_snapshots/%TS%/.chat-registry/chat-registry.db`

**File Stats:**
-rwxrwxrwx 1 groklygroup groklygroup 28K Aug  9 22:22 ./.repair-snapshots/20251120_204830/windows_mirror_backup/_snapshots/%TS%/.chat-registry/chat-registry.db

**Size:** 28K

**Modified:** 2025-08-09 22:22:17.000000000 -0700

**Accessed:** 2025-11-23 20:42:37.952955500 -0800

**Tables:**
chat_files

**Schema Sample (first 50 lines):**
```sql
CREATE TABLE chat_files (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    file_path TEXT UNIQUE NOT NULL,
    file_name TEXT NOT NULL,
    file_type TEXT,
    file_size INTEGER,
    file_modified TIMESTAMP,
    file_hash TEXT,
    content_preview TEXT,
    todo_count INTEGER DEFAULT 0,
    imported BOOLEAN DEFAULT 0,
    import_date TIMESTAMP,
    discovered_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE sqlite_sequence(name,seq);
CREATE INDEX idx_file_hash ON chat_files(file_hash);
CREATE INDEX idx_file_type ON chat_files(file_type);
CREATE INDEX idx_imported ON chat_files(imported);
```

---

#### Database: `./.repair-snapshots/20251120_204830/windows_mirror_backup/_snapshots/%TS%/.cleanup-analysis/file_analysis.db`

**File Stats:**
-rwxrwxrwx 1 groklygroup groklygroup 44K Jul 15 13:52 ./.repair-snapshots/20251120_204830/windows_mirror_backup/_snapshots/%TS%/.cleanup-analysis/file_analysis.db

**Size:** 44K

**Modified:** 2025-07-15 13:52:14.000000000 -0700

**Accessed:** 2025-11-23 20:32:27.346477400 -0800

**Tables:**
cleanup_categories  duplicate_groups    file_inventory    

**Schema Sample (first 50 lines):**
```sql
CREATE TABLE file_inventory (
    file_path TEXT PRIMARY KEY,
    content_hash TEXT,
    file_size INTEGER,
    modified_time INTEGER,
    mime_type TEXT,
    category TEXT,
    is_duplicate BOOLEAN DEFAULT 0,
    duplicate_group_id INTEGER,
    keep_file BOOLEAN DEFAULT 1,
    safety_score INTEGER DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE duplicate_groups (
    group_id INTEGER PRIMARY KEY AUTOINCREMENT,
    content_hash TEXT UNIQUE,
    file_count INTEGER,
    total_size INTEGER,
    category TEXT,
    keep_file TEXT,
    remove_files TEXT,
    space_saved INTEGER
);
CREATE TABLE sqlite_sequence(name,seq);
CREATE TABLE cleanup_categories (
    category TEXT PRIMARY KEY,
    description TEXT,
    safety_level INTEGER, -- 1=safe, 2=caution, 3=dangerous
    auto_clean BOOLEAN DEFAULT 0,
    file_count INTEGER DEFAULT 0,
    total_size INTEGER DEFAULT 0
);
CREATE INDEX idx_content_hash ON file_inventory(content_hash);
CREATE INDEX idx_category ON file_inventory(category);
CREATE INDEX idx_duplicate ON file_inventory(is_duplicate);
```

---

#### Database: `./.repair-snapshots/20251120_204830/windows_mirror_backup/_snapshots/%TS%/.extraction-progress.db`

**File Stats:**
-rwxrwxrwx 1 groklygroup groklygroup 20K Aug 10 04:45 ./.repair-snapshots/20251120_204830/windows_mirror_backup/_snapshots/%TS%/.extraction-progress.db

**Size:** 20K

**Modified:** 2025-08-10 04:45:28.000000000 -0700

**Accessed:** 2025-11-23 20:43:19.963743500 -0800

**Tables:**
extracted_files   extraction_state

**Schema Sample (first 50 lines):**
```sql
CREATE TABLE extracted_files (
    file_path TEXT PRIMARY KEY,
    file_hash TEXT,
    extraction_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    todos_found INTEGER DEFAULT 0,
    completed_count INTEGER DEFAULT 0,
    pending_count INTEGER DEFAULT 0,
    uncertain_count INTEGER DEFAULT 0
);
CREATE TABLE extraction_state (
    key TEXT PRIMARY KEY,
    value TEXT
);
```

---

#### Database: `./.repair-snapshots/20251120_204830/windows_mirror_backup/_snapshots/%TS%/.index-system/content-analysis.db`

**File Stats:**
-rwxrwxrwx 1 groklygroup groklygroup 88K Sep 23 10:21 ./.repair-snapshots/20251120_204830/windows_mirror_backup/_snapshots/%TS%/.index-system/content-analysis.db

**Size:** 88K

**Modified:** 2025-09-23 10:21:30.000000000 -0700

**Accessed:** 2025-11-23 20:37:54.432148100 -0800

**Tables:**
content_analysis

**Schema Sample (first 50 lines):**
```sql
CREATE TABLE content_analysis (
    doc_id TEXT PRIMARY KEY,
    file_path TEXT NOT NULL,
    content_type TEXT,
    keywords TEXT,
    tags TEXT,
    summary TEXT,
    language TEXT,
    analyzed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX idx_content_path ON content_analysis(file_path);
CREATE INDEX idx_content_type ON content_analysis(content_type);
```

---

#### Database: `./.repair-snapshots/20251120_204830/windows_mirror_backup/_snapshots/%TS%/.index-system/database/file-index.db`

**File Stats:**
-rwxrwxrwx 1 groklygroup groklygroup 0 Aug 16 04:11 ./.repair-snapshots/20251120_204830/windows_mirror_backup/_snapshots/%TS%/.index-system/database/file-index.db

**Size:** 0

**Modified:** 2025-08-16 04:11:35.000000000 -0700

**Accessed:** 2025-11-21 02:32:30.520399600 -0800

**Tables:**

**Schema Sample (first 50 lines):**
```sql
```

---

#### Database: `./.repair-snapshots/20251120_204830/windows_mirror_backup/_snapshots/%TS%/.index-system/database/quantum-index.db`

**File Stats:**
-rwxrwxrwx 1 groklygroup groklygroup 36M Sep 12 16:16 ./.repair-snapshots/20251120_204830/windows_mirror_backup/_snapshots/%TS%/.index-system/database/quantum-index.db

**Size:** 36M

**Modified:** 2025-09-12 16:16:55.000000000 -0700

**Accessed:** 2025-11-23 20:41:02.675858100 -0800

**Tables:**
file_registry            quantum_fts_docsize      todo_dependency_view   
quantum_fts              quantum_fts_idx          todos_archived_20250726
quantum_fts_config       quantum_todos            todos_by_category      
quantum_fts_content      quantum_todos_trash      todos_by_priority      
quantum_fts_data         todo_dependencies        todos_critical_path    

**Schema Sample (first 50 lines):**
```sql
CREATE TABLE quantum_todos (
    id TEXT PRIMARY KEY,
    content TEXT NOT NULL,
    status TEXT NOT NULL,
    priority TEXT NOT NULL,
    source TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    completed_at TIMESTAMP,
    session_id TEXT,
    tags TEXT,
    quantum_state TEXT DEFAULT 'superposition'
, depends_on TEXT, blocks TEXT, dependency_status TEXT DEFAULT 'ready', estimated_hours REAL, actual_hours REAL, dependency_chain_length INTEGER DEFAULT 0, content_hash TEXT, source_file_hash TEXT, source_line_number INTEGER, confidence_level TEXT DEFAULT 'medium', completion_evidence TEXT, auto_completed BOOLEAN DEFAULT 0, completion_reason TEXT, review_date TIMESTAMP);
CREATE TABLE IF NOT EXISTS 'quantum_fts_data'(id INTEGER PRIMARY KEY, block BLOB);
CREATE TABLE IF NOT EXISTS 'quantum_fts_idx'(segid, term, pgno, PRIMARY KEY(segid, term)) WITHOUT ROWID;
CREATE TABLE IF NOT EXISTS 'quantum_fts_content'(id INTEGER PRIMARY KEY, c0, c1);
CREATE TABLE IF NOT EXISTS 'quantum_fts_docsize'(id INTEGER PRIMARY KEY, sz BLOB);
CREATE TABLE IF NOT EXISTS 'quantum_fts_config'(k PRIMARY KEY, v) WITHOUT ROWID;
CREATE TABLE IF NOT EXISTS "todos_archived_20250726" (
    id TEXT PRIMARY KEY,
    content TEXT NOT NULL,
    status TEXT DEFAULT 'pending',
    priority TEXT DEFAULT 'medium',
    source TEXT DEFAULT 'import',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    completed_at DATETIME,
    session_id TEXT,
    tags TEXT,
    quantum_state TEXT DEFAULT 'superposition',
    hash TEXT UNIQUE
);
CREATE TABLE todo_dependencies (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    todo_id TEXT NOT NULL,
    depends_on_id TEXT NOT NULL,
    dependency_type TEXT DEFAULT 'blocks', -- blocks, requires, related
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (todo_id) REFERENCES quantum_todos(id),
    FOREIGN KEY (depends_on_id) REFERENCES quantum_todos(id),
    UNIQUE(todo_id, depends_on_id)
);
CREATE TABLE sqlite_sequence(name,seq);
CREATE TABLE file_registry (file_hash TEXT PRIMARY KEY, current_path TEXT NOT NULL, filename TEXT NOT NULL, last_seen TIMESTAMP DEFAULT CURRENT_TIMESTAMP, file_size INTEGER, file_modified TIMESTAMP, project TEXT, file_type TEXT);
CREATE INDEX idx_status ON quantum_todos(status);
CREATE INDEX idx_priority ON quantum_todos(priority);
CREATE INDEX idx_session ON quantum_todos(session_id);
CREATE INDEX idx_todos_status ON "todos_archived_20250726"(status);
CREATE INDEX idx_todos_priority ON "todos_archived_20250726"(priority);
CREATE INDEX idx_todos_created ON "todos_archived_20250726"(created_at);
CREATE INDEX idx_todos_hash ON "todos_archived_20250726"(hash);
CREATE INDEX idx_hash ON "todos_archived_20250726"(hash);
```

---

#### Database: `./.repair-snapshots/20251120_204830/windows_mirror_backup/_snapshots/%TS%/.index-system/file-index.db`

**File Stats:**
-rwxrwxrwx 1 groklygroup groklygroup 0 Aug 29 07:55 ./.repair-snapshots/20251120_204830/windows_mirror_backup/_snapshots/%TS%/.index-system/file-index.db

**Size:** 0

**Modified:** 2025-08-29 07:55:51.000000000 -0700

**Accessed:** 2025-11-21 02:32:33.058310400 -0800

**Tables:**

**Schema Sample (first 50 lines):**
```sql
```

---

#### Database: `./.repair-snapshots/20251120_204830/windows_mirror_backup/_snapshots/%TS%/.index-system/nl-index.db`

**File Stats:**
-rwxrwxrwx 1 groklygroup groklygroup 56K Aug 11 04:17 ./.repair-snapshots/20251120_204830/windows_mirror_backup/_snapshots/%TS%/.index-system/nl-index.db

**Size:** 56K

**Modified:** 2025-08-11 04:17:00.000000000 -0700

**Accessed:** 2025-11-23 20:41:12.876363700 -0800

**Tables:**
file_content_fts          file_content_fts_docsize  indexing_stats          
file_content_fts_config   file_content_fts_idx      write_queue_stats       
file_content_fts_data     file_index              

**Schema Sample (first 50 lines):**
```sql
CREATE TABLE file_index (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    file_path TEXT UNIQUE NOT NULL,
    file_name TEXT,
    file_size INTEGER,
    file_type TEXT,
    mime_type TEXT,
    encoding TEXT,
    content TEXT,
    content_hash TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    modified_at TIMESTAMP,
    indexed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    metadata TEXT,
    error_msg TEXT,
    retry_count INTEGER DEFAULT 0
);
CREATE TABLE sqlite_sequence(name,seq);
CREATE INDEX idx_file_path ON file_index(file_path);
CREATE INDEX idx_file_name ON file_index(file_name);
CREATE INDEX idx_content_hash ON file_index(content_hash);
CREATE INDEX idx_indexed_at ON file_index(indexed_at);
CREATE TABLE indexing_stats (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    files_processed INTEGER DEFAULT 0,
    bytes_processed INTEGER DEFAULT 0,
    errors INTEGER DEFAULT 0,
    avg_processing_time_ms INTEGER DEFAULT 0
);
CREATE TABLE write_queue_stats (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    queue_size INTEGER DEFAULT 0,
    batch_size INTEGER DEFAULT 0,
    write_time_ms INTEGER DEFAULT 0
);
CREATE VIRTUAL TABLE file_content_fts USING fts5(
    file_path,
    content,
    content=file_index,
    content_rowid=id
)
/* file_content_fts(file_path,content) */;
CREATE TABLE IF NOT EXISTS 'file_content_fts_data'(id INTEGER PRIMARY KEY, block BLOB);
CREATE TABLE IF NOT EXISTS 'file_content_fts_idx'(segid, term, pgno, PRIMARY KEY(segid, term)) WITHOUT ROWID;
CREATE TABLE IF NOT EXISTS 'file_content_fts_docsize'(id INTEGER PRIMARY KEY, sz BLOB);
CREATE TABLE IF NOT EXISTS 'file_content_fts_config'(k PRIMARY KEY, v) WITHOUT ROWID;
CREATE TRIGGER file_index_ai AFTER INSERT ON file_index BEGIN
    INSERT INTO file_content_fts(rowid, file_path, content)
```

---

#### Database: `./.repair-snapshots/20251120_204830/windows_mirror_backup/_snapshots/%TS%/.index-system/quantum-index.db`

**File Stats:**
-rwxrwxrwx 1 groklygroup groklygroup 16K Sep 13 17:23 ./.repair-snapshots/20251120_204830/windows_mirror_backup/_snapshots/%TS%/.index-system/quantum-index.db

**Size:** 16K

**Modified:** 2025-09-13 17:23:05.000000000 -0700

**Accessed:** 2025-11-23 20:38:52.584055500 -0800

**Tables:**
process_patterns

**Schema Sample (first 50 lines):**
```sql
CREATE TABLE process_patterns (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    pattern TEXT UNIQUE,
    avg_runtime INTEGER DEFAULT 0,
    timeout INTEGER DEFAULT 300,
    optimization TEXT,
    kill_count INTEGER DEFAULT 0,
    last_seen TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE sqlite_sequence(name,seq);
```

---

#### Database: `./.repair-snapshots/20251120_204830/windows_mirror_backup/_snapshots/%TS%/.index-system/test-file-index.db`

**File Stats:**
-rwxrwxrwx 1 groklygroup groklygroup 80K Aug 11 21:18 ./.repair-snapshots/20251120_204830/windows_mirror_backup/_snapshots/%TS%/.index-system/test-file-index.db

**Size:** 80K

**Modified:** 2025-08-11 21:18:52.000000000 -0700

**Accessed:** 2025-11-23 20:39:26.645434200 -0800

**Tables:**
file_index              file_index_fts_config   file_index_fts_idx    
file_index_basic        file_index_fts_data     simple_test           
file_index_fts          file_index_fts_docsize

**Schema Sample (first 50 lines):**
```sql
CREATE TABLE simple_test (id INTEGER PRIMARY KEY);
CREATE TABLE file_index_basic (
    id TEXT PRIMARY KEY,
    file_path TEXT NOT NULL,
    filename TEXT,
    extension TEXT,
    file_size INTEGER
);
CREATE VIRTUAL TABLE file_index_fts USING fts5(
    file_path,
    filename,
    content_preview,
    content_full,
    tags,
    keywords,
    content=file_index
)
/* file_index_fts(file_path,filename,content_preview,content_full,tags,keywords) */;
CREATE TABLE IF NOT EXISTS 'file_index_fts_data'(id INTEGER PRIMARY KEY, block BLOB);
CREATE TABLE IF NOT EXISTS 'file_index_fts_idx'(segid, term, pgno, PRIMARY KEY(segid, term)) WITHOUT ROWID;
CREATE TABLE IF NOT EXISTS 'file_index_fts_docsize'(id INTEGER PRIMARY KEY, sz BLOB);
CREATE TABLE IF NOT EXISTS 'file_index_fts_config'(k PRIMARY KEY, v) WITHOUT ROWID;
CREATE TABLE file_index (
    id TEXT PRIMARY KEY,
    file_path TEXT NOT NULL,
    filename TEXT,
    extension TEXT,
    file_size INTEGER,
    modified_at TIMESTAMP,
    indexed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    mime_type TEXT,
    encoding TEXT,
    is_binary BOOLEAN DEFAULT FALSE,
    content_preview TEXT,
    content_full TEXT,
    content_hash TEXT,
    sha256_hash TEXT,
    line_count INTEGER,
    word_count INTEGER,
    char_count INTEGER
);
```

---

#### Database: `./.repair-snapshots/20251120_204830/windows_mirror_backup/_snapshots/%TS%/.protection/protected-files.db`

**File Stats:**
-rwxrwxrwx 1 groklygroup groklygroup 24K Jul 12 22:11 ./.repair-snapshots/20251120_204830/windows_mirror_backup/_snapshots/%TS%/.protection/protected-files.db

**Size:** 24K

**Modified:** 2025-07-12 22:11:48.000000000 -0700

**Accessed:** 2025-11-23 18:44:37.603473200 -0800

**Tables:**
protected_files

**Schema Sample (first 50 lines):**
```sql
CREATE TABLE protected_files (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    file_path TEXT UNIQUE NOT NULL,
    hash TEXT NOT NULL,
    protection_level TEXT DEFAULT 'standard',
    protected_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    reason TEXT
);
CREATE TABLE sqlite_sequence(name,seq);
CREATE INDEX idx_file_path ON protected_files(file_path);
CREATE INDEX idx_protection_level ON protected_files(protection_level);
```

---

#### Database: `./.repair-snapshots/20251120_204830/windows_mirror_backup/_snapshots/%TS%/.quantum-todo/.e2e-test.db`

**File Stats:**
-rwxrwxrwx 1 groklygroup groklygroup 8.0K Sep 16 16:59 ./.repair-snapshots/20251120_204830/windows_mirror_backup/_snapshots/%TS%/.quantum-todo/.e2e-test.db

**Size:** 8.0K

**Modified:** 2025-09-16 16:59:18.000000000 -0700

**Accessed:** 2025-11-23 20:43:45.626212100 -0800

**Tables:**
test_results

**Schema Sample (first 50 lines):**
```sql
CREATE TABLE test_results (
    id INTEGER PRIMARY KEY,
    test_suite TEXT,
    test_name TEXT,
    status TEXT,
    duration REAL,
    error_message TEXT,
    timestamp TEXT DEFAULT CURRENT_TIMESTAMP
);
```

---

#### Database: `./.repair-snapshots/20251120_204830/windows_mirror_backup/_snapshots/%TS%/.quantum-todo/.quantum-behavior.db`

**File Stats:**
-rwxrwxrwx 1 groklygroup groklygroup 208K Sep 17 17:45 ./.repair-snapshots/20251120_204830/windows_mirror_backup/_snapshots/%TS%/.quantum-todo/.quantum-behavior.db

**Size:** 208K

**Modified:** 2025-09-17 17:45:30.000000000 -0700

**Accessed:** 2025-11-23 21:06:29.595596300 -0800

**Tables:**
command_sequences    performance_metrics  user_patterns      
error_predictions    task_predictions   

**Schema Sample (first 50 lines):**
```sql
CREATE TABLE user_patterns (
    id INTEGER PRIMARY KEY,
    pattern_type TEXT,
    pattern_data TEXT,
    frequency INTEGER DEFAULT 1,
    last_seen TEXT DEFAULT CURRENT_TIMESTAMP,
    prediction_accuracy REAL DEFAULT 0.0
);
CREATE TABLE command_sequences (
    id INTEGER PRIMARY KEY,
    command TEXT,
    next_command TEXT,
    frequency INTEGER DEFAULT 1,
    confidence REAL DEFAULT 0.0
);
CREATE TABLE task_predictions (
    id INTEGER PRIMARY KEY,
    context TEXT,
    predicted_task TEXT,
    actual_task TEXT,
    accuracy REAL,
    created_at TEXT DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE performance_metrics (
    id INTEGER PRIMARY KEY,
    metric_type TEXT,
    metric_value REAL,
    timestamp TEXT DEFAULT CURRENT_TIMESTAMP,
    prediction TEXT
);
CREATE TABLE error_predictions (
    id INTEGER PRIMARY KEY,
    error_pattern TEXT,
    prediction_time TEXT,
    actual_time TEXT,
    prevented BOOLEAN DEFAULT 0
);
CREATE INDEX idx_patterns_type ON user_patterns(pattern_type);
CREATE INDEX idx_commands_seq ON command_sequences(command);
CREATE INDEX idx_metrics_type ON performance_metrics(metric_type);
```

---

#### Database: `./.repair-snapshots/20251120_204830/windows_mirror_backup/_snapshots/%TS%/.quantum-todo/.quantum-immunity.db`

**File Stats:**
-rwxrwxrwx 1 groklygroup groklygroup 44K Sep 16 16:34 ./.repair-snapshots/20251120_204830/windows_mirror_backup/_snapshots/%TS%/.quantum-todo/.quantum-immunity.db

**Size:** 44K

**Modified:** 2025-09-16 16:34:29.000000000 -0700

**Accessed:** 2025-11-23 20:43:40.546518300 -0800

**Tables:**
antibodies                 threats                  
immune_responses           vulnerability_predictions
system_health            

**Schema Sample (first 50 lines):**
```sql
CREATE TABLE threats (
    id INTEGER PRIMARY KEY,
    threat_type TEXT,
    threat_signature TEXT UNIQUE,
    severity INTEGER,
    first_detected TEXT DEFAULT CURRENT_TIMESTAMP,
    last_seen TEXT,
    occurrence_count INTEGER DEFAULT 1,
    status TEXT DEFAULT 'active'
);
CREATE TABLE antibodies (
    id INTEGER PRIMARY KEY,
    antibody_id TEXT UNIQUE,
    threat_signature TEXT,
    prevention_code TEXT,
    cure_code TEXT,
    effectiveness REAL DEFAULT 1.0,
    deployment_count INTEGER DEFAULT 0,
    created_at TEXT DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE immune_responses (
    id INTEGER PRIMARY KEY,
    threat_id INTEGER,
    antibody_id TEXT,
    response_type TEXT,
    success BOOLEAN,
    response_time REAL,
    timestamp TEXT DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE system_health (
    id INTEGER PRIMARY KEY,
    component TEXT,
    health_score REAL,
    last_check TEXT DEFAULT CURRENT_TIMESTAMP,
    issues_detected INTEGER DEFAULT 0,
    auto_healed INTEGER DEFAULT 0
);
CREATE TABLE vulnerability_predictions (
    id INTEGER PRIMARY KEY,
    vulnerability_type TEXT,
    component TEXT,
    risk_score REAL,
    predicted_exploit_time TEXT,
    patch_available BOOLEAN DEFAULT 0,
    timestamp TEXT DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX idx_threat_sig ON threats(threat_signature);
CREATE INDEX idx_antibody_threat ON antibodies(threat_signature);
CREATE INDEX idx_health_component ON system_health(component);
```

---

#### Database: `./.repair-snapshots/20251120_204830/windows_mirror_backup/_snapshots/%TS%/.quantum-todo/.quantum-predictions.db`

**File Stats:**
-rwxrwxrwx 1 groklygroup groklygroup 56K Sep 16 16:28 ./.repair-snapshots/20251120_204830/windows_mirror_backup/_snapshots/%TS%/.quantum-todo/.quantum-predictions.db

**Size:** 56K

**Modified:** 2025-09-16 16:28:42.000000000 -0700

**Accessed:** 2025-11-23 20:43:49.766335600 -0800

**Tables:**
cache_predictions     predictions           workflow_patterns   
error_patterns        resource_predictions
ml_models             user_intents        

**Schema Sample (first 50 lines):**
```sql
CREATE TABLE predictions (
    id INTEGER PRIMARY KEY,
    prediction_type TEXT,
    prediction_data JSON,
    confidence REAL,
    created_at TEXT DEFAULT CURRENT_TIMESTAMP,
    expires_at TEXT,
    actual_outcome TEXT,
    accuracy_score REAL
);
CREATE TABLE user_intents (
    id INTEGER PRIMARY KEY,
    session_id TEXT,
    detected_intent TEXT,
    confidence REAL,
    context JSON,
    predicted_next_action TEXT,
    actual_next_action TEXT,
    timestamp TEXT DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE workflow_patterns (
    id INTEGER PRIMARY KEY,
    pattern_hash TEXT UNIQUE,
    workflow_sequence JSON,
    frequency INTEGER DEFAULT 1,
    avg_duration REAL,
    success_rate REAL,
    optimized_sequence JSON
);
CREATE TABLE resource_predictions (
    id INTEGER PRIMARY KEY,
    resource_type TEXT,
    current_usage REAL,
    predicted_usage REAL,
    prediction_window TEXT,
    alert_threshold REAL,
    timestamp TEXT DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE error_patterns (
    id INTEGER PRIMARY KEY,
    error_signature TEXT,
    occurrence_pattern JSON,
    prediction_model JSON,
    prevention_strategy JSON,
    success_count INTEGER DEFAULT 0
);
CREATE TABLE cache_predictions (
    id INTEGER PRIMARY KEY,
    query_pattern TEXT,
    predicted_result JSON,
```

---

#### Database: `./.repair-snapshots/20251120_204830/windows_mirror_backup/_snapshots/%TS%/.quantum-todo/.test-backup-20250917-224155/quantum-todo.db`

**File Stats:**
-rwxrwxrwx 1 groklygroup groklygroup 184K Sep 17 22:41 ./.repair-snapshots/20251120_204830/windows_mirror_backup/_snapshots/%TS%/.quantum-todo/.test-backup-20250917-224155/quantum-todo.db

**Size:** 184K

**Modified:** 2025-09-17 22:41:53.000000000 -0700

**Accessed:** 2025-11-23 20:43:54.993510500 -0800

**Tables:**
alert_history        performance_metrics  roles              
alert_rules          quantum_fts          tenant_config      
api_keys             quantum_fts_config   todo_dependencies  
audit_log            quantum_fts_data     user_roles         
cache_config         quantum_fts_docsize  webhook_events     
csrf_tokens          quantum_fts_idx      webhooks           
dependency_counts    quantum_todos        white_label_config 

**Schema Sample (first 50 lines):**
```sql
CREATE TABLE quantum_todos (
    id TEXT PRIMARY KEY,
    content TEXT NOT NULL,
    status TEXT NOT NULL DEFAULT 'pending',
    priority TEXT NOT NULL DEFAULT 'medium',
    priority_order INTEGER DEFAULT 999,
    source TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    completed_at TIMESTAMP,
    session_id TEXT,
    tags TEXT,
    quantum_state TEXT DEFAULT 'superposition',
    dependency_status TEXT DEFAULT 'ready',
    dependency_chain_length INTEGER DEFAULT 0,
    tenant_id TEXT DEFAULT 'default',
    content_hash TEXT,
    ml_priority_score REAL DEFAULT 0.5,
    predicted_duration INTEGER,
    actual_duration INTEGER
);
CREATE TABLE tenant_config (
    tenant_id TEXT PRIMARY KEY,
    max_todos INTEGER DEFAULT 10000,
    max_storage_mb INTEGER DEFAULT 100,
    features TEXT DEFAULT '{}',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE api_keys (
    key_hash TEXT PRIMARY KEY,
    tenant_id TEXT NOT NULL,
    user_id TEXT NOT NULL,
    permissions TEXT DEFAULT '{}',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_used TIMESTAMP,
    expires_at TIMESTAMP,
    FOREIGN KEY (tenant_id) REFERENCES tenant_config(tenant_id)
);
CREATE TABLE audit_log (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    tenant_id TEXT NOT NULL,
    user_id TEXT,
    action TEXT NOT NULL,
    resource_type TEXT,
    resource_id TEXT,
    details TEXT,
    ip_address TEXT,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE sqlite_sequence(name,seq);
```

---

#### Database: `./.repair-snapshots/20251120_204830/windows_mirror_backup/_snapshots/%TS%/.quantum-todo/auto-backup-20250916-142107.db`

**File Stats:**
-rwxrwxrwx 1 groklygroup groklygroup 44M Sep 16 14:21 ./.repair-snapshots/20251120_204830/windows_mirror_backup/_snapshots/%TS%/.quantum-todo/auto-backup-20250916-142107.db

**Size:** 44M

**Modified:** 2025-09-16 14:21:09.000000000 -0700

**Accessed:** 2025-11-23 20:51:14.608387700 -0800

**Tables:**
quantum_fts          quantum_fts_docsize  todo_dependencies  
quantum_fts_config   quantum_fts_idx    
quantum_fts_data     quantum_todos      

**Schema Sample (first 50 lines):**
```sql
CREATE TABLE quantum_todos (
    id TEXT PRIMARY KEY,
    content TEXT NOT NULL,
    status TEXT NOT NULL DEFAULT 'pending',
    priority TEXT NOT NULL DEFAULT 'medium',
    source TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    completed_at TIMESTAMP,
    session_id TEXT,
    tags TEXT,
    quantum_state TEXT DEFAULT 'superposition',
    dependency_status TEXT DEFAULT 'ready',
    dependency_chain_length INTEGER DEFAULT 0
);
CREATE TABLE todo_dependencies (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    todo_id TEXT NOT NULL,
    depends_on_id TEXT NOT NULL,
    dependency_type TEXT DEFAULT 'blocks',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (todo_id) REFERENCES quantum_todos (id),
    FOREIGN KEY (depends_on_id) REFERENCES quantum_todos (id),
    UNIQUE(todo_id, depends_on_id)
);
CREATE TABLE sqlite_sequence(name,seq);
CREATE INDEX idx_status ON quantum_todos(status);
CREATE INDEX idx_priority ON quantum_todos(priority);
CREATE INDEX idx_dependency_status ON quantum_todos(dependency_status);
CREATE INDEX idx_dependency_todo ON todo_dependencies(todo_id);
CREATE INDEX idx_dependency_depends ON todo_dependencies(depends_on_id);
CREATE VIRTUAL TABLE quantum_fts USING fts5(content, content=quantum_todos)
/* quantum_fts(content) */;
CREATE TABLE IF NOT EXISTS 'quantum_fts_data'(id INTEGER PRIMARY KEY, block BLOB);
CREATE TABLE IF NOT EXISTS 'quantum_fts_idx'(segid, term, pgno, PRIMARY KEY(segid, term)) WITHOUT ROWID;
CREATE TABLE IF NOT EXISTS 'quantum_fts_docsize'(id INTEGER PRIMARY KEY, sz BLOB);
CREATE TABLE IF NOT EXISTS 'quantum_fts_config'(k PRIMARY KEY, v) WITHOUT ROWID;
```

---

#### Database: `./.repair-snapshots/20251120_204830/windows_mirror_backup/_snapshots/%TS%/.quantum-todo/quantum-index.db`

**File Stats:**
-rwxrwxrwx 1 groklygroup groklygroup 64M Sep 23 19:46 ./.repair-snapshots/20251120_204830/windows_mirror_backup/_snapshots/%TS%/.quantum-todo/quantum-index.db

**Size:** 64M

**Modified:** 2025-09-23 19:46:23.000000000 -0700

**Accessed:** 2025-11-23 21:15:25.739944800 -0800

**Tables:**
anomaly_detections       ml_processing_progress   quantum_todos_optimized
api_keys                 ml_training_data         roles                  
audit_log                nlp_patterns             tenant_config          
audit_trail              performance_metrics      tenant_usage           
cache_config             quantum_execution_plan   theme_presets          
csrf_tokens              quantum_fts              todo_dependencies      
custom_domains           quantum_fts_config       todo_file_links        
dependency_counts        quantum_fts_data         ui_components          
email_templates          quantum_fts_docsize      user_behavior          
file_index               quantum_fts_idx          user_roles             
ml_models                quantum_todos            white_label_config     
ml_predictions           quantum_todos_archive  

**Schema Sample (first 50 lines):**
```sql
CREATE TABLE quantum_todos (
    id TEXT PRIMARY KEY,
    content TEXT NOT NULL,
    status TEXT NOT NULL DEFAULT 'pending',
    priority TEXT NOT NULL DEFAULT 'medium',
    source TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    completed_at TIMESTAMP,
    session_id TEXT,
    tags TEXT,
    quantum_state TEXT DEFAULT 'superposition',
    dependency_status TEXT DEFAULT 'ready',
    dependency_chain_length INTEGER DEFAULT 0
, craft_framework TEXT, project_tags TEXT, ml_priority_score REAL, content_hash TEXT, composite_content TEXT, tenant_id TEXT DEFAULT 'default', priority_order INTEGER DEFAULT 3);
CREATE TABLE todo_dependencies (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    todo_id TEXT NOT NULL,
    depends_on_id TEXT NOT NULL,
    dependency_type TEXT DEFAULT 'blocks',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (todo_id) REFERENCES quantum_todos (id),
    FOREIGN KEY (depends_on_id) REFERENCES quantum_todos (id),
    UNIQUE(todo_id, depends_on_id)
);
CREATE TABLE sqlite_sequence(name,seq);
CREATE TABLE IF NOT EXISTS 'quantum_fts_data'(id INTEGER PRIMARY KEY, block BLOB);
CREATE TABLE IF NOT EXISTS 'quantum_fts_idx'(segid, term, pgno, PRIMARY KEY(segid, term)) WITHOUT ROWID;
CREATE TABLE IF NOT EXISTS 'quantum_fts_docsize'(id INTEGER PRIMARY KEY, sz BLOB);
CREATE TABLE IF NOT EXISTS 'quantum_fts_config'(k PRIMARY KEY, v) WITHOUT ROWID;
CREATE TABLE sqlite_stat1(tbl,idx,stat);
CREATE TABLE file_index (
    file_path TEXT PRIMARY KEY,
    last_referenced TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    reference_count INTEGER DEFAULT 1
);
CREATE TABLE todo_file_links (
    todo_id TEXT,
    file_path TEXT,
    FOREIGN KEY (todo_id) REFERENCES quantum_todos(id),
    FOREIGN KEY (file_path) REFERENCES file_index(file_path)
);
CREATE TABLE ml_processing_progress (
    content_type TEXT PRIMARY KEY,
    last_processed_id TEXT,
    last_processed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    items_processed INTEGER DEFAULT 0,
    tenant_id TEXT DEFAULT 'default'
);
CREATE TABLE audit_trail (
    audit_id TEXT PRIMARY KEY,
```

---

#### Database: `./.repair-snapshots/20251120_204830/windows_mirror_backup/_snapshots/%TS%/.quantum-todo/quantum-test.db`

**File Stats:**
-rwxrwxrwx 1 groklygroup groklygroup 0 Sep 17 22:42 ./.repair-snapshots/20251120_204830/windows_mirror_backup/_snapshots/%TS%/.quantum-todo/quantum-test.db

**Size:** 0

**Modified:** 2025-09-17 22:42:40.000000000 -0700

**Accessed:** 2025-11-21 02:38:10.213120700 -0800

**Tables:**

**Schema Sample (first 50 lines):**
```sql
```

---

#### Database: `./.repair-snapshots/20251120_204830/windows_mirror_backup/_snapshots/%TS%/.quantum-todo/quantum-todo.db`

**File Stats:**
-rwxrwxrwx 1 groklygroup groklygroup 22M Sep 21 10:06 ./.repair-snapshots/20251120_204830/windows_mirror_backup/_snapshots/%TS%/.quantum-todo/quantum-todo.db

**Size:** 22M

**Modified:** 2025-09-21 10:06:15.000000000 -0700

**Accessed:** 2025-11-23 20:59:31.389893700 -0800

**Tables:**
alert_history        performance_metrics  roles              
alert_rules          quantum_fts          tenant_config      
api_keys             quantum_fts_config   todo_dependencies  
audit_log            quantum_fts_data     user_roles         
cache_config         quantum_fts_docsize  webhook_events     
csrf_tokens          quantum_fts_idx      webhooks           
dependency_counts    quantum_todos        white_label_config 

**Schema Sample (first 50 lines):**
```sql
CREATE TABLE tenant_config (
    tenant_id TEXT PRIMARY KEY,
    max_todos INTEGER DEFAULT 10000,
    max_storage_mb INTEGER DEFAULT 100,
    features TEXT DEFAULT '{}',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE api_keys (
    key_hash TEXT PRIMARY KEY,
    tenant_id TEXT NOT NULL,
    user_id TEXT NOT NULL,
    permissions TEXT DEFAULT '{}',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_used TIMESTAMP,
    expires_at TIMESTAMP,
    FOREIGN KEY (tenant_id) REFERENCES tenant_config(tenant_id)
);
CREATE TABLE audit_log (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    tenant_id TEXT NOT NULL,
    user_id TEXT,
    action TEXT NOT NULL,
    resource_type TEXT,
    resource_id TEXT,
    details TEXT,
    ip_address TEXT,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE sqlite_sequence(name,seq);
CREATE TABLE roles (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    role_name TEXT NOT NULL UNIQUE,
    permissions TEXT NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE user_roles (
    user_id TEXT NOT NULL,
    role_id INTEGER NOT NULL,
    tenant_id TEXT NOT NULL,
    assigned_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id, role_id, tenant_id),
    FOREIGN KEY (role_id) REFERENCES roles(id)
);
CREATE TABLE white_label_config (
    tenant_id TEXT PRIMARY KEY,
    brand_name TEXT NOT NULL DEFAULT 'Quantum TODO',
    brand_tagline TEXT DEFAULT 'Enterprise Task Management',
    primary_color TEXT DEFAULT '#3498db',
```

---

#### Database: `./.repair-snapshots/20251120_204830/windows_mirror_backup/_snapshots/%TS%/.quantum-todo/quantum-todos.db`

**File Stats:**
-rwxrwxrwx 1 groklygroup groklygroup 0 Aug 16 21:25 ./.repair-snapshots/20251120_204830/windows_mirror_backup/_snapshots/%TS%/.quantum-todo/quantum-todos.db

**Size:** 0

**Modified:** 2025-08-16 21:25:25.000000000 -0700

**Accessed:** 2025-11-21 02:38:11.505307500 -0800

**Tables:**

**Schema Sample (first 50 lines):**
```sql
```

---

#### Database: `./.repair-snapshots/20251120_204830/windows_mirror_backup/_snapshots/%TS%/chat_sessions.db`

**File Stats:**
-rwxrwxrwx 1 groklygroup groklygroup 64K Jul 24 15:30 ./.repair-snapshots/20251120_204830/windows_mirror_backup/_snapshots/%TS%/chat_sessions.db

**Size:** 64K

**Modified:** 2025-07-24 15:30:43.000000000 -0700

**Accessed:** 2025-11-23 20:31:29.622733100 -0800

**Tables:**
chat_sessions

**Schema Sample (first 50 lines):**
```sql
CREATE TABLE chat_sessions (
    session_id TEXT PRIMARY KEY,
    file_path TEXT NOT NULL,
    start_time TEXT,
    end_time TEXT,
    line_count INTEGER,
    size_bytes INTEGER,
    project TEXT,
    extracted_from TEXT,
    metadata TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX idx_project ON chat_sessions(project);
CREATE INDEX idx_start_time ON chat_sessions(start_time);
```

---

#### Database: `./.repair-snapshots/20251120_204830/windows_mirror_backup/_snapshots/%TS%/claude_sessions.db`

**File Stats:**
-rwxrwxrwx 1 groklygroup groklygroup 24K Jul 22 00:00 ./.repair-snapshots/20251120_204830/windows_mirror_backup/_snapshots/%TS%/claude_sessions.db

**Size:** 24K

**Modified:** 2025-07-22 00:00:22.000000000 -0700

**Accessed:** 2025-11-23 21:11:40.801191800 -0800

**Tables:**
claude_sessions

**Schema Sample (first 50 lines):**
```sql
CREATE TABLE claude_sessions (
    session_id TEXT PRIMARY KEY,
    project TEXT NOT NULL,
    worktree_path TEXT NOT NULL,
    branch TEXT NOT NULL,
    status TEXT DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_active TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    tmux_session TEXT,
    pid INTEGER,
    metadata TEXT
);
CREATE INDEX idx_project ON claude_sessions(project);
CREATE INDEX idx_status ON claude_sessions(status);
CREATE INDEX idx_tmux ON claude_sessions(tmux_session);
```

---

#### Database: `./.repair-snapshots/20251120_204830/windows_mirror_backup/_snapshots/%TS%/file_protection.db`

**File Stats:**
-rwxrwxrwx 1 groklygroup groklygroup 36K Jul 21 23:57 ./.repair-snapshots/20251120_204830/windows_mirror_backup/_snapshots/%TS%/file_protection.db

**Size:** 36K

**Modified:** 2025-07-21 23:57:12.000000000 -0700

**Accessed:** 2025-11-23 20:42:55.474383500 -0800

**Tables:**
file_history     protected_files

**Schema Sample (first 50 lines):**
```sql
CREATE TABLE protected_files (
    file_id TEXT PRIMARY KEY,
    path TEXT NOT NULL UNIQUE,
    sha256_hash TEXT NOT NULL,
    protection_level TEXT DEFAULT 'standard',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_modified TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    backup_path TEXT,
    metadata TEXT
);
CREATE TABLE file_history (
    history_id TEXT PRIMARY KEY,
    file_id TEXT NOT NULL,
    action TEXT NOT NULL,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    old_hash TEXT,
    new_hash TEXT,
    user TEXT,
    reason TEXT,
    FOREIGN KEY (file_id) REFERENCES protected_files(file_id)
);
CREATE INDEX idx_path ON protected_files(path);
CREATE INDEX idx_protection ON protected_files(protection_level);
CREATE INDEX idx_file_history ON file_history(file_id);
```

---

#### Database: `./.repair-snapshots/20251120_204830/windows_mirror_backup/_snapshots/%TS%/GLOBAL_CHAT_STORAGE.db`

**File Stats:**
-rwxrwxrwx 1 groklygroup groklygroup 240K Jun 18 09:57 ./.repair-snapshots/20251120_204830/windows_mirror_backup/_snapshots/%TS%/GLOBAL_CHAT_STORAGE.db

**Size:** 240K

**Modified:** 2025-06-18 09:57:20.000000000 -0700

**Accessed:** 2025-11-23 20:43:21.183705700 -0800

**Tables:**
global_sessions         message_search_content  message_search_idx    
message_search          message_search_data     messages              
message_search_config   message_search_docsize  projects              

**Schema Sample (first 50 lines):**
```sql
CREATE TABLE projects (
                    id INTEGER PRIMARY KEY AUTOINCREMENT,
                    project_name TEXT UNIQUE NOT NULL,
                    project_path TEXT NOT NULL,
                    description TEXT,
                    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
                );
CREATE TABLE sqlite_sequence(name,seq);
CREATE TABLE global_sessions (
                    id INTEGER PRIMARY KEY AUTOINCREMENT,
                    session_id TEXT UNIQUE NOT NULL,
                    project_id INTEGER NOT NULL,
                    project_name TEXT NOT NULL,
                    session_name TEXT,
                    conversation_history TEXT NOT NULL,  -- Full JSON with complete fidelity
                    message_count INTEGER DEFAULT 0,
                    total_tokens INTEGER DEFAULT 0,
                    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                    metadata TEXT,  -- JSON metadata
                    tags TEXT,      -- Comma-separated tags
                    FOREIGN KEY (project_id) REFERENCES projects (id)
                );
CREATE TABLE messages (
                    id INTEGER PRIMARY KEY AUTOINCREMENT,
                    session_id TEXT NOT NULL,
                    project_name TEXT NOT NULL,
                    role TEXT NOT NULL,
                    content TEXT NOT NULL,  -- Complete message content
                    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                    metadata TEXT,  -- JSON for tool calls, file refs, etc
                    FOREIGN KEY (session_id) REFERENCES global_sessions (session_id)
                );
CREATE VIRTUAL TABLE message_search 
                USING fts5(session_id, project_name, content, metadata)
/* message_search(session_id,project_name,content,metadata) */;
CREATE TABLE IF NOT EXISTS 'message_search_data'(id INTEGER PRIMARY KEY, block BLOB);
CREATE TABLE IF NOT EXISTS 'message_search_idx'(segid, term, pgno, PRIMARY KEY(segid, term)) WITHOUT ROWID;
CREATE TABLE IF NOT EXISTS 'message_search_content'(id INTEGER PRIMARY KEY, c0, c1, c2, c3);
CREATE TABLE IF NOT EXISTS 'message_search_docsize'(id INTEGER PRIMARY KEY, sz BLOB);
CREATE TABLE IF NOT EXISTS 'message_search_config'(k PRIMARY KEY, v) WITHOUT ROWID;
CREATE INDEX idx_sessions_project ON global_sessions(project_name);
CREATE INDEX idx_sessions_updated ON global_sessions(updated_at DESC);
CREATE INDEX idx_messages_session ON messages(session_id);
CREATE INDEX idx_messages_project ON messages(project_name);
CREATE INDEX idx_messages_timestamp ON messages(timestamp);
```

---

#### Database: `./.repair-snapshots/20251120_204830/windows_mirror_backup/_snapshots/%TS%/quantum-index.db`

**File Stats:**
-rwxrwxrwx 1 groklygroup groklygroup 4.0K Jul 14 06:27 ./.repair-snapshots/20251120_204830/windows_mirror_backup/_snapshots/%TS%/quantum-index.db

**Size:** 4.0K

**Modified:** 2025-07-14 06:27:49.000000000 -0700

**Accessed:** 2025-11-23 20:43:37.206234500 -0800

**Tables:**

**Schema Sample (first 50 lines):**
```sql
```

---

#### Database: `./.repair-snapshots/20251120_204830/windows_mirror_backup/_snapshots/%TS%/quantum-todo.db`

**File Stats:**
-rwxrwxrwx 1 groklygroup groklygroup 0 Aug 29 06:49 ./.repair-snapshots/20251120_204830/windows_mirror_backup/_snapshots/%TS%/quantum-todo.db

**Size:** 0

**Modified:** 2025-08-29 06:49:45.000000000 -0700

**Accessed:** 2025-08-29 06:49:45.000000000 -0700

**Tables:**

**Schema Sample (first 50 lines):**
```sql
```

---

#### Database: `./.repair-snapshots/20251120_204830/windows_mirror_backup/_snapshots/%TS%/todo_system.db`

**File Stats:**
-rwxrwxrwx 1 groklygroup groklygroup 0 Aug 31 00:49 ./.repair-snapshots/20251120_204830/windows_mirror_backup/_snapshots/%TS%/todo_system.db

**Size:** 0

**Modified:** 2025-08-31 00:49:34.000000000 -0700

**Accessed:** 2025-08-31 00:49:34.000000000 -0700

**Tables:**

**Schema Sample (first 50 lines):**
```sql
```

---

#### Database: `./.rollback/quantum-20250714-181922/.quantum-todo/quantum-index.db`

**File Stats:**
-rwxrwxrwx 1 groklygroup groklygroup 2.4M Jul 14 06:23 ./.rollback/quantum-20250714-181922/.quantum-todo/quantum-index.db

**Size:** 2.4M

**Modified:** 2025-07-14 06:23:49.000000000 -0700

**Accessed:** 2025-07-14 18:19:44.269362800 -0700

**Tables:**
quantum_fts          quantum_fts_docsize  todos_by_category  
quantum_fts_config   quantum_fts_idx      todos_by_priority  
quantum_fts_content  quantum_todos        todos_critical_path
quantum_fts_data     todos              

**Schema Sample (first 50 lines):**
```sql
CREATE TABLE quantum_todos (
    id TEXT PRIMARY KEY,
    content TEXT NOT NULL,
    status TEXT NOT NULL,
    priority TEXT NOT NULL,
    source TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    completed_at TIMESTAMP,
    session_id TEXT,
    tags TEXT,
    quantum_state TEXT DEFAULT 'superposition'
);
CREATE TABLE IF NOT EXISTS 'quantum_fts_data'(id INTEGER PRIMARY KEY, block BLOB);
CREATE TABLE IF NOT EXISTS 'quantum_fts_idx'(segid, term, pgno, PRIMARY KEY(segid, term)) WITHOUT ROWID;
CREATE TABLE IF NOT EXISTS 'quantum_fts_content'(id INTEGER PRIMARY KEY, c0, c1);
CREATE TABLE IF NOT EXISTS 'quantum_fts_docsize'(id INTEGER PRIMARY KEY, sz BLOB);
CREATE TABLE IF NOT EXISTS 'quantum_fts_config'(k PRIMARY KEY, v) WITHOUT ROWID;
CREATE INDEX idx_status ON quantum_todos(status);
CREATE INDEX idx_priority ON quantum_todos(priority);
CREATE INDEX idx_session ON quantum_todos(session_id);
CREATE VIRTUAL TABLE quantum_fts USING fts5(content, tags)
/* quantum_fts(content,tags) */;
CREATE VIEW todos_by_priority AS
SELECT 
    id,
    CASE priority
        WHEN 'critical' THEN '🚨 CRITICAL'
        WHEN 'high' THEN '🔴 HIGH'
        WHEN 'medium' THEN '🟡 MEDIUM'
        WHEN 'low' THEN '🟢 LOW'
        ELSE '⚪ UNSET'
    END as priority_label,
    substr(content, 1, 80) || CASE WHEN length(content) > 80 THEN '...' ELSE '' END as content,
    tags,
    created_at
FROM quantum_todos
WHERE status = 'pending'
ORDER BY 
    CASE priority
        WHEN 'critical' THEN 1
        WHEN 'high' THEN 2
        WHEN 'medium' THEN 3
        WHEN 'low' THEN 4
        ELSE 5
    END,
    created_at
/* todos_by_priority(id,priority_label,content,tags,created_at) */;
CREATE VIEW todos_by_category AS
SELECT 
    CASE 
```

---

#### Database: `./.search-index/metadata.db`

**File Stats:**
-rwxrwxrwx 1 groklygroup groklygroup 21M Dec  6 20:11 ./.search-index/metadata.db

**Size:** 21M

**Modified:** 2025-12-06 20:11:57.356691000 -0800

**Accessed:** 2025-12-06 20:11:57.356691000 -0800

**Tables:**
ai_content_view         file_index_fts_docsize  files_fts_docsize     
file_index              file_index_fts_idx      files_fts_idx         
file_index_fts          files                   index_config          
file_index_fts_config   files_fts               stats                 
file_index_fts_content  files_fts_config      
file_index_fts_data     files_fts_data        

**Schema Sample (first 50 lines):**
```sql
CREATE TABLE file_index (
    -- Core File Information
    id TEXT PRIMARY KEY,                    -- DOC-{SHA256_8}-{TIMESTAMP}
    file_path TEXT NOT NULL,
    filename TEXT,
    extension TEXT,
    file_size INTEGER,
    created_at TIMESTAMP,
    modified_at TIMESTAMP,
    indexed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- Copyright and Authorship
    copyright_owner TEXT DEFAULT 'groklyGroup™ LLC 2025',
    authors JSON,                           -- Detected content creators
    
    -- Enhanced File Type Information
    mime_type TEXT,
    encoding TEXT,
    is_binary BOOLEAN DEFAULT FALSE,
    
    -- File System Metadata
    permissions TEXT,
    owner TEXT,
    group_owner TEXT,
    symlink_target TEXT,
    
    -- Content & Hashing
    sha256_hash TEXT UNIQUE,
    content_hash TEXT,
    content_preview TEXT,                   -- First 2000 chars (increased from 500)
    content_full TEXT,                      -- Full text for FTS
    line_count INTEGER,
    word_count INTEGER,
    char_count INTEGER,
    
    -- AI-Powered Tags & Classification
    tags TEXT,                              -- AI-generated tags
    categories JSON,                        -- Multiple categories support
    keywords JSON,                          -- AI-extracted with relevance scores
    languages JSON,                         -- Multiple languages support
    
    -- Relationships & References
    parent_id TEXT,
    related_ids JSON,
    imports JSON,
    imported_by JSON,
    cross_refs JSON,
    semantic_embeddings BLOB,               -- Vector embeddings
    similar_files JSON,
    dependency_graph JSON,
```

---

#### Database: `./.session-management/sessions.db`

**File Stats:**
-rwxrwxrwx 1 groklygroup groklygroup 100K Nov 17 02:11 ./.session-management/sessions.db

**Size:** 100K

**Modified:** 2025-11-17 02:11:31.000000000 -0800

**Accessed:** 2025-12-05 12:12:47.000000000 -0800

**Tables:**
backup_status   sessions_full   sessions_quick

**Schema Sample (first 50 lines):**
```sql
CREATE TABLE sessions_quick (
    session_id TEXT PRIMARY KEY,
    timestamp DATETIME DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE sessions_full (
    session_id TEXT PRIMARY KEY,
    timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
    project TEXT,
    summary TEXT,
    completed_tasks TEXT,  -- JSON array of completed tasks
    pending_tasks TEXT,    -- JSON array of pending tasks
    modified_files TEXT,   -- JSON array of modified file paths
    critical_notes TEXT,
    tmux_session TEXT,
    chat_backup_path TEXT,
    line_count INTEGER DEFAULT 0
);
CREATE TABLE backup_status (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    session_id TEXT NOT NULL,
    backup_timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
    status TEXT CHECK(status IN ('active', 'completed', 'failed', 'warning')) DEFAULT 'active',
    file_path TEXT,
    file_size_bytes INTEGER,
    last_update DATETIME DEFAULT CURRENT_TIMESTAMP,
    error_message TEXT,
    FOREIGN KEY (session_id) REFERENCES sessions_full(session_id)
);
CREATE TABLE sqlite_sequence(name,seq);
CREATE INDEX idx_sessions_quick_timestamp ON sessions_quick(timestamp DESC);
CREATE INDEX idx_sessions_full_timestamp ON sessions_full(timestamp DESC);
CREATE INDEX idx_sessions_full_project ON sessions_full(project);
CREATE INDEX idx_backup_status_session_id ON backup_status(session_id);
CREATE INDEX idx_backup_status_status ON backup_status(status);
CREATE INDEX idx_backup_status_timestamp ON backup_status(backup_timestamp DESC);
CREATE TRIGGER update_backup_status_timestamp 
AFTER UPDATE ON backup_status
BEGIN
    UPDATE backup_status 
    SET last_update = CURRENT_TIMESTAMP 
    WHERE id = NEW.id;
END;
```

---

#### Database: `./.session-management/sessions_replica.db`

**File Stats:**
-rwxrwxrwx 1 groklygroup groklygroup 100K Nov 17 02:11 ./.session-management/sessions_replica.db

**Size:** 100K

**Modified:** 2025-11-17 02:11:31.000000000 -0800

**Accessed:** 2025-12-05 12:12:47.000000000 -0800

**Tables:**
backup_status   sessions_full   sessions_quick

**Schema Sample (first 50 lines):**
```sql
CREATE TABLE sessions_quick (
    session_id TEXT PRIMARY KEY,
    timestamp DATETIME DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE sessions_full (
    session_id TEXT PRIMARY KEY,
    timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
    project TEXT,
    summary TEXT,
    completed_tasks TEXT,  -- JSON array of completed tasks
    pending_tasks TEXT,    -- JSON array of pending tasks
    modified_files TEXT,   -- JSON array of modified file paths
    critical_notes TEXT,
    tmux_session TEXT,
    chat_backup_path TEXT,
    line_count INTEGER DEFAULT 0
);
CREATE TABLE backup_status (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    session_id TEXT NOT NULL,
    backup_timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
    status TEXT CHECK(status IN ('active', 'completed', 'failed', 'warning')) DEFAULT 'active',
    file_path TEXT,
    file_size_bytes INTEGER,
    last_update DATETIME DEFAULT CURRENT_TIMESTAMP,
    error_message TEXT,
    FOREIGN KEY (session_id) REFERENCES sessions_full(session_id)
);
CREATE TABLE sqlite_sequence(name,seq);
CREATE INDEX idx_sessions_quick_timestamp ON sessions_quick(timestamp DESC);
CREATE INDEX idx_sessions_full_timestamp ON sessions_full(timestamp DESC);
CREATE INDEX idx_sessions_full_project ON sessions_full(project);
CREATE INDEX idx_backup_status_session_id ON backup_status(session_id);
CREATE INDEX idx_backup_status_status ON backup_status(status);
CREATE INDEX idx_backup_status_timestamp ON backup_status(backup_timestamp DESC);
CREATE TRIGGER update_backup_status_timestamp 
AFTER UPDATE ON backup_status
BEGIN
    UPDATE backup_status 
    SET last_update = CURRENT_TIMESTAMP 
    WHERE id = NEW.id;
END;
```

---

#### Database: `./.test-environment/.index-system/database/file-index-test.db`

**File Stats:**
-rwxrwxrwx 1 groklygroup groklygroup 0 Nov 17 02:11 ./.test-environment/.index-system/database/file-index-test.db

**Size:** 0

**Modified:** 2025-11-17 02:11:44.000000000 -0800

**Accessed:** 2025-11-24 19:33:51.000000000 -0800

**Tables:**

**Schema Sample (first 50 lines):**
```sql
```

---

#### Database: `./.test-environment/.quantum-todo/quantum-test.db`

**File Stats:**
-rw-r--r-- 1 groklygroup groklygroup 100K Sep  3 11:47 ./.test-environment/.quantum-todo/quantum-test.db

**Size:** 100K

**Modified:** 2025-09-03 11:47:05.355176500 -0700

**Accessed:** 2025-09-03 11:47:21.863536700 -0700

**Tables:**
quantum_fts        quantum_todos      todo_dependencies

**Schema Sample (first 50 lines):**
```sql
CREATE TABLE quantum_todos(
  id TEXT,
  content TEXT,
  status TEXT,
  priority TEXT,
  source TEXT,
  created_at NUM,
  completed_at NUM,
  session_id TEXT,
  tags TEXT,
  quantum_state TEXT,
  dependency_status TEXT,
  dependency_chain_length INT
);
CREATE TABLE todo_dependencies(
  id INT,
  todo_id TEXT,
  depends_on_id TEXT,
  dependency_type TEXT,
  created_at NUM
);
CREATE TABLE quantum_fts(content);
```

---

#### Database: `./.test-environment/checkpoints/checkpoint-20250903-222519-initial/index-db-backup.db`

**File Stats:**
-rwxrwxrwx 1 groklygroup groklygroup 0 Nov 17 02:11 ./.test-environment/checkpoints/checkpoint-20250903-222519-initial/index-db-backup.db

**Size:** 0

**Modified:** 2025-11-17 02:11:53.000000000 -0800

**Accessed:** 2025-11-24 19:33:55.000000000 -0800

**Tables:**

**Schema Sample (first 50 lines):**
```sql
```

---

#### Database: `./.test-environment/checkpoints/checkpoint-20250903-222519-initial/quantum-db-backup.db`

**File Stats:**
-rwxrwxrwx 1 groklygroup groklygroup 38M Nov 17 02:11 ./.test-environment/checkpoints/checkpoint-20250903-222519-initial/quantum-db-backup.db

**Size:** 38M

**Modified:** 2025-11-17 02:11:53.000000000 -0800

**Accessed:** 2025-12-05 12:12:50.000000000 -0800

**Tables:**
quantum_fts          quantum_fts_docsize  todo_dependencies  
quantum_fts_config   quantum_fts_idx    
quantum_fts_data     quantum_todos      

**Schema Sample (first 50 lines):**
```sql
CREATE TABLE quantum_todos (
    id TEXT PRIMARY KEY,
    content TEXT NOT NULL,
    status TEXT NOT NULL DEFAULT 'pending',
    priority TEXT NOT NULL DEFAULT 'medium',
    source TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    completed_at TIMESTAMP,
    session_id TEXT,
    tags TEXT,
    quantum_state TEXT DEFAULT 'superposition',
    dependency_status TEXT DEFAULT 'ready',
    dependency_chain_length INTEGER DEFAULT 0
);
CREATE TABLE todo_dependencies (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    todo_id TEXT NOT NULL,
    depends_on_id TEXT NOT NULL,
    dependency_type TEXT DEFAULT 'blocks',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (todo_id) REFERENCES quantum_todos (id),
    FOREIGN KEY (depends_on_id) REFERENCES quantum_todos (id),
    UNIQUE(todo_id, depends_on_id)
);
CREATE TABLE sqlite_sequence(name,seq);
CREATE INDEX idx_status ON quantum_todos(status);
CREATE INDEX idx_priority ON quantum_todos(priority);
CREATE INDEX idx_dependency_status ON quantum_todos(dependency_status);
CREATE INDEX idx_dependency_todo ON todo_dependencies(todo_id);
CREATE INDEX idx_dependency_depends ON todo_dependencies(depends_on_id);
CREATE VIRTUAL TABLE quantum_fts USING fts5(content, content=quantum_todos)
/* quantum_fts(content) */;
CREATE TABLE IF NOT EXISTS 'quantum_fts_data'(id INTEGER PRIMARY KEY, block BLOB);
CREATE TABLE IF NOT EXISTS 'quantum_fts_idx'(segid, term, pgno, PRIMARY KEY(segid, term)) WITHOUT ROWID;
CREATE TABLE IF NOT EXISTS 'quantum_fts_docsize'(id INTEGER PRIMARY KEY, sz BLOB);
CREATE TABLE IF NOT EXISTS 'quantum_fts_config'(k PRIMARY KEY, v) WITHOUT ROWID;
```

---

#### Database: `./.universal-history/universal-history.db`

**File Stats:**
-rw-r--r-- 1 groklygroup groklygroup 0 Aug  8 23:56 ./.universal-history/universal-history.db

**Size:** 0

**Modified:** 2025-08-08 23:56:03.774721400 -0700

**Accessed:** 2025-08-08 23:56:03.774721400 -0700

**Tables:**

**Schema Sample (first 50 lines):**
```sql
```

---

#### Database: `./enterprise-test/data/test-index.db`

**File Stats:**
-rwxrwxrwx 1 groklygroup groklygroup 40K Nov 17 02:10 ./enterprise-test/data/test-index.db

**Size:** 40K

**Modified:** 2025-11-17 02:10:50.000000000 -0800

**Accessed:** 2025-12-05 12:14:41.000000000 -0800

**Tables:**
documents              documents_fts_data     files                
documents_fts          documents_fts_docsize  indexing_stats       
documents_fts_config   documents_fts_idx    

**Schema Sample (first 50 lines):**
```sql
CREATE TABLE files (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    path TEXT NOT NULL UNIQUE,
    name TEXT NOT NULL,
    extension TEXT,
    size INTEGER,
    hash TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    indexed_at TIMESTAMP,
    status TEXT DEFAULT 'pending'
);
CREATE TABLE sqlite_sequence(name,seq);
CREATE TABLE documents (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    file_id INTEGER REFERENCES files(id),
    content TEXT,
    metadata TEXT,
    language TEXT,
    word_count INTEGER,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE VIRTUAL TABLE documents_fts USING fts5(
    content, 
    metadata,
    content=documents,
    content_rowid=id
)
/* documents_fts(content,metadata) */;
CREATE TABLE IF NOT EXISTS 'documents_fts_data'(id INTEGER PRIMARY KEY, block BLOB);
CREATE TABLE IF NOT EXISTS 'documents_fts_idx'(segid, term, pgno, PRIMARY KEY(segid, term)) WITHOUT ROWID;
CREATE TABLE IF NOT EXISTS 'documents_fts_docsize'(id INTEGER PRIMARY KEY, sz BLOB);
CREATE TABLE IF NOT EXISTS 'documents_fts_config'(k PRIMARY KEY, v) WITHOUT ROWID;
CREATE TABLE indexing_stats (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    date DATE NOT NULL,
    files_processed INTEGER DEFAULT 0,
    files_failed INTEGER DEFAULT 0,
    total_size_bytes INTEGER DEFAULT 0,
    avg_processing_time_ms REAL
);
```

---

#### Database: `./evolution-framework/quantum/dna-registry.db`

**File Stats:**
-rwxrwxrwx 1 groklygroup groklygroup 40K Nov 17 02:11 ./evolution-framework/quantum/dna-registry.db

**Size:** 40K

**Modified:** 2025-11-17 02:11:43.000000000 -0800

**Accessed:** 2025-12-05 12:14:57.000000000 -0800

**Tables:**
dna_registry       evolution_history  gene_pool        

**Schema Sample (first 50 lines):**
```sql
CREATE TABLE dna_registry (
    component_id TEXT PRIMARY KEY,
    dna_sequence TEXT NOT NULL,
    generation INTEGER DEFAULT 1,
    parent_id TEXT,
    fitness_score REAL DEFAULT 0.5,
    mutations TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_evolved TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE evolution_history (
    id TEXT PRIMARY KEY,
    component_id TEXT NOT NULL,
    generation INTEGER NOT NULL,
    mutation_type TEXT NOT NULL,
    before_dna TEXT NOT NULL,
    after_dna TEXT NOT NULL,
    fitness_change REAL,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE gene_pool (
    gene_id TEXT PRIMARY KEY,
    gene_type TEXT NOT NULL,
    gene_data TEXT NOT NULL,
    success_rate REAL DEFAULT 0.5,
    usage_count INTEGER DEFAULT 0,
    origin_component TEXT
);
CREATE INDEX idx_dna_fitness ON dna_registry(fitness_score DESC);
CREATE INDEX idx_evolution_component ON evolution_history(component_id);
CREATE INDEX idx_gene_success ON gene_pool(success_rate DESC);
```

---

#### Database: `./evolution-framework/quantum/idea-elevation.db`

**File Stats:**
-rwxrwxrwx 1 groklygroup groklygroup 48K Nov 17 02:11 ./evolution-framework/quantum/idea-elevation.db

**Size:** 48K

**Modified:** 2025-11-17 02:11:43.000000000 -0800

**Accessed:** 2025-12-05 12:14:57.000000000 -0800

**Tables:**
elevation_history        ideas                  
idea_connections         implementation_patterns

**Schema Sample (first 50 lines):**
```sql
CREATE TABLE ideas (
    id TEXT PRIMARY KEY,
    concept TEXT NOT NULL,
    category TEXT NOT NULL,
    elevation_level INTEGER DEFAULT 1,
    implementation_readiness REAL DEFAULT 0.0,
    dependencies TEXT,
    parent_ideas TEXT,
    child_ideas TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    elevated_at TIMESTAMP,
    implemented_at TIMESTAMP,
    status TEXT DEFAULT 'raw'
);
CREATE TABLE elevation_history (
    id TEXT PRIMARY KEY,
    idea_id TEXT NOT NULL,
    from_level INTEGER NOT NULL,
    to_level INTEGER NOT NULL,
    elevation_type TEXT NOT NULL,
    transformation TEXT,
    catalyst TEXT,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (idea_id) REFERENCES ideas(id)
);
CREATE TABLE idea_connections (
    id TEXT PRIMARY KEY,
    idea1_id TEXT NOT NULL,
    idea2_id TEXT NOT NULL,
    connection_type TEXT NOT NULL,
    strength REAL DEFAULT 0.5,
    discovered_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (idea1_id) REFERENCES ideas(id),
    FOREIGN KEY (idea2_id) REFERENCES ideas(id)
);
CREATE TABLE implementation_patterns (
    id TEXT PRIMARY KEY,
    pattern_name TEXT NOT NULL,
    pattern_type TEXT NOT NULL,
    success_rate REAL DEFAULT 0.5,
    usage_count INTEGER DEFAULT 0,
    template TEXT,
    prerequisites TEXT
);
CREATE INDEX idx_ideas_level ON ideas(elevation_level DESC);
CREATE INDEX idx_ideas_readiness ON ideas(implementation_readiness DESC);
CREATE INDEX idx_connections_strength ON idea_connections(strength DESC);
```

---

#### Database: `./evolution-framework/quantum/natural-interaction.db`

**File Stats:**
-rwxrwxrwx 1 groklygroup groklygroup 64K Nov 17 02:11 ./evolution-framework/quantum/natural-interaction.db

**Size:** 64K

**Modified:** 2025-11-17 02:11:43.000000000 -0800

**Accessed:** 2025-12-05 12:14:57.000000000 -0800

**Tables:**
context_memory     interactions       natural_aliases  
intent_patterns    learning_feedback

**Schema Sample (first 50 lines):**
```sql
CREATE TABLE interactions (
    id TEXT PRIMARY KEY,
    interaction_type TEXT NOT NULL,
    input_text TEXT NOT NULL,
    interpreted_intent TEXT,
    confidence_score REAL DEFAULT 0.0,
    context_data TEXT,
    response_generated TEXT,
    satisfaction_score REAL,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE intent_patterns (
    id TEXT PRIMARY KEY,
    pattern_regex TEXT NOT NULL,
    intent_type TEXT NOT NULL,
    priority INTEGER DEFAULT 50,
    success_rate REAL DEFAULT 0.5,
    usage_count INTEGER DEFAULT 0,
    example_phrases TEXT
);
CREATE TABLE context_memory (
    id TEXT PRIMARY KEY,
    session_id TEXT NOT NULL,
    context_key TEXT NOT NULL,
    context_value TEXT NOT NULL,
    importance REAL DEFAULT 0.5,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    expires_at TIMESTAMP
);
CREATE TABLE learning_feedback (
    id TEXT PRIMARY KEY,
    interaction_id TEXT NOT NULL,
    feedback_type TEXT NOT NULL,
    feedback_value TEXT,
    learning_applied BOOLEAN DEFAULT FALSE,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (interaction_id) REFERENCES interactions(id)
);
CREATE TABLE natural_aliases (
    id TEXT PRIMARY KEY,
    natural_phrase TEXT NOT NULL UNIQUE,
    command_mapping TEXT NOT NULL,
    confidence REAL DEFAULT 0.8,
    usage_count INTEGER DEFAULT 0,
    created_by TEXT DEFAULT 'system'
);
CREATE INDEX idx_interactions_timestamp ON interactions(timestamp DESC);
CREATE INDEX idx_patterns_intent ON intent_patterns(intent_type);
CREATE INDEX idx_context_session ON context_memory(session_id);
CREATE INDEX idx_aliases_phrase ON natural_aliases(natural_phrase);
```

---

#### Database: `./evolution-framework/quantum/quantum-states.db`

**File Stats:**
-rwxrwxrwx 1 groklygroup groklygroup 36K Nov 17 02:11 ./evolution-framework/quantum/quantum-states.db

**Size:** 36K

**Modified:** 2025-11-17 02:11:43.000000000 -0800

**Accessed:** 2025-12-05 12:14:58.000000000 -0800

**Tables:**
entanglements     quantum_patterns  superpositions  

**Schema Sample (first 50 lines):**
```sql
CREATE TABLE superpositions (
    id TEXT PRIMARY KEY,
    problem_id TEXT NOT NULL,
    solutions TEXT NOT NULL,
    probabilities TEXT NOT NULL,
    entangled_with TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    collapsed_at TIMESTAMP,
    collapsed_to TEXT,
    context TEXT
);
CREATE TABLE entanglements (
    id TEXT PRIMARY KEY,
    problem1_id TEXT NOT NULL,
    problem2_id TEXT NOT NULL,
    correlation_strength REAL NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE quantum_patterns (
    id TEXT PRIMARY KEY,
    pattern_type TEXT NOT NULL,
    pattern_data TEXT NOT NULL,
    success_rate REAL,
    usage_count INTEGER DEFAULT 0
);
CREATE INDEX idx_superposition_problem ON superpositions(problem_id);
CREATE INDEX idx_entanglement_problems ON entanglements(problem1_id, problem2_id);
```

---

#### Database: `./evolution-framework/quantum/universal-benefit.db`

**File Stats:**
-rwxrwxrwx 1 groklygroup groklygroup 60K Nov 17 02:11 ./evolution-framework/quantum/universal-benefit.db

**Size:** 60K

**Modified:** 2025-11-17 02:11:43.000000000 -0800

**Accessed:** 2025-12-05 12:14:58.000000000 -0800

**Tables:**
benefit_propagation      collective_intelligence  ecosystem_health       
benefit_registry         community_contributions

**Schema Sample (first 50 lines):**
```sql
CREATE TABLE benefit_registry (
    id TEXT PRIMARY KEY,
    component_id TEXT NOT NULL,
    benefit_type TEXT NOT NULL,
    benefit_score REAL DEFAULT 0.0,
    impact_radius TEXT DEFAULT 'local',
    beneficiaries INTEGER DEFAULT 1,
    collective_value REAL DEFAULT 0.0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_measured TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE collective_intelligence (
    id TEXT PRIMARY KEY,
    knowledge_type TEXT NOT NULL,
    knowledge_data TEXT NOT NULL,
    contributor_count INTEGER DEFAULT 1,
    quality_score REAL DEFAULT 0.5,
    usage_count INTEGER DEFAULT 0,
    last_accessed TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE benefit_propagation (
    id TEXT PRIMARY KEY,
    source_component TEXT NOT NULL,
    target_component TEXT NOT NULL,
    benefit_type TEXT NOT NULL,
    propagation_strength REAL DEFAULT 0.5,
    propagated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE community_contributions (
    id TEXT PRIMARY KEY,
    contributor_id TEXT NOT NULL,
    contribution_type TEXT NOT NULL,
    contribution_data TEXT NOT NULL,
    impact_score REAL DEFAULT 0.0,
    recognition_level TEXT DEFAULT 'contributor',
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE ecosystem_health (
    id TEXT PRIMARY KEY,
    metric_name TEXT NOT NULL,
    metric_value REAL NOT NULL,
    metric_type TEXT NOT NULL,
    measurement_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    trend_direction TEXT,
    health_status TEXT DEFAULT 'healthy'
);
CREATE INDEX idx_benefit_score ON benefit_registry(benefit_score DESC);
CREATE INDEX idx_collective_quality ON collective_intelligence(quality_score DESC);
CREATE INDEX idx_propagation_time ON benefit_propagation(propagated_at DESC);
CREATE INDEX idx_health_time ON ecosystem_health(measurement_time DESC);
```

---

#### Database: `./evolution-framework/state-store/state.db`

**File Stats:**
-rwxrwxrwx 1 groklygroup groklygroup 56K Nov 17 02:11 ./evolution-framework/state-store/state.db

**Size:** 56K

**Modified:** 2025-11-17 02:11:43.000000000 -0800

**Accessed:** 2025-12-05 12:14:58.000000000 -0800

**Tables:**
collective_patterns   optimization_history  state_history       
component_state       performance_metrics 

**Schema Sample (first 50 lines):**
```sql
CREATE TABLE component_state (
    component_name TEXT PRIMARY KEY,
    state_data TEXT,
    version INTEGER DEFAULT 1,
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    checksum TEXT
);
CREATE TABLE state_history (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    component_name TEXT,
    state_data TEXT,
    version INTEGER,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    change_type TEXT,
    changed_by TEXT
);
CREATE TABLE sqlite_sequence(name,seq);
CREATE TABLE collective_patterns (
    pattern_id TEXT PRIMARY KEY,
    pattern_type TEXT,
    pattern_data TEXT,
    occurrences INTEGER DEFAULT 1,
    first_seen TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_seen TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    contributing_components TEXT
);
CREATE TABLE performance_metrics (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    component_name TEXT,
    metric_name TEXT,
    metric_value REAL,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE optimization_history (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    component_name TEXT,
    optimization_type TEXT,
    before_value REAL,
    after_value REAL,
    improvement_percent REAL,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    success BOOLEAN
);
CREATE INDEX idx_state_component ON component_state(component_name);
CREATE INDEX idx_history_component ON state_history(component_name, timestamp);
CREATE INDEX idx_patterns_type ON collective_patterns(pattern_type);
CREATE INDEX idx_metrics_time ON performance_metrics(timestamp);
CREATE INDEX idx_component_metric ON performance_metrics(component_name, metric_name, timestamp);
```

---

#### Database: `./external-repos/meta/llama-cookbook/3p-integrations/lamini/text2sql_memory_tuning/nba_roster.db`

**File Stats:**
-rwxrwxrwx 1 groklygroup groklygroup 56K Dec  1 16:31 ./external-repos/meta/llama-cookbook/3p-integrations/lamini/text2sql_memory_tuning/nba_roster.db

**Size:** 56K

**Modified:** 2025-12-01 16:31:46.845861300 -0800

**Accessed:** 2025-12-01 16:31:46.845861300 -0800

**Tables:**
nba_roster

**Schema Sample (first 50 lines):**
```sql
CREATE TABLE nba_roster (
                    Team TEXT,
                    NAME TEXT,
                    Jersey TEXT,
                    POS TEXT,
                    AGE INT,
                    HT TEXT,
                    WT TEXT,
                    COLLEGE TEXT,
                    SALARY TEXT
                );
```

---

#### Database: `./external-repos/meta/llama-cookbook/end-to-end-use-cases/coding/text2sql/nba_roster.db`

**File Stats:**
-rwxrwxrwx 1 groklygroup groklygroup 56K Dec  1 16:31 ./external-repos/meta/llama-cookbook/end-to-end-use-cases/coding/text2sql/nba_roster.db

**Size:** 56K

**Modified:** 2025-12-01 16:31:55.829397700 -0800

**Accessed:** 2025-12-01 16:31:55.829397700 -0800

**Tables:**
nba_roster

**Schema Sample (first 50 lines):**
```sql
CREATE TABLE nba_roster (
                    Team TEXT,
                    NAME TEXT,
                    Jersey TEXT,
                    POS TEXT,
                    AGE INT,
                    HT TEXT,
                    WT TEXT,
                    COLLEGE TEXT,
                    SALARY TEXT
                );
```

---

#### Database: `./file_protection.db`

**File Stats:**
-rw-r--r-- 1 groklygroup groklygroup 36K Jul 21 23:57 ./file_protection.db

**Size:** 36K

**Modified:** 2025-07-21 23:57:12.406718200 -0700

**Accessed:** 2025-07-22 02:29:38.025435800 -0700

**Tables:**
file_history     protected_files

**Schema Sample (first 50 lines):**
```sql
CREATE TABLE protected_files (
    file_id TEXT PRIMARY KEY,
    path TEXT NOT NULL UNIQUE,
    sha256_hash TEXT NOT NULL,
    protection_level TEXT DEFAULT 'standard',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_modified TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    backup_path TEXT,
    metadata TEXT
);
CREATE TABLE file_history (
    history_id TEXT PRIMARY KEY,
    file_id TEXT NOT NULL,
    action TEXT NOT NULL,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    old_hash TEXT,
    new_hash TEXT,
    user TEXT,
    reason TEXT,
    FOREIGN KEY (file_id) REFERENCES protected_files(file_id)
);
CREATE INDEX idx_path ON protected_files(path);
CREATE INDEX idx_protection ON protected_files(protection_level);
CREATE INDEX idx_file_history ON file_history(file_id);
```

---

#### Database: `./gencraft-v3.0/external-repos/meta/llama-cookbook/3p-integrations/lamini/text2sql_memory_tuning/nba_roster.db`

**File Stats:**
-rwxrwxrwx 1 groklygroup groklygroup 56K Dec  1 16:31 ./gencraft-v3.0/external-repos/meta/llama-cookbook/3p-integrations/lamini/text2sql_memory_tuning/nba_roster.db

**Size:** 56K

**Modified:** 2025-12-01 16:31:46.662997200 -0800

**Accessed:** 2025-12-01 16:31:46.662997200 -0800

**Tables:**
nba_roster

**Schema Sample (first 50 lines):**
```sql
CREATE TABLE nba_roster (
                    Team TEXT,
                    NAME TEXT,
                    Jersey TEXT,
                    POS TEXT,
                    AGE INT,
                    HT TEXT,
                    WT TEXT,
                    COLLEGE TEXT,
                    SALARY TEXT
                );
```

---

#### Database: `./gencraft-v3.0/external-repos/meta/llama-cookbook/end-to-end-use-cases/coding/text2sql/nba_roster.db`

**File Stats:**
-rwxrwxrwx 1 groklygroup groklygroup 56K Dec  1 16:31 ./gencraft-v3.0/external-repos/meta/llama-cookbook/end-to-end-use-cases/coding/text2sql/nba_roster.db

**Size:** 56K

**Modified:** 2025-12-01 16:31:55.608458400 -0800

**Accessed:** 2025-12-01 16:31:55.608458400 -0800

**Tables:**
nba_roster

**Schema Sample (first 50 lines):**
```sql
CREATE TABLE nba_roster (
                    Team TEXT,
                    NAME TEXT,
                    Jersey TEXT,
                    POS TEXT,
                    AGE INT,
                    HT TEXT,
                    WT TEXT,
                    COLLEGE TEXT,
                    SALARY TEXT
                );
```

---

#### Database: `./GLOBAL_CHAT_STORAGE.db`

**File Stats:**
-rwxrwxrwx 1 groklygroup groklygroup 240K Jun 18 09:57 ./GLOBAL_CHAT_STORAGE.db

**Size:** 240K

**Modified:** 2025-06-18 09:57:20.758253700 -0700

**Accessed:** 2025-06-19 23:11:27.836687400 -0700

**Tables:**
global_sessions         message_search_content  message_search_idx    
message_search          message_search_data     messages              
message_search_config   message_search_docsize  projects              

**Schema Sample (first 50 lines):**
```sql
CREATE TABLE projects (
                    id INTEGER PRIMARY KEY AUTOINCREMENT,
                    project_name TEXT UNIQUE NOT NULL,
                    project_path TEXT NOT NULL,
                    description TEXT,
                    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
                );
CREATE TABLE sqlite_sequence(name,seq);
CREATE TABLE global_sessions (
                    id INTEGER PRIMARY KEY AUTOINCREMENT,
                    session_id TEXT UNIQUE NOT NULL,
                    project_id INTEGER NOT NULL,
                    project_name TEXT NOT NULL,
                    session_name TEXT,
                    conversation_history TEXT NOT NULL,  -- Full JSON with complete fidelity
                    message_count INTEGER DEFAULT 0,
                    total_tokens INTEGER DEFAULT 0,
                    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                    metadata TEXT,  -- JSON metadata
                    tags TEXT,      -- Comma-separated tags
                    FOREIGN KEY (project_id) REFERENCES projects (id)
                );
CREATE TABLE messages (
                    id INTEGER PRIMARY KEY AUTOINCREMENT,
                    session_id TEXT NOT NULL,
                    project_name TEXT NOT NULL,
                    role TEXT NOT NULL,
                    content TEXT NOT NULL,  -- Complete message content
                    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                    metadata TEXT,  -- JSON for tool calls, file refs, etc
                    FOREIGN KEY (session_id) REFERENCES global_sessions (session_id)
                );
CREATE VIRTUAL TABLE message_search 
                USING fts5(session_id, project_name, content, metadata)
/* message_search(session_id,project_name,content,metadata) */;
CREATE TABLE IF NOT EXISTS 'message_search_data'(id INTEGER PRIMARY KEY, block BLOB);
CREATE TABLE IF NOT EXISTS 'message_search_idx'(segid, term, pgno, PRIMARY KEY(segid, term)) WITHOUT ROWID;
CREATE TABLE IF NOT EXISTS 'message_search_content'(id INTEGER PRIMARY KEY, c0, c1, c2, c3);
CREATE TABLE IF NOT EXISTS 'message_search_docsize'(id INTEGER PRIMARY KEY, sz BLOB);
CREATE TABLE IF NOT EXISTS 'message_search_config'(k PRIMARY KEY, v) WITHOUT ROWID;
CREATE INDEX idx_sessions_project ON global_sessions(project_name);
CREATE INDEX idx_sessions_updated ON global_sessions(updated_at DESC);
CREATE INDEX idx_messages_session ON messages(session_id);
CREATE INDEX idx_messages_project ON messages(project_name);
CREATE INDEX idx_messages_timestamp ON messages(timestamp);
```

---

#### Database: `./leadcraft/leadcraft_v2/data/database/analytics.db`

**File Stats:**
-rwxrwxrwx 1 groklygroup groklygroup 28K Jun 25 20:28 ./leadcraft/leadcraft_v2/data/database/analytics.db

**Size:** 28K

**Modified:** 2025-06-25 20:28:07.229222100 -0700

**Accessed:** 2025-06-27 21:06:26.315202900 -0700

**Tables:**
dashboards  kpis        reports   

**Schema Sample (first 50 lines):**
```sql
CREATE TABLE kpis (
                    id TEXT PRIMARY KEY,
                    name TEXT NOT NULL,
                    description TEXT,
                    category TEXT NOT NULL,
                    current_value REAL NOT NULL,
                    target_value REAL NOT NULL,
                    unit TEXT NOT NULL,
                    trend TEXT NOT NULL,
                    period TEXT NOT NULL,
                    last_updated TEXT NOT NULL
                );
CREATE TABLE reports (
                    id TEXT PRIMARY KEY,
                    name TEXT NOT NULL,
                    description TEXT,
                    report_type TEXT NOT NULL,
                    data TEXT NOT NULL,
                    generated_at TEXT NOT NULL,
                    period_start TEXT NOT NULL,
                    period_end TEXT NOT NULL,
                    format TEXT NOT NULL
                );
CREATE TABLE dashboards (
                    id TEXT PRIMARY KEY,
                    name TEXT NOT NULL,
                    description TEXT,
                    widgets TEXT NOT NULL,
                    layout TEXT NOT NULL,
                    permissions TEXT NOT NULL,
                    created_at TEXT NOT NULL,
                    updated_at TEXT NOT NULL
                );
```

---

#### Database: `./leadcraft/leadcraft_v2/data/database/crm.db`

**File Stats:**
-rwxrwxrwx 1 groklygroup groklygroup 44K Jun 25 20:28 ./leadcraft/leadcraft_v2/data/database/crm.db

**Size:** 44K

**Modified:** 2025-06-25 20:28:06.334238200 -0700

**Accessed:** 2025-06-27 21:06:26.200200700 -0700

**Tables:**
campaign_leads        interactions          leads               
campaigns             lead_scoring_history

**Schema Sample (first 50 lines):**
```sql
CREATE TABLE leads (
                id TEXT PRIMARY KEY,
                business_name TEXT NOT NULL,
                contact_name TEXT,
                email TEXT,
                phone TEXT,
                website TEXT,
                address TEXT,
                industry TEXT,
                company_size TEXT,
                status TEXT DEFAULT 'new',
                priority TEXT DEFAULT 'medium',
                score INTEGER DEFAULT 0,
                source TEXT,
                notes TEXT,
                created_date TEXT,
                updated_date TEXT,
                last_contact_date TEXT,
                next_follow_up TEXT,
                estimated_value REAL DEFAULT 0.0,
                probability INTEGER DEFAULT 0,
                tags TEXT,
                gdpr_consent BOOLEAN DEFAULT FALSE,
                gdpr_consent_date TEXT
            );
CREATE TABLE interactions (
                id TEXT PRIMARY KEY,
                lead_id TEXT,
                type TEXT,
                subject TEXT,
                content TEXT,
                date TEXT,
                outcome TEXT,
                next_action TEXT,
                created_by TEXT,
                FOREIGN KEY (lead_id) REFERENCES leads (id)
            );
CREATE TABLE campaigns (
                id TEXT PRIMARY KEY,
                name TEXT NOT NULL,
                type TEXT,
                status TEXT DEFAULT 'draft',
                target_audience TEXT,
                start_date TEXT,
                end_date TEXT,
                budget REAL DEFAULT 0.0,
                goals TEXT,
                metrics TEXT,
                created_date TEXT
            );
```

---

#### Database: `./leadcraft/leadcraft_v2/data/database/email_campaigns.db`

**File Stats:**
-rwxrwxrwx 1 groklygroup groklygroup 40K Jun 25 21:08 ./leadcraft/leadcraft_v2/data/database/email_campaigns.db

**Size:** 40K

**Modified:** 2025-06-25 21:08:44.414083300 -0700

**Accessed:** 2025-06-27 21:06:26.269015100 -0700

**Tables:**
email_campaigns  email_contacts   email_logs       email_templates

**Schema Sample (first 50 lines):**
```sql
CREATE TABLE email_templates (
                    id TEXT PRIMARY KEY,
                    name TEXT NOT NULL,
                    subject TEXT NOT NULL,
                    content TEXT NOT NULL,
                    template_type TEXT NOT NULL,
                    industry TEXT,
                    personalization_fields TEXT,
                    created_at TEXT NOT NULL,
                    updated_at TEXT NOT NULL
                );
CREATE TABLE email_contacts (
                    id TEXT PRIMARY KEY,
                    email TEXT UNIQUE NOT NULL,
                    first_name TEXT,
                    last_name TEXT,
                    company_name TEXT,
                    website_url TEXT,
                    industry TEXT,
                    phone TEXT,
                    status TEXT DEFAULT 'active',
                    tags TEXT,
                    custom_fields TEXT,
                    created_at TEXT NOT NULL,
                    updated_at TEXT NOT NULL
                );
CREATE TABLE email_campaigns (
                    id TEXT PRIMARY KEY,
                    name TEXT NOT NULL,
                    description TEXT,
                    template_id TEXT,
                    contact_list_ids TEXT,
                    scheduled_time TEXT,
                    send_immediately BOOLEAN,
                    status TEXT DEFAULT 'draft',
                    total_recipients INTEGER DEFAULT 0,
                    sent_count INTEGER DEFAULT 0,
                    opened_count INTEGER DEFAULT 0,
                    clicked_count INTEGER DEFAULT 0,
                    bounced_count INTEGER DEFAULT 0,
                    unsubscribed_count INTEGER DEFAULT 0,
                    created_at TEXT NOT NULL,
                    updated_at TEXT NOT NULL
                );
CREATE TABLE email_logs (
                    id TEXT PRIMARY KEY,
                    campaign_id TEXT,
                    contact_id TEXT,
                    template_id TEXT,
                    subject TEXT,
```

---

#### Database: `./leadcraft/leadcraft_v2/data/database/leadcraft.db`

**File Stats:**
-rwxrwxrwx 1 groklygroup groklygroup 44K Jun 25 17:42 ./leadcraft/leadcraft_v2/data/database/leadcraft.db

**Size:** 44K

**Modified:** 2025-06-25 17:42:03.631998800 -0700

**Accessed:** 2025-06-27 21:06:26.503963000 -0700

**Tables:**
campaigns     interactions  leads         settings      templates   

**Schema Sample (first 50 lines):**
```sql
CREATE TABLE leads (
            id TEXT PRIMARY KEY,
            business_name TEXT NOT NULL,
            website_url TEXT,
            industry TEXT,
            contact_email TEXT,
            contact_phone TEXT,
            address TEXT,
            lead_score INTEGER DEFAULT 0,
            mobile_responsive BOOLEAN DEFAULT FALSE,
            loading_speed REAL DEFAULT 0.0,
            design_issues TEXT,
            status TEXT DEFAULT 'new',
            notes TEXT,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        );
CREATE TABLE interactions (
            id TEXT PRIMARY KEY,
            lead_id TEXT,
            interaction_type TEXT,
            subject TEXT,
            content TEXT,
            outcome TEXT,
            next_action TEXT,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            FOREIGN KEY (lead_id) REFERENCES leads (id)
        );
CREATE TABLE campaigns (
            id TEXT PRIMARY KEY,
            name TEXT NOT NULL,
            type TEXT,
            status TEXT DEFAULT 'draft',
            target_criteria TEXT,
            content_template TEXT,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        );
CREATE TABLE templates (
            id TEXT PRIMARY KEY,
            name TEXT NOT NULL,
            type TEXT,
            subject TEXT,
            content TEXT,
            variables TEXT,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        );
CREATE TABLE settings (
            key TEXT PRIMARY KEY,
```

---

#### Database: `./leadcraft/leadcraft_v2/data/database/sales_pipeline.db`

**File Stats:**
-rwxrwxrwx 1 groklygroup groklygroup 36K Jun 25 20:28 ./leadcraft/leadcraft_v2/data/database/sales_pipeline.db

**Size:** 36K

**Modified:** 2025-06-25 20:28:06.935627100 -0700

**Accessed:** 2025-06-27 21:06:26.315202900 -0700

**Tables:**
opportunities     pipeline_stages   sales_activities  sales_goals     

**Schema Sample (first 50 lines):**
```sql
CREATE TABLE pipeline_stages (
                    id TEXT PRIMARY KEY,
                    name TEXT NOT NULL,
                    description TEXT,
                    probability REAL NOT NULL,
                    stage_order INTEGER NOT NULL,
                    active BOOLEAN NOT NULL DEFAULT 1,
                    created_at TEXT NOT NULL
                );
CREATE TABLE opportunities (
                    id TEXT PRIMARY KEY,
                    name TEXT NOT NULL,
                    description TEXT,
                    value REAL NOT NULL,
                    currency TEXT DEFAULT 'USD',
                    stage_id TEXT NOT NULL,
                    lead_id TEXT,
                    contact_email TEXT,
                    source TEXT,
                    probability REAL,
                    expected_close_date TEXT,
                    actual_close_date TEXT,
                    status TEXT NOT NULL DEFAULT 'open',
                    created_at TEXT NOT NULL,
                    updated_at TEXT NOT NULL,
                    tags TEXT,
                    notes TEXT,
                    FOREIGN KEY (stage_id) REFERENCES pipeline_stages (id)
                );
CREATE TABLE sales_activities (
                    id TEXT PRIMARY KEY,
                    opportunity_id TEXT NOT NULL,
                    activity_type TEXT NOT NULL,
                    subject TEXT NOT NULL,
                    description TEXT,
                    status TEXT NOT NULL DEFAULT 'planned',
                    scheduled_date TEXT,
                    completed_date TEXT,
                    duration_minutes INTEGER,
                    outcome TEXT,
                    created_at TEXT NOT NULL,
                    FOREIGN KEY (opportunity_id) REFERENCES opportunities (id)
                );
CREATE TABLE sales_goals (
                    id TEXT PRIMARY KEY,
                    name TEXT NOT NULL,
                    goal_type TEXT NOT NULL,
                    target_value REAL NOT NULL,
                    current_value REAL DEFAULT 0,
                    period TEXT NOT NULL,
```

---

#### Database: `./leadcraft/leadcraft_v2/data/database/security_compliance.db`

**File Stats:**
-rwxrwxrwx 1 groklygroup groklygroup 44K Jun 25 20:28 ./leadcraft/leadcraft_v2/data/database/security_compliance.db

**Size:** 44K

**Modified:** 2025-06-25 20:28:07.458513300 -0700

**Accessed:** 2025-06-27 21:06:26.201202100 -0700

**Tables:**
compliance_checks    data_requests        security_audit_logs
consent_records      encrypted_data     

**Schema Sample (first 50 lines):**
```sql
CREATE TABLE consent_records (
                    id TEXT PRIMARY KEY,
                    email TEXT NOT NULL,
                    consent_type TEXT NOT NULL,
                    consent_given BOOLEAN NOT NULL,
                    consent_date TEXT NOT NULL,
                    consent_method TEXT NOT NULL,
                    ip_address TEXT,
                    user_agent TEXT,
                    withdrawal_date TEXT,
                    lawful_basis TEXT NOT NULL,
                    retention_period TEXT,
                    created_at TEXT NOT NULL
                );
CREATE TABLE data_requests (
                    id TEXT PRIMARY KEY,
                    email TEXT NOT NULL,
                    request_type TEXT NOT NULL,
                    request_date TEXT NOT NULL,
                    status TEXT NOT NULL,
                    completion_date TEXT,
                    notes TEXT,
                    verification_status TEXT NOT NULL,
                    created_at TEXT NOT NULL
                );
CREATE TABLE security_audit_logs (
                    id TEXT PRIMARY KEY,
                    event_type TEXT NOT NULL,
                    user_id TEXT NOT NULL,
                    resource TEXT NOT NULL,
                    action TEXT NOT NULL,
                    ip_address TEXT NOT NULL,
                    user_agent TEXT,
                    success BOOLEAN NOT NULL,
                    risk_level TEXT NOT NULL,
                    details TEXT,
                    timestamp TEXT NOT NULL
                );
CREATE TABLE compliance_checks (
                    id TEXT PRIMARY KEY,
                    check_type TEXT NOT NULL,
                    status TEXT NOT NULL,
                    description TEXT NOT NULL,
                    recommendations TEXT,
                    last_checked TEXT NOT NULL,
                    next_check TEXT NOT NULL
                );
CREATE TABLE encrypted_data (
                    id TEXT PRIMARY KEY,
                    data_type TEXT NOT NULL,
```

---

#### Database: `./leadcraft/leadcraft_v2/data/database/website_analysis.db`

**File Stats:**
-rwxrwxrwx 1 groklygroup groklygroup 32K Jun 25 19:29 ./leadcraft/leadcraft_v2/data/database/website_analysis.db

**Size:** 32K

**Modified:** 2025-06-25 19:29:49.349933700 -0700

**Accessed:** 2025-06-27 21:06:26.385030200 -0700

**Tables:**
businesses          discovery_sessions  website_analyses  

**Schema Sample (first 50 lines):**
```sql
CREATE TABLE businesses (
                    id TEXT PRIMARY KEY,
                    name TEXT NOT NULL,
                    website_url TEXT NOT NULL,
                    phone TEXT,
                    address TEXT,
                    city TEXT,
                    state TEXT,
                    industry TEXT,
                    source TEXT,
                    discovery_date TEXT,
                    last_analyzed TEXT,
                    analysis_score INTEGER,
                    contact_email TEXT,
                    social_media TEXT,
                    UNIQUE(website_url)
                );
CREATE TABLE website_analyses (
                    id TEXT PRIMARY KEY,
                    business_id TEXT,
                    url TEXT NOT NULL,
                    overall_score INTEGER,
                    mobile_score INTEGER,
                    design_score INTEGER,
                    speed_score INTEGER,
                    content_score INTEGER,
                    technical_score INTEGER,
                    issues_found TEXT,
                    opportunities TEXT,
                    mobile_responsive BOOLEAN,
                    loading_time REAL,
                    has_ssl BOOLEAN,
                    last_updated_estimate TEXT,
                    contact_info_found TEXT,
                    technology_stack TEXT,
                    analysis_date TEXT,
                    screenshot_path TEXT,
                    FOREIGN KEY (business_id) REFERENCES businesses (id)
                );
CREATE TABLE discovery_sessions (
                    id TEXT PRIMARY KEY,
                    business_type TEXT,
                    location TEXT,
                    max_results INTEGER,
                    status TEXT,
                    businesses_found INTEGER,
                    businesses_analyzed INTEGER,
                    high_score_count INTEGER,
                    started_at TEXT,
                    completed_at TEXT,
```

---

#### Database: `./leadcraft/leadcraft_v2/data/unified_crm.db`

**File Stats:**
-rwxrwxrwx 1 groklygroup groklygroup 76K Jun 25 20:57 ./leadcraft/leadcraft_v2/data/unified_crm.db

**Size:** 76K

**Modified:** 2025-06-25 20:57:41.048495800 -0700

**Accessed:** 2025-06-27 21:06:26.351888500 -0700

**Tables:**
campaign_leads  campaigns       interactions    lead_sources    leads         

**Schema Sample (first 50 lines):**
```sql
CREATE TABLE leads (
                        id TEXT PRIMARY KEY,
                        business_name TEXT NOT NULL,
                        contact_name TEXT,
                        email TEXT,
                        phone TEXT,
                        website TEXT,
                        industry TEXT,
                        company_size TEXT,
                        annual_revenue TEXT,
                        location TEXT,
                        description TEXT,
                        status TEXT DEFAULT 'new',
                        priority TEXT DEFAULT 'medium',
                        source TEXT,
                        assigned_to TEXT,
                        estimated_value REAL DEFAULT 0.0,
                        probability INTEGER DEFAULT 0,
                        created_date TEXT,
                        updated_date TEXT,
                        last_contact_date TEXT,
                        next_follow_up TEXT
                    );
CREATE TABLE interactions (
                        id TEXT PRIMARY KEY,
                        lead_id TEXT,
                        interaction_type TEXT,
                        subject TEXT,
                        description TEXT,
                        outcome TEXT,
                        next_action TEXT,
                        interaction_date TEXT,
                        created_by TEXT,
                        created_date TEXT,
                        FOREIGN KEY (lead_id) REFERENCES leads (id)
                    );
CREATE TABLE campaigns (
                        id TEXT PRIMARY KEY,
                        name TEXT NOT NULL,
                        description TEXT,
                        campaign_type TEXT,
                        status TEXT DEFAULT 'active',
                        target_criteria TEXT,
                        start_date TEXT,
                        end_date TEXT,
                        budget REAL DEFAULT 0.0,
                        leads_generated INTEGER DEFAULT 0,
                        conversion_rate REAL DEFAULT 0.0,
                        created_date TEXT
                    );
```

---

#### Database: `./leadcraft/leadcraft_v2/voice_agent_system.db`

**File Stats:**
-rwxrwxrwx 1 groklygroup groklygroup 12K Jun 25 20:28 ./leadcraft/leadcraft_v2/voice_agent_system.db

**Size:** 12K

**Modified:** 2025-06-25 20:28:06.475854300 -0700

**Accessed:** 2025-06-27 21:06:27.811840200 -0700

**Tables:**
voice_calls

**Schema Sample (first 50 lines):**
```sql
CREATE TABLE voice_calls (
                    id TEXT PRIMARY KEY,
                    lead_id TEXT NOT NULL,
                    phone_number TEXT NOT NULL,
                    call_status TEXT DEFAULT 'queued',
                    call_duration INTEGER DEFAULT 0,
                    transcript TEXT,
                    outcome TEXT,
                    sentiment_score REAL DEFAULT 0.0,
                    next_action TEXT,
                    ai_agent_platform TEXT,
                    call_cost REAL DEFAULT 0.0,
                    recording_url TEXT,
                    started_at TEXT,
                    completed_at TEXT,
                    created_at TEXT
                );
```

---

#### Database: `./linux-windows-merge/.merge-state/differential-analysis.db`

**File Stats:**
-rwxrwxrwx 1 groklygroup groklygroup 1.0M Dec  5 22:03 ./linux-windows-merge/.merge-state/differential-analysis.db

**Size:** 1.0M

**Modified:** 2025-12-05 22:03:33.670209900 -0800

**Accessed:** 2025-12-05 22:03:33.670209900 -0800

**Tables:**
file_analysis

**Schema Sample (first 50 lines):**
```sql
CREATE TABLE file_analysis (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    file_path TEXT UNIQUE NOT NULL,
    file_type TEXT,
    linux_md5 TEXT,
    windows_md5 TEXT,
    status TEXT DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE sqlite_sequence(name,seq);
CREATE INDEX idx_file_type ON file_analysis(file_type);
CREATE INDEX idx_status ON file_analysis(status);
```

---

#### Database: `./linux-windows-merge/.merge-state/merge.db`

**File Stats:**
-rwxrwxrwx 1 groklygroup groklygroup 16K Nov 25 09:22 ./linux-windows-merge/.merge-state/merge.db

**Size:** 16K

**Modified:** 2025-11-25 09:22:58.056768900 -0800

**Accessed:** 2025-11-25 09:22:59.030118500 -0800

**Tables:**
files

**Schema Sample (first 50 lines):**
```sql
CREATE TABLE files (
  id INTEGER PRIMARY KEY,
  path TEXT UNIQUE,
  category TEXT,
  linux_hash TEXT,
  windows_hash TEXT,
  status TEXT,
  timestamp DATETIME DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX idx_status ON files(status);
```

---

#### Database: `./quantum-todo.db`

**File Stats:**
-rw-r--r-- 1 groklygroup groklygroup 0 Aug 29 06:49 ./quantum-todo.db

**Size:** 0

**Modified:** 2025-08-29 06:49:45.697226300 -0700

**Accessed:** 2025-08-29 06:49:45.697226300 -0700

**Tables:**

**Schema Sample (first 50 lines):**
```sql
```

---

#### Database: `./todo_system.db`

**File Stats:**
-rw-r--r-- 1 groklygroup groklygroup 0 Aug 31 00:49 ./todo_system.db

**Size:** 0

**Modified:** 2025-08-31 00:49:34.722429700 -0700

**Accessed:** 2025-08-31 00:49:34.722429700 -0700

**Tables:**

**Schema Sample (first 50 lines):**
```sql
```

---

## PART 2: HARD-CODED DATABASE PATH DEPENDENCIES

### All Shell Scripts Referencing Database Paths

#### Script: `AUTO_SESSION_END_PROTOCOL.sh`

**Database References:**
```bash
54:    sqlite3 "${CLAUDE_PROJECTS_ROOT}/.quantum-todo/quantum-index.db" \
```

⚠️ **Uses Contractual Paths**: NO - HARD-CODED!

**Explicit Database Paths:**
"${CLAUDE_PROJECTS_ROOT}/.quantum-todo/quantum-index.db"

---

#### Script: `CLAUDE_SESSION_END_PROTOCOL.sh`

**Database References:**
```bash
336:    "quantum_todo": "$BACKUP_DIR/.quantum-todo/quantum-index.db",
```

⚠️ **Uses Contractual Paths**: NO - HARD-CODED!

**Explicit Database Paths:**
"$BACKUP_DIR/.quantum-todo/quantum-index.db"

---

#### Script: `CLAUDE_SESSION_PROTOCOL.sh`

**Database References:**
```bash
133:    if [ -f "$QUANTUM_DIR/quantum-todo.db" ]; then
134:        sqlite3 "$QUANTUM_DIR/quantum-todo.db" "SELECT COUNT(*) FROM nlp_patterns" > /dev/null 2>&1 &
147:        [ -f "$QUANTUM_DIR/quantum-todo.db" ] && sqlite3 "$QUANTUM_DIR/quantum-todo.db" "PRAGMA quick_check" > /dev/null 2>&1 || ((issues++))
190:- Tasks created: $(sqlite3 "$QUANTUM_DIR/quantum-todo.db" "SELECT COUNT(*) FROM quantum_todos WHERE created_at > datetime('now', '-1 day')" 2>/dev/null || echo "0")
191:- Tasks completed: $(sqlite3 "$QUANTUM_DIR/quantum-todo.db" "SELECT COUNT(*) FROM quantum_todos WHERE status='completed' AND completed_at > datetime('now', '-1 day')" 2>/dev/null || echo "0")
192:- ML predictions made: $(sqlite3 "$QUANTUM_DIR/quantum-todo.db" "SELECT COUNT(*) FROM ml_predictions WHERE created_at > datetime('now', '-1 day')" 2>/dev/null || echo "0")
214:    "current_task": "$(sqlite3 "$QUANTUM_DIR/quantum-todo.db" "SELECT content FROM quantum_todos WHERE status='in_progress' LIMIT 1" 2>/dev/null || echo "None")",
215:    "pending_todos": $(sqlite3 "$QUANTUM_DIR/quantum-todo.db" "SELECT COUNT(*) FROM quantum_todos WHERE status='pending'" 2>/dev/null || echo 0),
218:        "ml_models_active": $(sqlite3 "$QUANTUM_DIR/quantum-todo.db" "SELECT COUNT(*) FROM ml_models WHERE status='active'" 2>/dev/null || echo 0)
238:$(sqlite3 "$QUANTUM_DIR/quantum-todo.db" "SELECT content, ml_priority_score FROM quantum_todos WHERE status='pending' ORDER BY ml_priority_score DESC LIMIT 5" 2>/dev/null || echo "No tasks")
276:    if [ -f "$QUANTUM_DIR/quantum-todo.db" ]; then
278:        sqlite3 "$QUANTUM_DIR/quantum-todo.db" "PRAGMA integrity_check" > /dev/null 2>&1 || {
280:            cp "$QUANTUM_DIR/quantum-todo.db" "$QUANTUM_DIR/quantum-todo.db.corrupt"
281:            sqlite3 "$QUANTUM_DIR/quantum-todo.db" ".dump" | sqlite3 "$QUANTUM_DIR/quantum-todo.db.new"
282:            mv "$QUANTUM_DIR/quantum-todo.db.new" "$QUANTUM_DIR/quantum-todo.db"
312:    if [ -f "$QUANTUM_DIR/quantum-todo.db" ]; then
314:        echo "  Total tasks: $(sqlite3 "$QUANTUM_DIR/quantum-todo.db" "SELECT COUNT(*) FROM quantum_todos")"
315:        echo "  Pending: $(sqlite3 "$QUANTUM_DIR/quantum-todo.db" "SELECT COUNT(*) FROM quantum_todos WHERE status='pending'")"
316:        echo "  Completed: $(sqlite3 "$QUANTUM_DIR/quantum-todo.db" "SELECT COUNT(*) FROM quantum_todos WHERE status='completed'")"
317:        echo "  ML predictions: $(sqlite3 "$QUANTUM_DIR/quantum-todo.db" "SELECT COUNT(*) FROM ml_predictions")"
```

✅ **Uses Contractual Paths**: YES
9:    source "$SCRIPT_DIR/contractual-paths-true.sh"
18:    source "$SCRIPT_DIR/contractual-paths.sh"

**Explicit Database Paths:**
"$QUANTUM_DIR/quantum-todo.db"
"$QUANTUM_DIR/quantum-todo.db"
"$QUANTUM_DIR/quantum-todo.db"
"$QUANTUM_DIR/quantum-todo.db"
"$QUANTUM_DIR/quantum-todo.db"
"$QUANTUM_DIR/quantum-todo.db"
"$QUANTUM_DIR/quantum-todo.db"
"$QUANTUM_DIR/quantum-todo.db"
"$QUANTUM_DIR/quantum-todo.db"
"$QUANTUM_DIR/quantum-todo.db"
"$QUANTUM_DIR/quantum-todo.db"
"$QUANTUM_DIR/quantum-todo.db"
"$QUANTUM_DIR/quantum-todo.db"
"$QUANTUM_DIR/quantum-todo.db"
"$QUANTUM_DIR/quantum-todo.db"
"$QUANTUM_DIR/quantum-todo.db"
"$QUANTUM_DIR/quantum-todo.db"
"$QUANTUM_DIR/quantum-todo.db"
"$QUANTUM_DIR/quantum-todo.db"
"$QUANTUM_DIR/quantum-todo.db"
"$QUANTUM_DIR/quantum-todo.db"

---

#### Script: `FORENSIC_DATABASE_ANALYSIS.sh`

**Database References:**
```bash
20:find . -name "*.db" -type f \
58:    if [ -f "$script" ] && grep -q "\.db" "$script" 2>/dev/null; then
63:        grep -n "\.db" "$script" 2>/dev/null | grep -v "^[[:space:]]*#" | head -20
76:        # Extract all .db references
78:        grep -oE '"[^"]*\.db"' "$script" 2>/dev/null || echo "None found"
119:    if grep -q "\.db" "$daemon" 2>/dev/null; then
124:        grep -n "\.db" "$daemon" | head -10
136:DB1=".index-system/database/quantum-index.db"
137:DB2=".quantum-todo/quantum-index.db"
195:ps aux | grep -E "(sqlite|\.db|daemon|index)" | grep -v grep | head -20
200:lsof 2>/dev/null | grep "\.db$" || echo "No open database files detected"
213:ls -lh .quantum-todo/*.db 2>/dev/null | grep -i "backup\|migration\|safety"
222:for db in $(find . -name "*.db" -type f ! -path "*/.backups/*" ! -path "*/.archive/*" ! -path "*/backups/*" 2>/dev/null | head -10); do
238:grep -l "\.db" *.sh 2>/dev/null | while read script; do
```

✅ **Uses Contractual Paths**: YES
67:        # Check if it sources contractual paths
70:            grep -n "source.*contractual" "$script" 2>/dev/null
99:grep -l "source.*contractual.*db" *.sh 2>/dev/null | while read script; do

**Explicit Database Paths:**
"*.db"
"\.db"
"\.db"
"]*\.db"
"\.db"
"\.db"
".index-system/database/quantum-index.db"
".quantum-todo/quantum-index.db"
"*.db"
"\.db"

---

#### Script: `capture-baseline-metrics.sh`

**Database References:**
```bash
53:    if [ -f "$CLAUDE_PROJECTS_ROOT/.index-system/database/file-index.db" ]; then
55:        echo "Size: $(du -h "$CLAUDE_PROJECTS_ROOT/.index-system/database/file-index.db" | cut -f1)"
56:        sqlite3 "$CLAUDE_PROJECTS_ROOT/.index-system/database/file-index.db" << EOF
67:    if [ -f "$CLAUDE_PROJECTS_ROOT/.quantum-todo/quantum-index.db" ]; then
69:        echo "Size: $(du -h "$CLAUDE_PROJECTS_ROOT/.quantum-todo/quantum-index.db" | cut -f1)"
70:        echo "Total tasks: $(sqlite3 "$CLAUDE_PROJECTS_ROOT/.quantum-todo/quantum-index.db" "SELECT COUNT(*) FROM quantum_todos;" 2>/dev/null || echo "0")"
71:        echo "Pending tasks: $(sqlite3 "$CLAUDE_PROJECTS_ROOT/.quantum-todo/quantum-index.db" "SELECT COUNT(*) FROM quantum_todos WHERE status='pending';" 2>/dev/null || echo "0")"
168:- Index DB: $(du -h "$CLAUDE_PROJECTS_ROOT/.index-system/database/file-index.db" 2>/dev/null | cut -f1 || echo "N/A")
169:- Quantum DB: $(du -h "$CLAUDE_PROJECTS_ROOT/.quantum-todo/quantum-index.db" 2>/dev/null | cut -f1 || echo "N/A")
170:- Test Index DB: $(du -h "$CLAUDE_PROJECTS_ROOT/.test-environment/.index-system/database/file-index-test.db" 2>/dev/null | cut -f1 || echo "N/A")
171:- Test Quantum DB: $(du -h "$CLAUDE_PROJECTS_ROOT/.test-environment/.quantum-todo/quantum-test.db" 2>/dev/null | cut -f1 || echo "N/A")
```

✅ **Uses Contractual Paths**: YES
5:source "$(dirname "$0")/contractual-paths-true.sh"
116:        source "$CLAUDE_PROJECTS_ROOT/contractual-paths.sh"

**Explicit Database Paths:**
"$CLAUDE_PROJECTS_ROOT/.index-system/database/file-index.db"
"$CLAUDE_PROJECTS_ROOT/.index-system/database/file-index.db"
"$CLAUDE_PROJECTS_ROOT/.index-system/database/file-index.db"
"$CLAUDE_PROJECTS_ROOT/.quantum-todo/quantum-index.db"
"$CLAUDE_PROJECTS_ROOT/.quantum-todo/quantum-index.db"
"$CLAUDE_PROJECTS_ROOT/.quantum-todo/quantum-index.db"
"$CLAUDE_PROJECTS_ROOT/.quantum-todo/quantum-index.db"
"$CLAUDE_PROJECTS_ROOT/.index-system/database/file-index.db"
"$CLAUDE_PROJECTS_ROOT/.quantum-todo/quantum-index.db"
"$CLAUDE_PROJECTS_ROOT/.test-environment/.index-system/database/file-index-test.db"
"$CLAUDE_PROJECTS_ROOT/.test-environment/.quantum-todo/quantum-test.db"

---

#### Script: `claude-memory-hooks.sh`

**Database References:**
```bash
528:    if [[ -f "$CLAUDE_PROJECTS_ROOT/.universal-index/claude-memory.db" ]]; then
591:    local index_db="$CLAUDE_PROJECTS_ROOT/.universal-index/claude-memory.db"
600:    local index_db="$CLAUDE_PROJECTS_ROOT/.universal-index/claude-memory.db"
742:    if [[ -f "$CLAUDE_PROJECTS_ROOT/.universal-index/claude-memory.db" ]]; then
751:    [[ ! -f "$CLAUDE_PROJECTS_ROOT/.memory-hooks/enterprise-analytics.db" ]] && features+=("analytics")
```

✅ **Uses Contractual Paths**: YES
10:        [[ -f "$dir/contractual-paths.conf" ]] && source "$dir/contractual-paths.conf" && break

**Explicit Database Paths:**
"$CLAUDE_PROJECTS_ROOT/.universal-index/claude-memory.db"
"$CLAUDE_PROJECTS_ROOT/.universal-index/claude-memory.db"
"$CLAUDE_PROJECTS_ROOT/.universal-index/claude-memory.db"
"$CLAUDE_PROJECTS_ROOT/.universal-index/claude-memory.db"
"$CLAUDE_PROJECTS_ROOT/.memory-hooks/enterprise-analytics.db"

---

#### Script: `claude-memory-taxonomycraft-integration.sh`

**Database References:**
```bash
26:UNIVERSAL_INDEX_DB="$CLAUDE_PROJECTS_ROOT/.universal-index/claude-memory.db"
291:    local index_db="$CLAUDE_PROJECTS_ROOT/.universal-index/claude-memory.db"
300:    local index_db="$CLAUDE_PROJECTS_ROOT/.universal-index/claude-memory.db"
```

✅ **Uses Contractual Paths**: YES
9:        [[ -f "$dir/contractual-paths.conf" ]] && source "$dir/contractual-paths.conf" && break

**Explicit Database Paths:**
"$CLAUDE_PROJECTS_ROOT/.universal-index/claude-memory.db"
"$CLAUDE_PROJECTS_ROOT/.universal-index/claude-memory.db"
"$CLAUDE_PROJECTS_ROOT/.universal-index/claude-memory.db"

---

#### Script: `claude-memory-watcher.sh`

**Database References:**
```bash
263:    local index_db="$CLAUDE_PROJECTS_ROOT/.universal-index/claude-memory.db"
```

✅ **Uses Contractual Paths**: YES
9:        [[ -f "$dir/contractual-paths.conf" ]] && source "$dir/contractual-paths.conf" && break

**Explicit Database Paths:**
"$CLAUDE_PROJECTS_ROOT/.universal-index/claude-memory.db"

---

#### Script: `claude-os-compliance-functions.sh`

**Database References:**
```bash
276:            echo "$CLAUDE_PROJECTS_ROOT/.quantum-todo/quantum-index.db"
279:            echo "$CLAUDE_PROJECTS_ROOT/.index-system/universal-index.db"
```

✅ **Uses Contractual Paths**: YES
13:source /mnt/c/Users/jdh/claude_projects/contractual-paths-true.sh

**Explicit Database Paths:**
"$CLAUDE_PROJECTS_ROOT/.quantum-todo/quantum-index.db"
"$CLAUDE_PROJECTS_ROOT/.index-system/universal-index.db"

---

#### Script: `claude-os-contractual-paths.sh`

**Database References:**
```bash
303:    if [[ -f "$CLAUDE_PROJECTS_ROOT/.quantum-todo/quantum-index.db" ]]; then
```

✅ **Uses Contractual Paths**: YES
12:source /mnt/c/Users/jdh/claude_projects/contractual-paths-true.sh
256:# Discover quantum computing resources (contractual)

**Explicit Database Paths:**
"$CLAUDE_PROJECTS_ROOT/.quantum-todo/quantum-index.db"

---

#### Script: `complete-hashing-final.sh`

**Database References:**
```bash
4:MASTER_DB="/mnt/c/Users/jdh/claude_projects/.quantum-todo/quantum-index.db"
```

⚠️ **Uses Contractual Paths**: NO - HARD-CODED!

**Explicit Database Paths:**
"/mnt/c/Users/jdh/claude_projects/.quantum-todo/quantum-index.db"

---

#### Script: `content-analyzer.sh`

**Database References:**
```bash
10:METADATA_DB="$CLAUDE_PROJECTS_ROOT/.search-index/metadata.db"
11:CONTENT_DB="$INDEX_DIR/content-analysis.db"
```

✅ **Uses Contractual Paths**: YES
6:source "$CLAUDE_PROJECTS_ROOT/contractual-paths-true.sh"

**Explicit Database Paths:**
"$CLAUDE_PROJECTS_ROOT/.search-index/metadata.db"
"$INDEX_DIR/content-analysis.db"

---

#### Script: `contractual-db-paths.sh`

**Database References:**
```bash
20:export QUANTUM_INDEX_DB="${INDEX_DB_DIR}/quantum-index.db"
21:export FILE_INDEX_DB="${INDEX_DB_DIR}/file-index.db"
22:export METADATA_DB="${SEARCH_INDEX_DIR}/metadata.db"
48:            echo "$INDEX_DB_DIR/$db_name.db"
```

✅ **Uses Contractual Paths**: YES
8:    source "${SCRIPT_DIR}/contractual-paths-true.sh"

**Explicit Database Paths:**
"${INDEX_DB_DIR}/quantum-index.db"
"${INDEX_DB_DIR}/file-index.db"
"${SEARCH_INDEX_DIR}/metadata.db"
"$INDEX_DB_DIR/$db_name.db"

---

#### Script: `contractual-paths-true.sh`

**Database References:**
```bash
8:INDEX_DB="${INDEX_DB:-$SCRIPT_DIR/enterprise-indexing/data/index/enterprise.db}"
```

⚠️ **Uses Contractual Paths**: NO - HARD-CODED!

**Explicit Database Paths:**
None found

---

#### Script: `contractual-paths.sh`

**Database References:**
```bash
44:export QUANTUM_DB="$QUANTUM_DIR/quantum-index.db"
```

✅ **Uses Contractual Paths**: YES
10:        [[ -f "$dir/contractual-paths.conf" ]] && source "$dir/contractual-paths.conf" && break

**Explicit Database Paths:**
"$QUANTUM_DIR/quantum-index.db"

---

#### Script: `create-test-backup.sh`

**Database References:**
```bash
148:        "index_db_size": "$(du -h "$CLAUDE_PROJECTS_ROOT/.index-system/database/file-index.db" 2>/dev/null | cut -f1)",
149:        "quantum_todos": $(sqlite3 "$CLAUDE_PROJECTS_ROOT/.quantum-todo/quantum-index.db" "SELECT COUNT(*) FROM quantum_todos;" 2>/dev/null || echo "0")
```

✅ **Uses Contractual Paths**: YES
8:source "$SCRIPT_DIR/contractual-paths-true.sh"

**Explicit Database Paths:**
"$CLAUDE_PROJECTS_ROOT/.index-system/database/file-index.db"
"$CLAUDE_PROJECTS_ROOT/.quantum-todo/quantum-index.db"

---

#### Script: `create-test-isolation.sh`

**Database References:**
```bash
22:if [ -f "$CLAUDE_PROJECTS_ROOT/.index-system/database/file-index.db" ]; then
24:    cp "$CLAUDE_PROJECTS_ROOT/.index-system/database/file-index.db" \
25:       "$TEST_ROOT/.index-system/database/file-index-test.db"
26:    echo "✅ ($(du -h "$TEST_ROOT/.index-system/database/file-index-test.db" | cut -f1))"
29:    touch "$TEST_ROOT/.index-system/database/file-index-test.db"
33:if [ -f "$CLAUDE_PROJECTS_ROOT/.quantum-todo/quantum-index.db" ]; then
36:    sqlite3 "$CLAUDE_PROJECTS_ROOT/.quantum-todo/quantum-index.db" \
37:        "ATTACH DATABASE '$TEST_ROOT/.quantum-todo/quantum-test.db' AS testdb;
47:        cp "$CLAUDE_PROJECTS_ROOT/.quantum-todo/quantum-index.db" \
48:           "$TEST_ROOT/.quantum-todo/quantum-test.db"
60:export INDEX_DATABASE_PATH="$TEST_ROOT/.index-system/database/file-index-test.db"
61:export QUANTUM_DB_PATH="$TEST_ROOT/.quantum-todo/quantum-test.db"
102:    rm -f .index-system/database/file-index-test.db
103:    rm -f .quantum-todo/quantum-test.db
157:echo "   - Index: file-index-test.db"
158:echo "   - Quantum: quantum-test.db"
```

✅ **Uses Contractual Paths**: YES
5:source "$(dirname "$0")/contractual-paths-true.sh"

**Explicit Database Paths:**
"$CLAUDE_PROJECTS_ROOT/.index-system/database/file-index.db"
"$CLAUDE_PROJECTS_ROOT/.index-system/database/file-index.db"
"$TEST_ROOT/.index-system/database/file-index-test.db"
"$TEST_ROOT/.index-system/database/file-index-test.db"
"$TEST_ROOT/.index-system/database/file-index-test.db"
"$CLAUDE_PROJECTS_ROOT/.quantum-todo/quantum-index.db"
"$CLAUDE_PROJECTS_ROOT/.quantum-todo/quantum-index.db"
"$CLAUDE_PROJECTS_ROOT/.quantum-todo/quantum-index.db"
"$TEST_ROOT/.quantum-todo/quantum-test.db"
"$TEST_ROOT/.index-system/database/file-index-test.db"
"$TEST_ROOT/.quantum-todo/quantum-test.db"
"   - Index: file-index-test.db"
"   - Quantum: quantum-test.db"

---

#### Script: `cs-search.sh`

**Database References:**
```bash
20:    QUANTUM_INDEX_DB="${CLAUDE_PROJECTS_ROOT}/.index-system/database/quantum-index.db"
```

✅ **Uses Contractual Paths**: YES
8:    source "$SCRIPT_DIR/contractual-paths-true.sh"
15:    source "${SCRIPT_DIR}/contractual-db-paths.sh"
17:    source "${CLAUDE_PROJECTS_ROOT}/contractual-db-paths.sh"

**Explicit Database Paths:**
"${CLAUDE_PROJECTS_ROOT}/.index-system/database/quantum-index.db"

---

#### Script: `database-dependency-diagnostic.sh`

**Database References:**
```bash
12:find . -name "*.db" -type f ! -path "*/.archive/*" ! -path "*/.perpetual-trash/*" ! -path "*/node_modules/*" ! -path "*/.git/*" -exec sh -c '
26:rg -l "\.db" --type sh --max-count 1 2>/dev/null | while read script; do
28:  rg "\.db" "$script" --no-line-number --color never 2>/dev/null | grep -v "^#" | head -5
35:ps aux | grep -E "(sqlite|\.db)" | grep -v grep
47:find . -name "*.db" -type f -size +10M ! -path "*/.archive/*" ! -path "*/.perpetual-trash/*" -exec du -h {} + 2>/dev/null | sort -rh | head -20
52:if [ -f .quantum-todo/quantum-todo.db ]; then
54:  sqlite3 .quantum-todo/quantum-todo.db ".schema" 2>/dev/null | head -50
```

⚠️ **Uses Contractual Paths**: NO - HARD-CODED!

**Explicit Database Paths:**
"*.db"
"\.db"
"\.db"
"*.db"

---

#### Script: `ecosystem-rbac.sh`

**Database References:**
```bash
10:RBAC_DB="$CLAUDE_PROJECTS_ROOT/.ecosystem/rbac.db"
```

✅ **Uses Contractual Paths**: YES
7:source "$SCRIPT_DIR/contractual-paths.sh"

**Explicit Database Paths:**
"$CLAUDE_PROJECTS_ROOT/.ecosystem/rbac.db"

---

#### Script: `enterprise-hash-normalization-fortress.sh`

**Database References:**
```bash
28:MASTER_DB="${CLAUDE_PROJECTS_ROOT}/.quantum-todo/quantum-index.db"
29:UNIVERSAL_INDEX_DB="${CLAUDE_PROJECTS_ROOT}/.index-system/universal-index.db"
32:DB_SNAPSHOT="${SECURITY_DIR}/database-snapshot-${FORTRESS_ID}.db"
491:        'quantum-index.db',
```

✅ **Uses Contractual Paths**: YES
13:source "$(dirname "$0")/contractual-paths-true.sh" 2>/dev/null || {

**Explicit Database Paths:**
"${CLAUDE_PROJECTS_ROOT}/.quantum-todo/quantum-index.db"
"${CLAUDE_PROJECTS_ROOT}/.index-system/universal-index.db"
"${SECURITY_DIR}/database-snapshot-${FORTRESS_ID}.db"

---

#### Script: `enterprise-plans-consolidation-200.sh`

**Database References:**
```bash
335:    PLANS_DB="$CLAUDE_PROJECTS_ROOT/.quantum-todo/quantum-index.db"
```

✅ **Uses Contractual Paths**: YES
13:source /mnt/c/Users/jdh/claude_projects/contractual-paths-true.sh

**Explicit Database Paths:**
"$CLAUDE_PROJECTS_ROOT/.quantum-todo/quantum-index.db"

---

#### Script: `enterprise-plans-consolidation-optimized.sh`

**Database References:**
```bash
37:PLANS_DB="$CLAUDE_PROJECTS_ROOT/.quantum-todo/quantum-index.db"
```

✅ **Uses Contractual Paths**: YES
13:source /mnt/c/Users/jdh/claude_projects/contractual-paths-true.sh

**Explicit Database Paths:**
"$CLAUDE_PROJECTS_ROOT/.quantum-todo/quantum-index.db"

---

#### Script: `get-active-databases.sh`

**Database References:**
```bash
5:find . -name "*.db" -type f \
```

⚠️ **Uses Contractual Paths**: NO - HARD-CODED!

**Explicit Database Paths:**
"*.db"

---

#### Script: `git-smart-merge.sh`

**Database References:**
```bash
16:DB_FILE="${WIN_ROOT}/.merge-state/merge.db"
```

⚠️ **Uses Contractual Paths**: NO - HARD-CODED!

**Explicit Database Paths:**
"${WIN_ROOT}/.merge-state/merge.db"

---

#### Script: `map-dependencies-pause-daemons.sh`

**Database References:**
```bash
26:  - quantum-index.db (READ/WRITE)
56:  - file-index.db (READ/WRITE)
```

✅ **Uses Contractual Paths**: YES
5:source "$(dirname "$0")/contractual-paths-true.sh"

**Explicit Database Paths:**
None found

---

#### Script: `merge-enterprise.sh`

**Database References:**
```bash
10:MERGE_DB=".merge-state/merge-production.db"
```

⚠️ **Uses Contractual Paths**: NO - HARD-CODED!

**Explicit Database Paths:**
".merge-state/merge-production.db"

---

#### Script: `merge-system-initialize.sh`

**Database References:**
```bash
9:MERGE_DB=".merge-state/merge-production.db"
```

⚠️ **Uses Contractual Paths**: NO - HARD-CODED!

**Explicit Database Paths:**
".merge-state/merge-production.db"

---

#### Script: `nl-daemon-hooks-enterprise.sh`

**Database References:**
```bash
171:    if [[ ! -f "$CLAUDE_PROJECTS_ROOT/.ml-training/daemon-commands.db" ]]; then
172:        sqlite3 "$CLAUDE_PROJECTS_ROOT/.ml-training/daemon-commands.db" << EOF
186:    sqlite3 "$CLAUDE_PROJECTS_ROOT/.ml-training/daemon-commands.db" \
```

✅ **Uses Contractual Paths**: YES
5:source "$CLAUDE_PROJECTS_ROOT/contractual-paths-true.sh" 2>/dev/null || true

**Explicit Database Paths:**
"$CLAUDE_PROJECTS_ROOT/.ml-training/daemon-commands.db"
"$CLAUDE_PROJECTS_ROOT/.ml-training/daemon-commands.db"
"$CLAUDE_PROJECTS_ROOT/.ml-training/daemon-commands.db"

---

#### Script: `organize-with-dependencies.sh`

**Database References:**
```bash
12:DB_PATH="$SCRIPT_DIR/enterprise-indexing/data/index/enterprise.db"
```

✅ **Uses Contractual Paths**: YES
9:source "$SCRIPT_DIR/contractual-paths-true.sh"

**Explicit Database Paths:**
"$SCRIPT_DIR/enterprise-indexing/data/index/enterprise.db"

---

#### Script: `parallel-db-writer.sh`

**Database References:**
```bash
49:    local pattern_db="$CLAUDE_PROJECTS_ROOT/.index-system/quantum-index.db"
```

✅ **Uses Contractual Paths**: YES
6:source "${CLAUDE_PROJECTS_ROOT:-$WINDOWS_HOME/claude_projects}/contractual-paths-true.sh"

**Explicit Database Paths:**
"$CLAUDE_PROJECTS_ROOT/.index-system/quantum-index.db"

---

#### Script: `parallel-repair-engine.sh`

**Database References:**
```bash
38:        QUANTUM_TODO_DB="$WIN_ROOT/.quantum-todo/quantum-todo.db"
```

⚠️ **Uses Contractual Paths**: NO - HARD-CODED!

**Explicit Database Paths:**
"$WIN_ROOT/.quantum-todo/quantum-todo.db"

---

#### Script: `plans-phase0-backup.sh`

**Database References:**
```bash
42:safe_copy "$CLAUDE_PROJECTS_ROOT/.quantum-todo/quantum-todo.db" "$BACKUP_DIR/databases/quantum-todo.db"
117:[[ -f "$BACKUP_DIR/databases/quantum-todo.db" ]] && \
118:    cp "$BACKUP_DIR/databases/quantum-todo.db" "$CLAUDE_PROJECTS_ROOT/.quantum-todo/quantum-todo.db"
```

✅ **Uses Contractual Paths**: YES
6:source $WINDOWS_HOME/claude_projects/contractual-paths-true.sh
94:source $WINDOWS_HOME/claude_projects/contractual-paths-true.sh

**Explicit Database Paths:**
"$CLAUDE_PROJECTS_ROOT/.quantum-todo/quantum-todo.db"
"$BACKUP_DIR/databases/quantum-todo.db"
"$BACKUP_DIR/databases/quantum-todo.db"
"$BACKUP_DIR/databases/quantum-todo.db"
"$CLAUDE_PROJECTS_ROOT/.quantum-todo/quantum-todo.db"

---

#### Script: `process-cleanup.sh`

**Database References:**
```bash
22:pkill -f "xargs.*metadata.db" 2>/dev/null
```

⚠️ **Uses Contractual Paths**: NO - HARD-CODED!

**Explicit Database Paths:**
"xargs.*metadata.db"

---

#### Script: `quantum-compliance-enterprise-200.sh`

**Database References:**
```bash
28:MASTER_DB="${CLAUDE_PROJECTS_ROOT}/.quantum-todo/quantum-index.db"
29:UNIVERSAL_INDEX_DB="${CLAUDE_PROJECTS_ROOT}/.index-system/universal-index.db"
```

✅ **Uses Contractual Paths**: YES
13:source "$(dirname "$0")/contractual-paths-true.sh" 2>/dev/null || {

**Explicit Database Paths:**
"${CLAUDE_PROJECTS_ROOT}/.quantum-todo/quantum-index.db"
"${CLAUDE_PROJECTS_ROOT}/.index-system/universal-index.db"

---

#### Script: `quantum-compliance-final-100.sh`

**Database References:**
```bash
24:MASTER_DB="${CLAUDE_PROJECTS_ROOT}/.quantum-todo/quantum-index.db"
25:UNIVERSAL_INDEX_DB="${CLAUDE_PROJECTS_ROOT}/.index-system/universal-index.db"
174:        'quantum-index.db',
```

✅ **Uses Contractual Paths**: YES
12:source "$(dirname "$0")/contractual-paths-true.sh" 2>/dev/null || {

**Explicit Database Paths:**
"${CLAUDE_PROJECTS_ROOT}/.quantum-todo/quantum-index.db"
"${CLAUDE_PROJECTS_ROOT}/.index-system/universal-index.db"

---

#### Script: `quantum-migration-enterprise.sh`

**Database References:**
```bash
31:MASTER_DB="${CLAUDE_PROJECTS_ROOT}/.quantum-todo/quantum-index.db"
158:            find "${CLAUDE_PROJECTS_ROOT}" -name "*quantum*.db" -exec cp {} "${BACKUP_DIR}/" \; 2>/dev/null || true
185:                "${CLAUDE_PROJECTS_ROOT}/.quantum-todo/auto-backup-20250916-142107.db"
186:                "${CLAUDE_PROJECTS_ROOT}/quantum-todo.db"
187:                "${CLAUDE_PROJECTS_ROOT}/quantum_todos.db"
246:            if [[ -f "${CLAUDE_PROJECTS_ROOT}/.index-system/universal-index.db" ]]; then
447:    find "${CLAUDE_PROJECTS_ROOT}" -name "*quantum*.db" -exec cp {} "${BACKUP_DIR}/" \;
466:        "${CLAUDE_PROJECTS_ROOT}/.quantum-todo/auto-backup-20250916-142107.db"
467:        "${CLAUDE_PROJECTS_ROOT}/quantum-todo.db"
468:        "${CLAUDE_PROJECTS_ROOT}/quantum_todos.db"
543:        "${CLAUDE_PROJECTS_ROOT}/.quantum-todo/auto-backup-20250916-142107.db"
544:        "${CLAUDE_PROJECTS_ROOT}/quantum-todo.db"
545:        "${CLAUDE_PROJECTS_ROOT}/quantum_todos.db"
```

✅ **Uses Contractual Paths**: YES
17:source "$(dirname "$0")/contractual-paths-true.sh" 2>/dev/null || {

**Explicit Database Paths:**
"${CLAUDE_PROJECTS_ROOT}/.quantum-todo/quantum-index.db"
"*quantum*.db"
"${CLAUDE_PROJECTS_ROOT}/.quantum-todo/auto-backup-20250916-142107.db"
"${CLAUDE_PROJECTS_ROOT}/quantum-todo.db"
"${CLAUDE_PROJECTS_ROOT}/quantum_todos.db"
"${CLAUDE_PROJECTS_ROOT}/.index-system/universal-index.db"
"*quantum*.db"
"${CLAUDE_PROJECTS_ROOT}/.quantum-todo/auto-backup-20250916-142107.db"
"${CLAUDE_PROJECTS_ROOT}/quantum-todo.db"
"${CLAUDE_PROJECTS_ROOT}/quantum_todos.db"
"${CLAUDE_PROJECTS_ROOT}/.quantum-todo/auto-backup-20250916-142107.db"
"${CLAUDE_PROJECTS_ROOT}/quantum-todo.db"
"${CLAUDE_PROJECTS_ROOT}/quantum_todos.db"

---

#### Script: `rollback-file-organization.sh`

**Database References:**
```bash
12:DB_PATH="$SCRIPT_DIR/enterprise-indexing/data/index/enterprise.db"
```

✅ **Uses Contractual Paths**: YES
9:source "$SCRIPT_DIR/contractual-paths-true.sh"

**Explicit Database Paths:**
"$SCRIPT_DIR/enterprise-indexing/data/index/enterprise.db"

---

#### Script: `rollback-quantum-todo-changes.sh`

**Database References:**
```bash
30:    if ! sqlite3 .quantum-todo/quantum-index.db "SELECT COUNT(*) FROM quantum_todos;" >/dev/null 2>&1; then
```

⚠️ **Uses Contractual Paths**: NO - HARD-CODED!

**Explicit Database Paths:**
None found

---

#### Script: `setup-rollback-checkpoints.sh`

**Database References:**
```bash
65:    if [ -f "$CLAUDE_PROJECTS_ROOT/.index-system/database/file-index.db" ]; then
66:        cp "$CLAUDE_PROJECTS_ROOT/.index-system/database/file-index.db" \
67:           "$checkpoint_dir/index-db-backup.db"
70:    if [ -f "$CLAUDE_PROJECTS_ROOT/.quantum-todo/quantum-index.db" ]; then
71:        cp "$CLAUDE_PROJECTS_ROOT/.quantum-todo/quantum-index.db" \
72:           "$checkpoint_dir/quantum-db-backup.db"
124:    if [ -f "$checkpoint_dir/index-db-backup.db" ]; then
125:        cp "$CLAUDE_PROJECTS_ROOT/.index-system/database/file-index.db" \
126:           "$pre_rollback_dir/index-db-current.db" 2>/dev/null
127:        cp "$checkpoint_dir/index-db-backup.db" \
128:           "$CLAUDE_PROJECTS_ROOT/.index-system/database/file-index.db"
131:    if [ -f "$checkpoint_dir/quantum-db-backup.db" ]; then
132:        cp "$CLAUDE_PROJECTS_ROOT/.quantum-todo/quantum-index.db" \
133:           "$pre_rollback_dir/quantum-db-current.db" 2>/dev/null
134:        cp "$checkpoint_dir/quantum-db-backup.db" \
135:           "$CLAUDE_PROJECTS_ROOT/.quantum-todo/quantum-index.db"
```

✅ **Uses Contractual Paths**: YES
5:source "$(dirname "$0")/contractual-paths-true.sh"

**Explicit Database Paths:**
"$CLAUDE_PROJECTS_ROOT/.index-system/database/file-index.db"
"$CLAUDE_PROJECTS_ROOT/.index-system/database/file-index.db"
"$checkpoint_dir/index-db-backup.db"
"$CLAUDE_PROJECTS_ROOT/.quantum-todo/quantum-index.db"
"$CLAUDE_PROJECTS_ROOT/.quantum-todo/quantum-index.db"
"$checkpoint_dir/quantum-db-backup.db"
"$checkpoint_dir/index-db-backup.db"
"$CLAUDE_PROJECTS_ROOT/.index-system/database/file-index.db"
"$pre_rollback_dir/index-db-current.db"
"$checkpoint_dir/index-db-backup.db"
"$CLAUDE_PROJECTS_ROOT/.index-system/database/file-index.db"
"$checkpoint_dir/quantum-db-backup.db"
"$CLAUDE_PROJECTS_ROOT/.quantum-todo/quantum-index.db"
"$pre_rollback_dir/quantum-db-current.db"
"$checkpoint_dir/quantum-db-backup.db"
"$CLAUDE_PROJECTS_ROOT/.quantum-todo/quantum-index.db"

---

#### Script: `smart-merge-parallel.sh`

**Database References:**
```bash
14:MERGE_DB=".merge-state/merge-production.db"
424:Database: .merge-state/merge-production.db
```

⚠️ **Uses Contractual Paths**: NO - HARD-CODED!

**Explicit Database Paths:**
".merge-state/merge-production.db"

---

#### Script: `test-ml-features.sh`

**Database References:**
```bash
46:sqlite3 .quantum-todo/.quantum-todo.db "
```

✅ **Uses Contractual Paths**: YES
6:source "$SCRIPT_DIR/contractual-paths-true.sh"

**Explicit Database Paths:**
None found

---

#### Script: `test-quantum-suite-enhanced.sh`

**Database References:**
```bash
11:TEST_DB="$QUANTUM_DIR/.test-quantum.db"
187:        cp "$ORIGINAL_DB" "$snapshot_path/quantum-todo.db.backup"
```

✅ **Uses Contractual Paths**: YES
8:source "$SCRIPT_DIR/contractual-paths.sh"

**Explicit Database Paths:**
"$QUANTUM_DIR/.test-quantum.db"

---

#### Script: `test-quantum-suite.sh`

**Database References:**
```bash
10:TEST_DB="$QUANTUM_DIR/quantum-test.db"
126:    if [[ -f "$QUANTUM_DIR/quantum-todo.db" ]]; then
127:        cp "$QUANTUM_DIR/quantum-todo.db" "$BACKUP_DIR/"
394:    if [[ -f "$QUANTUM_DIR/quantum-todo.db" ]]; then
395:        sqlite3 "$QUANTUM_DIR/quantum-todo.db" "
```

✅ **Uses Contractual Paths**: YES
7:source "$SCRIPT_DIR/contractual-paths-true.sh" 2>/dev/null || source "$SCRIPT_DIR/contractual-paths.sh"

**Explicit Database Paths:**
"$QUANTUM_DIR/quantum-test.db"
"$QUANTUM_DIR/quantum-todo.db"
"$QUANTUM_DIR/quantum-todo.db"
"$QUANTUM_DIR/quantum-todo.db"
"$QUANTUM_DIR/quantum-todo.db"

---

#### Script: `unified-index-daemon.sh`

**Database References:**
```bash
27:METADATA_DB="${CLAUDE_PROJECTS_ROOT}/.search-index/metadata.db"
124:    # Use hybrid system's metadata.db to track changes
```

✅ **Uses Contractual Paths**: YES
5:        [[ -f "$dir/contractual-paths.conf" ]] && source "$dir/contractual-paths.conf" && break

**Explicit Database Paths:**
"${CLAUDE_PROJECTS_ROOT}/.search-index/metadata.db"

---

#### Script: `verify-100-percent-compliance.sh`

**Database References:**
```bash
107:        local perf_test=$(sqlite3 .quantum-todo/quantum-todo.db "
123:    local encryption_ready=$(sqlite3 .quantum-todo/quantum-todo.db "SELECT value FROM cache_config WHERE key='encryption_ready'" 2>/dev/null)
```

✅ **Uses Contractual Paths**: YES
10:source "$SCRIPT_DIR/contractual-paths.sh" 2>/dev/null || source "$SCRIPT_DIR/contractual-paths-true.sh"

**Explicit Database Paths:**
None found

---

## PART 3: CONTRACTUAL PATH SYSTEM ANALYSIS

### contractual-db-paths.sh - Master Definition

```bash
#!/bin/bash
# Contractual database paths - single source of truth
# All scripts MUST source this file for database access

# Source contractual paths first
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ -f "${SCRIPT_DIR}/contractual-paths-true.sh" ]; then
    source "${SCRIPT_DIR}/contractual-paths-true.sh"
else
    # Fallback
    CLAUDE_PROJECTS_ROOT="${CLAUDE_PROJECTS_ROOT:-$WINDOWS_HOME/claude_projects}"
fi

# Database directories
export INDEX_DB_DIR="${CLAUDE_PROJECTS_ROOT}/.index-system/database"
export SEARCH_INDEX_DIR="${CLAUDE_PROJECTS_ROOT}/.search-index"
export QUANTUM_TODO_DIR="${CLAUDE_PROJECTS_ROOT}/.quantum-todo"

# Primary database paths
export QUANTUM_INDEX_DB="${INDEX_DB_DIR}/quantum-index.db"
export FILE_INDEX_DB="${INDEX_DB_DIR}/file-index.db"
export METADATA_DB="${SEARCH_INDEX_DIR}/metadata.db"

# Backup and archive paths
export DB_BACKUP_DIR="${CLAUDE_PROJECTS_ROOT}/.perpetual-trash"
export DB_ARCHIVE_PREFIX="db-backup"

# Ensure directories exist
mkdir -p "${INDEX_DB_DIR}"
mkdir -p "${SEARCH_INDEX_DIR}"
mkdir -p "${QUANTUM_TODO_DIR}"
mkdir -p "${DB_BACKUP_DIR}"

# Function to get database path by name
get_db_path() {
    local db_name="$1"
    case "$db_name" in
        "quantum"|"quantum-index")
            echo "$QUANTUM_INDEX_DB"
            ;;
        "file"|"file-index")
            echo "$FILE_INDEX_DB"
            ;;
        "metadata"|"search")
            echo "$METADATA_DB"
            ;;
        *)
            echo "$INDEX_DB_DIR/$db_name.db"
            ;;
    esac
}

# Function to check if database exists and is valid
check_db() {
    local db_path="$1"
    if [ -f "$db_path" ] && [ -s "$db_path" ]; then
        # Check if it's a valid SQLite database
        if sqlite3 "$db_path" "SELECT 1;" &>/dev/null; then
            return 0
        fi
    fi
    return 1
}

# Export functions for use in other scripts
export -f get_db_path
export -f check_db```

### Scripts Sourcing Contractual Paths

- `FORENSIC_DATABASE_ANALYSIS.sh`
- `cs-search.sh`

## PART 4: DAEMON DATABASE DEPENDENCIES

### Daemon Registry


### Daemon Scripts Database Usage

#### Daemon: `./.index-system/contract-discovery-daemon.sh`

**Database References:**
```bash
30:        grep -q "sqlite3\|\.db" "$file" && requires+=("database")
```

#### Daemon: `./.index-system/nl-daemon-original.sh`

**Database References:**
```bash
16:DB_PATH="${CLAUDE_PROJECTS_ROOT}/.search-index/metadata.db"
```

#### Daemon: `./.index-system/nl-daemon.sh`

**Database References:**
```bash
16:DB_PATH="${CLAUDE_PROJECTS_ROOT}/.search-index/metadata.db"
```

#### Daemon: `./.index-system/nl-search-daemon.sh`

**Database References:**
```bash
19:INDEX_DB="$CLAUDE_PROJECTS_ROOT/.index-system/nl-index.db"
```

#### Daemon: `./.organized/scripts/unified-index-daemon-optimized.sh`

**Database References:**
```bash
33:METADATA_DB="${CLAUDE_PROJECTS_ROOT}/.search-index/metadata.db"
```

#### Daemon: `./.organized/scripts/unified-index-daemon.sh`

**Database References:**
```bash
27:METADATA_DB="${CLAUDE_PROJECTS_ROOT}/.search-index/metadata.db"
90:    # Use hybrid system's metadata.db to track changes
```

#### Daemon: `./.repair-snapshots/20251120_204830/windows_mirror_backup/.index-system/contract-discovery-daemon.sh`

**Database References:**
```bash
30:        grep -q "sqlite3\|\.db" "$file" && requires+=("database")
```

#### Daemon: `./.repair-snapshots/20251120_204830/windows_mirror_backup/.index-system/nl-daemon-original.sh`

**Database References:**
```bash
16:DB_PATH="${CLAUDE_PROJECTS_ROOT}/.search-index/metadata.db"
```

#### Daemon: `./.repair-snapshots/20251120_204830/windows_mirror_backup/.index-system/nl-daemon.sh`

**Database References:**
```bash
16:DB_PATH="${CLAUDE_PROJECTS_ROOT}/.search-index/metadata.db"
```

#### Daemon: `./.repair-snapshots/20251120_204830/windows_mirror_backup/.index-system/nl-search-daemon.sh`

**Database References:**
```bash
19:INDEX_DB="$CLAUDE_PROJECTS_ROOT/.index-system/nl-index.db"
```

#### Daemon: `./.repair-snapshots/20251120_204830/windows_mirror_backup/.organized/scripts/unified-index-daemon-optimized.sh`

**Database References:**
```bash
33:METADATA_DB="${CLAUDE_PROJECTS_ROOT}/.search-index/metadata.db"
```

#### Daemon: `./.repair-snapshots/20251120_204830/windows_mirror_backup/.organized/scripts/unified-index-daemon.sh`

**Database References:**
```bash
27:METADATA_DB="${CLAUDE_PROJECTS_ROOT}/.search-index/metadata.db"
90:    # Use hybrid system's metadata.db to track changes
```

#### Daemon: `./.repair-snapshots/20251120_204830/windows_mirror_backup/.test-environment/checkpoints/checkpoint-20250903-222519-initial/files/.index-system/nl-daemon-optimized.sh`

**Database References:**
```bash
16:DB_PATH="${CLAUDE_PROJECTS_ROOT}/.search-index/metadata.db"
```

#### Daemon: `./.repair-snapshots/20251120_204830/windows_mirror_backup/.test-environment/checkpoints/checkpoint-20250903-222519-initial/files/.index-system/nl-daemon-original.sh`

**Database References:**
```bash
16:DB_PATH="${CLAUDE_PROJECTS_ROOT}/.search-index/metadata.db"
```

#### Daemon: `./.repair-snapshots/20251120_204830/windows_mirror_backup/.test-environment/checkpoints/checkpoint-20250903-222519-initial/files/.index-system/nl-daemon.sh`

**Database References:**
```bash
16:DB_PATH="${CLAUDE_PROJECTS_ROOT}/.index-system/database/file-index.db"
```

#### Daemon: `./.repair-snapshots/20251120_204830/windows_mirror_backup/.test-environment/checkpoints/checkpoint-20250903-222519-initial/files/.index-system/nl-search-daemon.sh`

**Database References:**
```bash
19:INDEX_DB="$CLAUDE_PROJECTS_ROOT/.index-system/nl-index.db"
```

#### Daemon: `./.repair-snapshots/20251120_204830/windows_mirror_backup/map-dependencies-pause-daemons.sh`

**Database References:**
```bash
26:  - quantum-index.db (READ/WRITE)
56:  - file-index.db (READ/WRITE)
```

#### Daemon: `./.repair-snapshots/20251120_204830/windows_mirror_backup/nl-daemon-hooks-enterprise.sh`

**Database References:**
```bash
171:    if [[ ! -f "$CLAUDE_PROJECTS_ROOT/.ml-training/daemon-commands.db" ]]; then
172:        sqlite3 "$CLAUDE_PROJECTS_ROOT/.ml-training/daemon-commands.db" << EOF
186:    sqlite3 "$CLAUDE_PROJECTS_ROOT/.ml-training/daemon-commands.db" \
```

#### Daemon: `./.repair-snapshots/20251120_204830/windows_mirror_backup/TRASH/backup-scripts-archived-2025-07-24/backup-guardian-daemon.sh`

**Database References:**
```bash
19:PRIMARY_DB="$SESSION_DIR/sessions.db"
20:REPLICA_DB="$SESSION_DIR/sessions_replica.db"
```

#### Daemon: `./.repair-snapshots/20251120_204830/windows_mirror_backup/unified-index-daemon.sh`

**Database References:**
```bash
27:METADATA_DB="${CLAUDE_PROJECTS_ROOT}/.search-index/metadata.db"
124:    # Use hybrid system's metadata.db to track changes
```

#### Daemon: `./.repair-snapshots/20251120_204830/windows_mirror_backup/_snapshots/%TS%/.index-system/contract-discovery-daemon.sh`

**Database References:**
```bash
30:        grep -q "sqlite3\|\.db" "$file" && requires+=("database")
```

#### Daemon: `./.repair-snapshots/20251120_204830/windows_mirror_backup/_snapshots/%TS%/.index-system/nl-daemon-original.sh`

**Database References:**
```bash
16:DB_PATH="${CLAUDE_PROJECTS_ROOT}/.search-index/metadata.db"
```

#### Daemon: `./.repair-snapshots/20251120_204830/windows_mirror_backup/_snapshots/%TS%/.index-system/nl-daemon.sh`

**Database References:**
```bash
16:DB_PATH="${CLAUDE_PROJECTS_ROOT}/.search-index/metadata.db"
```

#### Daemon: `./.repair-snapshots/20251120_204830/windows_mirror_backup/_snapshots/%TS%/.index-system/nl-search-daemon.sh`

**Database References:**
```bash
19:INDEX_DB="$CLAUDE_PROJECTS_ROOT/.index-system/nl-index.db"
```

#### Daemon: `./.repair-snapshots/20251120_204830/windows_mirror_backup/_snapshots/%TS%/.organized/scripts/unified-index-daemon-optimized.sh`

**Database References:**
```bash
33:METADATA_DB="${CLAUDE_PROJECTS_ROOT}/.search-index/metadata.db"
```

#### Daemon: `./.repair-snapshots/20251120_204830/windows_mirror_backup/_snapshots/%TS%/.organized/scripts/unified-index-daemon.sh`

**Database References:**
```bash
27:METADATA_DB="${CLAUDE_PROJECTS_ROOT}/.search-index/metadata.db"
90:    # Use hybrid system's metadata.db to track changes
```

#### Daemon: `./.repair-snapshots/20251120_204830/windows_mirror_backup/_snapshots/%TS%/map-dependencies-pause-daemons.sh`

**Database References:**
```bash
26:  - quantum-index.db (READ/WRITE)
56:  - file-index.db (READ/WRITE)
```

#### Daemon: `./.repair-snapshots/20251120_204830/windows_mirror_backup/_snapshots/%TS%/unified-index-daemon.sh`

**Database References:**
```bash
27:METADATA_DB="${CLAUDE_PROJECTS_ROOT}/.search-index/metadata.db"
89:    # Use hybrid system's metadata.db to track changes
```

#### Daemon: `./.test-environment/checkpoints/checkpoint-20250903-222519-initial/files/.index-system/nl-daemon-optimized.sh`

**Database References:**
```bash
16:DB_PATH="${CLAUDE_PROJECTS_ROOT}/.search-index/metadata.db"
```

#### Daemon: `./.test-environment/checkpoints/checkpoint-20250903-222519-initial/files/.index-system/nl-daemon-original.sh`

**Database References:**
```bash
16:DB_PATH="${CLAUDE_PROJECTS_ROOT}/.search-index/metadata.db"
```

#### Daemon: `./.test-environment/checkpoints/checkpoint-20250903-222519-initial/files/.index-system/nl-daemon.sh`

**Database References:**
```bash
16:DB_PATH="${CLAUDE_PROJECTS_ROOT}/.index-system/database/file-index.db"
```

#### Daemon: `./.test-environment/checkpoints/checkpoint-20250903-222519-initial/files/.index-system/nl-search-daemon.sh`

**Database References:**
```bash
19:INDEX_DB="$CLAUDE_PROJECTS_ROOT/.index-system/nl-index.db"
```

#### Daemon: `./map-dependencies-pause-daemons.sh`

**Database References:**
```bash
26:  - quantum-index.db (READ/WRITE)
56:  - file-index.db (READ/WRITE)
```

#### Daemon: `./nl-daemon-hooks-enterprise.sh`

**Database References:**
```bash
171:    if [[ ! -f "$CLAUDE_PROJECTS_ROOT/.ml-training/daemon-commands.db" ]]; then
172:        sqlite3 "$CLAUDE_PROJECTS_ROOT/.ml-training/daemon-commands.db" << EOF
186:    sqlite3 "$CLAUDE_PROJECTS_ROOT/.ml-training/daemon-commands.db" \
```

#### Daemon: `./unified-index-daemon.sh`

**Database References:**
```bash
27:METADATA_DB="${CLAUDE_PROJECTS_ROOT}/.search-index/metadata.db"
124:    # Use hybrid system's metadata.db to track changes
```

## PART 5: QUANTUM-INDEX.DB DUPLICATION ANALYSIS

### Two Locations Found:

#### Location 1: `.index-system/database/quantum-index.db`

-rwxr-xr-x 1 groklygroup groklygroup 36M Sep 12 16:16 .index-system/database/quantum-index.db

**Tables:**
file_registry            quantum_fts_docsize      todo_dependency_view   
quantum_fts              quantum_fts_idx          todos_archived_20250726
quantum_fts_config       quantum_todos            todos_by_category      
quantum_fts_content      quantum_todos_trash      todos_by_priority      
quantum_fts_data         todo_dependencies        todos_critical_path    

**Table Count:** 15

#### Location 2: `.quantum-todo/quantum-index.db`

-rwxrwxrwx 1 groklygroup groklygroup 129M Dec  6 12:31 .quantum-todo/quantum-index.db

**Tables:**
anomaly_detections          quantum_execution_plan    
api_keys                    quantum_fts               
audit_log                   quantum_fts_config        
audit_trail                 quantum_fts_data          
cache_config                quantum_fts_docsize       
cross_reference_validation  quantum_fts_idx           
csrf_tokens                 quantum_todos             
custom_domains              quantum_todos_archive     
dependency_counts           quantum_todos_optimized   
email_templates             roles                     
file_index                  tenant_config             
hash_verification           tenant_usage              
ml_models                   theme_presets             
ml_predictions              todo_dependencies         
ml_processing_progress      todo_file_links           
ml_training_data            ui_components             
nlp_patterns                user_behavior             
performance_metrics         user_roles                
plans_consolidated          white_label_config        

**Table Count:** 38

### Schema Comparison

⚠️ **Schemas DIFFER** - See differences below:

```diff
--- /tmp/schema1.txt	2025-12-06 23:28:12.211859781 -0800
+++ /tmp/schema2.txt	2025-12-06 23:28:12.275859765 -0800
@@ -1,157 +1,470 @@
 CREATE TABLE quantum_todos (
     id TEXT PRIMARY KEY,
     content TEXT NOT NULL,
-    status TEXT NOT NULL,
-    priority TEXT NOT NULL,
+    status TEXT NOT NULL DEFAULT 'pending',
+    priority TEXT NOT NULL DEFAULT 'medium',
     source TEXT,
     created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
     completed_at TIMESTAMP,
     session_id TEXT,
     tags TEXT,
-    quantum_state TEXT DEFAULT 'superposition'
-, depends_on TEXT, blocks TEXT, dependency_status TEXT DEFAULT 'ready', estimated_hours REAL, actual_hours REAL, dependency_chain_length INTEGER DEFAULT 0, content_hash TEXT, source_file_hash TEXT, source_line_number INTEGER, confidence_level TEXT DEFAULT 'medium', completion_evidence TEXT, auto_completed BOOLEAN DEFAULT 0, completion_reason TEXT, review_date TIMESTAMP);
+    quantum_state TEXT DEFAULT 'superposition',
+    dependency_status TEXT DEFAULT 'ready',
+    dependency_chain_length INTEGER DEFAULT 0
+, craft_framework TEXT, project_tags TEXT, ml_priority_score REAL, content_hash TEXT, composite_content TEXT, tenant_id TEXT DEFAULT 'default', priority_order INTEGER DEFAULT 3, depends_on TEXT, blocks TEXT, estimated_hours REAL, actual_hours REAL, source_file_hash TEXT, source_line_number INTEGER, confidence_level TEXT, completion_evidence TEXT, auto_completed INTEGER, completion_reason TEXT, review_date INTEGER, predicted_duration INTEGER, actual_duration INTEGER);
+CREATE TABLE todo_dependencies (
+    id INTEGER PRIMARY KEY AUTOINCREMENT,
+    todo_id TEXT NOT NULL,
+    depends_on_id TEXT NOT NULL,
+    dependency_type TEXT DEFAULT 'blocks',
+    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
+    FOREIGN KEY (todo_id) REFERENCES quantum_todos (id),
+    FOREIGN KEY (depends_on_id) REFERENCES quantum_todos (id),
+    UNIQUE(todo_id, depends_on_id)
+);
+CREATE TABLE sqlite_sequence(name,seq);
 CREATE TABLE IF NOT EXISTS 'quantum_fts_data'(id INTEGER PRIMARY KEY, block BLOB);
 CREATE TABLE IF NOT EXISTS 'quantum_fts_idx'(segid, term, pgno, PRIMARY KEY(segid, term)) WITHOUT ROWID;
-CREATE TABLE IF NOT EXISTS 'quantum_fts_content'(id INTEGER PRIMARY KEY, c0, c1);
 CREATE TABLE IF NOT EXISTS 'quantum_fts_docsize'(id INTEGER PRIMARY KEY, sz BLOB);
 CREATE TABLE IF NOT EXISTS 'quantum_fts_config'(k PRIMARY KEY, v) WITHOUT ROWID;
-CREATE TABLE IF NOT EXISTS "todos_archived_20250726" (
+CREATE TABLE sqlite_stat1(tbl,idx,stat);
+CREATE TABLE file_index (
+    file_path TEXT PRIMARY KEY,
+    last_referenced TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
+    reference_count INTEGER DEFAULT 1
+);
+CREATE TABLE todo_file_links (
+    todo_id TEXT,
+    file_path TEXT,
+    FOREIGN KEY (todo_id) REFERENCES quantum_todos(id),
+    FOREIGN KEY (file_path) REFERENCES file_index(file_path)
+);
+CREATE TABLE ml_processing_progress (
+    content_type TEXT PRIMARY KEY,
+    last_processed_id TEXT,
+    last_processed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
+    items_processed INTEGER DEFAULT 0,
+    tenant_id TEXT DEFAULT 'default'
+);
+CREATE TABLE audit_trail (
+    audit_id TEXT PRIMARY KEY,
+    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
+    operation TEXT,
+    user_id TEXT,
+    tenant_id TEXT,
+    target_id TEXT,
+    details TEXT,
+    ip_address TEXT
+);
+CREATE TABLE tenant_config (
+    tenant_id TEXT PRIMARY KEY,
+    max_todos INTEGER DEFAULT 10000,
+    max_storage_mb INTEGER DEFAULT 100,
+    features TEXT DEFAULT '{}',
+    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
+    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
+);
+CREATE TABLE tenant_usage (
+    tenant_id TEXT PRIMARY KEY,
+    todo_count INTEGER DEFAULT 0,
+    storage_bytes INTEGER DEFAULT 0,
+    api_calls_today INTEGER DEFAULT 0,
+    last_activity TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
+    FOREIGN KEY (tenant_id) REFERENCES tenant_config(tenant_id)
+);
+CREATE TABLE api_keys (
+    key_hash TEXT PRIMARY KEY,
+    tenant_id TEXT NOT NULL,
+    user_id TEXT NOT NULL,
+    permissions TEXT DEFAULT '{}',
+    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
+    last_used TIMESTAMP,
+    expires_at TIMESTAMP,
+    FOREIGN KEY (tenant_id) REFERENCES tenant_config(tenant_id)
+);
+CREATE TABLE audit_log (
+    id INTEGER PRIMARY KEY AUTOINCREMENT,
+    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
+    tenant_id TEXT,
+    user_id TEXT,
+    api_key_hash TEXT,
+    operation TEXT,
```

### Row Count Comparison (All Tables)

| Table | Location 1 | Location 2 | Difference |
|-------|------------|------------|------------|
| file_registry | 214 | 0 | -214 |
| quantum_fts_docsize | 19837 | 28668 | 8831 |
| todo_dependency_view | 16280 | 0 | -16280 |
| quantum_fts | 19837 | 27852 | 8015 |
| quantum_fts_idx | 97 | 422 | 325 |
| todos_archived_20250726 | 1509 | 0 | -1509 |
| quantum_fts_config | 1 | 1 | 0 |
| quantum_todos | 16280 | 27852 | 11572 |
| todos_by_category | 3 | 0 | -3 |
| quantum_fts_content | 19837 | 0 | -19837 |
| quantum_todos_trash | 0 | 0 | 0 |
| todos_by_priority | 6971 | 0 | -6971 |
| quantum_fts_data | 164 | 498 | 334 |
| todo_dependencies | 49849 | 11076 | -38773 |
| todos_critical_path | 643 | 0 | -643 |

## PART 6: ACTIVE PROCESS DATABASE USAGE

### Processes Using Databases

groklyg+   349  0.1  0.0   5024  2180 pts/17   S    Dec05   2:39 /bin/bash ./plan-capture-daemon.sh start
groklyg+   350  0.0  0.0   5024  2052 pts/17   S    Dec05   0:19 /bin/bash ./plan-capture-daemon.sh start
groklyg+   421  0.0  0.0   5156  3584 pts/17   S    Dec05   0:00 /bin/bash ./quantum-todo-autocapture-daemon-enhanced.sh start
groklyg+   456  0.0  0.0   5860  3424 pts/17   S    Dec05   0:40 /bin/bash ./quantum-todo-autocapture-daemon-enhanced.sh start
groklyg+   473  0.0  0.0   4892  2088 pts/17   S    Dec05   0:00 /bin/bash ./quantum-autonomous-daemon.sh start
groklyg+   493  0.1  0.0   4892  3328 pts/17   S    Dec05   2:27 /bin/bash ./.organized/scripts/tmux-index-footer.sh --daemon
groklyg+   626  0.0  0.0   4892  2088 pts/18   S    Dec05   0:00 /bin/bash ./quantum-autonomous-daemon.sh start
groklyg+   650  0.1  0.0   5024  2308 pts/18   S    Dec05   2:39 /bin/bash ./plan-capture-daemon.sh start
groklyg+   651  0.0  0.0   5024  2308 pts/18   S    Dec05   0:21 /bin/bash ./plan-capture-daemon.sh start
groklyg+   761  0.1  0.0   4892  3456 pts/18   S    Dec05   2:30 /bin/bash ./.organized/scripts/tmux-index-footer.sh --daemon
groklyg+   815  0.0  0.0   5156  3584 pts/6    S    Dec05   0:00 /bin/bash ./chat-backup-daemon-enhanced-v2.sh start
groklyg+   839  0.1  0.0   5156  2800 pts/6    S    Dec05   2:10 /bin/bash ./chat-backup-daemon-enhanced-v2.sh start
groklyg+   886  0.0  0.0   4892  1792 ?        S    Nov22   6:32 /bin/bash /mnt/c/Users/jdh/claude_projects/.universal-history/persistent-capture-daemon.sh
groklyg+   896  0.0  0.0   5024  3456 pts/6    S    Dec05   0:01 /bin/bash ./plan-capture-daemon.sh start
groklyg+   921  0.0  0.0   5156  3584 pts/6    S    Dec05   0:00 /bin/bash ./quantum-todo-autocapture-daemon-enhanced.sh start
groklyg+   953  0.0  0.0   5892  3296 pts/6    S    Dec05   0:43 /bin/bash ./quantum-todo-autocapture-daemon-enhanced.sh start
groklyg+   973  0.0  0.0   4892  2216 pts/6    S    Dec05   0:00 /bin/bash ./quantum-autonomous-daemon.sh start
groklyg+   993  0.1  0.0   5024  2052 pts/6    S    Dec05   2:40 /bin/bash ./plan-capture-daemon.sh start
groklyg+   994  0.0  0.0   5024  2052 pts/6    S    Dec05   0:19 /bin/bash ./plan-capture-daemon.sh start
groklyg+  1031  0.1  0.0   4892  3584 pts/6    S    Dec05   2:30 /bin/bash ./.organized/scripts/tmux-index-footer.sh --daemon

### Open Database File Handles

No open database files detected

## PART 7: DATABASE MIGRATION HISTORY

### Migration-Related Files

./.hash-migration-progress
./.index-system/backups/pre-file-index-migration-20250811-200345.db
./.index-system/backups/pre-file-index-migration-20250811-200828.db
./.logs/quantum-migration/migration-audit-quantum-migration-20251012-153532.log
./.logs/quantum-migration/migration-audit-quantum-migration-20251012-154212.log
./.logs/quantum-migration/progress-quantum-migration-20251012-153532.json
./.logs/quantum-migration/progress-quantum-migration-20251012-154212.json
./.migration-backup-20250826-223828/migration.log
./.organized/logs/2025-09/enhanced-migration-20250826-184725.log
./.organized/logs/2025-09/enhanced-migration-20250826-185530.log
./.organized/logs/2025-09/enterprise-migration-20250816-001111.log
./.organized/logs/2025-09/eternal-history-migration-20250728_064204.log
./.organized/logs/2025-09/hash-migration-20250809-163337.log
./.organized/logs/2025-09/hash-migration-complete-20250809-165855.log
./.organized/logs/2025-09/hash-migration-complete-20250809-170100.log
./.organized/logs/2025-09/hash-migration-complete-20250809-182141.log
./.organized/logs/2025-09/hash-migration-finalize-20250809-182948.log
./.organized/logs/2025-09/migration-20250813-093405.log
./.organized/logs/2025-09/migration.log
./.organized/logs/enhanced-migration-20250826-184725.log

### Safety Backup Files in .quantum-todo/

-rw-r--r-- 1 groklygroup groklygroup  44M Oct 10 03:13 .quantum-todo/HOT_MIGRATION_SAFETY_20251010_031354_auto-backup.db
-rw-r--r-- 1 groklygroup groklygroup  66M Oct 10 03:13 .quantum-todo/HOT_MIGRATION_SAFETY_20251010_031354_quantum-index.db
-rw-r--r-- 1 groklygroup groklygroup  22M Oct 10 03:13 .quantum-todo/HOT_MIGRATION_SAFETY_20251010_031354_quantum-todo.db
-rw-r--r-- 1 groklygroup groklygroup 504K Oct 10 03:13 .quantum-todo/HOT_MIGRATION_SAFETY_20251010_031354_quantum_todos.db
-rw-r--r-- 1 groklygroup groklygroup  66M Oct  9 23:56 .quantum-todo/SAFETY_BACKUP_20251009_235633.db
-rw-r--r-- 1 groklygroup groklygroup  44M Oct  9 23:59 .quantum-todo/auto-backup-20250916-142107.db

## PART 8: COMPLETE DEPENDENCY GRAPH

### Database → Script Dependencies

#### `./.chat-registry/chat-registry.db`

**Referenced by:**

#### `./.cleanup-analysis/file_analysis.db`

**Referenced by:**

#### `./.cleanup-state/rollback-20251117_191418/quantum-todo-backup.db`

**Referenced by:**

#### `./.enforcement/core/time-waste.db`

**Referenced by:**

#### `./.enforcement/core/violation-tracking.db`

**Referenced by:**

#### `./.extraction-progress.db`

**Referenced by:**

#### `./.index-system/content-analysis.db`

**Referenced by:**
- `content-analyzer.sh`
  11:CONTENT_DB="$INDEX_DIR/content-analysis.db"

#### `./.index-system/database/quantum-index.db`

**Referenced by:**
- `AUTO_SESSION_END_PROTOCOL.sh`
  54:    sqlite3 "${CLAUDE_PROJECTS_ROOT}/.quantum-todo/quantum-index.db" \
- `CLAUDE_SESSION_END_PROTOCOL.sh`
  336:    "quantum_todo": "$BACKUP_DIR/.quantum-todo/quantum-index.db",
- `FORENSIC_DATABASE_ANALYSIS.sh`
  136:DB1=".index-system/database/quantum-index.db"
  137:DB2=".quantum-todo/quantum-index.db"
- `capture-baseline-metrics.sh`
  67:    if [ -f "$CLAUDE_PROJECTS_ROOT/.quantum-todo/quantum-index.db" ]; then
  69:        echo "Size: $(du -h "$CLAUDE_PROJECTS_ROOT/.quantum-todo/quantum-index.db" | cut -f1)"
  70:        echo "Total tasks: $(sqlite3 "$CLAUDE_PROJECTS_ROOT/.quantum-todo/quantum-index.db" "SELECT COUNT(*) FROM quantum_todos;" 2>/dev/null || echo "0")"
- `claude-os-compliance-functions.sh`
  276:            echo "$CLAUDE_PROJECTS_ROOT/.quantum-todo/quantum-index.db"
- `claude-os-contractual-paths.sh`
  303:    if [[ -f "$CLAUDE_PROJECTS_ROOT/.quantum-todo/quantum-index.db" ]]; then
- `complete-hashing-final.sh`
  4:MASTER_DB="/mnt/c/Users/jdh/claude_projects/.quantum-todo/quantum-index.db"
- `contractual-db-paths.sh`
  20:export QUANTUM_INDEX_DB="${INDEX_DB_DIR}/quantum-index.db"
- `contractual-paths.sh`
  44:export QUANTUM_DB="$QUANTUM_DIR/quantum-index.db"
- `create-test-backup.sh`
  149:        "quantum_todos": $(sqlite3 "$CLAUDE_PROJECTS_ROOT/.quantum-todo/quantum-index.db" "SELECT COUNT(*) FROM quantum_todos;" 2>/dev/null || echo "0")
- `create-test-isolation.sh`
  33:if [ -f "$CLAUDE_PROJECTS_ROOT/.quantum-todo/quantum-index.db" ]; then
  36:    sqlite3 "$CLAUDE_PROJECTS_ROOT/.quantum-todo/quantum-index.db" \
  47:        cp "$CLAUDE_PROJECTS_ROOT/.quantum-todo/quantum-index.db" \
- `cs-search.sh`
  20:    QUANTUM_INDEX_DB="${CLAUDE_PROJECTS_ROOT}/.index-system/database/quantum-index.db"
- `enterprise-hash-normalization-fortress.sh`
  28:MASTER_DB="${CLAUDE_PROJECTS_ROOT}/.quantum-todo/quantum-index.db"
  491:        'quantum-index.db',
- `enterprise-plans-consolidation-200.sh`
  335:    PLANS_DB="$CLAUDE_PROJECTS_ROOT/.quantum-todo/quantum-index.db"
- `enterprise-plans-consolidation-optimized.sh`
  37:PLANS_DB="$CLAUDE_PROJECTS_ROOT/.quantum-todo/quantum-index.db"
- `map-dependencies-pause-daemons.sh`
  26:  - quantum-index.db (READ/WRITE)
- `parallel-db-writer.sh`
  49:    local pattern_db="$CLAUDE_PROJECTS_ROOT/.index-system/quantum-index.db"
- `quantum-compliance-enterprise-200.sh`
  28:MASTER_DB="${CLAUDE_PROJECTS_ROOT}/.quantum-todo/quantum-index.db"
- `quantum-compliance-final-100.sh`
  24:MASTER_DB="${CLAUDE_PROJECTS_ROOT}/.quantum-todo/quantum-index.db"
  174:        'quantum-index.db',
- `quantum-migration-enterprise.sh`
  31:MASTER_DB="${CLAUDE_PROJECTS_ROOT}/.quantum-todo/quantum-index.db"
- `rollback-quantum-todo-changes.sh`
  30:    if ! sqlite3 .quantum-todo/quantum-index.db "SELECT COUNT(*) FROM quantum_todos;" >/dev/null 2>&1; then
- `setup-rollback-checkpoints.sh`
  70:    if [ -f "$CLAUDE_PROJECTS_ROOT/.quantum-todo/quantum-index.db" ]; then
  71:        cp "$CLAUDE_PROJECTS_ROOT/.quantum-todo/quantum-index.db" \
  132:        cp "$CLAUDE_PROJECTS_ROOT/.quantum-todo/quantum-index.db" \

#### `./.index-system/nl-index.db`

**Referenced by:**

#### `./.index-system/quantum-index.db`

**Referenced by:**
- `AUTO_SESSION_END_PROTOCOL.sh`
  54:    sqlite3 "${CLAUDE_PROJECTS_ROOT}/.quantum-todo/quantum-index.db" \
- `CLAUDE_SESSION_END_PROTOCOL.sh`
  336:    "quantum_todo": "$BACKUP_DIR/.quantum-todo/quantum-index.db",
- `FORENSIC_DATABASE_ANALYSIS.sh`
  136:DB1=".index-system/database/quantum-index.db"
  137:DB2=".quantum-todo/quantum-index.db"
- `capture-baseline-metrics.sh`
  67:    if [ -f "$CLAUDE_PROJECTS_ROOT/.quantum-todo/quantum-index.db" ]; then
  69:        echo "Size: $(du -h "$CLAUDE_PROJECTS_ROOT/.quantum-todo/quantum-index.db" | cut -f1)"
  70:        echo "Total tasks: $(sqlite3 "$CLAUDE_PROJECTS_ROOT/.quantum-todo/quantum-index.db" "SELECT COUNT(*) FROM quantum_todos;" 2>/dev/null || echo "0")"
- `claude-os-compliance-functions.sh`
  276:            echo "$CLAUDE_PROJECTS_ROOT/.quantum-todo/quantum-index.db"
- `claude-os-contractual-paths.sh`
  303:    if [[ -f "$CLAUDE_PROJECTS_ROOT/.quantum-todo/quantum-index.db" ]]; then
- `complete-hashing-final.sh`
  4:MASTER_DB="/mnt/c/Users/jdh/claude_projects/.quantum-todo/quantum-index.db"
- `contractual-db-paths.sh`
  20:export QUANTUM_INDEX_DB="${INDEX_DB_DIR}/quantum-index.db"
- `contractual-paths.sh`
  44:export QUANTUM_DB="$QUANTUM_DIR/quantum-index.db"
- `create-test-backup.sh`
  149:        "quantum_todos": $(sqlite3 "$CLAUDE_PROJECTS_ROOT/.quantum-todo/quantum-index.db" "SELECT COUNT(*) FROM quantum_todos;" 2>/dev/null || echo "0")
- `create-test-isolation.sh`
  33:if [ -f "$CLAUDE_PROJECTS_ROOT/.quantum-todo/quantum-index.db" ]; then
  36:    sqlite3 "$CLAUDE_PROJECTS_ROOT/.quantum-todo/quantum-index.db" \
  47:        cp "$CLAUDE_PROJECTS_ROOT/.quantum-todo/quantum-index.db" \
- `cs-search.sh`
  20:    QUANTUM_INDEX_DB="${CLAUDE_PROJECTS_ROOT}/.index-system/database/quantum-index.db"
- `enterprise-hash-normalization-fortress.sh`
  28:MASTER_DB="${CLAUDE_PROJECTS_ROOT}/.quantum-todo/quantum-index.db"
  491:        'quantum-index.db',
- `enterprise-plans-consolidation-200.sh`
  335:    PLANS_DB="$CLAUDE_PROJECTS_ROOT/.quantum-todo/quantum-index.db"
- `enterprise-plans-consolidation-optimized.sh`
  37:PLANS_DB="$CLAUDE_PROJECTS_ROOT/.quantum-todo/quantum-index.db"
- `map-dependencies-pause-daemons.sh`
  26:  - quantum-index.db (READ/WRITE)
- `parallel-db-writer.sh`
  49:    local pattern_db="$CLAUDE_PROJECTS_ROOT/.index-system/quantum-index.db"
- `quantum-compliance-enterprise-200.sh`
  28:MASTER_DB="${CLAUDE_PROJECTS_ROOT}/.quantum-todo/quantum-index.db"
- `quantum-compliance-final-100.sh`
  24:MASTER_DB="${CLAUDE_PROJECTS_ROOT}/.quantum-todo/quantum-index.db"
  174:        'quantum-index.db',
- `quantum-migration-enterprise.sh`
  31:MASTER_DB="${CLAUDE_PROJECTS_ROOT}/.quantum-todo/quantum-index.db"
- `rollback-quantum-todo-changes.sh`
  30:    if ! sqlite3 .quantum-todo/quantum-index.db "SELECT COUNT(*) FROM quantum_todos;" >/dev/null 2>&1; then
- `setup-rollback-checkpoints.sh`
  70:    if [ -f "$CLAUDE_PROJECTS_ROOT/.quantum-todo/quantum-index.db" ]; then
  71:        cp "$CLAUDE_PROJECTS_ROOT/.quantum-todo/quantum-index.db" \
  132:        cp "$CLAUDE_PROJECTS_ROOT/.quantum-todo/quantum-index.db" \

## SUMMARY & CRITICAL FINDINGS

### Hard-Coded Paths Identified

⚠️ **AUTO_SESSION_END_PROTOCOL.sh** - Uses hard-coded database paths
⚠️ **CLAUDE_SESSION_END_PROTOCOL.sh** - Uses hard-coded database paths
⚠️ **complete-hashing-final.sh** - Uses hard-coded database paths
⚠️ **contractual-paths-true.sh** - Uses hard-coded database paths
⚠️ **database-dependency-diagnostic.sh** - Uses hard-coded database paths
⚠️ **get-active-databases.sh** - Uses hard-coded database paths
⚠️ **git-smart-merge.sh** - Uses hard-coded database paths
⚠️ **merge-enterprise.sh** - Uses hard-coded database paths
⚠️ **merge-system-initialize.sh** - Uses hard-coded database paths
⚠️ **parallel-repair-engine.sh** - Uses hard-coded database paths
⚠️ **process-cleanup.sh** - Uses hard-coded database paths
⚠️ **rollback-quantum-todo-changes.sh** - Uses hard-coded database paths
⚠️ **smart-merge-parallel.sh** - Uses hard-coded database paths

### Contractual Path Adoption

- **Total Scripts**: 146
- **Using Contractual Paths**: 89
- **Adoption Rate**: 60%

---

**Analysis Complete**: Sat Dec  6 23:29:03 PST 2025
**Output File**: DATABASE_FORENSIC_ANALYSIS_COMPLETE_20251206_231727.md
