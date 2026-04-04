# DesignExts Guide For AI Agents

## Scope
- This guide applies to `Sources/Exts` (`DesignExts` target).
- `Archived/` is excluded from the target in `Package.swift`; do not use `Archived/` APIs for new code.

## What DesignExts Provides
- `CALayer+.swift`
  - `CALayer.ShadowConfiguration` (conforms to `SelfCustomizable` from `DesignCore`)
  - `add(shadow:)`
  - `addShadow(...)`
  - `removeShadow()`
- `CGSize+.swift`
  - `static func + (CGSize, CGSize?) -> CGSize`
  - `static func / (CGSize, CGFloat) -> CGSize` (returns `.zero` when divisor is `0`)
- `Color+.swift`
  - `UIColor.hex(_:)`
  - `UIColor.init(hexString:)`
  - `UIColor.hexString` (`#RRGGBB`)

## Preferred Usage Patterns

### 1) Layer shadows
```swift
layer.add(shadow: .init(offSet: .init(width: 0, height: 2), opacity: 0.25, radius: 6))
layer.removeShadow()
```

### 2) Size math
```swift
let a = CGSize(width: 100, height: 40)
let b: CGSize? = CGSize(width: 20, height: 10)
let sum = a + b
let half = sum / 2
```

### 3) Hex colors
```swift
let primary = UIColor.hex("#3366FF")
let text = UIColor(hexString: "FFF")
let hex = primary.hexString
```

## Behavior Contracts
- `UIColor(hexString:)` accepts `3`, `6`, and `8` hex digits (after trimming non-alphanumerics).
- Invalid hex lengths fall back to black.
- `hexString` returns RGB only (no alpha), uppercase, with leading `#`.
- `CGSize / 0` must not crash and must return `.zero`.
- `removeShadow()` must reset shadow properties and keep `masksToBounds = false`.

## Guardrails For Changes
- Keep API source-compatible unless explicitly requested.
- Preserve deterministic fallbacks:
  - invalid hex -> black
  - divide by zero -> `.zero`
- Do not add UIKit behavior that requires a superview/window for these helpers.
- If color conversion logic changes, keep non-RGB color-space fallback path intact.
- Add/update tests in `Tests/Exts` for any behavior change in `Sources/Exts`.

## Validation
- Prefer package tests after changes:
  - `xcodebuild test -scheme ComponentSystem-Package -destination 'platform=iOS Simulator,id=<SIM_ID>'`
  - `xcodebuild test -scheme ComponentSystem-Package -destination 'platform=tvOS Simulator,id=<SIM_ID>'`
