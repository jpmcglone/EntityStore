import SwiftUI

@MainActor
@propertyWrapper
public struct Entity<T: Identifiable & Equatable & Hashable>: DynamicProperty {
  @StateObject private var box: EntityBox<T>

  public var wrappedValue: T {
    get { box.value }
    nonmutating set { box.value = newValue }
  }

  public var projectedValue: EntityBox<T> {
    box
  }

  public init(wrappedValue: T) {
    let entity = EntityStore.shared.entity(for: wrappedValue)
    _box = StateObject(wrappedValue: entity)
  }
}
