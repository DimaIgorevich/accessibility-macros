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

        guard let varDecl = declaration.as(VariableDeclSyntax.self),
              let binding = varDecl.bindings.first,
              let identifier = binding.pattern
                .as(IdentifierPatternSyntax.self)?
                .identifier.text
        else {
            return []
        }

        // Prevent overriding existing didSet/get/set
        if binding.accessorBlock != nil {
            return []
        }

        // Parse optional custom ID argument
        var customID: String? = nil

        if let arguments = node.arguments?.as(LabeledExprListSyntax.self),
           let first = arguments.first,
           let literal = first.expression.as(StringLiteralExprSyntax.self) {

            customID = literal.segments.compactMap {
                $0.as(StringSegmentSyntax.self)?.content.text
            }.joined()
        }

        // Find enclosing type name for prefix
        let parentType =
            context.lexicalContext
                .compactMap { $0.as(ClassDeclSyntax.self)?.name.text }
                .first
            ?? context.lexicalContext
                .compactMap { $0.as(StructDeclSyntax.self)?.name.text }
                .first

        let generatedID: String
        if let customID {
            generatedID = customID
        } else if let parentType {
            generatedID = "\(parentType).\(identifier)"
        } else {
            generatedID = identifier
        }

        return [
            """
            didSet {
                self.\(raw: identifier).accessibilityIdentifier = "\(raw: generatedID)"
            }
            """
        ]
    }
}
