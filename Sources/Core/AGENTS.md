# DesignCore Guide For AI Agents

## Scope
- This guide applies to `Sources/Core` (`DesignCore` target).
- `Archived/` is excluded from the target in `Package.swift`; do not use `Archived/` APIs for new code.

## What DesignCore Provides
- `Utilities/Builder.swift`: fluent configuration helpers:
  - `Chainable` for reference types (`with`, `customized`)
  - `SelfCustomizable` for value types (`custom`, `updated`)
- `Utilities/CommonProtocols.swift`: `FBuilder<Node>` result builder for declarative array construction.
- `Utilities/Preferences.swift`: preference wrappers:
  - `FPreferenceKey`
  - `@PreferenceItem<T: PreferenceValue>`
  - `@PreferenceData<T: Codable>`
- `Utilities/ObjectAssociation.swift`: Objective-C associated-object wrappers (`ObjectAssociation`, closure sleeves, `StructWrapper`).
- `Utilities/Loggable.swift`: default `Logger` for conforming types.
- `Strings/CommonAttributedString.swift`: chainable attributed string builder and target-range attribute helpers.
- `Exts/*`: core convenience extensions used across modules (`Array[safe:]`, `invertFilter`, date parsing/formatting, string helpers, condition transforms).

## Preferred Usage Patterns

### 1) Fluent setup for reference types
```swift
final class VM: Chainable {
    var title = ""
}

let vm = VM()
    .with(\.title, setTo: "Welcome")
    .customized { _ in }
```

### 2) Functional updates for value types
```swift
struct State: SelfCustomizable {
    var count: Int
}

let next = State(count: 1).updated(\.count, with: 2)
```

### 3) Preferences
```swift
@PreferenceItem("feature_enabled", false) var isEnabled: Bool
@PreferenceData("cached_profile", UserProfile.placeholder) var profile: UserProfile
```
- Use `FPreferenceKey` string literals directly.
- For custom stores in tests, pass `store:` to wrappers.

### 4) Attributed text
```swift
let text = NSAttributedString.build {
    CommonAttributedString("Hello ").font(.systemFont(ofSize: 14))
    CommonAttributedString("World").foreground(.systemBlue)
}
```

### 5) Safer collection and transform helpers
```swift
let item = items[safe: index]
let odds = numbers.invertFilter { $0.isMultiple(of: 2) }
```

## Guardrails For Changes
- Keep public API source-compatible unless explicitly requested.
- Keep `Array[safe:]` behavior as non-crashing (`nil` for out-of-bounds).
- Keep date parsing/formatting locale behavior (`.autoupdatingCurrent`) unless a breaking behavior change is intended.
- Do not replace `FPreferenceKey` with raw `String` parameters in wrapper APIs.
- Keep `ObjectAssociation`-based storage for extension-backed state in UIKit/Rx/Combine layers.
- Add or update tests in `Tests/Core` for any behavior change in `Sources/Core`.

## Validation
- Prefer package tests after changes:
  - `xcodebuild test -scheme DesignUIKit-Package -destination 'platform=iOS Simulator,id=<SIM_ID>'`
  - `xcodebuild test -scheme DesignUIKit-Package -destination 'platform=tvOS Simulator,id=<SIM_ID>'`
