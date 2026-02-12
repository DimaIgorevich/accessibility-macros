import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct AutoAccessibilityIDMacro: PeerMacro {

    public static func expansion(
        of node: AttributeSyntax,
        providingPeersOf declaration: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {

        guard let varDecl = declaration.as(VariableDeclSyntax.self),
              let binding = varDecl.bindings.first,
              let identifier = binding.pattern.as(IdentifierPatternSyntax.self)
        else {
            return []
        }

        let propertyName = identifier.identifier.text

        // Optional override: @AutoAccessibilityID("auth.loginButton")
        let customID =
            node.arguments?.description
                .replacingOccurrences(of: "\"", with: "")
                .trimmingCharacters(in: .whitespacesAndNewlines)

        let finalID = customID?.isEmpty == false ? customID! : propertyName

        let helperName = "__applyAccessibilityID_\(propertyName)"

        return [
            """
            private func \(raw: helperName)() {
                self.\(raw: propertyName)?.accessibilityIdentifier = true
                self.\(raw: propertyName)?.accessibilityIdentifier = "\(raw: finalID)"
            }
            """
        ]
    }
}
