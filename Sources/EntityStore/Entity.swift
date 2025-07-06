import SwiftUI

@MainActor
@propertyWrapper
public struct Entity<T>: DynamicProperty
where T: Identifiable & Equatable & Hashable,
      T.ID: Sendable
{
  @ObservedObject private var box: EntityBox<T>

  public var wrappedValue: T {
    get { box.value }
    nonmutating set { box.value = newValue }
  }

  public var projectedValue: EntityBox<T> {
    box
  }

  /// Explicit init
  public init(_ model: T, store: EntityStore = .shared) {
    self.box = store.entity(for: model)
  }

  /// Enables SwiftUI-style syntax with optional store
  public init(wrappedValue model: T, store: EntityStore? = nil) {
    self.init(model, store: store ?? .shared)
  }
}

