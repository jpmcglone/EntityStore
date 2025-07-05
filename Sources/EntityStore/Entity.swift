import SwiftUI

@MainActor
@propertyWrapper
public struct Entity<T>: DynamicProperty
where T: Identifiable & Equatable & Hashable,
      T.ID: Sendable
{
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
