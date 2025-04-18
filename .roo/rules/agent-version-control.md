---
description: Use this rule when making changes to the codebase.
globs:
alwaysApply: false
---
# Agent Version Control

You are an agent responsible for ensuring code changes are committed with consistent patterns, and in the appropriate branch.

## Critical Rules

1. ✅ Always check if the current branch is synchronized with main using the [Branch Check](#step-1-review-changes) e.g. `git sd-branch`
   - ❌ Never commit directly to `main` or `master`
2. ✅ Always check `.gitignore` before adding files to see if the repository has any files that should not be committed
3. ✅ Always identify logical chunks of changes and create conventional commits one-at-a-time for this codebase.
   - Prefer smaller, focused commits over larger, more complex ones.
4. ✅ If on the `dev` branch, create a feature branch for the current task using the [branching conventions](#branching-conventions)
5. ✅ Follow the [commit workflow](#commit-workflow) to commit changes
   - Always run through the [pre-commit checklist](#step-3-pre-commit-checklist) before committing
   - Always write conventional commit messages in the [preferred format](#commit-message-format)
   - Ask the user for the task description if you don't have a clear idea of what it was
6. ✅ Verify your changes with `git sd-status`
7. ✅ After all of your work is complete, push your changes with `git sd-push`
8. 🚧 If you run into issues, check the [troubleshooting](#troubleshooting) section
   - If you cannot resolve an issue autonomously, you should ask the user for help
   - Never perform a `force` action or `rebase` without the user's permission

## Branching Conventions

- Create new branches with `git sd-branch <branch-name>`
- Most of the time you should use prefix-based naming for branches e.g. `prefix/`:
  - Prefixes: `feat`, `fix`, `docs`, `build`, `chore`, `ci`, `style`, `refactor`, `perf`, `test`
- For version-specfic work, you should mention the version and prefix e.g. `[version]/[prefix]`
  - `v1.2.3/feat/add-storybook-support`
- For sub-branches, you should use the existing branch name, followed by a `/` and then a short description e.g. `feat/{{ feat_name }}/short-description`

### Commits

- Always create a commit for each logical chunk of changes
- Use the [commit message format](#commit-message-format) for commit messages
- Use the [commit message conventions](#commit-message-conventions) for commit messages
- Use the [commit message types](#commit-message-types) for commit messages
- Use the [commit message scopes](#commit-message-scopes) for commit messages
- Follow the [commit workflow](#commit-workflow) to commit and push your changes

### Commit Message Format

Use the following format for commit messages:

```txt
git sdc "type(scope): brief description as subject line"
```

### Commit Message Conventions

1. ✅ Use imperative mood in the subject line
   - e.g. ✅ `Add...` not ❌ `Added...`
2. ✅ Keep the subject line under 70 characters
3. ✅ Don't use a `.` period at the end of the subject line
4. ✅ Be specific and concise
5. ✨ Optional: Use a multi-line commit message by including a description file
   - e.g. `git sdc "type(scope): subject line" <commit-description-file>`

### Commit Message Types

- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation
- `style`: Formatting
- `refactor`: Code restructuring
- `test`: Test changes
- `chore`: Maintenance
- `perf`: Performance improvement
- `build`: Build system changes
- `ci`: CI configuration
- `revert`: Reverts a previous commit
- `hotfix`: Hotfix for a production issue
- `release`: Release notes

### Commit Message Scopes

- `api`: API changes
- `ui`: UI changes
- `db`: Database
- `auth`: Authentication
- `rules`: Cursor rules
- `docs`: Documentation
- `test`: Testing
- `core`: Core functionality
- `config`: Configuration files
- `deps`: Dependency updates
- `security`: Security-related changes
- `i18n`: Internationalization/localization
- `a11y`: Accessibility improvements
- `infra`: Infrastructure changes
- `analytics`: Analytics and monitoring
- `ux`: User experience improvements
- `models`: Data models or ML models
- `utils`: Utility functions
- `middleware`: Middleware components
- `storage`: Storage or caching mechanisms

### Examples Commit Messages

```bash
# ✅ Good examples:
git sdc "feat(auth): add login flow"
git sdc "fix(api): resolve timeout issue"
git sdc "docs: update installation instructions"

# ❌ Bad examples:
git sdc "changes to the auth module" # No type or scope
git sdc "fixed the timeout issue which was causing the application to crash after 30 seconds of inactivity" # Too long
```

## Commit Workflow

Follow the following workflow when committing changes and pushing to the remote repository:

### Step 1: Review Changes

1. Use `git sd-branch` to check the current branch's relationship to main and dev
   - If you're on a `dev` or `main` branch, you can use `git sd-branch <branch-name>` to create a new feature branch
   - Follow the guidance provided in the output if you're seeing issues
1. Check the repository's status with "super duper status": `git sd-status`

### Step 2: Analyze and Plan

1. Create a plan of your commits. Think about the sequence that would make most sense.
2. For each potential commit, you should identify:
   - The individual files that should be included in the commit
   - The commit [type](#commit-message-types) and [scope](#commit-message-scopes)
   - A clear and concise description of the changes
3. Explain this plan to the user, but you should not require confirmation unless there are destructive changes.
4. Proceed with the next steps:
   - [Complete the Pre-Commit Checklist](#step-3-pre-commit-checklist)
   - [Commit and Stage the Files](#step-4-write-a-properly-formatted-commit-message-and-stage-the-files)
   - [Push Changes](#step-5-push-changes-recap-and-verify)

### Step 3: Pre-Commit Checklist

1. Ensure code quality
   - Run linters
   - Check formatting
   - Remove extraneous debug code
   - Run appropriate tests
2. Preserve security
   - Check for any hardcoded secrets or API keys
   - Check for any sensitive information in the changes
   - Check file permissions

### Step 4: Write a properly-formatted commit message and stage the files

1. Always use the commit message [conventions](#commit-message-conventions)
   - Using the correct [type](#commit-message-types) and [scope](#commit-message-scopes)
   - Write the commit message:
     - For single-line commit messages: `git sdc "<commit-message>"`
     - For multi-line commit messages: `git sdc "<commit-message>" <commit-description-file>`
2. Review the changes
   - Check the repository's status with: `git sd-status`
   - Verify the file inclusions
3. Stage ONLY the files relevant to the specific commit with the `git sda` alias. This will also show the repository status and staged changes after staging the files.

   ```bash
   git sda <file-1> <file-2> <file-3> ...
   ```

#### Commit Examples

**✅ CORRECT PATTERNS:**

```bash
# Single quotes
git cm 'feat(auth): add login flow'

# Double quotes
git cm "fix(api): resolve timeout issue"

# File-based for multi-line
git cm "feat(ui): add responsive layout" <commit-description-file>

# COMMIT_DESC.tmp (for multi-line)
- Add mobile breakpoints
- Implement flex containers
- Update media queries"
# / COMMIT_DESC.tmp
```

**❌ INCORRECT PATTERNS:**

```bash
# DON'T use newlines without creating a temp file first
git cm "feat(ui): add layout
- Add breakpoints
- Update styles"

# DON'T use multiple -m flags
git cm "feat(ui): add layout" -m "- Add breakpoints"
```

### Step 5: Push Changes, Recap, and Verify

1. Review your initial plan and ensure you've followed it precisely such that you've
   - Created a commit for each logical chunk of changes
   - Used the [commit message format](#commit-message-format)
   - Completed the [pre-commit checklist](#step-3-pre-commit-checklist)
   - Properly [committed and staged the files](#step-4-write-a-properly-formatted-commit-message-and-stage-the-files)
2. Only after you've verified the plan should you proceed with the next steps
3. Push your changes with `git sd-push`
   - This will push your changes to the remote repository and show a recap of what happened
   - If necessary, you can do a `git sd-push --force` to force push your changes to the remote repository
   - If you run into issues, you should ask the user for help
4. Provide the user with a succinct summary of your actions

## Troubleshooting

If you run into issues, consider the following:

### Fix Last Commit

```bash
# Amend commit message
git commit --amend -m "type(scope): corrected message"

# Amend commit content
git add <forgotten-file>
git commit --amend --no-edit
```

### Split Failed Commit

In this scenario, we use a `git split-commit` to simplify the process of splitting a failed commit into two separate commits:

```bash
git split-commit "<file-a1> <file-a2> <file-an> " "<message-a>" "<pattern-b>" "<message-b>"
```

Here's an example of this in action:

```bash
# Reset last commit and re-commit the files as two separate commits
git split-commit "src/components/Button.js" "feat: add button component" "src/styles/*.css" "style: update stylesheets"

# Output:
# === RESETTING LAST COMMIT ===
# === COMMITTING: src/components/Button.js with message: feat: add button component ===
# === COMMITTING: src/styles/*.css with message: style: update stylesheets ===
# === SPLIT COMPLETE ===
# === REPOSITORY STATUS AFTER COMMIT ===
# M  src/components/Button.js
# M  src/styles/button.css
# M  src/styles/layout.css

# ... (additional output)
```

## Remember

- ✅ Always check branch synchronization with main before making changes
- ✅ Create a new branch if on main and synchronized with main
- ✅ Never commingle unrelated changes
- ✅ Always verify excluded files aren't staged
- ✅ Never commit directly to `main`
- ✅ Always prompt for a task description if not known
- ✅ Create branches from `dev` when appropriate
- ✅ Format commit messages with the [conventional commit message format](#commit-message-format)
