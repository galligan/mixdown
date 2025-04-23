# Mixdown Overview – Feedback & Gaps

Below is a focused review of your **Comprehensive Project Overview**. I’ve grouped comments by theme so you can triage quickly.

## 1. Big-Picture 👍

- **Vision & elevator pitch are crisp.** "Terraform for prompts" lands immediately.
- **CommonMark-only pledge** is reiterated throughout – good reinforcement.
- **Directory & architecture diagrams** help first-time contributors.

Keep these pillars; everything else is incremental tightening.

## 2. Missing or Ambiguous Details

These either surfaced in earlier design notes or emerge from the latest brace syntax.

- [ ] 1. **`xml` vs `no-xml` precedence**
    - Define conflict rule → *lint error* or *last token wins*.
- [ ] 2. **Flag negation style**
    - Confirm if shorthand `!xml` is allowed or only `no-xml`.
- [ ] 3. **Heading algorithm**
    - Start-of-file level?
    - Clamp `h±` inside 1-6?
    - Allowed on self-closing?
- [ ] 4. **Attribute precedence for flags**
    - Example `no-xml@cli xml` → which wins?
- [ ] 5. **Self-closing + export/skip**
    - Decide if `{{log / export="cli"}}` exports or ignores attr.
- [ ] 6. **Switch vs future `%if`**
    - State if `{{% switch target="cursor" %}}` will exist; else note "switch has no attrs".
- [ ] 7. **Escaping placeholders**
    - Official way to render literal `{...}` – `\{` or ``\`{}``.
- [ ] 8. **Group merge semantics**
    - Is `include/exclude` *patch* or *replace* after provider defaults?
- [ ] 9. **Provider manifest schema**
    - Provide full JSON with optional keys (`description`, `versionCompat`).
- [ ] 10. **Allowed attribute master list**
    - Overview references but table is empty—add or link.
- [ ] 11. **Import two-line syntax**
    - Remove legacy `[!mix]` line or document migrator.
- [ ] 12. **Case-sensitivity rules**
    - Enforce lower-kebab or auto-normalize IDs/groups/sections.
- [ ] 13. **Front-matter required keys**
    - Specify manifest field where providers declare `required_keys`.
- [ ] 14. **Heading strictness precedence**
    - Project config vs per-file override—who wins?
- [ ] 15. **Brace collision with static placeholders**
    - Lint rule for `{word}` without sigil/section.
- [ ] 16. **Multi-line section openers**
    - Allowed? Parsing & formatter rules.
- [ ] 17. **Inner placeholder recursion order**
    - Depth-first? Max depth?
- [ ] 18. **Fenced-code opt-in**
    - Always parse placeholders or require `{mixdown parse}` flag?
- [ ] 19. **Embedded front-matter in mixins**
    - `include-frontmatter` default behaviour.
- [ ] 20. **Duplicate mixin renaming**
    - Attribute to alias an embed when used twice.
- [ ] 21. **Target-vs-group naming collision**
    - Resolution rule if someone registers `cli` as a target ID.
- [ ] 22. **Version mismatch policy**
    - Behaviour when file `mixdown.version` > CLI version.

## 3. Minor Copy / Consistency Tweaks

- A few paragraphs still mention HTML-comment syntax (search for “comments will render”).
- Examples show `@@ide` shortcuts not described in spec section—decide to keep or drop.
- "Mixins" vs "Embeds" wording: unify to one term.

## 4. Quick Actions Before Publishing Docs

1. **BNF/Regex appendix** for section, attribute, placeholder tokens.
2. **Attribute master table** with type, default, allowed scopes.
3. Two linter examples: `xml@cursor no-xml`, `export="cli" skip@cli`.
4. Finalize merge order: provider-groups → project overrides → mix attrs.

Once these items are nailed down the spec should be implementation-ready and newcomer-friendly.

*Generated feedback – rev 2025-04-23*