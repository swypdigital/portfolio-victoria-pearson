# Conversation Transcript Export Prompt
## Reusable Prompt Template for Extracting Full Claude Conversation History

---

**Document ID:** CONVERSATION-TRANSCRIPT-EXPORT-PROMPT-V1-0-0  
**Artifact ID:** conversation-transcript-export-prompt-v1-0-0  
**Version:** 1.0.0  
**Release Date:** December 24, 2025  
**Last Updated:** December 24, 2025 at 04:15 PST (Los Angeles)  
**Author:** groklyGroup LLC™  
**Document Owner:** Victoria H. Pearson, groklyGroup LLC™  
**Classification:** Utility Prompt Template  
**Status:** Production Ready  
**Compliance:** GroklyGroup LLC™ Universal Documentation Standard v2.0.0  

---

**Copyright:** © 2025 groklyGroup LLC™. All rights reserved.  
*All patents, copyrights, and trademarks reserved for groklyGroup LLC™*

---

## Table of Contents

- [Purpose](#purpose)
- [The Prompt](#the-prompt)
- [Critical Instruction](#critical-instruction)
- [Expected Output Format](#expected-output-format)
- [Variations](#variations)
- [Use Cases](#use-cases)
- [Technical Notes](#technical-notes)
- [Version History](#version-history)

---

## Purpose

This prompt extracts a complete, faithful conversation transcript from any Claude session or project, formatted for readability, archival, and future reference. The output is delivered as a **downloadable markdown (.md) artifact**.

---

## The Prompt

Copy and paste the following prompt into any Claude session:

---

```
ACCESS AND EXPORT CONVERSATION TRANSCRIPT

1. ACCESS the full conversation transcript from this session with ABSOLUTE FIDELITY
   - Include every message without omission or summarization
   - Preserve the exact content of both user and Claude messages
   - If this is within a Project, access the project's conversation history

2. ORGANIZE the conversation in CHRONOLOGICAL ORDER
   - Earliest message first, latest message last
   - Maintain the natural flow of the dialogue

3. FORMAT with VISUAL SEPARATION between speakers:
   - User messages: Header "## 🧑 USER" followed by the message content
   - Claude responses: Header "## 🤖 CLAUDE" followed by the response content
   - Separate each exchange with a horizontal rule (---)
   - Include timestamps if available
   - Preserve any code blocks, lists, or formatting from the original

4. SAVE AS DOWNLOADABLE ARTIFACT:
   - File format: Markdown (.md)
   - Filename: "conversation-transcript-[SESSION-DATE-OR-PROJECT-NAME].md"
   - Use the create_file tool to save to /mnt/user-data/outputs/
   - Then use present_files to make it downloadable

5. DELIVER the downloadable markdown file to me

Do not summarize. Do not paraphrase. Do not omit any portion of the conversation.
I need the complete, verbatim record as a downloadable .md artifact.
```

---

## Critical Instruction

**Claude MUST save the output as a downloadable artifact:**

```
create_file → /mnt/user-data/outputs/conversation-transcript-[name].md
present_files → delivers downloadable link to user
```

Without these steps, the transcript will only appear in chat and cannot be downloaded.

---

## Expected Output Format

The exported transcript will look like this:

```markdown
# Conversation Transcript
**Session:** [Project Name or Date]
**Exported:** [Export Date]
**Total Exchanges:** [Count]

---

## 🧑 USER
[First user message - verbatim]

---

## 🤖 CLAUDE
[First Claude response - verbatim]

---

## 🧑 USER
[Second user message - verbatim]

---

## 🤖 CLAUDE
[Second Claude response - verbatim]

---

[...continues for entire conversation...]

---

**END OF TRANSCRIPT**
```

---

## Variations

### For a Specific Project

```
Access the full conversation transcript from Project "[PROJECT NAME]" with absolute fidelity.
[...steps 2-3 same as above...]
SAVE AS DOWNLOADABLE ARTIFACT to /mnt/user-data/outputs/transcript-[PROJECT-NAME].md
Use present_files to deliver the downloadable markdown file.
```

### For a Date Range

```
Access conversation transcripts from [START DATE] to [END DATE] with absolute fidelity.
[...steps 2-3 same as above...]
SAVE AS DOWNLOADABLE ARTIFACT to /mnt/user-data/outputs/transcript-[DATE-RANGE].md
Use present_files to deliver the downloadable markdown file.
```

### For Searching Specific Content

```
Access the full conversation transcript from this session, then highlight or flag 
all exchanges that mention "[KEYWORD OR TOPIC]".
[...steps 2-3 same as above...]
SAVE AS DOWNLOADABLE ARTIFACT to /mnt/user-data/outputs/transcript-[TOPIC]-flagged.md
Use present_files to deliver the downloadable markdown file.
```

### For Multiple Sessions

```
Access conversation transcripts from my last [N] sessions about "[TOPIC]", 
combine them chronologically into a single unified transcript.
[...steps 2-3 same as above...]
SAVE AS DOWNLOADABLE ARTIFACT to /mnt/user-data/outputs/transcript-[TOPIC]-combined.md
Use present_files to deliver the downloadable markdown file.
```

---

## Use Cases

| Scenario | Why Export |
|----------|------------|
| **Project Documentation** | Preserve complete decision history |
| **Knowledge Capture** | Archive insights and solutions discovered |
| **Handoff to Team** | Share context with collaborators |
| **Audit Trail** | Maintain record for compliance |
| **Learning Reference** | Review techniques and approaches used |
| **Backup** | Protect against data loss |
| **Analysis** | Study patterns in your Claude interactions |

---

## Technical Notes

- Claude accesses transcripts from `/mnt/transcripts/` directory
- Transcripts are read-only and cannot be modified
- File format: Markdown (.md) for maximum portability
- Large conversations may be split into multiple files if needed

---

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.0.0 | December 24, 2025 | Initial release with explicit downloadable artifact instructions |

---

## Copyright and Contact Information

**Copyright © 2025 groklyGroup LLC™. All Rights Reserved.**

*All patents, copyrights, and trademarks reserved for groklyGroup LLC™*

---

**END OF DOCUMENT**

---

*Conversation Transcript Export Prompt v1.0.0*  
*groklyGroup LLC™ Universal Documentation Standard v2.0.0 Compliant*  
*© 2025 groklyGroup LLC™. All rights reserved.*
