// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "CombineUIControl",
    platforms: [
        .iOS(.v13),
    ],
    products: [
        .library(
            name: "CombineUIControl",
            targets: ["CombineUIControl"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "CombineUIControl",
            dependencies: []),
        .testTarget(
            name: "CombineUIControlTests",
            dependencies: ["CombineUIControl"]),
    ]
)