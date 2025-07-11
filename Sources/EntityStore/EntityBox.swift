import SwiftUI

@MainActor
public final class EntityBox<T: Identifiable & Equatable & Hashable>: ObservableObject, Identifiable
where T.ID: Sendable {
  public let id: T.ID
  
  @Published public var value: T
  
  init(_ value: T) {
    self.value = value
    self.id = value.id
  }
}

extension EntityBox {
  func updateIfNeeded(to newValue: T) {
    guard value != newValue else { return }
    value = newValue
  }
}
