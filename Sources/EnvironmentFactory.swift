import SwiftUI

public extension View {
    func environment<V>(
        _ keyPath: WritableKeyPath<EnvironmentValues, V>,
        _ factory: @escaping (EnvironmentValues) -> V
    ) -> some View {
        modifier(FactoryModifier(
            keyPath: keyPath,
            factory: factory
        ))
    }

    @available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
    func environment<T>(
        _ factory: @escaping (EnvironmentValues) -> T?
    ) -> some View where T : AnyObject, T : Observable {
        modifier(ObservableFactoryModifier(
            factory: factory
        ))
    }

    func environmentObject<T>(
        _ factory: @escaping (EnvironmentValues) -> T
    ) -> some View where T : ObservableObject {
        modifier(ObservableObjectFactoryModifier(
            factory: factory
        ))
    }
}

private struct FactoryModifier<V>: ViewModifier, Equatable {

    @Environment(\.self) var environment
    let uuid = UUID()
    let keyPath: WritableKeyPath<EnvironmentValues, V>
    let factory: (EnvironmentValues) -> V
    
    func body(content: Content) -> some View {
        content.environment(keyPath, factory(environment))
    }
    
    nonisolated static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.uuid == rhs.uuid
    }
}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
private struct ObservableFactoryModifier<T: Observable & AnyObject>: ViewModifier, Equatable {

    @Environment(\.self) var environment
    let uuid = UUID()
    let factory: (EnvironmentValues) -> T?
    
    func body(content: Content) -> some View {
        content.environment(factory(environment))
    }
    
    nonisolated static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.uuid == rhs.uuid
    }
}

private struct ObservableObjectFactoryModifier<T: ObservableObject>: ViewModifier, Equatable {

    @Environment(\.self) var environment
    let uuid = UUID()
    let factory: (EnvironmentValues) -> T
    
    func body(content: Content) -> some View {
        content.environmentObject(factory(environment))
    }
    
    nonisolated static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.uuid == rhs.uuid
    }
}
