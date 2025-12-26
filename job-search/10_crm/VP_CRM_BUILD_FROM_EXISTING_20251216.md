# VICTORIA PEARSON - CRM BUILD FROM EXISTING TOOLS
## Zero-Cost Job Search Tracking System Using Google Sheets + Notion

**Generated:** December 16, 2025
**Purpose:** Track all job search activities (journalist outreach, VC pitches, applications, interviews)
**Cost:** $0 (using free tools)
**Time to Set Up:** 2-3 hours
**Status:** Step-by-step implementation guide

---

## 🎯 WHY YOU NEED A CRM

### The Problem
Without a CRM, you'll lose track of:
- Which journalists you've pitched (and when to follow up)
- Which VCs you've contacted (and their response status)
- Which companies you've applied to
- Which interviews are scheduled
- What you promised to send to whom

### The Solution
A simple CRM tracks:
- **Who** you contacted
- **When** you contacted them
- **What** you sent/discussed
- **Status** (waiting for response, interview scheduled, offer received)
- **Next Action** (follow up on X date, send Y document)

### Expected Outcome
- **Never miss a follow-up** (automatic reminders)
- **Know your pipeline at a glance** (50 applications, 10 interviews, 2 offers)
- **Optimize your outreach** (what pitches are working? which sources produce interviews?)

---

## 📋 CRM OPTION 1: GOOGLE SHEETS (RECOMMENDED)

### Why Google Sheets?
- **Free**
- **Familiar** (everyone knows spreadsheets)
- **Customizable** (add any columns you need)
- **Shareable** (can share with spouse/friend for accountability)
- **Mobile-friendly** (Google Sheets app)

### Setup Instructions

#### Step 1: Create Master Tracking Sheet

**Make a copy of this template:** (or build from scratch using structure below)

---

### **TAB 1: JOURNALIST OUTREACH**

| Column | Description | Example |
|--------|-------------|---------|
| **Date Contacted** | When you sent pitch | 2025-12-16 |
| **Journalist Name** | Full name | Kara Swisher |
| **Outlet** | Where they work | NY Times, Pivot podcast |
| **Beat** | What they cover | Tech, AI, startups |
| **Email** | Contact email | kara.swisher@nytimes.com |
| **Pitch Sent** | Subject line of email | "61, Non-Developer, Built $20M IP Portfolio" |
| **Status** | Current state | Sent / Replied / Interview Scheduled / Published |
| **Response Date** | When they replied | 2025-12-20 |
| **Next Action** | What to do next | Follow up 12/23 if no reply |
| **Notes** | Any relevant details | Mentioned she loves underdog stories |

**Formula for "Days Since Contact":**
```
=TODAY()-A2
```
(Helps you know when to follow up—if >7 days, send gentle follow-up)

---

### **TAB 2: VC OUTREACH**

| Column | Description | Example |
|--------|-------------|---------|
| **Date Contacted** | When you sent pitch | 2025-12-16 |
| **VC Firm** | Company name | Andreessen Horowitz (a16z) |
| **Contact Name** | Person you emailed | Anjney Midha (AI Fund Partner) |
| **Email** | Contact email | anjney@a16z.com |
| **Pitch Type** | Portfolio Licensing or Hybrid Hire-Buy | Portfolio Licensing |
| **Pitch Sent** | Subject line | "Portfolio Licensing: $50K-100K Revenue for Your Companies" |
| **Status** | Current state | Sent / Replied / Meeting Scheduled / Deal in Progress / Closed |
| **Meeting Date** | If scheduled | 2025-12-22 10am PT |
| **Deal Size** | Potential revenue | $100K (license to 2 portfolio companies) |
| **Next Action** | What to do next | Send follow-up email with GenCraft demo link |
| **Notes** | Any relevant details | Interested in InterviewPlus for HR tech portfolio company |

**Formula for "Pipeline Value":**
```
=SUM(J:J)
```
(Shows total potential revenue from all VC deals)

---

### **TAB 3: JOB APPLICATIONS**

| Column | Description | Example |
|--------|-------------|---------|
| **Date Applied** | When you submitted | 2025-12-16 |
| **Company** | Company name | Anthropic |
| **Role Title** | Job title | Staff Software Engineer - AI Infrastructure |
| **Application URL** | Link to job posting | https://boards.greenhouse.io/... |
| **Source** | How you found it | LinkedIn / HARO / Direct outreach / Referral |
| **Status** | Current state | Applied / Screening Call / Interview / Offer / Rejected |
| **Recruiter Name** | Who you're talking to | Sarah Johnson |
| **Recruiter Email** | Contact email | sarah.johnson@anthropic.com |
| **Interview Dates** | All interview dates | 12/20 (phone), 12/27 (technical), 1/3 (onsite) |
| **Salary Range** | Expected comp | $250K-400K total comp |
| **Next Action** | What to do next | Prepare for technical interview (system design) |
| **Notes** | Any relevant details | Referral from John Smith (former Google colleague) |

**Formula for "Days in Pipeline":**
```
=TODAY()-A2
```
(Track how long each application has been pending)

**Formula for "Conversion Rate":**
```
=COUNTIF(F:F,"Offer")/COUNTA(A:A)
```
(What % of applications turn into offers?)

---

### **TAB 4: INTERVIEWS SCHEDULED**

| Column | Description | Example |
|--------|-------------|---------|
| **Date** | Interview date | 2025-12-20 |
| **Time** | Interview time | 2:00 PM PT |
| **Company** | Company name | Anthropic |
| **Interviewer(s)** | Who you're meeting | Sarah Johnson (Recruiter), Alex Chen (Eng Manager) |
| **Interview Type** | Format | Phone Screen / Technical / System Design / Behavioral / Onsite |
| **Duration** | How long | 60 minutes |
| **Prep Needed** | What to review | Review CLAUDE.md system, prepare to explain GenCraft architecture |
| **Zoom/Location** | Meeting link or address | https://zoom.us/j/123456 |
| **Status** | Current state | Scheduled / Completed / Rescheduled |
| **Follow-Up Sent** | Thank-you email sent? | Yes (12/20 evening) |
| **Outcome** | Result | Moved to next round / Offer / Rejected |

**Formula for "Interviews This Week":**
```
=COUNTIFS(A:A,">="&TODAY(),A:A,"<"&TODAY()+7)
```
(Shows upcoming interviews for the week)

---

### **TAB 5: OFFERS & NEGOTIATIONS**

| Column | Description | Example |
|--------|-------------|---------|
| **Company** | Company name | Anthropic |
| **Role** | Job title | Staff Software Engineer |
| **Offer Date** | When received | 2026-01-10 |
| **Base Salary** | Annual base | $220K |
| **Equity** | Stock value (4-year) | $400K (RSUs) |
| **Signing Bonus** | One-time | $50K |
| **Total Year 1** | Base + Equity/4 + Bonus | $370K |
| **Benefits** | Health, 401k match, etc. | Excellent (Platinum health, 6% 401k match) |
| **Deadline** | Decision deadline | 2026-01-17 |
| **Negotiation Status** | Current state | Counter-sent / Accepted / Declined |
| **Counter Request** | What you asked for | $250K base, $75K signing bonus |
| **Final Offer** | After negotiation | $240K base, $60K bonus, $400K equity = $400K Year 1 |

**Formula for "Best Offer":**
```
=MAX(G:G)
```
(Shows highest total comp offer)

---

### **TAB 6: MEDIA MENTIONS & PR WINS**

| Column | Description | Example |
|--------|-------------|---------|
| **Date Published** | When it went live | 2026-01-15 |
| **Outlet** | Where it appeared | NY Times |
| **Type** | Format | Article / Podcast / Video / Interview |
| **Title** | Headline | "At 61, She Learned AI and Built a $20M Portfolio" |
| **Link** | URL | https://nytimes.com/... |
| **Journalist** | Who covered you | Kara Swisher |
| **Reach** | Estimated audience | 5M readers |
| **LinkedIn Shares** | How many times shared | 350+ |
| **Impact** | What happened after | 15 inbound job inquiries, 3 VC meetings |
| **Quote Used** | Your quote in article | "If I can do this at 61, anyone can catch this window" |

**Formula for "Total Reach":**
```
=SUM(G:G)
```
(Shows total audience across all media mentions)

---

### **TAB 7: WEEKLY DASHBOARD (Overview)**

**This tab auto-populates from other tabs for quick status check.**

| Metric | Formula | Example |
|--------|---------|---------|
| **Journalists Pitched** | =COUNTA('Journalist Outreach'!A:A)-1 | 25 |
| **Journalists Replied** | =COUNTIF('Journalist Outreach'!G:G,"Replied") | 5 |
| **Media Mentions** | =COUNTA('Media Mentions'!A:A)-1 | 3 |
| **VCs Pitched** | =COUNTA('VC Outreach'!A:A)-1 | 15 |
| **VC Meetings Held** | =COUNTIF('VC Outreach'!G:G,"Meeting Scheduled") | 4 |
| **VC Pipeline Value** | =SUM('VC Outreach'!I:I) | $450K |
| **Jobs Applied** | =COUNTA('Job Applications'!A:A)-1 | 30 |
| **Interviews Scheduled** | =COUNTIF('Job Applications'!F:F,"Interview") | 8 |
| **Offers Received** | =COUNTIF('Job Applications'!F:F,"Offer") | 2 |
| **Best Offer (Total Comp)** | =MAX('Offers'!G:G) | $400K |
| **This Week's Interviews** | =COUNTIFS('Interviews'!A:A,">="&TODAY(),'Interviews'!A:A,"<"&TODAY()+7) | 3 |

**Create a simple chart:**
- **Applications → Interviews → Offers** (funnel visualization)
- **Pipeline Value Over Time** (VC deals)
- **Media Mentions by Month** (PR momentum)

---

## 🔧 ADVANCED GOOGLE SHEETS FEATURES

### 1. Conditional Formatting (Visual Alerts)

**Highlight overdue follow-ups:**
- Select "Next Action" column
- Format → Conditional formatting
- Format cells if: "Text contains" → "Follow up"
- Color: Yellow background (reminder to act)

**Highlight hot leads:**
- Select "Status" column
- Format cells if: "Text is exactly" → "Interview Scheduled"
- Color: Green background

**Highlight rejections:**
- Format cells if: "Text is exactly" → "Rejected"
- Color: Gray background (so you can ignore)

---

### 2. Data Validation (Dropdown Menus)

**Status column dropdown:**
- Select "Status" column
- Data → Data validation
- Criteria: List of items → "Sent, Replied, Interview Scheduled, Offer, Rejected"
- Now you can select from dropdown (prevents typos)

---

### 3. Google Sheets Reminders (Using Google Calendar)

**Auto-create calendar events for follow-ups:**
- Use Zapier or IFTTT (free tier)
- Trigger: New row added to Google Sheet
- Action: Create Google Calendar event (date = "Next Action" date)
- Now follow-ups appear on your calendar automatically

---

### 4. Weekly Email Digest (Optional)

**Use Google Apps Script (free):**
```javascript
function sendWeeklyDigest() {
  var sheet = SpreadsheetApp.getActiveSpreadsheet().getSheetByName("Weekly Dashboard");
  var data = sheet.getRange("A1:B11").getValues();

  var emailBody = "Your Weekly Job Search Update:\n\n";
  for (var i = 0; i < data.length; i++) {
    emailBody += data[i][0] + ": " + data[i][1] + "\n";
  }

  MailApp.sendEmail({
    to: "your-email@example.com",
    subject: "Weekly Job Search Dashboard",
    body: emailBody
  });
}
```

**Set up trigger:**
- Extensions → Apps Script
- Paste code above
- Triggers → Add trigger → Time-driven → Week timer → Every Sunday

Now you get a weekly email with your stats!

---

## 📱 CRM OPTION 2: NOTION (IF YOU PREFER VISUAL)

### Why Notion?
- **More visual** than Google Sheets (kanban boards, galleries)
- **All-in-one** (notes, tasks, CRM in one place)
- **Templates available** (job search, CRM templates)
- **Free tier** sufficient for solo use

### Setup Instructions

**Step 1: Create Workspace**
- Sign up for Notion (free)
- Create new workspace: "Victoria Job Search"

**Step 2: Create Databases**

**Database 1: Journalist Outreach**
- View: Table (default), Kanban (by Status), Calendar (by Date Contacted)
- Properties: Same as Google Sheets columns above
- Kanban view: Drag cards from "Sent" → "Replied" → "Interview Scheduled"

**Database 2: VC Outreach**
- View: Table, Kanban (by Status), Gallery (visual cards with logos)
- Properties: Same as Google Sheets columns

**Database 3: Job Applications**
- View: Table, Kanban (by Status), Calendar (by Interview Date)
- Filters: "Hide Rejected" (so you only see active opportunities)

**Database 4: Interviews**
- View: Calendar (see all interviews on timeline)
- Properties: Same as Google Sheets

**Database 5: Offers**
- View: Table (simple list)
- Formula column: "Total Year 1 Comp" = Base + (Equity/4) + Bonus

**Step 3: Link Databases**
- Create "relations" between databases:
  - Job Application → Interviews (link each interview to its job)
  - Job Application → Offers (link offer to original application)
- Now you can see full journey: Application → Interview → Offer

**Step 4: Dashboard Page**
- Create new page: "Dashboard"
- Add linked database views:
  - "This Week's Interviews" (calendar view)
  - "Active Applications" (kanban board)
  - "VC Pipeline" (table view filtered by "In Progress")
  - "Recent Media Mentions" (gallery view)

---

## 🎯 WHICH CRM TO CHOOSE?

| Feature | Google Sheets | Notion |
|---------|---------------|--------|
| **Ease of Use** | ⭐⭐⭐⭐⭐ (everyone knows spreadsheets) | ⭐⭐⭐ (learning curve) |
| **Customization** | ⭐⭐⭐⭐⭐ (infinite formulas) | ⭐⭐⭐⭐ (flexible but less technical) |
| **Visual Appeal** | ⭐⭐ (basic) | ⭐⭐⭐⭐⭐ (beautiful) |
| **Mobile App** | ⭐⭐⭐⭐ (works well) | ⭐⭐⭐⭐⭐ (excellent) |
| **Sharing** | ⭐⭐⭐⭐⭐ (easy to share) | ⭐⭐⭐⭐ (easy to share) |
| **Free Tier** | ⭐⭐⭐⭐⭐ (unlimited) | ⭐⭐⭐⭐ (generous) |
| **Speed** | ⭐⭐⭐⭐⭐ (instant) | ⭐⭐⭐ (can be slow with large databases) |

**Recommendation:**
- **Start with Google Sheets** (faster setup, no learning curve)
- **Migrate to Notion later** if you want prettier dashboards

---

## 🚀 IMPLEMENTATION PLAN

### Week 1: Set Up CRM
**Monday (2 hours):**
- [ ] Choose CRM (Google Sheets or Notion)
- [ ] Create all tabs/databases
- [ ] Set up conditional formatting (Google Sheets) or views (Notion)
- [ ] Add first 10 journalist contacts from HARO strategy doc

**Tuesday (1 hour):**
- [ ] Add first 10 VC contacts from VC outreach strategy
- [ ] Set up dropdown menus for "Status" columns
- [ ] Create Weekly Dashboard tab

**Wednesday (30 min):**
- [ ] Test CRM by logging first 5 journalist pitches
- [ ] Set up Google Calendar integration for follow-ups

---

### Ongoing: Daily CRM Habits (10 min/day)

**Every Morning:**
- [ ] Check "Next Action" column for today's follow-ups
- [ ] Review "This Week's Interviews" calendar

**After Every Outreach:**
- [ ] Log contact immediately (don't let it pile up)
- [ ] Set "Next Action" date (usually 7 days for follow-up)

**Every Sunday (30 min):**
- [ ] Review Weekly Dashboard
- [ ] Update all "Status" columns
- [ ] Plan next week's outreach (who to contact, how many applications)

---

## 📊 METRICS TO TRACK

### Vanity Metrics (Feel-Good Numbers)
- Total journalists pitched
- Total job applications sent
- Total media mentions

### Actionable Metrics (What Actually Matters)
- **Response Rate:** Replies / Total Pitches (goal: >10%)
- **Interview Rate:** Interviews / Applications (goal: >20%)
- **Offer Rate:** Offers / Interviews (goal: >25%)
- **Time to Offer:** Days from first application to offer (track average)
- **VC Pipeline Value:** Total $ from all deals in progress

### Weekly Review Questions
1. **What's working?** (Which pitch templates get replies? Which job sources produce interviews?)
2. **What's not working?** (Which companies ghost you? Which pitches get ignored?)
3. **Where should I double down?** (If HARO responses get media hits, do more HARO)
4. **Where should I cut?** (If cold applications never work, stop applying cold)

---

## ✅ FINAL CHECKLIST

**Before Starting Week 1 PR Campaign:**
- [ ] CRM set up (Google Sheets or Notion)
- [ ] All tabs/databases created
- [ ] First 10 journalist contacts added (from HARO strategy)
- [ ] First 10 VC contacts added (from VC outreach strategy)
- [ ] Conditional formatting or views configured
- [ ] Weekly Dashboard created
- [ ] Google Calendar integration (optional but recommended)
- [ ] Daily CRM habit committed (10 min/day to log contacts)

**You're Ready to Launch!**

---

**Document Status:** ✅ COMPLETE
**Phase 3 Deliverables:** 1 of 4 COMPLETE
**Next:** Acqui-Hire Strategy & Target List (Deliverable #11)

**Generated by:** Claude Code (Sonnet 4.5)
**Purpose:** Zero-cost CRM for tracking all job search and PR activities
**Estimated Setup Time:** 2-3 hours (one-time), 10 min/day (ongoing)
