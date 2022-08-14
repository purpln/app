// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "app",
    products: [.executable(name: "app", targets: ["app"])],
    dependencies: [.package(url: "https://github.com/PureSwift/BluetoothLinux.git", .branch("master"))],
    targets: [.target(name: "app", dependencies: [.product(name: "BluetoothLinux", package: "BluetoothLinux")])]
)
