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
        
    }
    
    
    
    
    func testRegistration() throws {
        let login = "taty" + ICMPV6CTL_ERRPPSLIMIT_RANDOM_INCR.description
        let password = "12345"
        
        pressRegistrationButton()
        input(login: login, password: password, repeatPassword: password)
        
        assertSuccessRegistration()
        
        tapLoginBtn()
        
        assertLoginAndPasswordSetInLoginForm(login: login, password: password)
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
            let loginField = app.textFields["userNameTextField"].firstMatch
            loginField.tap()
            loginField.typeText(login)
        }
    }
    
    //MARK: - DSL
    private func input(password: String) {
        XCTContext.runActivity(named: "Вводим пароль \(password)") { _ in
            app.buttons["passwordTextField"].firstMatch.tap()
            let passwordInput = app.secureTextFields["passwordTextField"].firstMatch
            passwordInput.tap()
            passwordInput.typeText(password)
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
    
    private func pressRegistrationButton() {
        XCTContext.runActivity(named: "Нажимаем кнопку 'Create new account'") { _ in
            app.staticTexts["Create new account"].tap()
            XCTAssert(app.staticTexts["Sign Up"].waitForExistence(timeout: 3))
        }
    }
    
    private func input(login: String, password: String, repeatPassword: String) {
        input(login: login)
        input(password: password)
        input(reapitPassword: password)
        pressSignInButton()
    }
    
    private func input(reapitPassword: String){
        XCTContext.runActivity(named: "Вводим пароль повторно") { _ in
            app.buttons["confirmPasswordTextField"].firstMatch.tap()
            let passwordConfirmField = app.textFields["confirmPasswordTextField"].firstMatch
            passwordConfirmField.tap()
            passwordConfirmField.typeText(reapitPassword)
        }
    }
    
    private func pressSignInButton() {
        XCTContext.runActivity(named: "Нажимаем кнопку 'Sign Up'") { _ in
            app.buttons["Return"].firstMatch.tap()
            app.buttons["Sign Up"].firstMatch.tap()
        }
    }
    
    private func tapLoginBtn() {
        XCTContext.runActivity(named: "Нажимаем кнопку 'Sign In'") { _ in
            app.buttons["Log in"].firstMatch.tap()
        }
    }
    
    private func assertSuccessRegistration() {
        XCTContext.runActivity(named: "Проверка сообщения об успешной регистрации") { _ in
            XCTAssertEqual("Congratulations!", app.alerts.firstMatch.label)
        }
    }
    
    private func assertLoginAndPasswordSetInLoginForm(login: String, password: String){
        XCTContext.runActivity(named: "Проверка, что поля логин и пароль в форме авторизации равны логину и паролю из регистрации") { _ in
            XCTAssertEqual(login, app.textFields["userNameTextField"].firstMatch.value as? String)
            app.buttons["ic_show_hide"].tap()
            XCTAssertEqual(password, app.textFields["passwordTextField"].firstMatch.value as? String)
        }
    }
}
