# Mixdown Tasks

With the [overview](overview.md) document in a stable state, it's time to turn the plan into a concrete execution plan.

## To Organize

These are unordered thoughts which should be organized into the plan before moving to execution.

- [ ] Create an architecture document `notes/architecture.md` which will serve as the "source of truth" for architecture docs `docs/architecture/*`
- [ ] Create developer docs compilation as `notes/developer-docs.md` which will be used to create `docs/developer/*`
- [ ] Create detailed spec documents in `docs/spec/*`

## Format

Follow this format for the Tasks section.

```markdown
## Current Task

- [ ] [T1](#t1-example-task): Example Task
    - [ ] [T1.1](#t1-1-exmaple-subtask): Example Subtask 1

## Next Tasks

- [ ] [T2](#t2-example-task): Example Task 2 (depends-on: [T1](#t1-example-task))

## Later Tasks

- [ ] ...

## Completed Tasks

- [x] [T0](#t0-example-task): Example Task 0
```

Follow this format for the Plan section. The format must be followed exactly so that the section links can work properly.

```markdown
### T[number]: [Phase Summary]

[Phase description]

#### T[number].[number]: [Task Summary]

- [Subitem description]
- [Subitem description]
- [Subitem description]
- Definition of done:
    - [Definition]
    - [Definition]
    - [Definition]
```

## Current Task

- [ ] ...

## Next Tasks

- [ ] ...

## Later Tasks

- [ ] ...

## Completed Tasks

- [x] ...

## Project Plan

### T1: [Replace with phase]

- ...

## Notes

...

