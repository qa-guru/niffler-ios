import XCTest
import SwiftUICore

class BasePage {
    let app: XCUIApplication
    let viewTypes: [any View.Type]

    init(app: XCUIApplication, viewTypes: [any View.Type]) {
        self.app = app
        self.viewTypes = viewTypes
    }

    var viewNames: [String] {
        viewTypes.map { String(describing: $0) }
    }
}
