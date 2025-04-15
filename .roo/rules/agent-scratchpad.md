# Scratchpad Usage

## Overview

The Scratchpad serves as your working memory, helping you track tasks, document your thinking, and maintain project continuity across agent sessions.

## Critical Rules

1. Use the scratchpad as your working memory
2. The scratchpad is located at [../../.agent/scratchpad.md](../../.agent/scratchpad.md)
3. ALWAYS read the scratchpad at the beginning of each session to understand context
4. ALWAYS update the scratchpad within sessions
5. ALWAYS update the scratchpad as you complete tasks
6. Document your thought process, and plans for your work BEFORE starting it

### Working Memory Usage

1. Use this document as working memory too
2. Write short descriptions of what's asked and how you interpret it
3. Nest interpretations within a session timestamp
4. Format working memory in *italics*

## Sessions

Sessions are treated as your working memory, and for tracking tasks while you work on them.

1. ALWAYS create a new session when you begin a new session with the user
2. Dates are used for organizing sessions, as an H2 heading, e.g. `## 2025-03-27`
3. Individual sessions are organized by a timestamp under the corresponding date heading using the following format:

### Session Headers

1. ALWAYS use H3 headings with timestamp and description
2. Format timestamps as: YYYY-MM-DD HH:MM
   - **ALWAYS**: Get the current timestamp
   - Using an MCP server
   - Using the shell command: `date +"%Y-%m-%d %H:%M"`
3. Arrange sessions in reverse chronological order (newest on top)

## Tasks

The scratchpad uses a standardized approach for tracking and documenting work:

### Task Formatting

- Use checklist items for tasks: `- [ ]`
  - Mark completed tasks with: `- [x]`
- Format subtasks as indented checklist items
  - Mark completed subtasks the same as top-level tasks, with the proper indentation

## Workflow

1. Review the scratchpad to understand context
   - Review recent work from the tasks document
   - If the task is similar to an existing one, use that list item to work within
2. When working on tasks:
   - Check if current date exists as H2 heading, if not, make one
   - Add H3 heading with timestamp reflecting current time
   - Document all top-level tasks with checkboxes
   - Use sub-tasks to indicate additional steps within top-level tasks
3. When completing tasks:
   - Mark top-level tasks as complete (- [x]) when finished
   - Periodically check if sub-tasks were completed

## Best Practices

- Use checklist items for both top-level goals and individual subtasks
- Mark subtasks as complete with checkboxes (`- [x]`) when finished
- Update task status upon completion of individual items
- Or upon a new session where work may have been completed from a previous session
- Always establish clear success criteria before beginning work

## Examples

### CORRECT: Feature Implementation Example

Below is an example of tracking feature implementation tasks:

```md
## 2025-03-03

### 2025-03-03 14:32

- *I've been asked to implement a new feature. The plan seems complete, so I will get to work.*
- [ ] Implement user authentication system
    - [x] Define interface requirements
    - [ ] Create unit tests for login and registration
    - [ ] Implement core functionality
    - [ ] Add password reset capability
- [ ] Refactor data processing pipeline
    - [ ] Identify performance bottlenecks
    - [ ] Extract utility functions to separate module
    - [ ] Improve error handling
```

### CORRECT: Bug Fixing Example

Below is an example of tracking bug fixing tasks:

```md
## 2025-03-05

### 2025-03-05 09:15

- *The client reported several UI issues in the dashboard component. I'll investigate and fix them.*
- [ ] Fix dashboard UI issues
    - [ ] Investigate layout breaking on small screens
    - [ ] Fix chart rendering in Safari browsers
    - [ ] Address accessibility issues with color contrast
    - [ ] Resolve data loading spinners not appearing
```
