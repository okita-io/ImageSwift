// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "ImageSwift",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .library(
            name: "ImageSwiftLib",
            targets: ["ImageSwiftLib"]
        )
    ],
    targets: [
        .target(
            name: "ImageSwiftLib",
            path: "Sources/ImageSwiftLib"
        ),
        .executableTarget(
            name: "ImageSwift",
            dependencies: ["ImageSwiftLib"],
            path: "Sources/ImageSwift"
        )
    ]
)
