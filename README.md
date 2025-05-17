# DesignUIKit

A collection of modular Swift frameworks for building elegant, reactive, and customizable UIKit-based applications using declarative patterns and extensible components.

---

## 📦 Overview

- **DesignUIKit**  
  Core UI components, theming system, view builders, and styling protocols for a declarative UIKit architecture.

- **DesignCore**  
  Foundation utilities, builders, protocol abstractions, user preferences, and data helpers to support architecture and logic.

- **DesignExts**  
  Lightweight extensions for UIKit, Foundation, and CoreGraphics providing convenience and syntactic sugar.

- **DesignRxUIKit**  
  RxSwift-powered utilities and base classes to facilitate reactive MVVM patterns with `UIViewController`, `ViewModel`, and `Navigator`.

---

## 🎯 Features

- Fluent and declarative view APIs with `FComponent`, `FView`, `FStack`, `FGrid`, etc.
- Theming system for dynamic light/dark color mapping.
- Font system for scalable and switchable typography.
- Compositional collection and table view abstraction.
- Reusable base views: `BaseView`, `BaseButton`, `BaseLabel`, etc.
- Built-in RxSwift support for view binding, navigation, and view model management.
- Convenient `@Preferences` property wrapper and associated object helpers.

---

## 🧱 Architecture

Each framework is structured to be used independently or together:

| Module           | Depends On              | Description                                 |
|------------------|--------------------------|---------------------------------------------|
| DesignUIKit      | DesignCore, DesignExts   | UIKit components, themes, styling, layout   |
| DesignCore       | Logging, FileKit         | Protocols, helpers, object associations     |
| DesignExts       | —                        | Extensions on UIKit/Foundation/CoreGraphics |
| DesignRxUIKit    | DesignUIKit, RxSwift     | Rx-based ViewModel, Navigator, Controller   |

---

## 🛠 Setup

### Swift Package Manager

You can import the frameworks via SPM by adding the following to your `Package.swift` or Xcode:

```swift
.package(url: "https://github.com/duke6431/DesignUIKit.git", from: "1.0.0")
```

And in your target dependencies:

```swift
.product(name: "DesignUIKit", package: "DesignUIKit"),
.product(name: "DesignCore", package: "DesignUIKit"),
.product(name: "DesignExts", package: "DesignUIKit"),
.product(name: "DesignRxUIKit", package: "DesignUIKit"),
```

### CocoaPods

To install using CocoaPods, add the following to your `Podfile`:

```ruby
pod 'DesignCore'
pod 'DesignExts'
pod 'DesignUIKit'
pod 'DesignRxUIKit'
```

Then run:

```bash
pod install
```

> 💡 Make sure you've added the appropriate source if hosting via GitHub:
```ruby
source 'https://github.com/CocoaPods/Specs.git'
```

---

## 🧪 Requirements

- iOS 13+
- Swift 5.7+
- Xcode 14+
- RxSwift (for DesignRxUIKit only)

---

## 📚 Usage Examples

```swift
FStack(axis: .vertical, spacing: 8) {
    FLabel("Welcome")
        .font(.boldSystemFont(ofSize: 24))
        .foreground(.label)
    FButton("Get Started")
        .onTap {
            print("Button tapped")
        }
}
.padding(16)
```

---

## 🔧 Author

Created with ❤️ by **Duke Nguyen**

---

## 📄 License

MIT License
