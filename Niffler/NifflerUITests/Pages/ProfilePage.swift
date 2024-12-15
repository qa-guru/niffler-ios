//
//  ProfilePage.swift
//  NifflerUITests
//
//  Created by Orxan on 15.12.24.
//

import XCTest

class ProfilePage: BasePage {
    
    func verifyCategoryIsNotPresent(_ categoryName: String, timeout: TimeInterval = 2, file: StaticString = #file, line: UInt = #line) {
        XCTContext.runActivity(named: "Проверяю отсутствие категории в списке: \(categoryName)") { _ in
            let category = app.staticTexts[categoryName]
            XCTAssertFalse(category.exists, "Категория '\(categoryName)' присутствует в списке, хотя не должна быть.", file: file, line: line)
        }
    }

    func verifyCategory(_ categoryName: String, timeout: TimeInterval = 2, file: StaticString = #file, line: UInt = #line) {
        XCTContext.runActivity(named: "Проверяю наличие категории в списке: \(categoryName)") { _ in
            let category = app.staticTexts[categoryName]
            waitForElement(category, timeout: timeout, message: "'\(categoryName)' - категории нет в списке", file: file, line: line)
            XCTAssertTrue(category.exists, "Категории '\(categoryName)' нет в списке", file: file, line: line)
        }
    }

    func deleteCategory(_ categoryName: String) -> Self {
        XCTContext.runActivity(named: "Удаляю категорию '\(categoryName)'") { _ in
            let categoryCell = app.cells.containing(.staticText, identifier: categoryName).firstMatch
            waitForElement(categoryCell, message: "Категория '\(categoryName)' не отображается в списке")

            XCTContext.runActivity(named: "Свайпаю влево для удаления категории '\(categoryName)'") { _ in
                categoryCell.swipeLeft()
            }

            let deleteButton = app.buttons["Delete"]
            waitForElement(deleteButton, message: "Кнопка удаления не отображается")

            XCTContext.runActivity(named: "Нажимаю кнопку удаления 'Delete'") { _ in
                XCTAssertTrue(deleteButton.isHittable, "Кнопка удаление не кликается")
                deleteButton.tap()
            }
        }
        return self
    }

    func closeProfile(){
        XCTContext.runActivity(named: "Нажимаем на элемент закрытия профиля") { _ in
            let buttonClose = app.buttons["Close"]
            waitForElement(buttonClose, message: "Не отображается кнопки закрытия профиля")
            buttonClose.tap()
        }
    }
}
