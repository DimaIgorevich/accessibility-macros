import XCTest
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport

#if canImport(AccessibilityMacrosMacros)
import AccessibilityMacrosMacros
#endif

final class AccessibilityMacrosTests: XCTestCase {

    // MARK: - Property Macro

    func testAutoAccessibilityIDGeneratesPrefixedIdentifier() throws {
        #if canImport(AccessibilityMacrosMacros)

        assertMacroExpansion(
            """
            final class LoginView: UIView {
                @AutoAccessibilityID
                var loginButton: UIButton
            }
            """,
            expandedSource: """
            final class LoginView: UIView {
                var loginButton: UIButton {
                    didSet {
                        self.loginButton.accessibilityIdentifier = "LoginView.loginButton"
                    }
                }
            }
            """,
            macros: [
                "AutoAccessibilityID": AutoAccessibilityIDMacro.self
            ]
        )

        #else
        throw XCTSkip("Macros are only supported when running tests on the host platform")
        #endif
    }

    func testAutoAccessibilityIDWithCustomValueOverridesPrefix() throws {
        #if canImport(AccessibilityMacrosMacros)

        assertMacroExpansion(
            """
            final class LoginView: UIView {
                @AutoAccessibilityID("auth.loginButton")
                var loginButton: UIButton
            }
            """,
            expandedSource: """
            final class LoginView: UIView {
                var loginButton: UIButton {
                    didSet {
                        self.loginButton.accessibilityIdentifier = "auth.loginButton"
                    }
                }
            }
            """,
            macros: [
                "AutoAccessibilityID": AutoAccessibilityIDMacro.self
            ]
        )

        #else
        throw XCTSkip("Macros are only supported when running tests on the host platform")
        #endif
    }

    // MARK: - Class Macro

    func testAutoAccessibilityIDsAppliesToIBOutletOnly() throws {
        #if canImport(AccessibilityMacrosMacros)

        assertMacroExpansion(
            """
            @AutoAccessibilityIDs
            final class LoginView: UIView {
                @IBOutlet weak var loginButton: UIButton!
                var viewModel: LoginViewModel
            }
            """,
            expandedSource: """
            final class LoginView: UIView {
                @IBOutlet
                @AutoAccessibilityID weak var loginButton: UIButton!
                var viewModel: LoginViewModel
            }
            """,
            macros: [
                "AutoAccessibilityIDs": AutoAccessibilityIDsMacro.self
            ]
        )

        #else
        throw XCTSkip("Macros are only supported when running tests on the host platform")
        #endif
    }

}
