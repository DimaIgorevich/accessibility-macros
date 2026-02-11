import Foundation

@attached(accessor)
public macro AutoAccessibilityID(_ value: String? = nil) =
    #externalMacro(module: "AccessibilityMacrosMacros", type: "AutoAccessibilityIDMacro")

@attached(memberAttribute)
public macro AutoAccessibilityIDs() =
    #externalMacro(module: "AccessibilityMacrosMacros", type: "AutoAccessibilityIDsMacro")
