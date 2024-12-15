//
//  RegistrationUITests.swift
//  NifflerUITests
//
//  Created by Orxan on 04.12.24.
//

import XCTest

final class RegistrationUITests: TestCase {
    func test_registration() {
        launchAppWithoutLogin()
        let username = UUID().uuidString
        loginPage.goToSignUpPage()
        
        let regForm = registrationPage.getRegContainer()
        registrationPage.signUp(login: username, password: "12345", confirmPassword: "12345", form: regForm)
        
        registrationPage.checkSuccessRegistration()
        registrationPage.pressLogInButton()
        
        loginPage.goToSignUpPage()
        registrationPage.checkFilledRegistrationForm(username: username, form: regForm)
    }
}
