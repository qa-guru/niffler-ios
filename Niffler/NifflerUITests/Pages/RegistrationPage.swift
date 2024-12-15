//
//  RegistrationPage.swift
//  NifflerUITests
//
//  Created by Orxan on 15.12.24.
//

import XCTest

class RegistrationPage: BasePage  {
    func getRegContainer() -> XCUIElement {
        return app.otherElements.containing(.staticText, identifier: "Sign Up").element
    }
    
    func checkSuccessRegistration() {
        XCTContext.runActivity(named: "Проверяю наличие модального окна успешной регистрации") { _ in
            app.staticTexts["Congratulations"].waitForExistence(timeout: 5)
            XCTAssertTrue(app.staticTexts[" You've registered!"].exists)
            pressLogInButtonInAlert()
        }
    }
    
    func checkFilledRegistrationForm(username: String, form: XCUIElement) {
        XCTContext.runActivity(named: "Проверяю что форма регистрации заполнена \(username)") { _ in
            XCTAssertEqual(form.textFields["userNameTextField"].value as? String, username)
            let passwordFieldValue = form.secureTextFields["passwordTextField"].value as? String
            let confirmPasswordFieldValue = form.secureTextFields["confirmPasswordTextField"].value as? String
            XCTAssertNotNil(passwordFieldValue)
            XCTAssertNotNil(confirmPasswordFieldValue)
        }
    }

    func signUp(login: String, password: String, confirmPassword: String, form: XCUIElement) -> Self {
        XCTContext.runActivity(named: "Заполняю форму регистрации \(login), \(password), \(confirmPassword)") { _ in
            input(login: login, container: form)
            input(password: password, container: form)
            input(confirmPassword: confirmPassword, container: form)
            closeKeyboard()
            pressSignUpButton(container: form)
        }
        return self
    }
    
    func input(login: String, container: XCUIElement) {
        XCTContext.runActivity(named: "Ввожу логин \(login)") { _ in
            container.textFields["userNameTextField"].tap()
            container.textFields["userNameTextField"].typeText(login)
        }
    }
    
    func input(password: String, container: XCUIElement) {
        XCTContext.runActivity(named: "Ввожу пароль \(password)") { _ in
            container.secureTextFields["passwordTextField"].tap()
            container.secureTextFields["passwordTextField"].typeText(password)
        }
    }
    
    func input(confirmPassword: String, container: XCUIElement) {
        XCTContext.runActivity(named: "Подтверждаю пароль \(confirmPassword)") { _ in
            container.secureTextFields["confirmPasswordTextField"].tap()
            container.secureTextFields["confirmPasswordTextField"].typeText(confirmPassword)
        }
    }
    
    func pressSignUpButton(container: XCUIElement) {
        XCTContext.runActivity(named: "Жму кнопку регистрации") { _ in
            container.buttons["Sign Up"].tap()
        }
    }
    
    func pressLogInButtonInAlert() {
        XCTContext.runActivity(named: "Жму на Log in в алерте") { _ in
            app.alerts.buttons["Log in"].firstMatch.tap()
        }
    }
    
    func pressLogInButton() {
            XCTContext.runActivity(named: "Жму на Log In button на экране") { _ in
                app.buttons["loginButton"].tap()
            }
        }
}
