import SwiftUI

@MainActor
public final class EntityStore: ObservableObject {
  static public let shared = EntityStore()
  
  @Published private var boxes: [ObjectIdentifier: [AnyHashable: AnyObject]] = [:]
  
  public func entity<T: Identifiable & Equatable & Hashable>(for model: T, overwrite: Bool = true) -> EntityBox<T> {
    let typeID = ObjectIdentifier(T.self)
    let id = model.id
    
    if let box = boxes[typeID]?[id] as? EntityBox<T> {
      if overwrite {
        box.updateIfNeeded(to: model)
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
    entity(for: model, overwrite: true)
  }
  
  @discardableResult
  public func save<T: Identifiable & Equatable & Hashable>(_ models: [T]) -> [EntityBox<T>] {
    guard !models.isEmpty else { return [] }
    
    let typeID = ObjectIdentifier(T.self)
    if boxes[typeID] == nil {
      boxes[typeID] = [:]
    }
    
    var result: [EntityBox<T>] = []
    for model in models {
      let id = model.id
      
      if let box = boxes[typeID]?[id] as? EntityBox<T> {
        box.updateIfNeeded(to: model)
        result.append(box)
      } else {
        let box = EntityBox(model)
        boxes[typeID]?[id] = box
        result.append(box)
      }
    }
    
    return result
  }
  
  public func peek<T: Identifiable & Equatable & Hashable>(for id: T.ID) -> T? where T.ID: Sendable {
    return (boxes[ObjectIdentifier(T.self)]?[id] as? EntityBox<T>)?.value
  }
  
  public func first<T: Identifiable & Equatable & Hashable>(
    of type: T.Type = T.self,
    where predicate: (T) -> Bool
  ) -> T? where T.ID: Sendable {
    let typeID = ObjectIdentifier(type)
    return boxes[typeID]?.values
      .compactMap { ($0 as? EntityBox<T>)?.value }
      .first(where: predicate)
  }
  
  public func all<T: Identifiable & Equatable & Hashable>(of type: T.Type = T.self) -> [T] where T.ID: Sendable {
    let typeID = ObjectIdentifier(type)
    return boxes[typeID]?.values
      .compactMap { ($0 as? EntityBox<T>)?.value } ?? []
  }
  
  public func contains<T: Identifiable & Hashable>(_ id: T.ID, of type: T.Type = T.self) -> Bool {
    let typeID = ObjectIdentifier(type)
    return boxes[typeID]?[id] != nil
  }
  
  public func entity<T: Identifiable & Equatable & Hashable>(for id: T.ID) -> EntityBox<T>? {
    let typeID = ObjectIdentifier(T.self)
    return boxes[typeID]?[id] as? EntityBox<T>
  }
  
  public func entity<T: Identifiable & Equatable & Hashable>(
    for id: T.ID,
    as type: T.Type = T.self
  ) -> EntityBox<T>? {
    let typeID = ObjectIdentifier(type)
    return boxes[typeID]?[id] as? EntityBox<T>
  }
  
  public func filter<T: Identifiable & Equatable & Hashable>(
    of type: T.Type = T.self,
    where predicate: (T) -> Bool
  ) -> [T] where T.ID: Sendable {
    let typeID = ObjectIdentifier(type)
    return boxes[typeID]?.values
      .compactMap { ($0 as? EntityBox<T>)?.value }
      .filter(predicate) ?? []
  }
  
  public func clear() {
    boxes.removeAll()
  }
  
  /// Clears the entire store or just the specified type.
  public func clear<T: Identifiable & Equatable & Hashable>(type: T.Type?) {
    if let type = type {
      let typeID = ObjectIdentifier(type)
      boxes[typeID] = nil
    } else {
      boxes.removeAll()
    }
  }
  
  public func clear<T: Identifiable & Equatable & Hashable>(id: T.ID, of type: T.Type = T.self) {
    let typeID = ObjectIdentifier(type)
    boxes[typeID]?[id] = nil
    if boxes[typeID]?.isEmpty == true {
      boxes[typeID] = nil
    }
  }
}
