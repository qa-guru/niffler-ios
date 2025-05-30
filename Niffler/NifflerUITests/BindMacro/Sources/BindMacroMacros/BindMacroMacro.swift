import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct BindNamedMacro: ExpressionMacro {
    public static func expansion(
        of node: some FreestandingMacroExpansionSyntax,
        in context: some MacroExpansionContext
    ) throws -> ExprSyntax {
        
        guard node.arguments.count == 2 else {
            throw MacroExpansionErrorMessage("Expected two arguments: variable name and XCUIElement.")
        }

        guard let label = node.arguments.first?.expression.as(StringLiteralExprSyntax.self),
              let variableName = label.segments.first?.as(StringSegmentSyntax.self)?.content.text else {
            throw MacroExpansionErrorMessage("First argument must be a string literal representing the variable name.")
        }

        guard let argument = node.arguments.last?.expression else {
            throw MacroExpansionErrorMessage("Second argument must be an XCUIElement expression.")
        }
        
        return """
            {
                let element = \(argument)
                let fileName = URL(fileURLWithPath: #file).lastPathComponent
                let publisher = ConsoleLetPublisher()
                let elementInfo = ElementInfo(fieldName: "\(raw: variableName)", selector: String(describing: element))
                publisher.publish(pageObjectName: fileName, viewName: viewNames.joined(separator: ","), elementInfo: elementInfo)
                return element
            }()
            """
    }
}

public struct BindMacro: ExpressionMacro {
    public static func expansion(
        of node: some FreestandingMacroExpansionSyntax,
        in context: some MacroExpansionContext
    ) throws -> ExprSyntax {
        guard node.arguments.count == 1 else {
            throw MacroExpansionErrorMessage("Expected one argument: XCUIElement.")
        }

        guard let argument = node.arguments.first?.expression else {
            throw MacroExpansionErrorMessage("First argument must be an XCUIElement expression.")
        }
        
        return """
            {
                let element = \(argument)
                let fileName = URL(fileURLWithPath: #file).lastPathComponent
                let publisher = ConsolePropertyPublisher()
                let elementInfo = ElementInfo(fieldName: #function, selector: String(describing: element))
                publisher.publish(pageObjectName: fileName, viewName: viewNames.joined(separator: ","), elementInfo: elementInfo)
                return element
            }()
            """
    }
}


@main
struct BindMacroPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        BindNamedMacro.self,BindMacro.self
    ]
}
