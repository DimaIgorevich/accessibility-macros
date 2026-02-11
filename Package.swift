// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import CompilerPluginSupport

let package = Package(
    name: "AccessibilityMacros",

    platforms: [
        .iOS(.v15),
        .macOS(.v13)
    ],

    products: [
        .library(
            name: "AccessibilityMacros",
            targets: ["AccessibilityMacros"]
        )
    ],

    dependencies: [
        .package(
            url: "https://github.com/swiftlang/swift-syntax.git",
            from: "601.0.0"
        )
    ],
    
    targets: [

        // MARK: - Macro Implementation
        .macro(
            name: "AccessibilityMacrosMacros",
            dependencies: [
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax")
            ]
        ),

        // MARK: - Public API
        .target(
            name: "AccessibilityMacros",
            dependencies: ["AccessibilityMacrosMacros"]
        ),

        // MARK: - Tests
        .testTarget(
            name: "AccessibilityMacrosTests",
            dependencies: [
                "AccessibilityMacrosMacros",
                .product(
                    name: "SwiftSyntaxMacrosTestSupport",
                    package: "swift-syntax"
                )
            ]
        )
    ]
)
