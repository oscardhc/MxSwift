// swift-tools-version:4.0
import PackageDescription

var targets:[Target] = [
    .target(name: "Antlr4"),
    .target(name: "Parser", dependencies: ["Antlr4"]),
    .target(name: "MxSwift", dependencies: ["Antlr4", "Parser"]),
]

var products: [Product] = [
    .executable(name: "MxSwift", targets: ["MxSwift"])
]

let package = Package(
    name: "MxSwift",
    products: products,
    targets: targets
)
