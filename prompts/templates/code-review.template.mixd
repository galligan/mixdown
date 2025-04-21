# Code Review Report Template

<template>
# Code Review Report: {{ project_or_feature_name case="title" }}

- **Date:** {{ date format="YYYY-MM-DD" }}
- **Pull Request / Commit:** [Link to PR/Commit]({{ url }}) (IF APPLICABLE)

## 📜 Summary

{{ summary: Provide a brief (2-3 sentence) executive summary. What was reviewed? What is the overall assessment (e.g., "Approved with minor changes," "Requires major revisions," "Looks good")? Mention the most critical findings briefly. }}

---

## 🚨 Critical Issues

{{ critical_issues: Issues that **must** be fixed before merging. These typically involve bugs, security vulnerabilities, potential data loss, or significant architectural flaws. }}

### Critical: {{ Concise Issue Title }}

- **Location**: `{{ path/to/file.ext }}:{{ line_number }}`
- **Description**:
  - {{ Clearly explain the problem. What is wrong? Why is it wrong? }}
  - {{ Use sub-bullets for complex explanations if needed. }}
- **Impact**: {{ Describe the potential consequences (e.g., "Causes application crash under condition X," "Exposes sensitive data," "Prevents feature Y from working"). }}
- **Recommendation**: {{ Explain the *required* fix. Be specific. }}
- **References**: {{ (Optional) Links to relevant documentation, style guides, or best practices. }}

**Affected Code Snippet**:

{{ affected_code_snippet_summary }}

```{{ language_name }}
// {{ path/to/file.ext }}:{{ start_line }}-{{ end_line }}
{{ code_snippet: Highlight the issue, comment in the language of the code detailing the offending code }}
```

**Proposed Change / Example**:

{{ proposed_change_summary }}

```{{ language_name }}
// {{ path/to/file.ext }}
{{ code_snippet: Demonstrate the recommended fix }}
```

{{ more_critical_issues: Add more Critical issues as needed, following the same format. If none, state "No critical issues found." }}

---

## 🔴 High Priority Issues

{{ high_priority_issues: Use the same format as Critical issues. }}

---

## 🟠 Medium Priority Issues

{{ medium_priority_issues: Use the same format as Critical issues. }}

---

## 🟡 Low Priority Issues

{{ low_priority_issues: Use the same format as Critical issues. }}

---

## 💡 Suggestions & Code Quality Improvements

{{ General suggestions not tied to specific bugs but aimed at improving overall code health, readability, maintainability, or elegance. }}

### Improvement: {{ Title of Suggestion }}

- **Location**: `{{ path/to/file.ext }}:{{ line_number }}` (or general area)
- **Description**: {{ Explain the suggested improvement. Why is it better? }}
- **Benefit**: {{ How this enhances the codebase (e.g., "Improves readability," "Reduces complexity," "Enhances reusability"). }}

**Current Approach (Optional Snippet)**:

{{ current_approach_summary }}

```{{ language_name }}
// {{ path/to/file.ext }}
{{ code_snippet: Show the current implementation }}
```

**Suggested Approach (Optional Snippet)**:

{{ proposed_approach_summary }}

```{{ language_name }}
// {{ path/to/file.ext }}
{{ code_snippet: Show the improved implementation }}
```

{{ more_suggestions: Add as needed. }}

---

## 🛡️ Security Considerations

{{ Specific review points related to security. }}

- **Input Validation**: {{ input_validation: Assessment of how user/external inputs are validated and sanitized. Any concerns? }}
- **Authentication/Authorization**: {{ auth_assessment: Assessment of auth checks. Are permissions correctly enforced? }}
- **Data Handling**: {{ data_handling: Assessment of sensitive data handling (storage, transmission, logging). }}
- **Dependencies**: {{ dependency_vulnerabilities: Any known vulnerabilities in dependencies? }}
- **Other Concerns**: {{ security_observations: Any other security-related observations. }}

---

## 📊 Performance Considerations

{{ Specific review points related to performance. }}

1. **Observation**: {{ Description of potential performance concern (e.g., "Inefficient database query," "Potential N+1 problem," "Large asset loading"). }}
   - **Location**: `{{ path/to/file.ext }}:{{ line_number }}`
   - **Potential Impact**: {{ Quantify if possible (e.g., "May increase API response time under load," "Could lead to high memory usage"). }}
   - **Recommendation**: {{ Specific advice (e.g., "Add index to database table X," "Use eager loading," "Optimize image assets"). }}
2. {{ more_performance_points: (As needed) }}

---

## 🧪 Test Coverage Assessment

- **Overall Assessment**: {{ Brief assessment of test coverage adequacy for the changes (e.g., "Good," "Adequate but missing edge cases," "Insufficient"). }}
- **Missing Tests**:
  - {{ Identify specific components, functions, or scenarios lacking tests. }}
  - {{ Example: "Error handling paths in `UserService.createUser` are not tested." }}
- **Recommendations**:
  - [ ] {{ suggest: Suggest specific test cases and/or improvements to add (e.g., "Add test for invalid input to `calculate_discount`"). }}
  - [ ] {{ more_suggestions: Add as needed }}

---

## 📝 Documentation Needs

- [ ] {{ documentation_need_1 }}
- [ ] {{ documentation_need_2 }}
- [ ] ...

<example>
- [ ] Update README.md
- [ ] Add/update inline code comments for complex logic
- [ ] Update developer documentation
- [ ] Add/update user-facing documentation
- [ ] Update API documentation
</example>
---

## 🚀 Architecture and Design Feedback

{{ high_level_feedback: High-level feedback on the design choices and structure. }}

- **Overall Design**: {{ Comments on the chosen approach, patterns used, and alignment with existing architecture. }}
- **Modularity/Component Structure**: {{ Assessment of how well the code is organized into reusable and maintainable components. }}
- **Adherence to Principles**: {{ Comments on adherence to SOLID, DRY, etc., where applicable. }}
- **Dependency Management**: {{ Review of new dependencies added or existing ones used. }}

---

## 👍 Positive Highlights

{{ positive_highlights: Acknowledge good work! Be specific. }}

- ✅ {{ positive_highlight_1 }}
- ✅ {{ positive_highlight_2 }}
- ✅ …

<example>
- ✅ Excellent use of the Strategy pattern in the `PaymentProcessor`.
- ✅ The error handling logic is comprehensive and clear.
- ✅ Code is well-commented and follows the style guide consistently.
- ✅ Performance optimization in the data fetching logic is appreciated.
</example>

---

## ✅ Final Recommendation

{{ Choose one: **Approve**, **Approve with comments** (for minor, non-blocking changes), or **Request changes**. }}

**Recommendation:** {{ approval_status }}

{{ Provide a concluding paragraph summarizing the required next steps before the code can be merged. Reiterate the most important issues (Critical/High) that need addressing. }}

**Priority Actions:**

1. {{ priority_action_1 }}
   - {{ priority_action_1_detail }}
2. {{ priority_action_2: Add this and more as needed }}

<example>
1. **Fix:** Fix the SQL injection vulnerability in the user search function
   - Replace the vulnerable string concatenation with parameterized queries using prepared statements to prevent SQL injection attacks
2. **Consider:** Refactor the authentication middleware to improve separation of concerns
3. **Address:** Add unit tests for the order processing workflow, especially for edge cases
</example>

</template>
