import XCTest

final class SpendsUITests: TestCase {
    
    func test_whenAddSpent_shouldShowSpendInList() {
        launchAppWithoutLogin()
        
        // Arrange
        loginPage
            .input(login: "stage", password: "12345")
        
        // Act
        spendsPage
            .waitSpendsScreen()
            .addSpent()
        
        let title = UUID.randomPart
        newSpendPage
            .inputSpent(title: title)
        
        // Assert
        spendsPage
            .assertNewSpendIsShown(title: title)
    }
    
    func test_user_create_new_category_and_create_spend() throws {
        let username = UUID().uuidString
        let description = UUID().uuidString
        
        // Arrange
        launchAppWithoutLogin()
        loginPage.goToSignUpPage()
        
        //Act
        let regForm = registrationPage.getRegContainer()
        registrationPage.signUp(login: username, password: "12345", confirmPassword: "12345", form: regForm)
        .checkSuccessRegistration()
        
        loginPage.pressLoginButton()
        spendsPage.assertIsAddSpendButtonShown()
            .addSpent()
        newSpendPage.addSpend(description: description, isNewCategory: true)
        
        // Assert
        spendsPage.assertNewSpendIsShown(title: description)
    }
    
    func test_user_choose_category_and_create_spend() throws {
        let username = UUID().uuidString
        let description = UUID().uuidString
        
        // Arrange
        launchAppWithoutLogin()
            loginPage.goToSignUpPage()
        
        //Act
        let regForm = registrationPage.getRegContainer()
        registrationPage.signUp(login: username, password: "12345", confirmPassword: "12345", form: regForm)
            .checkSuccessRegistration()
        
        loginPage.pressLoginButton()
        
        spendsPage.assertIsAddSpendButtonShown()
            .addSpent()
        
        let categoryName = newSpendPage.addSpend(description: description, isNewCategory: false)
        
        // Assert
        spendsPage.assertNewSpendIsShown(title: description)
            .goToProfile()
        
        profilePage.verifyCategory(categoryName)
    }


    func test_deleted_category_is_not_shown_in_spend_screen() throws {
        let username = UUID().uuidString
        let description = UUID().uuidString
        
        // Arrange
        launchAppWithoutLogin()
            loginPage.goToSignUpPage()
        
        //Act
        let regForm = registrationPage.getRegContainer()
        registrationPage.signUp(login: username, password: "12345", confirmPassword: "12345", form: regForm)
            .checkSuccessRegistration()
        
        loginPage.pressLoginButton()
        
        spendsPage.assertIsAddSpendButtonShown()
            .addSpent()
        
        spendsPage.assertIsAddSpendButtonShown()
            .addSpent()
        
        let category = newSpendPage.addSpend(description: description, isNewCategory: false)
        
        spendsPage.goToProfile()
        
        profilePage
            .deleteCategory(category)
            .closeProfile()
        spendsPage.addSpent()


        // Assert
        newSpendPage.isNewCategoryVisible()
    }
        
}

extension UUID {
    static var randomPart: String {
        UUID().uuidString.components(separatedBy: "-").first!
    }
}
