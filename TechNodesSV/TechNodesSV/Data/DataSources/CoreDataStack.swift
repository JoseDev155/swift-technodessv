import Foundation
import CoreData

class CoreDataStack {
    static let shared = CoreDataStack()
    
    lazy var persistentContainer: NSPersistentContainer = {
        // Creating the model programmatically to avoid XML file creation issues outside Xcode
        let model = NSManagedObjectModel()
        
        let componentEntity = NSEntityDescription()
        componentEntity.name = "CDComponent"
        componentEntity.managedObjectClassName = NSStringFromClass(CDComponent.self)
        
        let idAttr = NSAttributeDescription()
        idAttr.name = "id"
        idAttr.attributeType = .stringAttributeType
        idAttr.isOptional = false
        
        let nameAttr = NSAttributeDescription()
        nameAttr.name = "name"
        nameAttr.attributeType = .stringAttributeType
        nameAttr.isOptional = false
        
        let quantityAttr = NSAttributeDescription()
        quantityAttr.name = "quantity"
        quantityAttr.attributeType = .integer32AttributeType
        quantityAttr.isOptional = false
        
        let isPurchasedAttr = NSAttributeDescription()
        isPurchasedAttr.name = "isPurchased"
        isPurchasedAttr.attributeType = .booleanAttributeType
        isPurchasedAttr.isOptional = false
        
        let priceAttr = NSAttributeDescription()
        priceAttr.name = "expectedPrice"
        priceAttr.attributeType = .doubleAttributeType
        priceAttr.isOptional = true
        
        componentEntity.properties = [idAttr, nameAttr, quantityAttr, isPurchasedAttr, priceAttr]
        model.entities = [componentEntity]
        
        let container = NSPersistentContainer(name: "TechNodesSV", managedObjectModel: model)
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                print("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

// Managed Object Class defined explicitly
@objc(CDComponent)
public class CDComponent: NSManagedObject {
    @NSManaged public var id: String
    @NSManaged public var name: String
    @NSManaged public var quantity: Int32
    @NSManaged public var isPurchased: Bool
    @NSManaged public var expectedPrice: NSNumber? // Using NSNumber for optional Double
}
