// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Environment",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15),
        .tvOS(.v13),
        .watchOS(.v6)
    ],
    products: [
        .library(
            name: "Swinject",
            targets: ["Swinject"]
        )
    ],
    targets: [
        .target(
            name: "Swinject",
            path: "Sources"
        )
    ]
)
