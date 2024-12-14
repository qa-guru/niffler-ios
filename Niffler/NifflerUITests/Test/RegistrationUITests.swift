//
//  RegistrationUITests.swift
//  NifflerUITests
//
//  Created by Orxan on 04.12.24.
//

import XCTest

final class RegistrationUITests: TestCase {
        
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
    
    func test_user_create_new_category_and_create_spend() throws {
        let username = UUID().uuidString
        let description = UUID().uuidString
        
        // Arrange
        launchAppWithoutLogin()
        goToSignUpPage()
        
        //Act
        let regForm = getRegContainer()
        signUp(login: username, password: "12345", confirmPassword: "12345", form: regForm)
        checkSuccessRegistration()
        pressLogInButton()
        assertIsAddSpendButtonShown()
        pressAddSpendButton()
        addSpend(amount: "500", description: description, isNewCategory: true)
        
        // Assert
        assertNewSpendIsShown(title: description)
    }
    
    func test_user_choose_category_and_create_spend() throws {
        let username = UUID().uuidString
        let description = UUID().uuidString
        
        // Arrange
        launchAppWithoutLogin()
        goToSignUpPage()
        
        //Act
        let regForm = getRegContainer()
        signUp(login: username, password: "12345", confirmPassword: "12345", form: regForm)
        checkSuccessRegistration()
        pressLogInButton()
        assertIsAddSpendButtonShown()
        pressAddSpendButton()
        addSpend(amount: "500", description: description, isNewCategory: false)
        
        // Assert
        assertNewSpendIsShown(title: description)
    }
    
    //MARK: New spending
    
    func assertNewSpendIsShown(title: String, file: StaticString = #filePath, line: UInt = #line) {
            XCTContext.runActivity(named: "Проверка создания новой траты с заголовком '\(title)'") { _ in
                let spendTitle = app.firstMatch
                    .scrollViews.firstMatch
                    .staticTexts[title].firstMatch

                waitForElement(spendTitle, timeout: 2, message: "Новая трата '\(title)' не отображается в листе затрат.")
            }
        }
    
    func addSpend(amount: String, description: String, isNewCategory: Bool) {
        let categoryName = UUID().uuidString
        if isNewCategory {
            pressAddNewCategory()
            inputCategoryName(categoryName: categoryName)
        }
    
        inputAmount(amount: amount)
        inputDescription(description: description)
        pressAddSpend()
    }
    
    func pressAddNewCategory(){
            XCTContext.runActivity(named: "Жму кноку добавления новой категории") { _ in
                app.buttons["+ New category"].tap()
            }
    }
    
    func inputDescription(description: String) {
        XCTContext.runActivity(named: "Заполняю поле description, равное \(description)") { _ in
            app.textFields["descriptionField"].tap()
            app.textFields["descriptionField"].typeText(description)
        }
    }
    
    func inputAmount(amount: String) {
            XCTContext.runActivity(named: "Вводим сумму равную \(amount)") { _ in
             app.textFields["amountField"].typeText(amount)
            }
    }
    
    func inputCategoryName(categoryName: String) {
         XCTContext.runActivity(named: "Вводим название категории, равное  \(categoryName)") { _ in
             app.textFields["Name"].typeText(categoryName)
             app.buttons["Add"].firstMatch.tap()}
    }
    
    func pressAddSpendButton() {
        app.buttons["addSpendButton"].tap()
    }
    
    // MARK: Main page
    func pressAddSpend() {
          XCTContext.runActivity(named: "Нажимаю кнопку 'Add' для сохранения траты") { _ in
              let addButton = app.buttons["Add"]
              waitForElement(addButton, message: "'Add' button did not appear.")
              addButton.tap()
          }
    }
    
    
    //MARK: registration
    private func goToSignUpPage() {
        XCTContext.runActivity(named: "Перехожу на страницу регистрации") { _ in
            app.staticTexts["Create new account"].tap()
        }
    }
    
    private func checkSuccessRegistration() {
        XCTContext.runActivity(named: "Проверяю наличие модального окна успешной регистрации") { _ in
            app.staticTexts["Congratulations"].waitForExistence(timeout: 5)
            XCTAssertTrue(app.staticTexts[" You've registered!"].exists)
            pressLogInButtonInAlert()
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
    
    private func pressLogInButtonInAlert() {
        XCTContext.runActivity(named: "Жму на Log in в алерте") { _ in
            app.alerts.buttons["Log in"].firstMatch.tap()
        }
    }
    
    private func pressLogInButton() {
            XCTContext.runActivity(named: "Жму на Log In button на экране") { _ in
                app.buttons["loginButton"].tap()
            }
        }
    
    func assertIsAddSpendButtonShown(file: StaticString = #filePath, line: UInt = #line) {
        XCTContext.runActivity(named: "Жду кноку добавления траты") { _ in
            let isAddSpendButton = app.buttons["addSpendButton"].waitForExistence(timeout: 3)

            XCTAssertTrue(isAddSpendButton,
                          "Не нашли кнопку добавления траты",
                          file: #file, line: #line)
        }
    }
    
    // MARK: common
    private func waitForElement(_ element: XCUIElement, timeout: TimeInterval = 1, message: String, file: StaticString = #file, line: UInt = #line) {
           XCTContext.runActivity(named: "Ожидание элемента") { _ in
               XCTAssertTrue(element.waitForExistence(timeout: timeout), message, file: file, line: line)
           }
    }
    
    private func closeKeyboard() {
        XCTContext.runActivity(named: "Закрываю клавиатуру") { _ in
            app.keyboards.buttons["Return"].tap()
        }
    }
}
