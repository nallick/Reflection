// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "Reflection",
    platforms: [.iOS(.v10), .macOS(.v10_12)],
    products: [
        .library(
            name: "Reflection",
            targets: ["Reflection"]),
    ],
    dependencies: [
        .package(url: "https://github.com/nallick/BaseSwift.git", from: "1.0.0"),
        .package(url: "https://github.com/wickwirew/Runtime.git", from: "2.1.1"),
    ],
    targets: [
        .target(
            name: "Reflection",
            dependencies: ["BaseSwift", "Runtime"]),
        .testTarget(
            name: "ReflectionTests",
            dependencies: ["Reflection", "Runtime"]),
    ]
)
