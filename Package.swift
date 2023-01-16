// swift-tools-version:5.7

import PackageDescription

let package = Package(
    name: "app",
    products: [.executable(name: "app", targets: ["Application"])],
    dependencies: [
        
    ],
    targets: [
        .executableTarget(name: "Application", dependencies: [
            .target(name: "Architecture")
        ]),
        .target(name: "Architecture", dependencies: [
            .target(name: "Loop")
        ]),
        .target(name: "Loop"),
        .target(name: "File"),
        .target(name: "JSON"),
    ]
)
