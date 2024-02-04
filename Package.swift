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
        .macOS(.v12),
        .tvOS(.v16)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "DesignCore",
            targets: ["DesignCore"]),
        .library(
            name: "DesignUI",
            targets: ["DesignUI"]
        ),
        .library(
            name: "DesignBridge",
            targets: ["DesignBridge"]
        )
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(name: "Logger", path: "../Logger"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "DesignCore",
            path: "Sources/Core"
        ),
        .target(
            name: "DesignUI",
            dependencies: [
                .target(name: "DesignCore")
            ],
            path: "Sources/UI"
        ),
        .target(
            name: "DesignBridge",
            dependencies: [
                .target(name: "DesignCore")
            ],
            path: "Sources/Bridge"
        )
//        .target(
//            name: "DesignBlink",
//                dependencies: [
//            .target(name: "DesignCore")
//        ], 
//            path: "Sources/Blink"
//        )
    ]
)
