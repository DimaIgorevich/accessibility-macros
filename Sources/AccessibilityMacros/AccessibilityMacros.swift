import Foundation

@attached(peer, names: arbitrary)
public macro AutoAccessibilityID(_ value: String? = nil) =
    #externalMacro(
        module: "AccessibilityMacrosMacros",
        type: "AutoAccessibilityIDMacro"
    )

@attached(memberAttribute)
public macro AutoAccessibilityIDs(_ prefix: String? = nil) =
    #externalMacro(
        module: "AccessibilityMacrosMacros",
        type: "AutoAccessibilityIDsMacro"
    )