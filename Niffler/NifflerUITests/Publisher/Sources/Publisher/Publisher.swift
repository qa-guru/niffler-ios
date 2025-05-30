public protocol Publisher {
    func publish(pageObjectName: String, elementInfo : ElementInfo)
}

extension Publisher {
    func getInctance() -> Publisher {
        return ConsolePropertyPublisher()
    }
}

public struct ElementInfo {
    public init(fieldName: String, selector: String) {
        self.fieldName = fieldName
        self.selector = selector
    }
    
    let fieldName: String
    let selector: String
}
