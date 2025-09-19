// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "HowardCommon",
    platforms: [
        .iOS(.v16),
        .macOS(.v11)
    ],
    products: [
        .library(
            name: "HowardCommon",
            targets: ["HowardCommon"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "HowardCommon",
            dependencies: []),
        .testTarget(
            name: "HowardCommonTests",
            dependencies: ["HowardCommon"]),
    ]
)
