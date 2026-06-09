// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "ImageSwift",
    platforms: [
        .macOS(.v13)
    ],
    targets: [
        .executableTarget(
            name: "ImageSwift",
            path: "Sources/ImageSwift"
        )
    ]
)
