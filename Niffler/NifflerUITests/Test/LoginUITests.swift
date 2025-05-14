import XCTest

final class LoginUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUp() {
        super.setUp()
        launchAppWithoutLogin()
        
    }
    
    @MainActor
    func test_loginSuccess() throws {
        //Arrange
        input(login: "stage", password: "12345")
        
        //Assert
        assertIsSpendsViewAppeared()
        
        
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func test_loginFailure() throws {
        input(login: "stage", password: "123456")
        
        assertLoginErrorShown()
        
        
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    
    
    //MARK: - DSL
    
    private func input(login: String, password: String){
        input(login: login)
        input(password: password)
        pressLoginButton()
    }
    
    private func launchAppWithoutLogin() {
        XCTContext.runActivity(named: "Запуск приложения в режиме 'без авторизации'") { _ in
            app = XCUIApplication()
            app.launchArguments = ["RemoveAuthOnStart"]
            app.launch()
        }
    }
    
    
    private func input(login: String) {
        XCTContext.runActivity(named: "Вводим логин \(login)") { _ in
            app.textFields["userNameTextField"].tap()
            app.textFields["userNameTextField"].typeText(login)
        }
    }
    
    //MARK: - DSL
    private func input(password: String) {
        XCTContext.runActivity(named: "Вводим логин \(password)") { _ in
            app.secureTextFields["passwordTextField"].tap()
            app.secureTextFields["passwordTextField"].typeText(password)
        }
    }
    
    private func pressLoginButton() {
        XCTContext.runActivity(named: "Нажимаем кнопку логина") { _ in
            app.buttons["loginButton"].tap()
        }
    }
    
    private func assertIsSpendsViewAppeared(){
        XCTContext.runActivity(named: "Ожидание экрана с тратами") { _ in
            let _ = app.scrollViews.switches.firstMatch.waitForExistence(timeout: 10)
            XCTAssertGreaterThanOrEqual(app.scrollViews.switches.count, 1)
        }
    }
    
    private func assertLoginErrorShown(file: StaticString = #filePath, line: UInt = #line){
        XCTContext.runActivity(named: "Ожидаем ошибку") { _ in
            let isFound = app.staticTexts["Нет такого пользователя. Попробуйте другие данные"].waitForExistence(timeout: 10)
            XCTAssertTrue(isFound,
                          "Не нашли сообщение о неправильном логине",
                          file: file,
                          line: line)
        }
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
