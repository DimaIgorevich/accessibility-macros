// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import CompilerPluginSupport

let package = Package(
    name: "AccessibilityMacros",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15),
        .tvOS(.v13),
        .watchOS(.v6)
    ],
    products: [
        .library(
            name: "AccessibilityMacros",
            targets: ["AccessibilityMacros"]
        )
    ],
    dependencies: [
        // Swift 5.9 toolchain → swift-syntax 509.x
        .package(url: "https://github.com/swiftlang/swift-syntax.git", exact: "509.0.0")
    ],
    targets: [
        .macro(
            name: "AccessibilityMacrosMacros",
            dependencies: [
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax")
            ]
        ),
        .target(
            name: "AccessibilityMacros",
            dependencies: ["AccessibilityMacrosMacros"]
        ),
        .testTarget(
            name: "AccessibilityMacrosTests",
            dependencies: [
                "AccessibilityMacrosMacros",
                .product(name: "SwiftSyntaxMacrosTestSupport", package: "swift-syntax")
            ]
        )
    ]
)
