import SwiftUI

public final class EntityBox<T: Identifiable & Equatable & Hashable>: ObservableObject, Identifiable {
    public var id: T.ID { value.id }

    @Published public var value: T

    init(_ value: T) {
        self.value = value
    }
}

extension EntityBox {
  func updateIfNeeded(to newValue: T) {
    guard value != newValue else { return }
    value = newValue
  }
}
