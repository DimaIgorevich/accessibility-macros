import UIKit
import accessibility_macros

final class LoginView: UIView {

    @AutoAccessibilityID
    var loginButton: UIButton = UIButton()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupAccessibility_loginButton()
        print("ID =", loginButton.accessibilityIdentifier ?? "nil")
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
}

_ = LoginView(frame: .zero)
