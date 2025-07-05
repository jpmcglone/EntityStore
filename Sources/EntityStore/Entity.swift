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

  public init(model: T, store: EntityStore = .shared) {
    if let existingBox = store.entity(for: model.id, as: T.self) {
      _box = StateObject(wrappedValue: existingBox)
    } else {
      _box = StateObject(wrappedValue: EntityBox(model))
    }
  }
}
