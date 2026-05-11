// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "mt_carplay",
  platforms: [
    .iOS("14.0")
  ],
  products: [
    .library(name: "mt-carplay", targets: ["mt_carplay"])
  ],
  dependencies: [
    .package(name: "FlutterFramework", path: "../FlutterFramework")
  ],
  targets: [
    .target(
      name: "mt_carplay",
      dependencies: [
        .product(name: "FlutterFramework", package: "FlutterFramework")
      ],
      resources: []
    )
  ]
)
