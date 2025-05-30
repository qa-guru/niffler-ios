@_exported import Publisher

@freestanding(expression)
public macro bind<T>(_ value: T) -> T = #externalMacro(module: "BindMacroMacros", type: "BindMacro")

@freestanding(expression)
public macro bindNamed<T>(_ name: String, _ value: T) -> T = #externalMacro(module: "BindMacroMacros", type: "BindNamedMacro")
