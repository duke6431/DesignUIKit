# DesignUIKit Guide For AI Agents

## Scope
- This guide applies to `Sources/UIKit` (`DesignUIKit` target).
- `Archived/` is excluded from the target in `Package.swift`; do not use archived files for new code.

## What DesignUIKit Provides
- Base UI layer (`Components/BaseUI`): shared themed base classes (`BaseView`, `BaseLabel`, `BaseButton`, etc.).
- Theme and typography systems (`Components/Systems`):
  - `Theme`, `ThemeSystem`, `ThemeKey`, themable protocols
  - `FontSystem`, spacing helpers
- Declarative SwiftUIKit components (`SwiftUIKit/*`):
  - Base abstractions (`FComponent`, `FConfigurable`, `FView`, `FModifier`)
  - Content/input/collection/container components (`FLabel`, `FImage`, `FButton`, `FTextField`, `FGrid`, `FList`, `FViewController`, etc.)
- Reusable table/collection infrastructure (`ListView/*`):
  - `CommonTableView` and `CommonCollection.View` with model protocols and reusable registration helpers.

## Preferred Usage Patterns

### 1) Declarative component composition
```swift
FVStack(spacing: 8) {
    FLabel("Title").foreground(.label)
    FButton("Continue") { print("tap") }
}
```

### 2) Theme-aware styling
```swift
label.foreground(key: MyThemeKey.textPrimary)
container.background(key: MyThemeKey.surface)
```

### 3) Container/child VC embedding
```swift
let child = SomeViewController()
let host = FViewController(child).parent(parentViewController)
```
- Use `parent(...)` and internal attach/detach flow.
- Do not manually call child VC lifecycle methods around `addChild`.

## Behavior Contracts
- `FViewController` containment must be idempotent:
  - No duplicate `willMove(toParent:)` before `addChild`
  - Do not re-add if already parented to the same parent
- `CommonCollection.View` must remain safe under diffable/snapshot timing:
  - Guard section/item indexing in layout/data source/selection paths
- `FButton.tapEvent` is platform-specific and must stay consistent:
  - iOS: `.touchUpInside`
  - tvOS/macCatalyst: `.primaryActionTriggered`

## Guardrails For Changes
- Preserve chainable API style for `F*` components and modifiers.
- Keep iOS/tvOS compatibility as declared in `Package.swift`.
- Avoid introducing hard assumptions about immediate snapshot consistency in collection/table adapters.
- Keep theme/font registration logic centralized in system classes (`ThemeSystem`, `FontSystem`).
- Add/update tests in `Tests/UIKit` when changing component lifecycle, selection, or adapter behavior.

## Validation
- Run package tests after changes:
  - `xcodebuild test -scheme ComponentSystem-Package -destination 'platform=iOS Simulator,id=<SIM_ID>'`
  - `xcodebuild test -scheme ComponentSystem-Package -destination 'platform=tvOS Simulator,id=<SIM_ID>'`
