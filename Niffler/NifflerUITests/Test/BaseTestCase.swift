import XCTest

class TestCase: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUp() {
        super.setUp()
        
        app = XCUIApplication()
    }
    
    override func tearDown() {
        app = nil
        
        
        super.tearDown()
    }
    
    func launchAppWithoutLogin() {
        XCTContext.runActivity(named: "Запускаю приложение в режиме 'без авторизации'") { _ in
            app.launchArguments = ["RemoveAuthOnStart"]
            app.launch()
        }
    }
    

}

