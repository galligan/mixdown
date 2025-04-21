# Tasks

## Task Management

- ✅ Use the [task management rules](./.cursor/rules/task-management.mdc) to track your tasks
- ✅ Use `$ date +"%Y-%m-%dT%H:%M:%S%z"` to get the current timestamp
- ✅ Maintain the `tasks.md` file in `./.agent/` ensuring it's up to date with the latest state of your tasks
- ✅ Create task plans for complex tasks:
  - Create a task plan `./.agent/plans/task-plan-description.md` file
  - Add a checklist item in the relevant section, linking to the plan file
  - Once a plan is completed, move the plan file to `./.agent/plans/completed`
  - Rename the plan file to `[completion-timestamp format="YYYY-MM-DD"]-[task-plan-description].md`
  - Update the plan link in the Completed section

## Example Task Listpro

```md
## In Progress

- [ ] [Task 1 Description] ([ref](path/to/related-file.md))
  - [ ] [Subtask 1 Description]
  - [x] [Subtask 2 Description] (completed 2025-04-18T12:00:00-04:00)

## Future

- [ ] [Task 4 Description] ([ref-1](path/to/related-file.md), [ref-2](path/to/related-file-2.md))
- [ ] Project: [Project Description](tasks/project-description-tasks.md)

## Completed

- [x] [Task Description] (completed 2025-04-18T12:00:00-04:00)
  - Notes: [Notes providing additional context about the task once completed]
- [x] Project: [Project Description](tasks/completed/project-description-tasks.md) (completed 2025-04-18T12:00:00-04:00)
```

## 🟡 In Progress Tasks

- [ ] [Project: Mixdown MVP Task Plan](./.agent/plans/mixdown-mvp-tasks.md)

## 🔵 Future Tasks

- ...

## 🟢 Completed Tasks

- [x] Project: Mixdown MVP Task Plan ([ref](./.agent/plans/mixdown-mvp-tasks.md))
- [x] Clean up package.json dependencies ([ref](./.agent/plans/completed/2025-04-18-package-json-cleanup-plan.md)) (completed 2025-04-18T10:03:40-0400)
  - [x] Create backups of package.json and pnpm-lock.yaml files (completed 2025-04-18T10:03:01-0400)
  - [x] Create simplified package.json with essential dependencies (completed 2025-04-18T10:03:22-0400)
  - [x] Delete pnpm-lock.yaml and reinstall dependencies (completed 2025-04-18T10:03:40-0400)
  - Notes: Successfully cleaned up package.json by removing unnecessary dependencies while keeping core functionality. Created backups of the original files for reference.
