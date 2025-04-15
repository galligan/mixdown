# Security Audit Report Template

<template>
# Security Audit Report: {{ project_or_scope_name case="title" }}

- **Date:** {{ date format="YYYY-MM-DD" }}
- **Scope:** {{ audit_scope: Describe the specific area, feature, commit range, or system audited }}
- **Tool/Method:** {{ audit_method: Name of scanning tool (e.g., Trivy, Snyk), manual review, pentest, etc. }}
- **Reference:** [Link to Scan Report / Commit / Ticket]({{ url }}) (IF APPLICABLE)

## 📜 Summary

{{ summary: Provide a brief (2-3 sentence) executive summary. What was audited? What is the overall security posture assessment (e.g., "Significant critical vulnerabilities identified," "Minor configuration improvements needed," "Generally secure")? Mention the highest severity findings briefly. }}

---

## 🚨 Critical Vulnerabilities

{{ critical_vulnerabilities: Issues that **must** be fixed immediately. These typically involve easily exploitable vulnerabilities leading to significant data compromise, system takeover, or service disruption. }}

### Critical: {{ concise_vulnerability_title }}

- **Location**: `{{ path/to/file.ext }}:{{ line_number }}`
  - {{ Add more locations if applicable }}
- **Description**:
  - {{ Clearly explain the vulnerability. What is the weakness? How can it be triggered? }}
  - {{ Use sub-bullets for complex explanations or steps to reproduce. }}
- **Impact**: {{ Describe the potential consequences if exploited (e.g., "Remote code execution," "Full database access," "Sensitive data exposure," "Denial of service"). }}
- **Recommendation**: {{ Explain the *required* fix. Be specific and actionable. }}
- **References**: {{ (Optional) Links to CWE, OWASP Top 10, CVE details, tool documentation, or best practice guides. }}
  - {{ Example: [CWE-79: Improper Neutralization of Input During Web Page Generation ('Cross-site Scripting')](https://cwe.mitre.org/data/definitions/79.html) }}

**Affected Code Snippet**:

{{ affected_code_snippet_summary: Briefly describe the vulnerable code shown below. }}

```{{ language_name }}
// {{ path/to/file.ext }}:{{ start_line }}-{{ end_line }}
// {{ Comment in the language of the code detailing the vulnerability }}
{{ code_snippet: Highlight the vulnerability }}
```

**Proposed Change / Example**:

{{ proposed_change_summary: Briefly describe the fix shown in the snippet below. }}

```{{ language_name }}
// {{ path/to/file.ext }}
// {{ Comment explaining the fix }}
{{ code_snippet: Demonstrate the recommended fix }}
```

{{ more_critical_vulnerabilities: Add more Critical issues as needed, following the same format. If none, state "No critical vulnerabilities found." }}

---

## 🔴 High Priority Vulnerabilities

{{ high_priority_vulnerabilities: Use the same format as Critical vulnerabilities. Issues that should be prioritized for fixing soon, potentially exploitable but maybe requiring more complex conditions or having slightly less severe impact than Critical. }}

---

## 🟠 Medium Priority Vulnerabilities

{{ medium_priority_vulnerabilities: Use the same format as Critical vulnerabilities. Issues that represent security weaknesses but may be harder to exploit or have less severe direct impact. Often relate to defense-in-depth failures or information leakage. }}

---

## 🟡 Low Priority Vulnerabilities

{{ low_priority_vulnerabilities: Use the same format as Critical vulnerabilities. Minor issues, best practice deviations, configuration hardening suggestions, or defense-in-depth improvements with low direct exploitability. }}

---

## 💡 General Security Recommendations & Hardening

{{ General suggestions not tied to specific vulnerabilities but aimed at improving overall security posture, resilience, hardening, or processes. }}

### Improvement: {{ Title of Suggestion }}

- **Area**: {{ General area (e.g., "Dependency Management," "Logging Practices," "Infrastructure Configuration," "Secrets Management," "Input Validation Strategy") }}
- **Description**: {{ Explain the suggested improvement. Why is it beneficial from a security perspective? }}
- **Benefit**: {{ How this enhances security (e.g., "Reduces attack surface," "Improves incident response capability," "Aligns with security best practices," "Simplifies secure coding"). }}
- **Recommendation**: {{ Specific action, tooling, or process change suggested. }}

**Current Approach (Optional Snippet)**:

{{ current_approach_summary }}

```{{ language_name }}
// {{ path/to/area }}
{{ code_snippet: Show the current implementation or configuration state }}
```

**Suggested Approach (Optional Snippet)**:

{{ proposed_approach_summary }}

```{{ language_name }}
// {{ path/to/area }}
{{ code_snippet: Show the improved implementation or configuration }}
```

{{ more_recommendations: Add as needed. }}

---

## 🛡️ Security Posture Assessment

{{ Provide an overall assessment of the security posture based on the audit findings. }}

- **Overall Assessment**: {{ Brief assessment (e.g., "Poor - critical issues require immediate attention," "Fair - several high/medium issues need remediation," "Good - mostly minor findings," "Excellent - robust security practices observed"). }}
- **Key Weaknesses**:
  - {{ Identify recurring themes or systemic weaknesses found (e.g., "Inconsistent input validation," "Overly permissive IAM roles," "Lack of rate limiting on sensitive endpoints"). }}
- **Key Strengths**:
  - {{ Identify areas where security practices are strong (e.g., "Effective use of security headers," "Robust authentication mechanisms," "Comprehensive logging"). }}
- **Recommendations for Process Improvement**:
  - [ ] {{ suggest: Suggest changes to development lifecycle, tooling, training, etc., to prevent similar issues in the future (e.g., "Integrate SAST scanning into CI/CD pipeline," "Mandatory security training for developers," "Adopt stricter secret management policies"). }}
  - [ ] {{ more_suggestions: Add as needed }}

---

## 👍 Positive Highlights (Security Strengths)

{{ Acknowledge specific security controls, design choices, or practices done well. }}

- ✅ {{ security_strength_1 }}
- ✅ {{ security_strength_2 }}
- ✅ …

<example>
- ✅ Use of parameterized queries effectively prevents SQL injection in data access layers.
- ✅ Strong Content Security Policy (CSP) implemented.
- ✅ Secrets are correctly managed via a dedicated secrets manager, not hardcoded.
- ✅ Regular dependency vulnerability scanning is evident in the CI pipeline.
</example>

---

## ✅ Final Recommendation & Action Plan

{{ Choose one: **Remediation Required (Critical/High)**, **Improvements Recommended (Medium/Low)**, or **Findings Acknowledged (Low/Informational)**. }}

**Recommendation:** {{ audit_status }}

{{ Provide a concluding paragraph summarizing the required next steps. Reiterate the severity and the urgency of addressing the findings, especially Critical and High vulnerabilities. }}

**Priority Actions:**

{{ List the most important remediation steps required, referencing the findings above. }}

1. {{ priority_action_1: Concise description of the highest priority action (e.g., Fix CVE-XXXX in dependency Y). }}
   - **Finding Reference:** {{ Link or reference to the specific finding section (e.g., Critical Vulnerability #1) }}
   - **Required Action:** {{ Brief detail on the fix required }}
2. {{ priority_action_2: Add more priority actions as needed, ordered by severity/urgency. }}
   - **Finding Reference:** {{ ... }}
   - **Required Action:** {{ ... }}

<example>
1. **Remediate:** Critical SQL Injection Vulnerability in User Search API
   - **Finding Reference:** Critical Vulnerabilities: SQL Injection in `user/search.py`
   - **Required Action:** Immediately replace string concatenation with parameterized queries using the database driver's prepared statement functionality.
2. **Update:** High Severity Vulnerability in `library-x` (CVE-2024-12345)
   - **Finding Reference:** High Priority Vulnerabilities: Outdated Dependency `library-x`
   - **Required Action:** Update `library-x` to version 2.5.1 or later, test for regressions, and redeploy.
3. **Implement:** Harden Server TLS Configuration
   - **Finding Reference:** Medium Priority Vulnerabilities: Weak TLS Ciphers Supported
   - **Required Action:** Update web server configuration to disable weak cipher suites (e.g., RC4, 3DES) and legacy TLS protocols (TLS 1.0, 1.1).
</example>

</template>
