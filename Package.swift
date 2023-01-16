// swift-tools-version:5.7

import PackageDescription

let package = Package(
    name: "app",
    products: [.executable(name: "app", targets: ["Application"])],
    dependencies: [
        .package(url: "https://github.com/purpln/loop.git", branch: "main")
    ],
    targets: [
        .executableTarget(name: "Application", dependencies: [
            .target(name: "Architecture")
        ]),
        .target(name: "Architecture", dependencies: [
            .product(name: "Loop", package: "loop")
        ]),
        .target(name: "File"),
        .target(name: "JSON"),
    ]
)

#if os(macOS) || os(iOS)
package.platforms = [.macOS(.v13), .iOS(.v16)]
#endif
