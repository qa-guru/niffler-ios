//
//  ConsolePublisher.swift
//  BindMacro
//
//  Created by Дмитрий Тучс on 24.02.2025.
//

public class ConsoleLetPublisher : Publisher {
    public init() {}
    
    public func publish(pageObjectName: String, elementInfo : ElementInfo) {
        print("Инициализируем элемент '" + elementInfo.fieldName + "' → " + elementInfo.selector + " в PageObj: " + pageObjectName)
    }
}
