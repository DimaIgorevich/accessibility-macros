# AccessibilityMacros

Swift Macros for automatically generating `accessibilityIdentifier` values in UIKit.

This package helps you avoid manually assigning accessibility IDs across your app,
while keeping UI tests stable, readable, and consistent.

---

## ✨ Features

✅ Automatically assigns `accessibilityIdentifier` to UI elements  
✅ Generates stable IDs using `Type.property` prefix  
✅ Supports custom overrides  
✅ Apply IDs to entire UIKit classes via `@IBOutlet` scanning  
✅ Designed for UI testing reliability  
✅ Includes full unit test coverage with SwiftSyntaxMacroTesting  

---

## 📦 Installation

### Swift Package Manager

Add the package dependency in Xcode:

**File → Add Packages…**

Or directly in `Package.swift`:

```swift
.package(
    url: "https://github.com/Dimalgorevich/accessibility-macros",
    from: "1.1.1"
)
```

Then add the product:

```swift
.product(name: "AccessibilityMacros", package: "accessibility-macros")
```

---

## 🚀 Usage

Import the package:

```swift
import AccessibilityMacros
```

---

## ✅ Property Macro

Apply `@AutoAccessibilityID` directly to a UIKit property:

```swift
final class LoginView: UIView {

    @AutoAccessibilityID
    var loginButton: UIButton
}
```

### Generated expansion:

```swift
var loginButton: UIButton {
    didSet {
        self.loginButton.accessibilityIdentifier = "LoginView.loginButton"
    }
}
```

So your UI tests can reliably reference:

```
LoginView.loginButton
```

---

## 🎯 Custom Identifier Override

You can provide your own explicit ID:

```swift
@AutoAccessibilityID("auth.loginButton")
var loginButton: UIButton
```

Expansion:

```swift
self.loginButton.accessibilityIdentifier = "auth.loginButton"
```

Custom values always override auto-generated prefixes.

---

## 🏷 Class-Level Macro (IBOutlets)

You can apply IDs automatically to **all `@IBOutlet` UI properties**
inside a class:

```swift
@AutoAccessibilityIDs
final class LoginView: UIView {

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var passwordField: UITextField!

    var viewModel: LoginViewModel
}
```

### Result:

- `@IBOutlet` properties receive `@AutoAccessibilityID`
- Non-outlet properties are ignored

Generated identifiers:

```
LoginView.loginButton
LoginView.passwordField
```

---

## ✅ Best Practices

This package is intended for:

- UI automation testing (XCTest / XCUITest)
- Accessibility consistency
- Reducing boilerplate in UIKit codebases

Recommended ID format:

```
TypeName.propertyName
```

Example:

```
LoginView.loginButton
CheckoutView.payButton
ProfileView.logoutButton
```

---

## 🧪 Testing

This package includes full macro expansion tests using:

- `SwiftSyntaxMacrosTestSupport`
- `assertMacroExpansion`

Run all tests with:

```bash
swift test
```

---

## 📌 Requirements

- Swift 6.0+
- Xcode 16+
- iOS 13+
- macOS 10.15+

---

## 📄 License

MIT License

---

## 🤝 Contributing

Pull requests, ideas, and improvements are welcome!

If you'd like to add:

- enum-based ID generation
- SwiftUI support
- didSet merging
- global namespace control

Feel free to open an issue or PR.

---

## ⭐ Author

Built with ❤️ for UIKit developers who are tired of writing:

```swift
view.accessibilityIdentifier = "some.random.string"
```

Enjoy clean UI testing ✨
