import Foundation

@attached(accessor)
public macro AutoAccessibilityID(_ value: String? = nil) =
    #externalMacro(
        module: "AccessibilityMacrosMacros",
        type: "AutoAccessibilityIDMacro"
    )

@attached(member, names: named(applyAccessibilityIDs))
public macro AutoAccessibilityIDs(_ prefix: String? = nil) =
    #externalMacro(
        module: "AccessibilityMacrosMacros",
        type: "AutoAccessibilityIDsMacro"
    )
