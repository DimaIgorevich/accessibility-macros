import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct AccessibilityMacrosPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        AutoAccessibilityIDMacro.self,
        AutoAccessibilityIDsMacro.self
    ]
}
