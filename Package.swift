// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "json-value",
    products: [
        .library(name: "JSONValue", targets: ["JSONValue"])
    ],
    targets: [
        .target(
            name: "JSONValue"
        ),
        .testTarget(
            name: "JSONValueTests",
            dependencies: ["JSONValue"]
        )
    ]
)
