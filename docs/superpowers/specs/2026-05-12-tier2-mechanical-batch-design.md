# Tier 2 Mechanical Batch — Design

**Status:** Approved (brainstorm 2026-05-12)
**Scope:** First sub-project of Tier 2. Bundles the two mechanical items so they ship as one PR before the three feature builds (favorites, battery/time, recently-played) start.
**Out of scope:** game.favorite toggle, battery/time strip, recently-played view (each gets its own spec).

---

## Goal

Make the theme's font handling honour the user's Pegasus font configuration for the bold header slot, and surface preview images in Pegasus's Theme Manager — both without changing any visible behaviour for a user who has not customised their font config.

---

## Part A — globalFonts migration (header slot only)

### What changes

Only the bold header font is migrated. `Rubik-Regular` (body) and `FredokaOne-Regular` (decorative subheader) stay bundled and unchanged.

`OpenSans-ExtraBold.ttf` remains in the `fonts/` directory as a fallback. We do not delete the bundle.

### Pattern

Inline the fallback at each call site. There are exactly three of them.

`HeaderText.qml:23`, `MetaBox.qml:45`, and `CollectionsView.qml:156`:

```qml
// before
font.family: headerFont.name
// after
font.family: globalFonts.sansBold || headerFont.name
```

(`CollectionsView.qml:156` is the active-collection-name header rendered over the carousel — same `headerFont` reference, same migration.)

The `FontLoader { id: headerFont; source: "fonts/OpenSans-ExtraBold.ttf" }` declaration in `theme.qml:10` is kept verbatim — it is now only used as a fallback when `globalFonts.sansBold` is unset (empty string).

### API path

Use the legacy alias `globalFonts.sansBold`. Pegasus's `main.qml` exposes both `globalFonts.X` (legacy) and `global.fonts.X` (new). The legacy alias is used here because:
- `global` is awkward in QML/JS scope.
- The legacy alias is documented as still present in the stable line.
- The README compatibility baseline is Pegasus 2024w38, which exposes `globalFonts`.

### Why inline vs. centralised property

Considered: adding a `property string headerFontFamily` on the root in `theme.qml` and threading it down to consumers via per-component exported properties. Rejected — three call sites, one short expression, no need for new component API surface. If a future change adds a fourth header consumer, revisit then.

### Affected files

- `HeaderText.qml` — one line.
- `MetaBox.qml` — one line.
- `CollectionsView.qml` — one line.
- `theme.qml` — no change.
- `fonts/OpenSans-ExtraBold.ttf` and `fonts/OpenSans-LICENSE.txt` — no change (still bundled as fallback).

---

## Part B — assets.screenshots in theme.cfg

### What changes

A new `assets.screenshots` key is added to `theme.cfg` listing two remote PNG URLs (already hosted under the repo owner's `user-images.githubusercontent.com` account, embedded in the README since 2019).

### Syntax

Per [Pegasus theme overview docs](https://pegasus-frontend.org/docs/themes/overview/): one path per line, indented under the key. Pegasus accepts either local paths relative to the `cfg` file or image URLs; both are valid.

```
assets.screenshots:
   https://user-images.githubusercontent.com/30796598/62833639-86380000-bc85-11e9-96ab-7e9e590d4020.png
   https://user-images.githubusercontent.com/30796598/62833650-a49dfb80-bc85-11e9-980c-e41f534977c8.png
```

The first URL is the collection-carousel hero; the second is a populated details/game-grid view. Both pre-date Tier 1 but Tier 1 was zero-behaviour-change, so they still represent the current look.

### Placement in theme.cfg

Inserted between `keywords:` and `homepage:` so all `assets.*` keys group near the other descriptive metadata:

```
name: Homage
author: asdfgasfhsn
version: 0.2.0
summary: A theme paying a modern Homage to great console and game box art
description: A 16:9 theme for Pegasus inspired by retro gaming packaging and artwork. Features a dynamic star-field background, per-system highlight colours, video snap support, swipe/touch input on Android, and persistent cursor positions per collection.
keywords: retro, console, carousel, grid, starfield, 16:9, video, touch
assets.screenshots:
   https://user-images.githubusercontent.com/30796598/62833639-86380000-bc85-11e9-96ab-7e9e590d4020.png
   https://user-images.githubusercontent.com/30796598/62833650-a49dfb80-bc85-11e9-980c-e41f534977c8.png
homepage: https://github.com/asdfgasfhsn/pegasus-theme-homage/
```

### Caveat

Pegasus fetches `assets.screenshots` URLs at Theme-Manager display time. On an offline install or when GitHub user-content is blocked, previews simply won't appear. This is an acceptable tradeoff vs. committing ~hundreds of KB of binary assets to the repo.

### Affected files

- `theme.cfg` — three new lines (key + two URLs).

---

## Verification

No automated tests — Pegasus loads QML at runtime, theme.cfg at startup. Manual checks after implementation:

- Load the theme in Pegasus with **no** user font override: headers should render in OpenSans-ExtraBold exactly as before (the `globalFonts.sansBold` value falls through to the bundled font if Pegasus's default sansBold is empty; otherwise it's the user-default).
- Set a user font override for sansBold in Pegasus settings: headers should pick up the new font.
- Open Pegasus's Theme Manager → Homage → previews: confirm the two screenshots load and display.
- Confirm the bundled OpenSans-ExtraBold is still in the `fonts/` directory and still referenced by the `headerFont` `FontLoader` in `theme.qml`.

---

## Non-goals (will be separate specs)

- Migrating Rubik (body) to `globalFonts.sans`.
- Removing the bundled OpenSans-ExtraBold.ttf.
- Committing screenshots into the repo (only re-evaluate if the remote-URL approach breaks for users in practice).
- Any of the three Tier 2 feature builds (favorites, battery/time, recently-played).

---

## Open questions

None. All decisions resolved during brainstorm.

---

## Sources

- [Pegasus theme overview docs](https://pegasus-frontend.org/docs/themes/overview/) — `assets.screenshots` syntax and URL support, verified 2026-05-12.
- `Project_Uplift.md` — Tier 2 item descriptions and Pegasus API surface.
