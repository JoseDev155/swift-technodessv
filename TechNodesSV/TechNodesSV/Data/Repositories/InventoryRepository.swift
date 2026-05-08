import Foundation
import CoreData

class InventoryRepository: InventoryRepositoryProtocol {
    private let coreDataStack: CoreDataStack
    
    init(coreDataStack: CoreDataStack = .shared) {
        self.coreDataStack = coreDataStack
    }
    
    func getComponents() async throws -> [Component] {
        let request = NSFetchRequest<CDComponent>(entityName: "CDComponent")
        // CoreData skill: Use fetchBatchSize for lazy loading arrays
        request.fetchBatchSize = 20
        
        return try await withCheckedThrowingContinuation { continuation in
            coreDataStack.context.perform {
                do {
                    let results = try self.coreDataStack.context.fetch(request)
                    let components = results.map { cdComponent in
                        Component(
                            id: cdComponent.id,
                            name: cdComponent.name,
                            quantity: Int(cdComponent.quantity),
                            isPurchased: cdComponent.isPurchased,
                            expectedPrice: cdComponent.expectedPrice?.doubleValue
                        )
                    }
                    continuation.resume(returning: components)
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    func saveComponent(_ component: Component) async throws {
        // CoreData skill: Use background thread for heavy tasks/saves to avoid main thread blocking
        try await coreDataStack.persistentContainer.performBackgroundTask { context in
            let request = NSFetchRequest<CDComponent>(entityName: "CDComponent")
            request.predicate = NSPredicate(format: "id == %@", component.id)
            
            let results = try context.fetch(request)
            let cdComponent = results.first ?? CDComponent(context: context)
            
            cdComponent.id = component.id
            cdComponent.name = component.name
            cdComponent.quantity = Int32(component.quantity)
            cdComponent.isPurchased = component.isPurchased
            if let price = component.expectedPrice {
                cdComponent.expectedPrice = NSNumber(value: price)
            } else {
                cdComponent.expectedPrice = nil
            }
            
            if context.hasChanges {
                try context.save()
            }
        }
    }
    
    func deleteComponent(id: String) async throws {
        // CoreData skill: Use background context
        try await coreDataStack.persistentContainer.performBackgroundTask { context in
            let request = NSFetchRequest<CDComponent>(entityName: "CDComponent")
            request.predicate = NSPredicate(format: "id == %@", id)
            
            let results = try context.fetch(request)
            if let componentToDelete = results.first {
                context.delete(componentToDelete)
                try context.save()
            }
        }
    }
}
