// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "FluxSwift",
    products: [
        .library(name: "FluxSwift", targets: ["FluxSwift"]),
    ],
    dependencies: [
        .package(url: "https://github.com/ReactiveX/RxSwift.git", from: "5.0.1"),
    ],
    targets: [
        .target(name: "FluxSwift", dependencies: ["RxSwift", "RxRelay"]),
        .testTarget(name: "FluxSwiftTests", dependencies: ["FluxSwift"]),
    ]
)
