@testable import Niffler
import XCTest
import BindMacro

class LoginPage: BasePage {
    
    init(app: XCUIApplication) {
        super.init(app: app, viewTypes: [LoginView.self])
    }
    
    private var userNameInput: XCUIElement {
        #bind(app.textFields["userNameTextField"])
    }
    
    private var passwordInput: XCUIElement {
        #bind(app.secureTextFields["passwordTextField"])
    }
    
    private var loginButton: XCUIElement {
        #bind(app.buttons["loginButton"])
    }
    
    private var loginError: XCUIElement {
        #bind(app.staticTexts["LoginError"])
    }
    
    @discardableResult
    func input(login: String, password: String) -> Self {
        XCTContext.runActivity(named: "Авторизуюсь \(login), \(password)") { _ in
            input(login: login)
            input(password: password)
            pressLoginButton()
        }
        return self
    }
    
    private func input(login: String) {
        XCTContext.runActivity(named: "Ввожу логин \(login)") { _ in
            userNameInput.tap()
            userNameInput.tap() // TODO: Remove the cause of double tap
            userNameInput.typeText(login)
        }
    }
    
    private func input(password: String) {
        XCTContext.runActivity(named: "Ввожу пароль \(password)") { _ in
            passwordInput.tap()
            passwordInput.typeText(password)
        }
    }
    
    private func pressLoginButton() {
        XCTContext.runActivity(named: "Жму кнопку логина") { _ in
            loginButton.tap()
        }
    }
    
    func assertIsLoginErrorShown(file: StaticString = #filePath, line: UInt = #line) {
        XCTContext.runActivity(named: "Жду сообщение с ошибкой") { _ in
            let isFound = loginError
                .waitForExistence(timeout: 5)
            
            XCTAssertTrue(isFound,
                          "Не нашли сообщение о неправильном логине",
                          file: file, line: line)
        }
    }
    
    func assertNoErrorShown(file: StaticString = #filePath, line: UInt = #line) {
        XCTContext.runActivity(named: "Жду сообщение с ошибкой") { _ in
            let errorLabel = #bindNamed(
                "errorLabel",
                app.staticTexts[
                    "LoginError"
                    //"Нет такого пользователя. Попробуйте другие данные"
                ])
            
                
            let isFound = errorLabel.waitForExistence(timeout: 5)
            
            XCTAssertFalse(isFound,
                           "Появилась ошибка: \(errorLabel.label)",
                          file: file, line: line)
        }
    }
}
