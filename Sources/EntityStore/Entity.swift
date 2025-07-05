import SwiftUI

@MainActor
@propertyWrapper
struct Entity<T: Identifiable & Equatable & Hashable>: DynamicProperty {
    @StateObject private var box: EntityBox<T>

    var wrappedValue: T {
        get { box.value }
        nonmutating set { box.value = newValue }
    }

    var projectedValue: EntityBox<T> {
        box
    }

    init(wrappedValue: T) {
        let entity = EntityStore.shared.entity(for: wrappedValue)
        _box = StateObject(wrappedValue: entity)
    }
}
