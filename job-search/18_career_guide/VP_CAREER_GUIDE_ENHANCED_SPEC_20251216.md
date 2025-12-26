# VICTORIA PEARSON - CAREER GUIDE ENHANCED
## HTML Portfolio Website Specification

**Generated:** December 16, 2025
**Purpose:** Single-page HTML portfolio showcasing all 6 systems + career narrative
**Format:** Responsive HTML/CSS (mobile-friendly)
**Deployment:** Netlify/Vercel (free hosting)

---

## 🎯 WEBSITE STRUCTURE

### Single-Page Layout (Sections)
1. **Hero/About** - 61-year-old narrative + $8M-25M portfolio value
2. **Portfolio** - 6 systems with demos/screenshots
3. **Services** - Acqui-hire, consulting, advisory offerings
4. **Media** - Press mentions, blog posts (when available)
5. **Contact** - LinkedIn, email, Calendly scheduling

---

## 📄 SECTION 1: HERO/ABOUT

### Hero Section (Above Fold)
```html
<section id="hero">
  <h1>Victoria Pearson</h1>
  <h2>61-Year-Old AI Architect | $20M IP Portfolio | Self-Taught in <12 Months</h2>
  <p class="tagline">If I can build enterprise AI systems at 61, imagine what YOU can do.</p>

  <div class="stats">
    <div class="stat">
      <span class="number">6</span>
      <span class="label">Production Systems Built</span>
    </div>
    <div class="stat">
      <span class="number">$8M-25M</span>
      <span class="label">Portfolio Value</span>
    </div>
    <div class="stat">
      <span class="number">21,810</span>
      <span class="label">Files Analyzed</span>
    </div>
    <div class="stat">
      <span class="number">500K+</span>
      <span class="label">Lines of Code</span>
    </div>
  </div>

  <div class="cta-buttons">
    <a href="#portfolio" class="btn-primary">View Portfolio</a>
    <a href="#contact" class="btn-secondary">Get In Touch</a>
  </div>
</section>
```

### About Section
```html
<section id="about">
  <h2>The Unconventional Journey</h2>

  <div class="story">
    <p><strong>At 61, I taught myself AI and built a $20M portfolio in less than 12 months.</strong></p>

    <p>No CS degree. No tech background. No funding. Just relentless curiosity and 10-20 hour coding days.</p>

    <p>I'm living proof that age is not a barrier—it's an advantage. Life experience gives you better product sense, systems thinking, and patience than any 22-year-old bootcamp grad.</p>

    <h3>What I've Built</h3>
    <ul>
      <li><strong>InterviewPlus:</strong> Multi-tenant HR SaaS (5,635 TypeScript files, production-deployed)</li>
      <li><strong>GenCraft:</strong> Meta-generation AI engine ($20M-50M licensing potential)</li>
      <li><strong>TokenCalc:</strong> AI cost calculator with patent-worthy forensic watermarking</li>
      <li><strong>BookCraft:</strong> AI-augmented book creation pipeline</li>
      <li><strong>LeadCraft:</strong> B2B lead extraction tool</li>
      <li><strong>Claude OS:</strong> Enterprise workflow automation (180+ scripts, 12 daemons)</li>
    </ul>

    <h3>Tech Stack</h3>
    <div class="skills">
      <span class="skill">TypeScript</span>
      <span class="skill">React</span>
      <span class="skill">Next.js</span>
      <span class="skill">Node.js</span>
      <span class="skill">PostgreSQL</span>
      <span class="skill">Supabase</span>
      <span class="skill">Python</span>
      <span class="skill">Claude API</span>
      <span class="skill">OpenAI API</span>
      <span class="skill">System Architecture</span>
    </div>
  </div>
</section>
```

---

## 📄 SECTION 2: PORTFOLIO

### Portfolio Grid
```html
<section id="portfolio">
  <h2>Portfolio: $8M-25M in Production Systems</h2>

  <!-- Project 1: InterviewPlus -->
  <div class="project">
    <div class="project-header">
      <h3>InterviewPlus</h3>
      <span class="value">$2M-4M</span>
    </div>

    <p class="description">Multi-tenant HR SaaS platform with AI-powered interview coaching, real-time feedback, and enterprise white-label branding.</p>

    <div class="tech-stack">
      <span>Next.js</span>
      <span>TypeScript</span>
      <span>Supabase</span>
      <span>PostgreSQL</span>
    </div>

    <div class="highlights">
      <ul>
        <li>5,635 TypeScript files</li>
        <li>5-level RBAC (god mode → end user)</li>
        <li>Multi-tenant data isolation</li>
        <li>Production-deployed, handling real users</li>
      </ul>
    </div>

    <div class="links">
      <a href="#contact" class="btn-small">Request Demo</a>
    </div>
  </div>

  <!-- Project 2: GenCraft -->
  <div class="project featured">
    <div class="project-header">
      <h3>GenCraft</h3>
      <span class="value">$20M-50M</span>
    </div>

    <p class="description">Model-agnostic meta-generation engine that builds complete systems from user intent. The architecture that generated all other projects.</p>

    <div class="tech-stack">
      <span>TypeScript</span>
      <span>AI APIs</span>
      <span>Pattern Synthesis</span>
    </div>

    <div class="highlights">
      <ul>
        <li>Works with Claude, GPT, Gemini (any LLM)</li>
        <li>10 ATP (Agentic Testing Patterns) library</li>
        <li>Generated InterviewPlus (5,635 files) in 90 days</li>
        <li>License-only (never for sale)</li>
      </ul>
    </div>

    <div class="links">
      <a href="#contact" class="btn-small">Licensing Inquiry</a>
    </div>
  </div>

  <!-- Project 3: TokenCalc -->
  <div class="project">
    <div class="project-header">
      <h3>TokenCalc</h3>
      <span class="value">$1M-1.5M</span>
    </div>

    <p class="description">AI cost tracking tool with patent-worthy forensic watermarking that prevents freemium abuse via multi-layer PDF manipulation.</p>

    <div class="tech-stack">
      <span>React</span>
      <span>Node.js</span>
      <span>PostgreSQL</span>
      <span>PDF Manipulation</span>
    </div>

    <div class="highlights">
      <ul>
        <li>Multi-model cost tracking (OpenAI, Anthropic, Google)</li>
        <li>3-layer watermarking (visible + email-triggered + invisible)</li>
        <li>Solves "Perplexity Comet problem"</li>
        <li>Market-ready, 2-3 weeks to integration</li>
      </ul>
    </div>

    <div class="links">
      <a href="#contact" class="btn-small">Acquisition Inquiry</a>
    </div>
  </div>

  <!-- Project 4: BookCraft -->
  <div class="project">
    <div class="project-header">
      <h3>BookCraft</h3>
      <span class="value">$3M-8M</span>
    </div>

    <p class="description">End-to-end AI-augmented book creation pipeline with market research, competitive analysis, and automated editing.</p>

    <div class="tech-stack">
      <span>Python</span>
      <span>AI APIs</span>
      <span>Automation</span>
    </div>

    <div class="highlights">
      <ul>
        <li>Research → outline → chapters → editing</li>
        <li>Market research integration</li>
        <li>SEO optimization</li>
        <li>Complete pipeline (production-ready)</li>
      </ul>
    </div>
  </div>

  <!-- Project 5: LeadCraft -->
  <div class="project">
    <div class="project-header">
      <h3>LeadCraft</h3>
      <span class="value">$100K-500K</span>
    </div>

    <p class="description">B2B lead extraction and analysis tool with web scraping, LinkedIn extraction, and CRM integration.</p>

    <div class="tech-stack">
      <span>Python</span>
      <span>Web Scraping</span>
      <span>NLP</span>
    </div>

    <div class="highlights">
      <ul>
        <li>Company/contact data extraction</li>
        <li>Email verification</li>
        <li>CRM-ready output (CSV, API)</li>
        <li>ToS-compliant LinkedIn extraction</li>
      </ul>
    </div>
  </div>

  <!-- Project 6: Claude OS -->
  <div class="project">
    <div class="project-header">
      <h3>Claude OS</h3>
      <span class="value">$100K-500K/year</span>
    </div>

    <p class="description">Enterprise workflow automation ecosystem built around Claude Code (180+ scripts, 12 production daemons).</p>

    <div class="tech-stack">
      <span>Bash</span>
      <span>Python</span>
      <span>System Integration</span>
    </div>

    <div class="highlights">
      <ul>
        <li>180+ automation scripts</li>
        <li>12 production daemons</li>
        <li>Session management, testing frameworks</li>
        <li>Consulting IP ($100K-500K/year)</li>
      </ul>
    </div>
  </div>
</section>
```

---

## 📄 SECTION 3: SERVICES

```html
<section id="services">
  <h2>How I Can Help</h2>

  <div class="services-grid">
    <!-- Service 1: Acqui-Hire -->
    <div class="service">
      <h3>🚀 Acqui-Hire Opportunities</h3>
      <p>Acquire my IP + hire me as Staff/Principal Engineer</p>

      <div class="package">
        <h4>Package Structure:</h4>
        <ul>
          <li><strong>Signing Bonus:</strong> $500K-1M (IP acquisition)</li>
          <li><strong>Base Salary:</strong> $250K-400K</li>
          <li><strong>Equity:</strong> 0.1%-0.5% or $200K-500K RSUs</li>
          <li><strong>Year 1 Total:</strong> $750K-1.4M</li>
        </ul>
      </div>

      <div class="targets">
        <h4>Target Companies:</h4>
        <p>Anthropic, OpenAI, Scale AI, Hugging Face, Vercel, Replit, Cursor</p>
      </div>

      <a href="#contact" class="btn-primary">Discuss Acqui-Hire</a>
    </div>

    <!-- Service 2: Consulting -->
    <div class="service">
      <h3>💼 AI Systems Consulting</h3>
      <p>Architecture, development, and deployment of production AI systems</p>

      <div class="offerings">
        <ul>
          <li><strong>System Architecture:</strong> Multi-tenant SaaS, microservices</li>
          <li><strong>AI Integration:</strong> Claude/GPT/Gemini into existing products</li>
          <li><strong>Code Review:</strong> Clean up messy codebases</li>
          <li><strong>Training:</strong> Teach your team AI-augmented development</li>
        </ul>
      </div>

      <div class="pricing">
        <h4>Rates:</h4>
        <p><strong>Hourly:</strong> $150-400/hour</p>
        <p><strong>Project:</strong> $15K-50K (4-12 weeks)</p>
        <p><strong>Retainer:</strong> $10K-20K/month</p>
      </div>

      <a href="#contact" class="btn-primary">Book Consultation</a>
    </div>

    <!-- Service 3: Advisory -->
    <div class="service">
      <h3>🎯 Advisory for VCs/Startups</h3>
      <p>Advise portfolio companies on AI strategy, architecture, and execution</p>

      <div class="offerings">
        <ul>
          <li><strong>Due Diligence:</strong> Tech stack audits for VCs</li>
          <li><strong>Strategic Advising:</strong> AI roadmap planning</li>
          <li><strong>Portfolio Support:</strong> Help early-stage companies scale</li>
          <li><strong>Interim CTO:</strong> 3-6 month engagements</li>
        </ul>
      </div>

      <div class="pricing">
        <h4>Engagement:</h4>
        <p><strong>Advisory:</strong> Equity + cash (negotiate per deal)</p>
        <p><strong>Interim CTO:</strong> $15K-30K/month</p>
      </div>

      <a href="#contact" class="btn-primary">VC Partnerships</a>
    </div>
  </div>
</section>
```

---

## 📄 SECTION 4: MEDIA (PLACEHOLDER)

```html
<section id="media">
  <h2>Media & Press</h2>

  <div class="media-notice">
    <p><strong>Press inquiries welcome.</strong> I have a compelling story: 61-year-old woman, self-taught AI architect, built $20M portfolio in <12 months.</p>
    <p>Perfect for stories about: AI democratization, ageism in tech, career pivots, diversity in STEM.</p>
  </div>

  <!-- Placeholder for future media mentions -->
  <div class="media-grid">
    <div class="media-item placeholder">
      <h3>Articles (Coming Soon)</h3>
      <p>Media coverage will appear here as it's published.</p>
    </div>

    <div class="media-item">
      <h3>Blog Posts</h3>
      <ul>
        <li><a href="#">At 61, I Learned AI to Launch My Second Act</a> (Coming Soon)</li>
        <li><a href="#">The CLAUDE.md System: Teaching AI to Work Like You</a> (Coming Soon)</li>
        <li><a href="#">Building a $20M IP Portfolio With Zero Funding</a> (Coming Soon)</li>
      </ul>
    </div>

    <div class="media-item placeholder">
      <h3>Podcast Interviews</h3>
      <p>Available for podcast interviews. Topics: AI, career change, ageism, entrepreneurship.</p>
    </div>
  </div>
</section>
```

---

## 📄 SECTION 5: CONTACT

```html
<section id="contact">
  <h2>Let's Talk</h2>

  <div class="contact-intro">
    <p>Interested in acquiring my IP? Hiring me? Collaboration? Let's connect.</p>
    <p>I respond to all legitimate inquiries within 24-48 hours.</p>
  </div>

  <div class="contact-methods">
    <div class="contact-card">
      <h3>📧 Email</h3>
      <a href="mailto:victoria@groklygroup.me">victoria@groklygroup.me</a>
      <p>Best for: Detailed inquiries, proposals</p>
    </div>

    <div class="contact-card">
      <h3>💼 LinkedIn</h3>
      <a href="https://linkedin.com/in/victoria-pearson" target="_blank">Connect on LinkedIn</a>
      <p>Best for: Professional networking</p>
    </div>

    <div class="contact-card">
      <h3>📅 Schedule a Call</h3>
      <a href="https://calendly.com/victoria-pearson/30min" target="_blank">Book 30-Minute Discovery Call</a>
      <p>Best for: Acqui-hire, consulting, partnerships</p>
    </div>

    <div class="contact-card">
      <h3>🌐 Portfolio Website</h3>
      <a href="https://groklygroup.me" target="_blank">groklygroup.me</a>
      <p>Learn more about my work</p>
    </div>
  </div>

  <div class="contact-cta">
    <h3>What I'm Looking For:</h3>
    <ul>
      <li>✅ Acqui-hire opportunities ($750K-1.4M total Year 1)</li>
      <li>✅ Staff/Principal Engineer roles ($250K-400K)</li>
      <li>✅ Consulting engagements ($150-400/hour)</li>
      <li>✅ Advisory roles (VCs, startups)</li>
      <li>✅ Speaking opportunities (conferences, podcasts)</li>
    </ul>
  </div>
</section>
```

---

## 🎨 CSS STYLING GUIDE

```css
/* Color Palette */
:root {
  --primary: #2563eb;      /* Blue */
  --secondary: #7c3aed;    /* Purple */
  --accent: #10b981;       /* Green */
  --dark: #1f2937;         /* Dark gray */
  --light: #f9fafb;        /* Light gray */
  --text: #374151;         /* Text gray */
}

/* Typography */
h1 { font-size: 3rem; font-weight: 700; }
h2 { font-size: 2.25rem; font-weight: 600; margin-bottom: 2rem; }
h3 { font-size: 1.5rem; font-weight: 600; }
p { line-height: 1.6; color: var(--text); }

/* Hero Section */
#hero {
  min-height: 100vh;
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  text-align: center;
  background: linear-gradient(135deg, var(--primary) 0%, var(--secondary) 100%);
  color: white;
}

.stats {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 2rem;
  margin: 3rem 0;
}

.stat .number { font-size: 2.5rem; font-weight: 700; display: block; }
.stat .label { font-size: 0.875rem; opacity: 0.8; }

/* Portfolio Grid */
.project {
  border: 1px solid #e5e7eb;
  border-radius: 8px;
  padding: 2rem;
  margin-bottom: 2rem;
  transition: box-shadow 0.3s;
}

.project:hover { box-shadow: 0 10px 25px rgba(0,0,0,0.1); }

.project.featured {
  border: 2px solid var(--accent);
  background: linear-gradient(135deg, rgba(37,99,235,0.05) 0%, rgba(124,58,237,0.05) 100%);
}

.project-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 1rem;
}

.value {
  font-size: 1.25rem;
  font-weight: 700;
  color: var(--accent);
}

/* Responsive Design */
@media (max-width: 768px) {
  .stats { grid-template-columns: repeat(2, 1fr); }
  h1 { font-size: 2rem; }
  h2 { font-size: 1.75rem; }
}
```

---

## 📊 DEPLOYMENT CHECKLIST

**Before Launch:**
- [ ] Replace placeholder LinkedIn URL with real profile
- [ ] Replace placeholder Calendly URL with actual link
- [ ] Add professional headshot photo (hero section)
- [ ] Add project screenshots/demos (portfolio section)
- [ ] Test on mobile devices (responsive design)
- [ ] Add Google Analytics tracking code
- [ ] Set up custom domain (groklygroup.me or victoriapearson.dev)

**Hosting Options:**
1. **Netlify** (recommended): Drag-and-drop, free SSL, custom domain
2. **Vercel**: GitHub integration, automatic deployments
3. **GitHub Pages**: Free, version controlled

**SEO Optimization:**
- Add meta description: "61-year-old AI architect built $20M portfolio. Available for acqui-hire, consulting, advisory roles."
- Add Open Graph tags (LinkedIn/Twitter preview)
- Create sitemap.xml
- Submit to Google Search Console

---

**Total Word Count:** ~2,400 words
**File Size:** Complete HTML spec with copy-paste sections
**Build Time:** 2-4 hours (HTML/CSS implementation)

**Next Step:** Implement HTML using provided sections + CSS styling
