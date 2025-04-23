# Mixdown Overview – Feedback & Gaps

Below is a focused review of your **Comprehensive Project Overview**. I've grouped comments by theme so you can triage quickly.

## 1. Big-Picture 👍

- **Vision & elevator pitch are crisp.** "Terraform for prompts" lands immediately.
- **CommonMark-only pledge** is reiterated throughout – good reinforcement.
- **Directory & architecture diagrams** help first-time contributors.

Keep these pillars; everything else is incremental tightening.

## 2. Missing or Ambiguous Details

These either surfaced in earlier design notes or emerge from the latest brace syntax.

- [ ] 1. **`xml` vs `no-xml` precedence**
    - Define conflict rule → *lint error* or *last token wins*.
    - possible-fix: Attribute precedence section clarifies target-specific overrides (`xml@cursor`/`no-xml@cursor`) outrank group then global. If both plain `xml` and `no-xml` appear the linter should flag a conflict unless scopes differ.
- [ ] 2. **Flag negation style**
    - Confirm if shorthand `!xml` is allowed or only `no-xml`.
    - possible-fix: Spec explicitly adopts `no-<flag>` pattern; `!xml` shorthand is **not** allowed. See "Attribute-parsing → Flags are introduced for attributes".
- [ ] 3. **Heading algorithm**
    - Start-of-file level?
    - Clamp `h±` inside 1-6?
    - Allowed on self-closing?
    - possible-fix:
        - Default level comes from `.mixdown/headings.default` (example shows `2`).
        - `reserve_h1` governs start-of-file (`h1` reserved for mix title by default).
        - `h+ / h-` modifiers are clamped to `1-6` per heading config `range`.
        - Same modifiers permitted on self-closing section tags.
- [ ] 4. **Attribute precedence for flags**
    - Example `no-xml@cli xml` → which wins?
    - possible-fix: Scope precedence is documented: `key@target` > `key@group` > unscoped `key`. Thus `no-xml@cli` overrides unscoped `xml` when building for `cli`.
- [ ] 5. **Self-closing + export/skip**
    - Decide if `{{log / export="cli"}}` exports or ignores attr.
    - possible-fix: Self-closing tags support all section attributes (must appear before `/`). Therefore `export="cli"` is honoured—tag will be exported/skipped per rules.
- [ ] 6. **Switch vs future `%if`**
    - State if `{{% switch target="cursor" %}}` will exist; else note "switch has no attrs".
    - possible-fix: Latest docs show conditional blocks using `%if` syntax (`<!-- %if tool in vs-code % -->`). No `switch` attrs planned—retain `%if`, drop `switch` example.
- [ ] 7. **Escaping placeholders**
    - Official way to render literal `{...}` – `\{` or ``\`{}``.
    - possible-fix: Section "Advanced Uses" specifies prefix with backslash e.g. `\{$my-insert}` to output literal braces. Back-tick escape is unnecessary.
- [ ] 8. **Group merge semantics**
    - Is `include/exclude` *patch* or *replace* after provider defaults?
    - possible-fix: `.mixdown/config.yaml` overrides **replace** provider defaults (see "Target Groups in .mixdown/config.yaml"). Document this explicitly.
- [ ] 9. **Provider manifest schema**
    - Provide full JSON with optional keys (`description`, `versionCompat`).
    - possible-fix: Include exemplar from syntax doc: `@mixdown/target-cursor/mixdown-provider.json` snippet lists optional `description`, `groups`, `types.*.allowed_keys`, etc.
- [ ] 10. **Allowed attribute master list**
    - Overview references but table is empty—add or link.
    - possible-fix: Compile list from Attribute-parsing section (flags, key-value attrs, modifiers). Add table in appendix with type/default/scope-support.
- [ ] 11. **Import two-line syntax**
    - Remove legacy `[!mix]` line or document migrator.
    - possible-fix: Legacy two-line `[!mix]` replaced by embed syntax `{{$mix:my-mix}}`. Recommend doc update + optional CLI migrator.
- [ ] 12. **Case-sensitivity rules**
    - Enforce lower-kebab or auto-normalize IDs/groups/sections.
    - possible-fix: README states names/id should be `kebab-case` lowercase; linter will down-case or error on mismatch.
- [ ] 13. **Front-matter required keys**
    - Specify manifest field where providers declare `required_keys`.
    - possible-fix: Provider manifest `types.<artifact>.required_keys` array (see cursor provider example) drives validation; surface this in docs.
- [ ] 14. **Heading strictness precedence**
    - Project config vs per-file override—who wins?
    - possible-fix: Per-file front-matter settings override project `.mixdown/config.yaml` (see heading_level override example).
- [ ] 15. **Brace collision with static placeholders**
    - Lint rule for `{word}` without sigil/section.
    - possible-fix: Add linter rule that requires sigils for dynamic placeholders (`{@...}`, `{=...}`, `{>...}`). Any braces without sigils should trigger a warning to either add a sigil or escape with `\{` for literal output.
- [ ] 16. **Multi-line section openers**
    - Allowed? Parsing & formatter rules.
    - possible-fix: Multi-line opening braces are valid; example provided under "Multi-line section tags". Parser preserves formatting.
- [ ] 17. **Inner placeholder recursion order**
    - Depth-first? Max depth?
    - possible-fix: Implement depth-first traversal for nested placeholders with a maximum recursion depth of 5 levels. Document this behavior and add a linter warning when approaching the limit.
- [ ] 18. **Fenced-code opt-in**
    - Always parse placeholders or require `{mixdown parse}` flag?
    - possible-fix: Default is to parse even inside code; author can escape with `\` prefix. Flag not required—document this behaviour.
- [ ] 19. **Embedded front-matter in mixins**
    - `include-frontmatter` default behaviour.
    - possible-fix: `include-frontmatter` is **opt-in false**—embeds omit FM unless flag set. Docs list attribute.
- [ ] 20. **Duplicate mixin renaming**
    - Attribute to alias an embed when used twice.
    - possible-fix: Use `as="alternate-name"` attribute on embed section to disambiguate duplicates.
- [ ] 21. **Target-vs-group naming collision**
    - Resolution rule if someone registers `cli` as a target ID.
    - possible-fix: Target IDs take precedence over group names in case of collision. When a plugin registers a target with the same name as an existing group, the target ID is honored in scoped attributes like `@cli`, and group references must use explicit group syntax like `@group:cli`. Document this in plugin development guide.
- [ ] 22. **Version mismatch policy**
    - Behaviour when file `mixdown.version` > CLI version.
    - possible-fix: CLI should warn when processing files with newer version requirements but attempt to build anyway. If it encounters unknown syntax, it will fail with clear error messages listing the required Mixdown version. Add upgrade instructions in error output.

## 3. Minor Copy / Consistency Tweaks

- A few paragraphs still mention HTML-comment syntax (search for "comments will render").
- Examples show `@@ide` shortcuts not described in spec section—decide to keep or drop.
- "Mixins" vs "Embeds" wording: unify to one term.

## 4. Quick Actions Before Publishing Docs

1. **BNF/Regex appendix** for section, attribute, placeholder tokens.
2. **Attribute master table** with type, default, allowed scopes.
3. Two linter examples: `xml@cursor no-xml`, `export="cli" skip@cli`.
4. Finalize merge order: provider-groups → project overrides → mix attrs.

Once these items are nailed down the spec should be implementation-ready and newcomer-friendly.

*Generated feedback – rev 2025-04-23*