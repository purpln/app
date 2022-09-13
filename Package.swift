// swift-tools-version:5.7

import PackageDescription

let package = Package(
    name: "app",
    products: [.executable(name: "app", targets: ["Application"])],
    dependencies: [.package(url: "https://github.com/PureSwift/BluetoothLinux.git", branch: "master")],
    targets: [
        .executableTarget(name: "Application", dependencies: [
            .target(name: "Architecture"),
            .product(name: "BluetoothLinux", package: "BluetoothLinux")
        ], swiftSettings: [
            .unsafeFlags(["-Xfrontend", "-experimental-hermetic-seal-at-link"])
        ]),
        .target(name: "Architecture")
    ], cxxLanguageStandard: .cxx17
)
