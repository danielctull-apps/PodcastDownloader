// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "PodcastDownloader",
    platforms: [
        .macOS(.v10_13),
    ],
    products: [
        .executable(name: "PodcastDownloader", targets: ["PodcastDownloader"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "0.0.1"),
        .package(url: "https://github.com/danielctull/Resourceful", .branch("main")),
        .package(url: "https://github.com/MaxDesiatov/XMLCoder.git", from: "0.10.0"),
    ],
    targets: [

        .target(name: "PodcastDownloader", dependencies: [
            .product(name: "ArgumentParser", package: "swift-argument-parser"),
            "PodcastKit",
            "Resourceful",
        ]),

        .target(name: "PodcastKit", dependencies: [
            "Resourceful",
            "XMLCoder",
        ]),
    ]
)
    
