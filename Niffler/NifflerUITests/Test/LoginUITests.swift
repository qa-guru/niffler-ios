import XCTest

final class LoginUITests: TestCase {
    
    @MainActor
    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        app.textFields["userNameTextField"].tap()
        app.textFields["userNameTextField"].typeText("stage")
        app.secureTextFields["passwordTextField"].tap()
        app.secureTextFields["passwordTextField"].typeText("12345")
        app.buttons["loginButton"].tap()
        let _ = app.scrollViews.switches.firstMatch.waitForExistence(timeout: 3)
        XCTAssertGreaterThanOrEqual(app.scrollViews.switches.count, 1)
        
        
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    
    func testRegistration() throws {
        let app = XCUIApplication()
        app.launch()
        let login = "taty"
        let password = "12345"

        app.staticTexts["Create new account"].tap()
        XCTAssert(app.staticTexts["Sign Up"].waitForExistence(timeout: 3))
        
        let userNameField = app.textFields["userNameTextField"].firstMatch
        userNameField.tap()
        userNameField.typeText(login)
        
        app.buttons["passwordTextField"].firstMatch.tap()
        let passwordField = app.textFields["passwordTextField"].firstMatch
        passwordField.tap()
        passwordField.typeText(password)
        
        app.buttons["passwordTextField"].firstMatch.tap()
        let passwordConfirmField = app.secureTextFields["confirmPasswordTextField"].firstMatch
        passwordConfirmField.tap()
        passwordConfirmField.typeText(password)
        
        app.buttons["Return"].firstMatch.tap()
        app.buttons["Sign Up"].firstMatch.tap()
        
        XCTAssertEqual("Congratulations!", app.alerts.firstMatch.label)
        
        app.buttons["Log in"].firstMatch.tap()
        
        XCTAssertEqual(login, app.textFields["userNameTextField"].firstMatch.value as? String)
        app.buttons["ic_show_hide"].tap()
        XCTAssertEqual(password, app.textFields["passwordTextField"].firstMatch.value as? String)
    }
}
