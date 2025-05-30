public protocol Publisher {
    func publish(pageObjectName: String, viewName: String, elementInfo : ElementInfo)
}

public struct ElementInfo {
    public init(fieldName: String, selector: String) {
        self.fieldName = fieldName
        self.selector = selector
    }
    
    let fieldName: String
    let selector: String
}
