// swift-tools-version: 6.0

import PackageDescription

let package = Package(
  name: "MetalDeviceInfo",
  platforms: [
    .macOS(.v14)
  ],
  products: [
    .library(name: "MetalDeviceInfo", targets: ["MetalDeviceInfo"]),
    .library(name: "FpUtil", targets: ["FpUtil"]),
  ],
  dependencies: [
    .package(url: "https://github.com/realm/SwiftLint", from: "0.58.2")
  ],
  targets: [
    .target(name: "MetalDeviceInfo"),
    .target(name: "FpUtil"),
    .testTarget(
      name: "MetalDeviceInfoTests",
      dependencies: ["MetalDeviceInfo"]
    ),
  ]
)
