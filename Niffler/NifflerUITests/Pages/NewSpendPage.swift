import XCTest

class NewSpendPage: BasePage {
    
    func inputSpent(title: String) {
        inputAmount()
        .selectCategory()
        .inputDescription(title)
//        .swipeToAddSpendsButton()
        .pressAddSpend()
    }
    
    func inputAmount() -> Self {
        app.textFields["amountField"].typeText("14")
        return self
    }
    
    func selectCategory() -> Self {
        app.buttons["Select category"].tap()
        app.buttons["Рыбалка"].tap() // TODO: Bug
        return self
    }
    
    func inputDescription(_ title: String) -> Self {
        app.textFields["descriptionField"].tap()
        app.textFields["descriptionField"].typeText(title)
        return self
    }
    
//    func swipeToAddSpendsButton() -> Self {
//        let screenCenter = app.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5))
//        let screenTop = app.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.15))
//        screenCenter.press(forDuration: 0.01, thenDragTo: screenTop)
//        return self
//    }
    
    func addSpend(description: String, isNewCategory: Bool) {
        let categoryName = UUID().uuidString
        if isNewCategory {
            pressAddNewCategory()
                .inputCategoryName(categoryName: categoryName)
        }
    
        inputAmount()
        .inputDescription(description)
        .pressAddSpend()
    }
    
    func pressAddNewCategory() -> Self{
            XCTContext.runActivity(named: "Жму кноку добавления новой категории") { _ in
                app.buttons["+ New category"].tap()
            }
        return self
    }
    
    func inputCategoryName(categoryName: String) {
         XCTContext.runActivity(named: "Вводим название категории, равное  \(categoryName)") { _ in
             app.textFields["Name"].typeText(categoryName)
             app.buttons["Add"].firstMatch.tap()}
    }
    
    func pressAddSpend() {
        app.buttons["Add"].tap()
    }
}
