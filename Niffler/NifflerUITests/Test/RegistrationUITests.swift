//
//  RegistrationUITests.swift
//  NifflerUITests
//
//  Created by Orxan on 04.12.24.
//

import XCTest

final class RegistrationUITests: TestCase {
    
    func test_registration() {
        let username = UUID().uuidString
        let password = "12345"
        
        let app = XCUIApplication()
        app.launch()
        
        app.staticTexts["Create new account"].tap()
        let signUpContainer = app.otherElements.containing(.staticText, identifier: "Sign Up").element
        
        signUpContainer.textFields["userNameTextField"].tap()
        signUpContainer.textFields["userNameTextField"].typeText(username)
    
                
        signUpContainer.secureTextFields["passwordTextField"].tap()
        signUpContainer.secureTextFields["passwordTextField"].typeText(password)
        
        signUpContainer.secureTextFields["confirmPasswordTextField"].tap()
        signUpContainer.secureTextFields["confirmPasswordTextField"].typeText(password)
        
        app.keyboards.buttons["Return"].tap()
        signUpContainer.buttons["Sign Up"].tap()
        
        app.staticTexts["Congratulations"].waitForExistence(timeout: 5)
        XCTAssertTrue(app.staticTexts[" You've registered!"].exists)
        
        app.scrollViews.buttons["Log in"].tap()
        
        app.staticTexts["Create new account"].tap()
        
        XCTAssertEqual(signUpContainer.textFields["userNameTextField"].value as? String, username)
        
        let passwordFieldValue = signUpContainer.secureTextFields["passwordTextField"].value as? String
        let confirmPasswordFieldValue = signUpContainer.secureTextFields["confirmPasswordTextField"].value as? String
        XCTAssertNotNil(passwordFieldValue)
        XCTAssertNotNil(confirmPasswordFieldValue)
    }
}
