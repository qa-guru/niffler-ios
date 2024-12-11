//
//  RegistrationUITests.swift
//  NifflerUITests
//
//  Created by Orxan on 04.12.24.
//

import XCTest

final class RegistrationUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    private func launchApp() {
        XCTContext.runActivity(named: "Запуск приложения") { _ in
            app = XCUIApplication()
            app.launch()
        }
    }
    
    func test_registration() {
        launchApp()
        let username = UUID().uuidString
        goToSignUpPage()
        
        let regForm = getRegContainer()
        signUp(login: username, password: "12345", confirmPassword: "12345", form: regForm)
        
        checkSuccessRegistration()
        pressLogInButton()
    
        goToSignUpPage()
        checkFilledRegistrationForm(username: username, form: regForm)
    }
    
    private func goToSignUpPage() {
        XCTContext.runActivity(named: "Перехожу на страницу регистрации") { _ in
            app.staticTexts["Create new account"].tap()
        }
    }
    
    private func checkSuccessRegistration() {
        XCTContext.runActivity(named: "Проверяю наличие модального окна успешной регистрации") { _ in
            app.staticTexts["Congratulations"].waitForExistence(timeout: 5)
            XCTAssertTrue(app.staticTexts[" You've registered!"].exists)
        }
    }
    
    private func getRegContainer() -> XCUIElement {
        return app.otherElements.containing(.staticText, identifier: "Sign Up").element
    }
    
    private func checkFilledRegistrationForm(username: String, form: XCUIElement) {
        XCTContext.runActivity(named: "Проверяю что форма регистрации заполнена \(username)") { _ in
            XCTAssertEqual(form.textFields["userNameTextField"].value as? String, username)
            let passwordFieldValue = form.secureTextFields["passwordTextField"].value as? String
            let confirmPasswordFieldValue = form.secureTextFields["confirmPasswordTextField"].value as? String
            XCTAssertNotNil(passwordFieldValue)
            XCTAssertNotNil(confirmPasswordFieldValue)
        }
    }
    
    
    private func signUp(login: String, password: String, confirmPassword: String, form: XCUIElement) {
        XCTContext.runActivity(named: "Заполняю форму регистрации \(login), \(password), \(confirmPassword)") { _ in
            input(login: login, container: form)
            input(password: password, container: form)
            input(confirmPassword: confirmPassword, container: form)
            closeKeyboard()
            pressSignUpButton(container: form)
        }
    }
    
    private func input(login: String, container: XCUIElement) {
        XCTContext.runActivity(named: "Ввожу логин \(login)") { _ in
            container.textFields["userNameTextField"].tap()
            container.textFields["userNameTextField"].typeText(login)
        }
    }
    
    private func input(password: String, container: XCUIElement) {
        XCTContext.runActivity(named: "Ввожу пароль \(password)") { _ in
            container.secureTextFields["passwordTextField"].tap()
            container.secureTextFields["passwordTextField"].typeText(password)
        }
    }
    
    private func input(confirmPassword: String, container: XCUIElement) {
        XCTContext.runActivity(named: "Подтверждаю пароль \(confirmPassword)") { _ in
            container.secureTextFields["confirmPasswordTextField"].tap()
            container.secureTextFields["confirmPasswordTextField"].typeText(confirmPassword)
        }
    }
    
    private func pressSignUpButton(container: XCUIElement) {
        XCTContext.runActivity(named: "Жму кнопку регистрации") { _ in
            container.buttons["Sign Up"].tap()
        }
    }
    
    private func pressLogInButton() {
        XCTContext.runActivity(named: "Жму кнопку авторизации") { _ in
            app.scrollViews.buttons["Log in"].tap()
        }
    }
    
    private func closeKeyboard() {
        XCTContext.runActivity(named: "Закрываю клавиатуру") { _ in
            app.keyboards.buttons["Return"].tap()
        }
    }
}
