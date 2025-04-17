# Using Changesets in Mixdown

This project uses [Changesets](https://github.com/changesets/changesets) for versioning and changelog management.

## Adding a Changeset

When you make a change to the codebase that requires a version bump, you need to add a changeset:

```bash
pnpm changeset:add
# or
pnpm changeset add
```

You will be prompted to:
1. Select the packages that have changed (in this single-package repo, it's just the main package)
2. Specify what type of version change is needed (patch, minor, major)
3. Write a description of the change (this will be added to the changelog)

## Checking Changesets Status

To see what changesets are currently pending:

```bash
pnpm changeset:status
# or
pnpm changeset status
```

## Versioning

To update the version based on the collected changesets:

```bash
pnpm changeset:version
# or
pnpm changeset version
```

This will:
1. Update package.json with the new version
2. Create/update CHANGELOG.md files
3. Remove the processed changesets files

## Publishing

To build the project and publish to npm:

```bash
pnpm release
```

## GitHub Actions

This project has a GitHub Actions workflow that automatically:
1. Creates a PR with version updates when changesets are pushed to the main branch
2. Publishes to npm when that PR is merged

You need to ensure you have set the `NPM_TOKEN` secret in your GitHub repository settings for the automatic publishing to work. 