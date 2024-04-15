// swift-tools-version: 5.9

/**
 *  ComponentSystem
 *  Copyright (c) Duc Nguyen 2022
 *  Licensed under the MIT license. See LICENSE file.
 */
import PackageDescription

let package = Package(
    name: "ComponentSystem",
    platforms: [
        .iOS(.v15),
        .macOS(.v14)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "DesignCore",
            targets: ["DesignCore"]
        ),
        .library(
            name: "DesignExts",
            targets: ["DesignExts"]
        ),
        .library(
            name: "DesignUI",
            targets: ["DesignUI"]
        ),
        .library(
            name: "DesignUIKit",
            targets: ["DesignUIKit"]
        ),
//        .library(
//            name: "DesignRxUIKit",
//            targets: ["DesignRxUIKit"]
//        ),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/SnapKit/SnapKit.git", .upToNextMajor(from: "5.0.1")),
        .package(url: "https://github.com/kean/Nuke.git", .upToNextMajor(from: "12.4.0")),
//        .package(url: "https://github.com/ReactiveX/RxSwift.git", .upToNextMajor(from: "6.5.0"))
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "DesignCore",
            path: "Sources/Core",
            exclude: [
                "Archived/"
            ]
        ),
        .target(
            name: "DesignExts",
            dependencies: [
                .target(name: "DesignCore")
            ],
            path: "Sources/Exts"
        ),
        .target(
            name: "DesignUI",
            dependencies: [
                .target(name: "DesignCore"),
                .target(name: "DesignExts")
            ],
            path: "Sources/SwiftUI"
        ),
        .target(
            name: "DesignUIKit",
            dependencies: [
                .target(name: "DesignCore"),
                .target(name: "DesignExts"),
                "SnapKit",
                "Nuke"
            ],
            path: "Sources/UIKit"
        ),
        .testTarget(
            name: "DesignCoreTests",
            dependencies: [
                .target(name: "DesignCore")
            ],
            path: "Tests/Core"
        )
//        .target(
//            name: "DesignRxUIKit",
//            dependencies: [
//                .target(name: "DesignUIKit"),
//                .product(name: "RxCocoa", package: "RxSwift")
//            ],
//            path: "Sources/RxUIKit"
//        ),
    ]
)
