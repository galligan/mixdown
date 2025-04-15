---
description: Use this rule when writing security audit reports
globs:
alwaysApply: false
---
# Creating Security Audit Reports

## Critical Rules

1. ✅ ALWAYS check for an existing security report before writing a new one
   - Look in the [.agent/notes/reviews directory](mdc:./.agent/notes/reviews) for a report with a similar name
   - If you find a report, use it as a starting point, but make sure it follows the template
2. ✅ ALWAYS follow the [Security Audit Report Template](mdc:./.agent/templates/template-security-report.md)
3. ✅ Store the report in the `./.agent/notes/reviews` directory
4. ✅ Use the format `YYYY-MM-DD-security-audit-{scope}-{scan_or_commit_ref}.md`. Example: `2025-04-02-security-audit-backend-api-trivy-scan.md` or `2025-04-02-security-audit-auth-module-commit-abc1234.md`
5. ✅ Use the defined severity levels (Critical, High, Medium, Low) appropriately based on potential impact and exploitability
6. ✅ Be specific. Provide clear explanations, evidence (code snippets), impact assessment, and actionable remediation steps for each finding
7. ✅ Ensure all relevant sections are filled out, even if just to state "No findings" for a particular severity level
