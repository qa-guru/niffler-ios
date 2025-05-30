//
//  ConsolePublisher.swift
//  BindMacro
//
//  Created by Дмитрий Тучс on 24.02.2025.
//

public class ConsolePropertyPublisher : Publisher {
    public init() {}
    
    public func publish(pageObjectName: String, elementInfo : ElementInfo) {
        print("Обращаемся к элементу '" + elementInfo.fieldName + "' → " + elementInfo.selector + " в PageObj: " + pageObjectName)
    }
}
