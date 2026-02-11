import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct AutoAccessibilityIDsMacro: MemberMacro {

    public static func expansion(
        of node: AttributeSyntax,
        providingMembersOf declaration: some DeclGroupSyntax,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {

        let helpers = declaration.memberBlock.members.compactMap { member -> String? in
            guard let varDecl = member.decl.as(VariableDeclSyntax.self),
                  varDecl.attributes.contains(where: {
                      $0.as(AttributeSyntax.self)?
                        .attributeName.description
                        .trimmingCharacters(in: .whitespacesAndNewlines)
                        == "AutoAccessibilityID"
                  }),
                  let binding = varDecl.bindings.first,
                  let identifier = binding.pattern.as(IdentifierPatternSyntax.self)
            else { return nil }

            return "__applyAccessibilityID_\(identifier.identifier.text)()"
        }

        guard !helpers.isEmpty else { return [] }

        let calls = helpers.joined(separator: "\n        ")

        return [
            """
            override func awakeFromNib() {
                super.awakeFromNib()
                \(raw: calls)
            }
            """
        ]
    }
}