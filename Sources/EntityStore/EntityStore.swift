import SwiftUI

@MainActor
public final class EntityStore {
    static let shared = EntityStore()

    private var boxes: [ObjectIdentifier: [AnyHashable: AnyObject]] = [:]

    func entity<T: Identifiable & Equatable & Hashable>(for model: T) -> EntityBox<T> {
        let typeID = ObjectIdentifier(T.self)
        let id = model.id

        if let box = boxes[typeID]?[id] as? EntityBox<T> {
            box.value = model // update value if it changed
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

    func entity<T: Identifiable & Equatable & Hashable>(for id: T.ID) -> EntityBox<T>? {
        let typeID = ObjectIdentifier(T.self)
        return boxes[typeID]?[id] as? EntityBox<T>
    }
}
