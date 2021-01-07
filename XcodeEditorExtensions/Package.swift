// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "XcodeEditorExtensions",
    platforms: [.macOS(.v11)],
    products: [
        .library(
            name: "XcodeEditorExtensions",
            targets: ["XcodeEditorExtensions"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "XcodeEditorExtensions",
            dependencies: []
        ),
        .testTarget(
            name: "XcodeEditorExtensionsTests",
            dependencies: ["XcodeEditorExtensions"]
        ),
    ]
)
