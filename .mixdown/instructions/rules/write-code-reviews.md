---
description: Use this rule when creating or updating code review reports
globs:
alwaysApply: false
---

# Creating Code Review Reports

## Critical Rules

1. ✅ ALWAYS follow the [Code Review Report Template](mdc:./.agent/templates/template-code-review.md) for consistency
2. ✅ ALWAYS store the report in the [.agent/notes/reviews directory](mdc:./.agent/notes/reviews)
   - Or if you're working on a specific project, use the project's directory e.g. `.agent/notes/projects/{{ project_name }}`
3. ✅ ALWAYS use the format `YYYY-MM-DD-code-review-{feature-or-component}-{PR#}.md`
   - Example: `2025-04-02-code-review-user-auth-123.md`.
4. ✅ ALWAYS use the defined severity levels (Critical, High, Medium, Low) appropriately with a focus on impact and urgency
5. ✅ ALWAYS be specific, provide actionable feedback, and include code snippets and clear explanations.
6. ✅ ALWAYS highlight both areas for improvement and positive aspects of the code.
