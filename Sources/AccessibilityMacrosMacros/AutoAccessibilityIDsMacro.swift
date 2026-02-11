import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

/// Class-level macro that automatically applies @AutoAccessibilityID
/// to all IBOutlet UI properties.
public struct AutoAccessibilityIDsMacro: MemberAttributeMacro {

    public static func expansion(
        of node: AttributeSyntax,
        attachedTo declaration: some DeclGroupSyntax,
        providingAttributesFor member: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [AttributeSyntax] {

        guard let varDecl = member.as(VariableDeclSyntax.self) else {
            return []
        }

        // Only apply to @IBOutlet properties
        let hasIBOutlet = varDecl.attributes.contains {
            $0.as(AttributeSyntax.self)?
                .attributeName.description
                .contains("IBOutlet") == true
        }

        guard hasIBOutlet else {
            return []
        }

        return [
            AttributeSyntax(
                attributeName: IdentifierTypeSyntax(
                    name: .identifier("AutoAccessibilityID")
                )
            )
        ]
    }
}
