---
name: Template: Project Plans
type: template
description: Always use this format for projects
globs: **/projects/*.md
alwaysApply: false
---
# Template: Project Plans

<template>

# [date format="YYYY-MM-DD"] Project: [title format="Title Case"]

## Overview

- **Objective:** [Clear statement of what this plan aims to accomplish]
- **Scope:** [Boundaries and limitations of the plan]
- **Expected Outcome:** [What success looks like when implemented]

## Status

- **Current Status:** [Backlog/In Progress/Completed]
- **Last Updated:** [Date and time of last update]
- **Task Plan:** [Link to task plan]

## Prerequisites

- [Required tasks to complete by the user]
  - [In Phase [number]](#link-to-section-in-plan):
    - [User task title]: [User task description]
    - ...
  ...
- [Required components, tools, or dependencies]
- [Required access or permissions]
- [Required knowledge or skills]
- [References to other plans or documents]

## Background Research

[Summary of research findings relevant to this plan. Include sources, key considerations, and alternatives evaluated.]

### Key Findings

- **[Finding 1]:** [Details]
- **[Finding 2]:** [Details]
- **[Finding 3]:** [Details]

### Alternatives Considered

| Option | Pros | Cons | Decision |
|--------|------|------|----------|
| [Option 1] | [Pros] | [Cons] | [Selected/Rejected] |
| [Option 2] | [Pros] | [Cons] | [Selected/Rejected] |

## Implementation Plan

### Dependencies and Sequence

[Visual or textual representation of task dependencies and optimal sequence]

### Phase 1: [Initial Setup/Preparation]

1. [Step description]
   - **Complexity:** [Low/Medium/High]
   - **Dependencies:** [Any prerequisite steps or conditions]
   - [Details or sub-steps]
   - [Command examples]

   ```bash
   # Example command
   command --option value
   ```

2. [Step description]
   - **Complexity:** [Low/Medium/High]
   - **Dependencies:** [Any prerequisite steps or conditions]
   - [Details or sub-steps]

### Phase 2: [Core Implementation]

1. [Step description]
   - **Complexity:** [Low/Medium/High]
   - **Dependencies:** [Any prerequisite steps or conditions]
   - [Details or sub-steps]
   - [Potential challenges or edge cases]
2. [Step description]
   - **Complexity:** [Low/Medium/High]
   - **Dependencies:** [Any prerequisite steps or conditions]
   - [Details or sub-steps]

### Phase 3: [Verification and Testing]

1. [Step description]
   - **Success criteria:** [How to determine if this step succeeded]
   - [Details or sub-steps]
2. [Step description]
   - **Success criteria:** [How to determine if this step succeeded]
   - [Details or sub-steps]

## Technical Considerations

### Security Considerations

[Security-related considerations, best practices, and safeguards]

### Testing Considerations

[Testing-related considerations, best practices, and safeguards]

### Performance Considerations

[Performance-related considerations, resource requirements, limits]

### Deployment Considerations

[Deployment-related considerations, best practices, and process]

## Verification Process

[How to verify the implementation was successful]

1. [Verification step]
   - [Expected result]
2. [Verification step]
   - [Expected result]
3. ...

## Proposed Tasks

**Important:** Once you're ready, be sure to create a [task plan](./.cursor/rules/task-plans.mdc) for these tasks.

1. [Task 1 title]
   - **Description:** [Description]
   - **Complexity:** [Low/Medium/High]
   - **Dependencies:** [List any dependencies on other tasks]
   - **Potential challenges:** [Specific challenges or edge cases]
   - **Subtasks:**
     - [ ] [Subtask 1 title]
       - [Description]
       - **Complexity:** [Low/Medium/High]
       - **Dependencies:** [List any dependencies on other subtasks]
       - **Potential challenges:** [Specific challenges or edge cases]
     - ...
2. [Task 2 title]
   - **Description:** [Description]
   - **Complexity:** [Low/Medium/High]
   - **Dependencies:** [List any dependencies on other tasks]
   - **Potential challenges:** [Specific challenges or edge cases]
3. [Task 3 title]
   - **Description:** [Description]
   - **Complexity:** [Low/Medium/High]
   - **Dependencies:** [List any dependencies on other tasks]
   - **Potential challenges:** [Specific challenges or edge cases]
4. ...

## References

- [Reference 1]
- [Reference 2]
- [Reference 3]
- ...

## Appendix

[Additional information, code snippets, configuration examples, etc.]

</template>
