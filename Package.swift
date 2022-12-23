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
        .iOS(.v12)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "DesignCore",
            targets: ["Core"]),
        .library(
            name: "DesignToolbox",
            targets: ["Design"]
        ),
        .library(
            name: "DesignComponents",
            targets: ["Components"]
        ),
        .library(
            name: "DesignRx",
            targets: ["RxComponents"]
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
            name: "Core",
            path: "Sources/Core"
        ),
        .target(
            name: "Design",
            path: "Sources/Design"
        ),
        .target(
            name: "Components",
            dependencies: [
                .target(name: "Core"),
                .target(name: "Design")
            ],
            path: "Sources/Components"
        ),
        .target(
            name: "RxComponents",
            dependencies: [
                .target(name: "Components"),
                .product(name: "RxCocoa", package: "RxSwift")
            ],
            path: "Sources/RxComponents"
        ),
        .testTarget(
            name: "ComponentSystemTests",
            dependencies: ["Core"],
            path: "ComponentSystemTests"
        )
    ]
)
