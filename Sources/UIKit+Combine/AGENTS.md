# DesignCombineUIKit Guide For AI Agents

## Scope
- This guide applies to `Sources/UIKit+Combine` (`DesignCombineUIKit` target).
- `Archived/` is excluded from the target in `Package.swift`; do not use archived files for new code.

## What DesignCombineUIKit Provides
- Combine-enabled base blocks (`BaseBlocks/*`):
  - `BaseViewModel`, `BaseViewController`, `BaseCoordinating`
  - Use-case contracts: `UseCase`, `CompletableUseCase`, `StreamUseCase`
- Combine binding support for UIKit components:
  - `FComponent+Combine` (`FBinder`, `Combinable`, `bind(to:next:error:complete:)`)
  - view binders for `FLabel`, `FButton`, `FTextField`, `FTextView`, `FImage`
- Combine utility operators (`Wrapper/Combine+.swift`):
  - `compacted`, `void`, `toggle`, `invertFilter`, `cast`, `optionalCast`, `erased`, sink helpers
- Preference wrapper (`Wrapper/FObservedPreference.swift`):
  - `@FObservedPreference<T>` backed by `UserDefaults` and `@Published`

## Preferred Usage Patterns

### 1) UI binding
```swift
button.bind(to: titlePublisher) { button, title in
    button.setTitle(title, for: .normal)
}
```

### 2) Combine wrappers
```swift
let values = [1, nil, 2].publisher.compacted()
let toggled = [true, false].publisher.toggle()
```

### 3) Observed preferences
```swift
@FObservedPreference("feature_enabled", default: false) var enabled: Bool
```

### 4) ViewModel + UseCase composition
```swift
final class ProfileViewModel: BaseViewModel {
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
- `FComponent+Combine.bind(...)` must keep delivery on main queue for UI updates.
- `FObservedPreference` keys are `FPreferenceKey` (use string literals that infer `FPreferenceKey`).
- `FObservedPreference` writes through to `UserDefaults` on value change.
- Use-case contracts in `BaseBlocks` are architecture abstractions only.
  - Intention: define executable boundaries for ViewModels.
  - Non-goal: hosting feature/domain-specific implementations.

## Guardrails For Changes
- Preserve non-breaking API surface for `FBinder` and extension initializers.
- Maintain associated-object storage for `cancellables` on `UIView`.
- Avoid adding side effects in operator helpers beyond documented transforms.
- Keep base blocks and wrappers framework-agnostic (no app-specific logic).
- Keep use-case protocols lightweight and composable for dependency injection.
- Do not introduce app-specific/domain-specific use-case implementations in this module.
- Add/update tests in `Tests/UIKitCombine` for wrapper behavior and preference observation.

## Validation
- Run package tests after changes:
  - `xcodebuild test -scheme ComponentSystem-Package -destination 'platform=iOS Simulator,id=<SIM_ID>'`
  - `xcodebuild test -scheme ComponentSystem-Package -destination 'platform=tvOS Simulator,id=<SIM_ID>'`
