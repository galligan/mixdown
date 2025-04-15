---
description: 
globs: .agent/tasks.md
alwaysApply: false
---
# Agent Tasks

## Critical Rules

1. The project & tasks tracking doc is at [tasks.md](mdc:.agent/tasks.md)
2. Always try to keep tasks up to date
   - Use the [scratchpad.md](mdc:.agent/scratchpad.md) when you're actively working on something
   - As you complete major portions of your work, or subtasks in the tasks document, mark them as complete with `- [x]`
3. Be sure to follow the [version control rules](mdc:.cursor/rules/agent-version-control.mdc)

## Examples

### Basic tasks

Incomplete task

```md
- [ ] Task name
```

Complete subtask with incomplete parent

```md
- [ ] Task name
  - [x] Subtask name
```

### Tasks with a sequence

Incomplete task in sequence with subtasks

```md
1. [ ] Task name
   - [ ] Subtask name
   - [ ] Subtask name
```

## Format

```md
## [Project name]

### Phase [number]: [title]

#### Chunk [number]: [title]

1. [ ] [Task short name]
   - [ ] [Subtask short name]
   - [ ] [Other subtask]
2. [ ] [2nd task short name]
…