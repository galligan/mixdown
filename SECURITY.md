# Mixdown Security

This document outlines the security considerations and constraints in Mixdown.

> See also the [Security, Testing & Performance](notes/overview.md#security-testing--performance) section in the overview for a high-level summary.

## Security Model

Mixdown operates with a minimal-access security model:

1. **Sandboxed Execution** - All dynamic operations are performed in controlled environments
2. **Allowlist Approach** - Only explicitly permitted operations are allowed
3. **Input Validation** - All inputs are validated against schemas before processing

## Placeholder Execution Security

Placeholders that execute code (e.g., `{@git_branch}`, `{@shell:command}`) operate under the following constraints:

### Allowed Operations

The following placeholder operations are permitted:

| Placeholder | Purpose | Security Constraints |
|-------------|---------|---------------------|
| `{@git_branch}` | Get current Git branch | Read-only, no arguments |
| `{@git_version}` | Get Git version | Read-only, no arguments |
| `{@date:format}` | Get formatted date | Specified date formats only |
| `{@env:VAR}` | Access environment variable | Allowlisted variables only |

<sub>Table 1: Allowed placeholder operations and their security constraints</sub>

### Sandbox Constraints

1. **No Network Access** - Dynamic placeholders cannot access the network
2. **No File System Writes** - Operations are read-only
3. **Resource Limits** - Execution time and memory are capped
4. **Isolation** - Each operation runs in isolation from others

## XML Parser Security

The XML parser used for processing sections employs the following security measures:

1. **Entity Expansion Disabled** - `ignoreEntities: true` prevents XXE attacks
2. **DTD Processing Disabled** - Prevents DTD-based vulnerabilities
3. **External Loading Disabled** - No external entities can be loaded

## Path Security

All file paths are sanitized to prevent directory traversal:

1. **Path Normalization** - Removes `../` and other potential traversal sequences
2. **Base Directory Enforcement** - Operations cannot access files outside defined roots
3. **Symlink Resolution** - Symlinks are resolved and validated against allowed paths

## Recommendations for Users

1. **Review Custom Placeholders** - Carefully review any custom placeholders before use
2. **Use Version Pinning** - Pin to specific Mixdown versions in your project
3. **Keep Updated** - Follow security advisories and update promptly
4. **Limit Privileges** - Run Mixdown with minimal system privileges

## Reporting Security Issues

Please report security vulnerabilities via [private issue reporting](https://github.com/mixdown/mixdown/security/advisories/new) rather than public issues. 