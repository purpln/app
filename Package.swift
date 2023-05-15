// swift-tools-version:5.7

import PackageDescription

let package = Package(
    name: "app",
    products: [
        .executable(name: "app", targets: ["Application"])
    ],
    dependencies: [
        .package(url: "https://github.com/purpln/loop.git", branch: "main"),
        .package(url: "https://github.com/purpln/network.git", branch: "main"),
    ],
    targets: [
        .executableTarget(name: "Application", dependencies: [
            .target(name: "Architecture"),
            .target(name: "Internal"),
            .target(name: "Link"),
            .product(name: "Network", package: "network"),
        ]),
        .target(name: "Architecture", dependencies: [
            .product(name: "Loop", package: "loop"),
        ]),
        .target(name: "File"),
        .target(name: "Internal"),
        .target(name: "JSON"),
        .target(name: "Link"),
    ]
)

#if os(macOS) || os(iOS) || os(watchOS) || os(tvOS)
package.platforms = [.macOS(.v13), .iOS(.v16), .watchOS(.v9), .tvOS(.v16)]
#endif
