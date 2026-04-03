# DesignUIKit Package Guide For AI Agents

## Scope
- This guide applies to the entire package at repository root.
- Use it as the entry point, then follow the module-specific guides below.
- `Archived/` folders under sources are excluded in `Package.swift`; do not use archived APIs for new code.

## Package Purpose
- Provide a modular UI toolkit for Apple platforms, split into:
  - `DesignCore`: shared utilities, builders, preference wrappers, attributed string helpers.
  - `DesignExts`: focused UIKit extensions (color, layer, size helpers).
  - `DesignExternal`: wrappers for externally re-exported dependencies.
  - `DesignUIKit`: primary UIKit and SwiftUIKit component layer.
  - `DesignCombineUIKit`: Combine bindings for UIKit components.
  - `DesignRxUIKit`: RxSwift/RxCocoa bindings for UIKit components.

## Module Guides
- Core: [Sources/Core/AGENTS.md](Sources/Core/AGENTS.md)
- Exts: [Sources/Exts/AGENTS.md](Sources/Exts/AGENTS.md)
- External: [Sources/ExternalPackages/AGENTS.md](Sources/ExternalPackages/AGENTS.md)
- UIKit: [Sources/UIKit/AGENTS.md](Sources/UIKit/AGENTS.md)
- UIKit+Combine: [Sources/UIKit+Combine/AGENTS.md](Sources/UIKit+Combine/AGENTS.md)
- UIKit+Rx: [Sources/UIKit+Rx/AGENTS.md](Sources/UIKit+Rx/AGENTS.md)

## Dependency Direction
- Keep dependency flow one-way:
  - `DesignCore` -> foundation utilities only
  - `DesignExts` depends on `DesignCore`
  - `DesignUIKit` depends on `DesignCore`, `DesignExts`, `DesignExternal`
  - `DesignCombineUIKit` and `DesignRxUIKit` extend `DesignUIKit`; do not move reactive concerns into base UIKit module
- Avoid introducing circular dependencies between targets.

## MVVM Intention For Reactive Base Blocks
- `DesignRxUIKit` and `DesignCombineUIKit` base blocks define architecture contracts, not feature business logic.
- Use-case protocols in `Sources/UIKit+Rx/BaseBlocks` and `Sources/UIKit+Combine/BaseBlocks` are blueprint interfaces to support MVVM composition.
- ViewModels may coordinate multiple use cases (one per business intent).
- Keep concrete use-case implementations in feature/domain modules and inject them into ViewModels.

## Cross-Package Guardrails
- Preserve source compatibility for public API unless a breaking change is explicitly requested.
- Keep platform support aligned with package settings (`iOS`, `tvOS`; no macOS requirement).
- Keep safety behavior intact for known crash-sensitive areas:
  - child view-controller containment in `FViewController`
  - section/item bounds in list/collection adapters and layout providers
- Prefer adding behavior in extensions or new types over changing established core semantics.
- When changing behavior, add or update tests in the matching `Tests/*` module.

## Validation
- Preferred (full package on Apple platforms):
  - `xcodebuild test -scheme DesignUIKit-Package -destination 'platform=iOS Simulator,id=<SIM_ID>'`
  - `xcodebuild test -scheme DesignUIKit-Package -destination 'platform=tvOS Simulator,id=<SIM_ID>'`
- Optional host sanity:
  - `swift test` (can fail on macOS due dependency platform requirements; prefer `xcodebuild` commands above for authoritative validation)
