// swift-tools-version: 5.6

/**
 *  ComponentSystem
 *  Copyright (c) Duc Nguyen 2022
 *  Licensed under the MIT license. See LICENSE file.
 */
import PackageDescription

let package = Package(
    name: "ComponentSystem",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "DesignCore",
            targets: ["DesignCore"]),
        .library(
            name: "DesignToolbox",
            targets: ["DesignToolbox"]
        ),
        .library(
            name: "DesignComponents",
            targets: ["DesignComponents"]
        ),
        .library(
            name: "DesignRx",
            targets: ["DesignRx"]
        )
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(name: "Logger", path: "../Logger"),
        .package(url: "https://github.com/ReactiveX/RxSwift.git", from: "6.5.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "DesignCore",
            path: "Sources/Core"
        ),
        .target(
            name: "DesignToolbox",
            dependencies: [
                .target(name: "DesignCore")
            ],
            path: "Sources/Design"
        ),
        .target(
            name: "DesignComponents",
            dependencies: [
                .target(name: "DesignCore"),
                .target(name: "DesignToolbox")
            ],
            path: "Sources/Components"
        ),
        .target(
            name: "DesignRx",
            dependencies: [
                .target(name: "DesignComponents"),
                .product(name: "RxCocoa", package: "RxSwift")
            ],
            path: "Sources/RxComponents"
        ),
        .testTarget(
            name: "ComponentSystemTests",
            dependencies: ["DesignCore"],
            path: "ComponentSystemTests"
        )
    ]
)
