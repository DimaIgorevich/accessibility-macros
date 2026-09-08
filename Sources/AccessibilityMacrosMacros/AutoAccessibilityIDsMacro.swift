import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct AutoAccessibilityIDsMacro: MemberMacro {

    public static func expansion(
        of node: AttributeSyntax,
        providingMembersOf declaration: some DeclGroupSyntax,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {

        // MARK: - Parse prefix argument

        let prefix: String? = node.arguments?
            .as(LabeledExprListSyntax.self)?
            .first?
            .expression
            .as(StringLiteralExprSyntax.self)?
            .segments
            .compactMap { $0.as(StringSegmentSyntax.self)?.content.text }
            .joined()

        // MARK: - Extract all IBOutlet properties

        let outletNames: [String] = declaration.memberBlock.members.compactMap { member in

            guard let varDecl = member.decl.as(VariableDeclSyntax.self) else {
                return nil
            }

            // Must contain @IBOutlet
            let hasIBOutlet = varDecl.attributes.contains(where: { attr in
                attr.as(AttributeSyntax.self)?
                    .attributeName
                    .description
                    .trimmingCharacters(in: .whitespacesAndNewlines) == "IBOutlet"
            })

            guard hasIBOutlet else { return nil }

            // Extract property name
            guard let binding = varDecl.bindings.first,
                  let identifier = binding.pattern.as(IdentifierPatternSyntax.self)?.identifier.text
            else {
                return nil
            }

            let isLayoutConstraint = binding.typeAnnotation?.type.tokens(viewMode: .sourceAccurate)
                .contains { $0.tokenKind == .identifier("NSLayoutConstraint") } ?? false
            guard !isLayoutConstraint else { return nil }

            return identifier
        }

        // Nothing to generate
        guard outletNames.isEmpty == false else {
            return []
        }

        // MARK: - Build applyAccessibilityIDs() body

        let assignments: [String] = outletNames.map { name in

            let id: String
            if let prefix {
                id = "\(prefix).\(name)"
            } else {
                // Default: TypeName.outletName
                let typeName =
                    declaration.as(ClassDeclSyntax.self)?.name.text ??
                    declaration.as(StructDeclSyntax.self)?.name.text ??
                    declaration.as(ActorDeclSyntax.self)?.name.text ??
                    "UnknownType"

                id = "\(typeName).\(name)"
            }

            return """
            \(name).accessibilityIdentifier = "\(id)"
            """
        }

        // MARK: - Generate method

        let method: DeclSyntax =
        """
        func applyAccessibilityIDs() {
        \(raw: assignments.joined(separator: "\n\n"))
        }
        """

        return [method]
    }
}
