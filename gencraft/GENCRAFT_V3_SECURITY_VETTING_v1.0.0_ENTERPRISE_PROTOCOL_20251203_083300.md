# ENTERPRISE SECURITY VETTING PROTOCOL
**Created**: 2025-12-03
**Purpose**: Define mandatory security processes for all third-party code integration
**Compliance**: Fortune 500 security standards + NIST guidelines

---

## 🚨 ZERO TRUST PRINCIPLE

**"Never trust, always verify" - Every dependency is guilty until proven innocent**

No code enters our systems without passing ALL security gates, regardless of source reputation.

---

## 📋 ENTERPRISE SECURITY VETTING PROCESS

### PHASE 0: SOURCE REPUTATION ASSESSMENT (Pre-Download)

#### Tier 1: Trusted Primary Sources (Lowest Risk)
**Criteria**:
- Official repositories from established organizations
- Examples: Google (TensorFlow), Meta (PyTorch), Microsoft (TypeScript), Mozilla, Apache Foundation
- Verified organization badges on GitHub
- 10,000+ stars, 100+ contributors, 5+ years active
- Regular security audits publicly documented

**Additional Checks**:
- [ ] Organization verified with blue checkmark
- [ ] Active maintenance (commits within last 30 days)
- [ ] Security policy documented (`SECURITY.md` present)
- [ ] Vulnerability disclosure process published
- [ ] CVE history reviewed (all patched promptly)

#### Tier 2: Well-Known Community Projects (Moderate Risk)
**Criteria**:
- Established open-source projects with large communities
- Examples: ESLint, Black, RuboCop
- 5,000+ stars, 50+ contributors, 3+ years active
- Used by Fortune 500 companies (verifiable)

**Additional Checks**:
- [ ] Code of conduct present
- [ ] Active issue triage (responses within 7 days)
- [ ] Documented governance model
- [ ] No major security incidents in last 2 years
- [ ] Dependencies themselves vetted

#### Tier 3: Emerging/Niche Tools (High Risk)
**Criteria**:
- Newer projects or specialized tools
- <5,000 stars or <3 years old
- Limited contributor base

**Additional Checks**:
- [ ] Full source code audit required
- [ ] All maintainers identity-verified
- [ ] External security audit completed (if available)
- [ ] Consider forking and maintaining internally
- [ ] Evaluate alternatives from Tier 1/2 first

#### Tier 4: NEVER USE (Prohibited)
- Anonymous maintainers
- No source code available (binaries only)
- Obfuscated code without justification
- Cryptocurrency-related projects (high malware risk)
- Forks of Tier 1/2 projects by unknown parties
- Dependencies from sanctioned countries without audit
- Projects with known security incidents (unpatched)

---

## 🔒 PHASE 1: PRE-DOWNLOAD SECURITY ASSESSMENT

### Step 1.1: Repository Metadata Analysis
**Run these checks WITHOUT downloading code**:

```bash
# Check GitHub API for repository info
curl -H "Authorization: token $GITHUB_TOKEN" \
  https://api.github.com/repos/ORG/REPO | jq '
{
  stars: .stargazers_count,
  forks: .forks_count,
  watchers: .watchers_count,
  open_issues: .open_issues_count,
  created_at: .created_at,
  updated_at: .updated_at,
  pushed_at: .pushed_at,
  language: .language,
  license: .license.name,
  has_issues: .has_issues,
  has_wiki: .has_wiki,
  archived: .archived,
  disabled: .disabled
}'

# Check for security policy
curl -s https://api.github.com/repos/ORG/REPO/community/profile | jq '.files.security'

# Check contributors count
curl -s https://api.github.com/repos/ORG/REPO/contributors | jq 'length'

# Check recent commit activity
curl -s https://api.github.com/repos/ORG/REPO/commits | jq '.[0:5] | .[] | {date: .commit.author.date, author: .commit.author.name}'
```

**Red Flags**:
- ❌ Archived or disabled repository
- ❌ No commits in last 90 days
- ❌ Single contributor (no peer review)
- ❌ Sudden spike in stars (bot manipulation)
- ❌ No license specified
- ❌ More open issues than stars (abandoned)

### Step 1.2: Dependency Tree Analysis
**Check what dependencies it pulls in**:

```bash
# For npm/Node.js
npm view PACKAGE dependencies peerDependencies

# For Python
pip show PACKAGE | grep Requires

# For Go
go mod graph PACKAGE

# For Rust
cargo tree PACKAGE
```

**Evaluate EVERY dependency**:
- [ ] All dependencies from Tier 1 or Tier 2 sources
- [ ] No circular dependencies
- [ ] No deprecated packages
- [ ] Dependency count reasonable (<50 for most projects)
- [ ] No dependencies from suspicious registries

### Step 1.3: Known Vulnerability Check
**Query CVE databases BEFORE download**:

```bash
# Check npm advisory database
npm audit --audit-level=moderate PACKAGE

# Check Python safety database
pip install safety
safety check --json

# Check Snyk vulnerability database
snyk test --package-manager=npm PACKAGE

# Check OSV.dev (Open Source Vulnerabilities)
curl "https://api.osv.dev/v1/query" -d \
  '{"package": {"name": "PACKAGE", "ecosystem": "npm"}}'
```

**Rejection Criteria**:
- ❌ Any HIGH or CRITICAL vulnerabilities (unpatched)
- ❌ Known malware signatures
- ❌ Supply chain attack history

---

## 🔍 PHASE 2: SHALLOW CLONE SECURITY SCAN

### Step 2.1: Shallow Clone (Minimal Exposure)
```bash
# Clone only latest commit (reduce attack surface)
git clone --depth 1 https://github.com/ORG/REPO /tmp/security-scan-$(date +%s)
cd /tmp/security-scan-*

# Verify no executables auto-run
ps aux | grep -i "REPO"  # Should return nothing
```

### Step 2.2: Automated Security Scanners
**Run ALL of these tools**:

#### A. Semgrep (Pattern-Based Analysis)
```bash
# Install Semgrep
pip install semgrep

# Run comprehensive security rules
semgrep --config=auto \
  --config="p/security-audit" \
  --config="p/secrets" \
  --config="p/ci" \
  --config="p/owasp-top-ten" \
  --json --output semgrep-results.json .

# Check for critical findings
jq '.results[] | select(.extra.severity == "ERROR")' semgrep-results.json
```

**Red Flags**:
- ❌ Hardcoded secrets/credentials
- ❌ SQL injection vulnerabilities
- ❌ Command injection patterns
- ❌ Path traversal vulnerabilities
- ❌ XSS vulnerabilities
- ❌ SSRF patterns

#### B. Trivy (Vulnerability Scanner)
```bash
# Install Trivy
curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sh

# Scan filesystem
trivy fs --severity HIGH,CRITICAL \
  --scanners vuln,secret,misconfig \
  --format json --output trivy-results.json .

# Check results
jq '.Results[] | select(.Vulnerabilities != null)' trivy-results.json
```

#### C. Bandit (Python Security)
```bash
# For Python projects only
pip install bandit
bandit -r . -f json -o bandit-results.json

# Check for high-severity issues
jq '.results[] | select(.issue_severity == "HIGH")' bandit-results.json
```

#### D. ESLint Security Plugin (JavaScript)
```bash
# For JavaScript/TypeScript projects
npm install -g eslint eslint-plugin-security

# Scan for security issues
eslint --plugin security --rule "security/*: error" . \
  --format json --output-file eslint-security.json
```

#### E. CodeQL (GitHub Advanced Security)
```bash
# Download CodeQL CLI
wget https://github.com/github/codeql-cli-binaries/releases/latest/download/codeql-linux64.zip
unzip codeql-linux64.zip

# Create database and analyze
codeql database create db --language=javascript
codeql database analyze db \
  --format=sarif-latest \
  --output=codeql-results.sarif \
  -- security-and-quality
```

### Step 2.3: Manual Code Pattern Analysis
**Search for suspicious patterns**:

```bash
# Check for obfuscation
rg -i "eval\(|exec\(|Function\(|setTimeout\(|setInterval\(" --type js
rg -i "exec\(|eval\(|compile\(|__import__\(" --type py

# Check for base64 encoding (data exfiltration)
rg -i "atob\(|btoa\(|Buffer\.from.*base64" --type js
rg -i "base64\.b64decode|base64\.b64encode" --type py

# Check for network calls
rg -i "fetch\(|XMLHttpRequest|http\.request|axios\." --type js
rg -i "requests\.|urllib\.|httplib\." --type py

# Check for file system access
rg -i "fs\.writeFile|fs\.readFile|require\('fs'\)" --type js
rg -i "open\(|os\.system|subprocess\." --type py

# Check for crypto mining
rg -i "coinhive|cryptonight|monero|stratum\+tcp"

# Check for reverse shells
rg -i "socket\.connect|reverse_tcp|bind_tcp|meterpreter"

# Check for credential harvesting
rg -i "password|passwd|api[_-]?key|secret|token|auth" --type env

# Check for backdoors
rg -i "backdoor|rootkit|keylog|trojan"
```

**Legitimate Use Cases** (require justification):
- Image/file encoding: OK if documented
- Sandboxed eval: OK in template engines
- Localhost network calls: OK for dev servers
- Environment variables: OK if not hardcoded secrets

### Step 2.4: Dependency Confusion Check
```bash
# Check if package name conflicts with internal packages
npm search PACKAGE_NAME --registry=https://registry.npmjs.org/
# Compare with internal registry
npm search PACKAGE_NAME --registry=https://internal.company.com/

# Ensure no typosquatting
npm search SIMILAR_NAME_1 SIMILAR_NAME_2 TYPO_VARIANT
```

**Red Flags**:
- ❌ Package name similar to well-known package (1-2 char difference)
- ❌ Package claims to be "official" but isn't from official org
- ❌ Recent creation date but high download count (suspicious)

---

## 🔬 PHASE 3: DEEP ANALYSIS (For Non-Trivial Dependencies)

### Step 3.1: Static Application Security Testing (SAST)
**Use commercial-grade SAST tools**:

1. **Snyk Code** (Free for open source):
```bash
npm install -g snyk
snyk auth
snyk code test --json > snyk-code-results.json
```

2. **SonarQube** (Self-hosted or cloud):
```bash
docker run -d --name sonarqube -p 9000:9000 sonarqube
# Configure and scan via web interface
```

### Step 3.2: Software Composition Analysis (SCA)
**Analyze entire dependency tree**:

```bash
# OWASP Dependency-Check
dependency-check --project "PACKAGE_NAME" \
  --scan . \
  --format JSON \
  --out dependency-check-report.json

# Check results
jq '.dependencies[] | select(.vulnerabilities != null)' dependency-check-report.json
```

### Step 3.3: License Compliance Check
**Ensure license compatibility**:

```bash
# For npm
npx license-checker --json --out licenses.json

# For Python
pip-licenses --format=json --output-file=licenses.json

# Check for restrictive licenses
jq '.[] | select(.licenses | contains("GPL") or contains("AGPL"))' licenses.json
```

**Acceptable Licenses for Commercial Use**:
- ✅ MIT
- ✅ Apache 2.0
- ✅ BSD (2-clause, 3-clause)
- ✅ ISC
- ⚠️ LGPL (with caution - consult legal)
- ❌ GPL/AGPL (requires open-sourcing our code)
- ❌ Proprietary/Commercial (requires purchase)

### Step 3.4: Maintainer Reputation Check
**Verify maintainer identity and history**:

```bash
# Check maintainer GitHub profiles
for maintainer in $(npm view PACKAGE maintainers --json | jq -r '.[].name'); do
  echo "Checking $maintainer..."
  curl -s "https://api.github.com/users/$maintainer" | jq '{
    name: .name,
    company: .company,
    created: .created_at,
    public_repos: .public_repos,
    followers: .followers
  }'
done
```

**Red Flags**:
- ❌ Anonymous maintainers (no real name/company)
- ❌ Account created recently (<1 year)
- ❌ No other significant projects
- ❌ Suspicious activity patterns (mass commits at odd hours)

---

## 🛡️ PHASE 4: SANDBOXED EXECUTION TEST

### Step 4.1: Isolated Environment Setup
**NEVER run unknown code in production environment**:

```bash
# Create Docker sandbox
docker run -it --rm \
  --network=none \
  --memory=512m \
  --cpus=1 \
  --read-only \
  --security-opt=no-new-privileges \
  node:20-alpine sh

# Inside container, install and test
npm install PACKAGE
node -e "const pkg = require('PACKAGE'); console.log(pkg);"
```

### Step 4.2: Runtime Behavior Monitoring
**Monitor what the code does when executed**:

```bash
# Monitor network calls (should be none in sandbox)
tcpdump -i eth0 -w network-capture.pcap &

# Monitor file system access
strace -f -e trace=file npm install PACKAGE 2>&1 | tee fs-access.log

# Monitor process spawning
strace -f -e trace=process npm install PACKAGE 2>&1 | tee process-spawn.log

# Check for unexpected behavior
grep -i "EACCES\|EPERM\|unexpected" *.log
```

**Red Flags**:
- ❌ Network calls during installation (data exfiltration)
- ❌ Attempting to write outside package directory
- ❌ Spawning unexpected processes
- ❌ Accessing sensitive system files (/etc/passwd, ~/.ssh/)

---

## 📊 PHASE 5: SECURITY SCORECARD

### Step 5.1: Automated Security Scoring
**Use OpenSSF Scorecard**:

```bash
# Install scorecard
go install github.com/ossf/scorecard/v4/cmd/scorecard@latest

# Run scorecard
scorecard --repo=github.com/ORG/REPO --format=json > scorecard-results.json

# View results
jq '.checks[] | select(.score < 7)' scorecard-results.json
```

**Minimum Requirements**:
- [ ] Code-Review: 8/10 (PRs reviewed before merge)
- [ ] Maintained: 8/10 (active development)
- [ ] CII-Best-Practices: 7/10 (security best practices)
- [ ] Branch-Protection: 8/10 (protected main branch)
- [ ] Signed-Releases: 7/10 (GPG-signed releases)
- [ ] Security-Policy: 10/10 (SECURITY.md present)
- [ ] Vulnerabilities: 10/10 (no known vulnerabilities)

### Step 5.2: Manual Security Review Checklist

**Code Quality**:
- [ ] TypeScript/type checking enabled
- [ ] Linters configured and passing
- [ ] Test coverage >80%
- [ ] No commented-out code
- [ ] No TODO/FIXME in critical paths

**Security Best Practices**:
- [ ] Input validation present
- [ ] Output encoding/escaping
- [ ] Authentication/authorization checks
- [ ] Secrets in environment variables (not hardcoded)
- [ ] Error messages don't leak sensitive info
- [ ] Rate limiting implemented
- [ ] CSRF protection (for web apps)
- [ ] SQL parameterization (no string concatenation)

**Documentation Quality**:
- [ ] README with clear usage examples
- [ ] API documentation complete
- [ ] Security considerations documented
- [ ] Breaking changes documented
- [ ] Migration guides for major versions

---

## ✅ PHASE 6: APPROVAL & DOCUMENTATION

### Step 6.1: Security Review Summary
**Generate comprehensive report**:

```markdown
# Security Review: [PACKAGE_NAME]

**Date**: [DATE]
**Reviewer**: [NAME]
**Version**: [VERSION]

## Summary
- **Risk Level**: [LOW/MEDIUM/HIGH]
- **Recommendation**: [APPROVE/REJECT/APPROVE WITH CONDITIONS]

## Findings

### Critical Issues (Must Fix)
- None / [List issues]

### High-Priority Warnings
- [List warnings]

### Medium-Priority Observations
- [List observations]

## Test Results
- Source Reputation: [PASS/FAIL]
- CVE Check: [PASS/FAIL]
- Semgrep Scan: [X errors, Y warnings]
- Trivy Scan: [X critical, Y high]
- CodeQL Scan: [PASS/FAIL]
- License Check: [LICENSE_NAME - COMPATIBLE]
- OpenSSF Scorecard: [X/10]
- Sandboxed Execution: [PASS/FAIL]

## Dependencies Analysis
- Total Dependencies: [COUNT]
- Vulnerable Dependencies: [COUNT]
- License Issues: [COUNT]

## Approval Conditions
1. [Condition 1, if any]
2. [Condition 2, if any]

## Sign-off
Approved by: [NAME]
Date: [DATE]
Next Review: [DATE + 6 months]
```

### Step 6.2: Add to Approved Dependencies List
```bash
# Add to project's approved dependencies
cat >> gencraft-v3.0/APPROVED_DEPENDENCIES.md << EOF
### [PACKAGE_NAME] v[VERSION]
- **Purpose**: [WHY WE NEED IT]
- **License**: [LICENSE_NAME]
- **Risk Level**: [LOW/MEDIUM/HIGH]
- **Last Reviewed**: [DATE]
- **Reviewed By**: [NAME]
- **Security Score**: [X/10]
- **Known Issues**: [NONE / LIST]
- **Conditions**: [NONE / LIST]
EOF
```

### Step 6.3: Pin Exact Versions
**NEVER use flexible version ranges for security-critical deps**:

```json
// ❌ BAD - allows automatic updates
{
  "dependencies": {
    "some-package": "^1.2.3",
    "other-package": "~2.0.0"
  }
}

// ✅ GOOD - exact versions only
{
  "dependencies": {
    "some-package": "1.2.3",
    "other-package": "2.0.0"
  }
}
```

---

## 🔄 PHASE 7: CONTINUOUS MONITORING

### Step 7.1: Automated Vulnerability Scanning
**Set up continuous monitoring**:

```bash
# GitHub Dependabot (automatic)
# - Create .github/dependabot.yml
# - Automatically scans and creates PRs for updates

# Snyk continuous monitoring
snyk monitor --project-name=gencraft-v3.0

# OWASP Dependency-Check (weekly cron)
0 2 * * 0 /usr/local/bin/dependency-check.sh --update
```

### Step 7.2: Re-review Triggers
**Re-run security review when**:
- [ ] Major version update (X.0.0)
- [ ] New CVE discovered for dependency
- [ ] Maintainer changes
- [ ] 6 months elapsed since last review
- [ ] Behavioral anomaly detected in production

---

## 🚫 REJECTION CRITERIA (Immediate Disqualification)

**Automatically reject if ANY of these are true**:

1. ❌ **Critical/High CVE** (unpatched)
2. ❌ **GPL/AGPL license** (unless legal approval)
3. ❌ **Malicious code patterns** detected
4. ❌ **Anonymous maintainers** (no verifiable identity)
5. ❌ **Abandoned project** (no commits in 1+ year)
6. ❌ **Failed sandbox test** (unexpected network/file access)
7. ❌ **OpenSSF Score <5** (multiple security failures)
8. ❌ **Obfuscated code** (without legitimate justification)
9. ❌ **Cryptocurrency-related** (high malware risk)
10. ❌ **Typosquatting attempt** (similar name to popular package)
11. ❌ **Supply chain attack history** (previous compromises)
12. ❌ **Suspicious dependency tree** (pulls in risky packages)

---

## 📚 INDUSTRY STANDARDS & FRAMEWORKS

### Security Frameworks We Follow:
1. **NIST Cybersecurity Framework**
2. **OWASP Top 10** (for web vulnerabilities)
3. **CIS Controls** (Critical Security Controls)
4. **SLSA Framework** (Supply Chain Levels for Software Artifacts)
5. **SSDF** (Secure Software Development Framework)

### Compliance Requirements:
- **SOC 2 Type II**: Security controls for service providers
- **ISO 27001**: Information security management
- **GDPR**: Data protection (for EU users)
- **HIPAA**: Healthcare data (if applicable)

---

## 🎯 RISK-BASED APPROACH

### Risk Classification:

**CRITICAL RISK** (Requires full Phase 1-6 review):
- Authentication/authorization libraries
- Cryptography libraries
- Database access libraries
- Network communication libraries
- Code execution/eval libraries

**HIGH RISK** (Requires Phase 1-4 review):
- File system access libraries
- HTML/XML parsers (XSS risk)
- API clients (SSRF risk)
- Serialization libraries (injection risk)

**MEDIUM RISK** (Requires Phase 1-3 review):
- UI components
- Logging libraries
- Testing frameworks
- Build tools

**LOW RISK** (Requires Phase 1-2 review):
- Type definitions (@types/*)
- Documentation generators
- Code formatters (Prettier, Black)

---

## ✅ TRUSTED PRIMARY SOURCES (Pre-Approved)

### Official Organizations (Tier 1 - Minimal Review):
- **Google**: TensorFlow, Angular, Protobuf
- **Meta**: React, PyTorch, Jest
- **Microsoft**: TypeScript, VSCode, .NET
- **Mozilla**: Firefox, Rust, MDN
- **Apache Foundation**: Kafka, Spark, Hadoop
- **CNCF**: Kubernetes, Prometheus, Envoy
- **Python Software Foundation**: Python, pip
- **Node.js Foundation**: Node.js, npm
- **Anthropic**: Claude SDKs, cookbooks, tools
- **Vercel**: Next.js, SWR, Turbo
- **Supabase**: Supabase client libraries

**Even for trusted sources**:
- [ ] Still run CVE checks (auto-update may lag)
- [ ] Still verify license (may change between versions)
- [ ] Still pin exact versions
- [ ] Still monitor for vulnerabilities

---

## 🛠️ TOOLS SUMMARY

### Required Security Tools:
1. **Semgrep** - Pattern-based security analysis
2. **Trivy** - Vulnerability scanning
3. **Snyk** - Dependency vulnerability tracking
4. **OWASP Dependency-Check** - SCA analysis
5. **CodeQL** - Advanced code analysis
6. **OpenSSF Scorecard** - Security scoring
7. **npm audit / pip audit** - Package manager security

### Optional (Enhanced Security):
8. **SonarQube** - Code quality + security
9. **Bandit** - Python security
10. **ESLint Security** - JavaScript security
11. **GitGuardian** - Secret scanning
12. **Dependabot** - Automated updates

---

## 📞 ESCALATION PROCESS

**When in doubt, escalate**:

1. **Security Team Review** (for MEDIUM/HIGH risk)
2. **CISO Approval** (for CRITICAL risk)
3. **Legal Review** (for license questions)
4. **Vendor Security Assessment** (for commercial tools)

**No one person should approve CRITICAL dependencies alone.**

---

**This protocol is MANDATORY for GenCraft v3.0 and all groklyGroup LLC projects.**

**Author**: Victoria Pearson
**Title**: Meta AI Architect and Vibe Coder
**Organization**: groklyGroup LLC
**Contact**: +1.626.278.1242
