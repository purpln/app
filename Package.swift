// swift-tools-version:5.7

import PackageDescription

let loop: [Target.Dependency]
#if os(Linux)
loop = ["CEpoll"]
#else
loop = []
#endif

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
        .target(name: "Loop", dependencies: loop),
        .target(name: "File"),
        .target(name: "JSON"),
    ]
)

#if os(macOS) || os(iOS)
package.platforms = [.macOS(.v13), .iOS(.v11)]
#elseif os(Linux)
package.targets.append(.systemLibrary(name: "CEpoll"))
#endif
