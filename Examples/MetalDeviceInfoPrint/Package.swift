// swift-tools-version: 6.0

import PackageDescription

let package = Package(
  name: "MetalDeviceInfoPrint",
  platforms: [
    .macOS(.v14)
  ],
  dependencies: [
    .package(url: "https://github.com/realm/SwiftLint", from: "0.58.2"),
    .package(path: "../.."),
  ],
  targets: [
    .executableTarget(
      name: "MetalDeviceInfoPrint",
      dependencies: [
        .product(name: "FpUtil", package: "sw-metal-device-info"),
        .product(name: "MetalDeviceInfo", package: "sw-metal-device-info"),
      ]
    )
  ]
)
