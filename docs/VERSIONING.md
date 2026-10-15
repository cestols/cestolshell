# Versioning Strategy

## Overview

Every version has three numbers: `MAJOR.STAGE.STEP` (e.g. `0.1.2`).

- **Stage (`0.Y.x`)**: a functional phase of the roadmap (`0.1.x` simple bar, `0.2.x` bar
  status, ...). In prose and in `dev/scaffold.sh --stage 0.1` a stage is named by its
  first two numbers.
- **Version (`0.Y.Z`)**: a complete, visible and testable step inside a stage. Each stage
  starts at `0.Y.0`; a stage is complete when its last planned version is tagged.
- **Git commit**: an atomic code change; it never needs a version bump.

Every planned version and what it implements is listed in [ROADMAP.md](ROADMAP.md).
`1.0.0` marks the first stable release.

---

## The Golden Rule

Before tagging a version, ask:

> _"Is this state testable, cohesive, and usable as a checkpoint?"_

If **yes**, tag it. If **no** (e.g., just added a single component or fixed a typo), it
belongs in a regular Git commit.

### Examples

- **Good version**: `0.2.1 — Bar shows the battery` (visible, testable in a running session).
- **Too small**: `0.2.1 — Added BatteryIndicator.qml` (a single commit inside a version).

---

## When to Bump

### Increment the step (`0.Y.Z` → `0.Y.Z+1`)

- A row of [ROADMAP.md](ROADMAP.md) works in a running session.
- A fix or change worth a checkpoint lands after the stage's last version.

### Start the next stage (`0.Y.Z` → `0.Y+1.0`)

- The last planned version of the current stage is tagged.
- The project moves to the next feature area.

### Do NOT bump

- Updating a single file or line.
- Small internal bugfixes or refactoring without behavioral changes.
- Renaming files or internal variables.

---

## Git Tags & Changelog Integration

1. **Git tags**: every version is tagged `vX.Y.Z` (e.g. `v0.1.0`) on the commit that
   completes it. No two-number tags.
2. **`CHANGELOG.md`**: one entry per tagged version. Individual commits do not need
   entries; the entry of a stage's last version notes that the stage is complete.
3. **[ROADMAP.md](ROADMAP.md)**: mark the version as done in the same change.

---

## Summary

- **Stage (`0.Y.x`)**: where we want to go.
- **Version (`0.Y.Z`)**: a verifiable checkpoint along the way.
- **Commit**: the technical change required to get there.
