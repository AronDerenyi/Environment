import SwiftUI

public protocol EnvironmentProvider<T>: DynamicProperty {
    associatedtype T
    var environment: T { get }
}

public extension View {
    func environment<V>(
        _ keyPath: WritableKeyPath<EnvironmentValues, V>,
        _ provider: some EnvironmentProvider<V>
    ) -> some View {
        modifier(ValueProviderModifier(
            keyPath: keyPath,
            provider: provider
        ))
    }

    @available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
    func environment<T: AnyObject & Observable>(
        _ provider: some EnvironmentProvider<T?>
    ) -> some View {
        modifier(ObservableProviderModifier(
            provider: provider
        ))
    }

    func environmentObject<T: ObservableObject>(
        _ provider: some EnvironmentProvider<T>
    ) -> some View {
        modifier(ObservableObjectProviderModifier(
            provider: provider
        ))
    }
}

private struct ValueProviderModifier<V, P: EnvironmentProvider<V>>: ViewModifier {

    let keyPath: WritableKeyPath<EnvironmentValues, V>
    let provider: P

    func body(content: Content) -> some View {
        content.environment(keyPath, provider.environment)
    }
}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
private struct ObservableProviderModifier<T: Observable & AnyObject, P: EnvironmentProvider<T?>>: ViewModifier {

    let provider: P

    func body(content: Content) -> some View {
        content.environment(provider.environment)
    }
}

private struct ObservableObjectProviderModifier<T: ObservableObject, P: EnvironmentProvider<T>>: ViewModifier {

    let provider: P

    func body(content: Content) -> some View {
        content.environmentObject(provider.environment)
    }
}
