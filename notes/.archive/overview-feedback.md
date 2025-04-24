# Mixdown Overview – Feedback & Gaps

## Overview Fixes

The following items have been addressed and should be incorporated into the overview document:

- [x] **Negation Clarification** 
  - [x] Specify that flag negations are NOT allowed - only attribute values can be negated
  - [x] Update overview to explicitly state this limitation
- [x] **Heading Algorithm**
  - [x] Confirm default level comes from `.mixdown/headings.default` (example shows `2`)
  - [x] Document that H1 is reserved for top title unless `headings.default` is set to `1`
  - [x] Specify that clamping should use the `headings.range` value
  - [x] Clarify that self-closing tags honor the same heading rules
- [x] **Self-closing with Attributes**
  - [x] Clarify that self-closing tags support all section attributes (must appear before `/`)
  - [x] Fix example syntax to `{{log export="cli" /}}` instead of `{{log / export="cli"}}`
- [x] **Switch vs future `%if`**
  - [x] Remove any mention of switch attributes from overview
  - [x] Add note in future roadmap about potential "conditional" placeholders
- [x] **Escaping Placeholders**
  - [x] Clarify that the official way to escape is with backslash `\{`
  - [x] Specify that back-tick escape is unnecessary
  - [x] Enhance the "Advanced Uses" section to make this clearer
- [x] **Group Merge Semantics**
  - [x] Explicitly document that `.mixdown/config.yaml` overrides REPLACE provider defaults
  - [x] Update "Target Groups in .mixdown/config.yaml" section
- [x] **Provider Manifest Schema**
  - [x] Include full exemplar from syntax doc showing optional fields
  - [x] Add `description`, `groups`, `types.*.allowed_keys` to documentation
- [x] **Allowed Attribute Master List**
  - [x] Compile comprehensive list from Attribute-parsing section
  - [x] Add table in appendix with type/default/scope-support information
- [x] **Import Two-line Syntax**
  - [x] Remove legacy `[!mix]` references
  - [x] Confirm embed syntax is now `{{$mix:my-mix}}`
- [x] **Case-sensitivity Rules**
  - [x] Document that names/IDs should be `kebab-case` lowercase
  - [x] Note that linter will down-case or error on mismatch
- [x] **Front-matter Required Keys**
  - [x] Document that provider manifest `types.<artifact>.required_keys` array drives validation
  - [x] Reference the cursor provider example
- [x] **Heading Strictness Precedence**
  - [x] Specify that per-file front-matter settings override project `.mixdown/config.yaml`
  - [x] Reference the heading_level override example
- [x] **Brace Collision with Static Placeholders**
  - [x] Add linter rule requiring sigils for dynamic placeholders
  - [x] Specify warning/error behavior for braces without sigils
  - [x] Note potential config option to warn or error on these cases
- [x] **Multi-line Section Openers**
  - [x] Confirm multi-line opening braces are valid
  - [x] Reference existing example under "Multi-line section tags"
  - [x] Note that parser preserves formatting
- [x] **Fenced-code Opt-in**
  - [x] Document that default behavior is to parse placeholders even inside code blocks
  - [x] Mention that authors can escape with `\` prefix
  - [x] Clarify that no special flag is required for this behavior
- [x] **Embedded Front-matter in Mixins**
  - [x] Document that `include-frontmatter` is opt-in/false by default
  - [x] Note that embeds omit front-matter unless this flag is set
- [x] **Duplicate Mixin Renaming**
  - [x] Document `as="alternate-name"` attribute on embed sections
  - [x] Explain how this helps disambiguate duplicates
- [x] **Target-vs-Group Naming Collision**
  - [x] Document that target IDs take precedence over group names in collisions
  - [x] Specify that group references must use explicit syntax like `@group:cli` in these cases
  - [x] Add recommendation to plugin development guide
- [x] **Version Mismatch Policy**
  - [x] Document that CLI should warn when processing files with newer version requirements
  - [x] Specify that it will attempt to build but fail with clear errors for unknown syntax
  - [x] Note that error output should include upgrade instructions

### Fix Notes

- **Negation Clarification**
  - Added clarification to section 7.7 stating that flag shorthand negation (e.g., `!flag`) is not supported, only attribute value negation for specific attributes like `filter`.
- **Escaping Placeholders**
  - Added a dedicated "Escaping Placeholders" bullet point in section 7.7
  - Clearly stated that backslash is the official way to escape placeholders
  - Explicitly mentioned that back-tick escaping is unnecessary
  - Updated the "Placeholder Resolution in Code Blocks" bullet to maintain consistency with the escaping method
- **Group Merge Semantics**
  - Added a clear note in section 7.6 that configurations in `.mixdown/config.yaml` completely override provider defaults
  - Clarified that `include` and `exclude` arrays replace provider-defined values, while `append` adds to existing list
  - Updated the ambiguity item in section 7.8 to show this has been resolved with the replacement approach
- **Provider Manifest Schema**
  - Enhanced the JSON example in section 7.9 with additional fields
  - Added `description`, `name`, `groups` with their structure, and `types` with required/allowed keys
  - Updated the ambiguity item in section 7.8 to indicate that the schema is now fully documented
  - Ensured the example is comprehensive but still focused on the key fields
- **Allowed Attribute Master List**
  - Added a new section 15.1 "Comprehensive Attribute Reference Table" in the Appendix
  - Created a detailed table listing all attributes with their types, default values, and scope support
  - Organized attributes by context (Section, Mixin, Front-matter)
  - Added helpful notes about attribute scoping and flag default values
  - Ensured complete coverage of all attributes mentioned throughout the document
- **Import Two-line Syntax**
  - Verified that there are no legacy `[!mix]` references in the overview document
  - Confirmed that the embed syntax `{{$mix:my-mix}}` is properly documented in section 7.4.5
  - Checked that examples in section 8.5 demonstrate the correct syntax
  - Found that old syntax is only mentioned in tables explicitly comparing old vs. new syntax, which is appropriate
- **Heading Algorithm**
  - Updated section 7.5 to clarify that `headings.default` sets the base level.
  - Added explanation for `reserve_h1` and its interaction with `headings.default` regarding H1 usage.
  - Explicitly mentioned that `h+/-` modifiers are clamped by the `headings.range` setting.
  - Added a note that self-closing tags also respect heading attribute modifiers.
  - Removed the corresponding ambiguity from section 7.8.
- **Self-closing with Attributes**
  - Added clarification to section 7.4.1 that attributes must precede the `/` in self-closing tags.
  - Verified no incorrect examples (e.g., `{{log / export="cli"}}`) exist in the overview document.
- **Switch vs future `%if`**
  - Verified no mentions of `switch` attributes exist.
  - Removed the specific `%if` syntax example from section 7.7.
  - Added a broader note to section 7.7 about potential future conditional logic syntax, advising users to rely on filtering attributes for now.
- **Case-sensitivity Rules**
  - Added a bullet point to section 7.7 recommending `kebab-case` for names/IDs.
  - Mentioned that the linter will handle mismatches (warn/error/normalize).
  - Removed the corresponding ambiguity from section 7.8.
- **Front-matter Required Keys**
  - Added clarification to section 7.4.3 explaining that `types.<artifact>.required_keys` and `allowed_keys` in the provider manifest control front-matter validation.
  - Referenced the example in section 7.9.
- **Heading Strictness Precedence**
  - Added a note under the per-file override example in section 7.5 confirming that file front-matter takes precedence over project config.
  - Removed the corresponding ambiguity from section 7.8.
- **Brace Collision with Static Placeholders**
  - Added a bullet point to section 7.7 explaining the linter rule for requiring sigils (`{@...}`, `{=...}`, `{>...}`) on dynamic placeholders.
  - Clarified that plain braces `{word}` will trigger a configurable warning/error, prompting the user to add a sigil or escape (`\{word}`).
- **Multi-line Section Openers**
  - Confirmed multi-line openers are documented as valid in section 7.4.1.
  - Added a note in 7.4.1 confirming the parser preserves formatting (during the self-closing tag edit).
  - Existing example in 7.4.1 is referenced implicitly by being in the same subsection.
- **Fenced-code Opt-in**
  - Updated the "Placeholder Resolution in Code Blocks" bullet in section 7.7 to clarify that parsing is the default.
  - Explicitly mentioned the `\` escape mechanism.
  - Confirmed that no special flag is needed for this behavior.
- **Embedded Front-matter in Mixins**
  - Updated the attribute description for `include-frontmatter` in the table in section 7.4.5 to explicitly state it defaults to `false`.
  - Clarified that front-matter from the source mixin is only included if the flag is present.
- **Duplicate Mixin Renaming**
  - Enhanced the description of the `as` attribute in both section 7.4.5 and the attributes table in section 15.1.
  - Added explicit explanation that the attribute helps disambiguate when the same mixin is included multiple times in a document.
- **Target-vs-Group Naming Collision**
  - Added a new paragraph in section 7.6 (Target Groups) explaining precedence when target IDs and group names collide.
  - Documented the explicit syntax `@group:cli` for disambiguation.
  - Added a recommendation for plugin authors to avoid naming conflicts.
- **Version Mismatch Policy**
  - Added section 7.8 specifically for version mismatch handling.
  - Documented the warning behavior for newer version requirements.
  - Specified that the CLI will attempt to build but fail with clear error messages for unknown syntax.
  - Noted that error outputs include upgrade instructions.

---

Below is a focused review of your **Comprehensive Project Overview**. I've grouped comments by theme so you can triage quickly.

## 1. Big-Picture 👍

- **Vision & elevator pitch are crisp.** "Terraform for prompts" lands immediately.
- **CommonMark-only pledge** is reiterated throughout – good reinforcement.
- **Directory & architecture diagrams** help first-time contributors.

Keep these pillars; everything else is incremental tightening.

## 2. Missing or Ambiguous Details

These either surfaced in earlier design notes or emerge from the latest brace syntax.

- [x] 1. **`xml` vs `no-xml` precedence**
    - Define conflict rule → *lint error* or *last token wins*.
    - possible-fix: Attribute precedence section clarifies target-specific overrides (`xml@cursor`/`no-xml@cursor`) outrank group then global. If both plain `xml` and `no-xml` appear the linter should flag a conflict unless scopes differ.
    - **Answer:** There is no conflict as `xml` is not a valid attribute.
- [x] 2. **Flag negation style**
    - Confirm if shorthand `!xml` is allowed or only `no-xml`.
    - possible-fix: Spec explicitly adopts `no-<flag>` pattern; `!xml` shorthand is **not** allowed. See "Attribute-parsing → Flags are introduced for attributes".
    - **Answer:** Flag negations are **not** allowed. Only attribute values can be negated.
    - **Solution:** Update [overview](overview.md) to clarify that negation is for attribute values only.
- [x] 3. **Heading algorithm**
    - Start-of-file level?
    - Clamp `h±` inside 1-6?
    - Allowed on self-closing?
    - possible-fix:
        - Default level comes from `.mixdown/headings.default` (example shows `2`).
        - `reserve_h1` governs start-of-file (`h1` reserved for mix title by default).
        - `h+ / h-` modifiers are clamped to `1-6` per heading config `range`.
        - Same modifiers permitted on self-closing section tags.
    - **Answer/Solution** The default level comes from `.mixdown/headings.default` (example shows `2`).
        - H1 is reserved for a top title, unless `headings.default` is set to `1`.
        - The clamping should use the `headings.range` value.
        - Self-closing tags should be honoured with the same situation
- [x] 4. **Attribute precedence for flags**
    - Example `no-xml@cli xml` → which wins?
    - possible-fix: Scope precedence is documented: `key@target` > `key@group` > unscoped `key`. Thus `no-xml@cli` overrides unscoped `xml` when building for `cli`.
    - **Answer:** At this point the `xml` attribute is not valid, so it is ignored. However, if it were valid, the `no-xml` attribute would take precedence for the `cli` target due to the precedence rules. Yet still, we should recommend that it would be a best practice to write first to last.
- [x] 5. **Self-closing + export/skip**
    - Decide if `{{log / export="cli"}}` exports or ignores attr.
    - **Answer:** Self-closing tags support all section attributes (must appear before `/`). Therefore `export="cli"` is honoured—tag will be exported/skipped per rules. However, the correct syntax would have been `{{log export="cli" /}}`. We should ensure this is clarified in the spec.
- [x] 6. **Switch vs future `%if`**
    - State if `{{% switch target="cursor" %}}` will exist; else note "switch has no attrs".
    - Answer: We don't have plans to add switch attribute and should be removed from [overview](overview.md) if present. Also, we should note in the future roadmap that a "conditional" placeholder may be added in the future.
- [x] 7. **Escaping placeholders**
    - Official way to render literal `{...}` – `\{` or ``\`{}``.
    - possible-fix: Section "Advanced Uses" specifies prefix with backslash e.g. `