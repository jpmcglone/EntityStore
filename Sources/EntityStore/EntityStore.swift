import SwiftUI

@MainActor
public final class EntityStore {
  static public let shared = EntityStore()

  private var boxes: [ObjectIdentifier: [AnyHashable: AnyObject]] = [:]

  public func entity<T: Identifiable & Equatable & Hashable>(for model: T) -> EntityBox<T> {
    let typeID = ObjectIdentifier(T.self)
    let id = model.id

    if let box = boxes[typeID]?[id] as? EntityBox<T> {
      DispatchQueue.main.async {
        box.value = model // update value if it changed
      }
      return box
    } else {
      let box = EntityBox(model)
      if boxes[typeID] == nil {
        boxes[typeID] = [:]
      }
      boxes[typeID]?[id] = box
      return box
    }
  }

  /// Alias for `entity(for:)`, intended for semantic clarity.
  /// Use when updating the store with a new or changed model.
  /// Return value can be ignored safely.
  @discardableResult
  public func save<T: Identifiable & Equatable & Hashable>(_ model: T) -> EntityBox<T> {
    entity(for: model)
  }

  public func entity<T: Identifiable & Equatable & Hashable>(for id: T.ID) -> EntityBox<T>? {
    let typeID = ObjectIdentifier(T.self)
    return boxes[typeID]?[id] as? EntityBox<T>
  }
}
