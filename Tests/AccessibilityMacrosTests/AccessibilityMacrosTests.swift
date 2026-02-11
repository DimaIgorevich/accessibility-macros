import XCTest
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport

#if canImport(AccessibilityMacrosMacros)
import AccessibilityMacrosMacros

let testMacros: [String: Macro.Type] = [
    "AutoAccessibilityID": AutoAccessibilityIDMacro.self,
    "AutoAccessibilityIDs": AutoAccessibilityIDsMacro.self
]
#endif

final class AccessibilityMacrosTests: XCTestCase {

    func testAutoAccessibilityIDGeneratesIdentifier() throws {
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
                        self.loginButton.accessibilityIdentifier = "loginButton"
                    }
                }
            }
            """,
            macros: testMacros
        )

        #else
        throw XCTSkip("Macros are only supported when running tests for the host platform")
        #endif
    }

    func testAutoAccessibilityIDWithCustomValueOverridesIdentifier() throws {
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
            macros: testMacros
        )

        #else
        throw XCTSkip("Macros are only supported when running tests for the host platform")
        #endif
    }

    func testAutoAccessibilityIDsAppliesToIBOutletOnly() throws {
        #if canImport(AccessibilityMacrosMacros)

        assertMacroExpansion(
            """
            final class LoginView: UIView {

                @IBOutlet
                @AutoAccessibilityID
                weak var loginButton: UIButton!

                var viewModel: LoginViewModel
            }
            """,
            expandedSource: """
            final class LoginView: UIView {

                @IBOutlet
                weak var loginButton: UIButton! {
                    didSet {
                        self.loginButton.accessibilityIdentifier = "loginButton"
                    }
                }

                var viewModel: LoginViewModel
            }
            """,
            macros: testMacros
        )

        #else
        throw XCTSkip("Macros are only supported when running tests for the host platform")
        #endif
    }
}
