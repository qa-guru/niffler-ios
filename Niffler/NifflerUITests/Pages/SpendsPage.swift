import XCTest

class SpendsPage: BasePage {
    func assertIsSpendsViewAppeared(file: StaticString = #filePath, line: UInt = #line) {
        XCTContext.runActivity(named: "Жду экран с тратами") { _ in
            waitSpendsScreen(file: file, line: line)
            XCTAssertGreaterThanOrEqual(app.scrollViews.switches.count, 1,
                                        "Не нашел трат в списке",
                                        file: file, line: line)
        }
    }
    
    @discardableResult
    func waitSpendsScreen(file: StaticString = #filePath, line: UInt = #line) -> Self {
        let isFound = app.firstMatch
            .scrollViews.firstMatch
            .switches.firstMatch
            .waitForExistence(timeout: 10)
        
        XCTAssertTrue(isFound,
                      "Не дождались экрана со списком трат",
                      file: file, line: line)
        
        return self
    }
    
    func addSpent() {
        app.buttons["addSpendButton"].tap()
    }
    
    func assertNewSpendIsShown(title: String, file: StaticString = #filePath, line: UInt = #line) -> Self {
        let isFound = app.firstMatch
            .scrollViews.firstMatch
            .staticTexts[title].firstMatch
            .waitForExistence(timeout: 1)
        
        XCTAssertTrue(isFound, file: file, line: line)
        return self
    }
    
    func assertIsAddSpendButtonShown(file: StaticString = #filePath, line: UInt = #line) -> Self {
        XCTContext.runActivity(named: "Ожидание появление кнопки добавления траты") { _ in
            let isAddSpendButton = app.buttons["addSpendButton"].waitForExistence(timeout: 3)

            XCTAssertTrue(isAddSpendButton,
                          "Не нашли кнопку добавления траты",
                          file: #file, line: #line)
        }
        return self
    }
    
    func goToProfile() {
        XCTContext.runActivity(named: "Перехожу на экран профиля") { _ in
            openMenu()
            tapProfileButton()
        }
    }
    private func openMenu() {
        XCTContext.runActivity(named: "Открываю бургер-меню") { _ in
            let burgerMenu = app.images["ic_menu"]
            waitForElement(burgerMenu, message: "Бургер меню не отображается")
            burgerMenu.tap()
        }
    }

    private func tapProfileButton() {
        XCTContext.runActivity(named: "Нажимаю кнопку 'Profile'") { _ in
            let profileButton = app.buttons["Profile"]
            waitForElement(profileButton, message: "Кнопка профиля не отображается")
            XCTAssertTrue(profileButton.isHittable, "Кнопка профиля не кликается")
            profileButton.tap()
        }
    }
}
