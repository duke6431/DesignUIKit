# DesignExternal Guide For AI Agents

## Scope
- This guide applies to `Sources/ExternalPackages` (`DesignExternal` target).
- `Archived/` is excluded from the target in `Package.swift`; do not use archived code for new implementations.

## What DesignExternal Provides
- This module currently acts as a thin export surface:
  - `FileKit.swift` re-exports FileKit via `@_exported import FileKit`.
- Practical effect: consumers of `DesignExternal` can use FileKit APIs (e.g. `Path`) without importing FileKit directly.

## Preferred Usage Patterns
```swift
import DesignExternal

let tmp = Path.uniqueTemporary
try tmp.createDirectory()
try tmp.deleteFile()
```

## Guardrails For Changes
- Keep this target lightweight and focused on external package exposure.
- Preserve source compatibility for existing imports (`import DesignExternal` should continue to expose `Path` and related FileKit symbols).
- Avoid introducing app-specific business logic in this target.
- If wrappers are added, keep them thin and testable.

## Validation
- Run package tests after changes:
  - `xcodebuild test -scheme ComponentSystem-Package -destination 'platform=iOS Simulator,id=<SIM_ID>'`
  - `xcodebuild test -scheme ComponentSystem-Package -destination 'platform=tvOS Simulator,id=<SIM_ID>'`
