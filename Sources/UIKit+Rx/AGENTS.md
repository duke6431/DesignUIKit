# DesignRxUIKit Guide For AI Agents

## Scope
- This guide applies to `Sources/UIKit+Rx` (`DesignRxUIKit` target).
- `Archived/` is excluded from the target in `Package.swift`; do not use archived files for new code.

## What DesignRxUIKit Provides
- Rx-enabled base blocks (`BaseBlocks/*`):
  - `BaseViewModel`, `BaseViewController`, `BaseNavigating`
  - Use-case contracts: `UseCase`, `CompletableUseCase`, `StreamUseCase`
- Rx binding support for UIKit components:
  - `FComponent+Rx` (`Reactivable`, `disposeBag`, `bind(to: Driver, ...)`)
  - view binders for `FLabel`, `FButton`, `FTextField`, `FTextView`, `FImage`
- Rx utility transforms (`Rx+/Rx+Transform.swift`):
  - `cast`, `void`, `compacted`, `toggle`, `invertFilter`, `completeDriver`, etc.
- Error tracking utility (`Rx+/ErrorTracker.swift`):
  - tracks observable errors and exposes them as `Driver` / `Observable`

## Preferred Usage Patterns

### 1) UI binding
```swift
label.bind(to: titleDriver) { label, title in
    label.text = title
}
```

### 2) Rx transforms
```swift
let clean = source.compacted()
let inverse = boolSource.toggle()
```

### 3) Error tracking
```swift
let tracker = ErrorTracker()
source.trackError(tracker)
```

### 4) ViewModel + UseCase composition
```swift
final class ProfileViewModel: BaseViewModel, ViewModeling {
    let loadProfile: any UseCase<Void, Profile>
    let updateAvatar: any CompletableUseCase<UIImage>

    init(
        loadProfile: some UseCase<Void, Profile>,
        updateAvatar: some CompletableUseCase<UIImage>
    ) {
        self.loadProfile = loadProfile
        self.updateAvatar = updateAvatar
        super.init()
    }
}
```
- A single ViewModel can own multiple use cases, each mapped to one business intent.

## Behavior Contracts
- `FComponent+Rx.bind(...)` is Driver-based and should remain UI-safe.
- `UIView`-scoped `disposeBag` is associated-object-backed and should remain lifecycle-tied.
- `ErrorTracker` forwards source errors into its internal stream.
- Use-case contracts in `BaseBlocks` are architecture abstractions only.
  - Intention: define executable boundaries for ViewModels.
  - Non-goal: hosting feature/domain-specific implementations.
- `FButton+Rx` currently provides:
  - title binding convenience initializer
  - `sendTap(to:)` (not available on tvOS)
  - no action-closure convenience initializer in the current API.

## Guardrails For Changes
- Preserve public API compatibility unless explicitly requested.
- Keep driver/observable conversion semantics stable (`completeDriver()` remains non-throwing).
- Avoid introducing blocking or synchronous work inside bind/transform helpers.
- Respect platform guards (`#if !os(tvOS)` for tap binding helpers where applicable).
- Keep use-case protocols lightweight and composable for dependency injection.
- Do not introduce app-specific/domain-specific use-case implementations in this module.
- Add/update tests in `Tests/UIKitRx` for transform and error-tracking behavior changes.

## Validation
- Run package tests after changes:
  - `xcodebuild test -scheme ComponentSystem-Package -destination 'platform=iOS Simulator,id=<SIM_ID>'`
  - `xcodebuild test -scheme ComponentSystem-Package -destination 'platform=tvOS Simulator,id=<SIM_ID>'`
