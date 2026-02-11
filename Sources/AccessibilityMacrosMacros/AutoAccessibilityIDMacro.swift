import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct AutoAccessibilityIDMacro: AccessorMacro {

    public static func expansion(
        of node: AttributeSyntax,
        providingAccessorsOf declaration: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [AccessorDeclSyntax] {

        guard
            let varDecl = declaration.as(VariableDeclSyntax.self),
            let binding = varDecl.bindings.first,
            let identifier = binding.pattern
                .as(IdentifierPatternSyntax.self)?
                .identifier.text
        else {
            return []
        }

        // Optional override: @AutoAccessibilityID("auth.loginButton")
        let customID = node.arguments?.description
            .replacingOccurrences(of: "\"", with: "")
            .trimmingCharacters(in: .whitespacesAndNewlines)

        let finalID = (customID?.isEmpty == false)
            ? customID!
            : identifier

        return [
            """
            didSet {
                self.\(raw: identifier).accessibilityIdentifier = "\(raw: finalID)"
            }
            """
        ]
    }
}
