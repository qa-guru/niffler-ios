import XCTest

class BasePage {
    init(app: XCUIApplication) {
        self.app = app
    }
    
    let app: XCUIApplication
    
    func waitForElement(_ element: XCUIElement, timeout: TimeInterval = 1, message: String, file: StaticString = #file, line: UInt = #line) {
           XCTContext.runActivity(named: "Ожидание элемента") { _ in
               XCTAssertTrue(element.waitForExistence(timeout: timeout), message, file: file, line: line)
           }
    }
    
    func closeKeyboard() {
        XCTContext.runActivity(named: "Закрываю клавиатуру") { _ in
            app.keyboards.buttons["Return"].tap()
        }
    }
}
