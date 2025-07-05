// swift-tools-version: 6.1
import PackageDescription

let package = Package(
  name: "EntityStore",
  platforms: [
    .iOS(.v15)
  ],
  products: [
    .library(
      name: "EntityStore",
      targets: ["EntityStore"]
    ),
  ],
  targets: [
    .target(
      name: "EntityStore"
    ),
  ]
)
