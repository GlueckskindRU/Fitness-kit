//
//  CoreDataManager.swift
//  Fitness-kit
//
//  Created by Yuri Ivashin on 25.02.2020.
//  Copyright © 2020 The Homber Team. All rights reserved.
//

import CoreData

class CoreDataManager {
    private let modelName: String
    
    init(modelName: String) {
        self.modelName = modelName
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: modelName)
        
        container.loadPersistentStores {
            (storeDescription, error) in
            
            if let error = error as NSError? {
                fatalError("~~~~1~~~~Unresolved error \(error), \(error.userInfo)")
            }
        }
        
        return container
    }()
    
    func getContext() -> NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func save(context: NSManagedObjectContext) {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("~~~~2~~~~Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func createObject<T: NSManagedObject>(from entity: T.Type) -> T? {
        let context = getContext()
        
        return NSEntityDescription.insertNewObject(forEntityName: String(describing: entity), into: context) as? T
    }

    func getEntity<T: NSManagedObject>(with id: String) -> T? {
        let idPredicate = NSPredicate(format: "appointmentId == '\(id)'")
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [idPredicate])
        
        let resultArray = fetchData(for: T.self, predicate: compoundPredicate)
        let result: T?
        
        if resultArray.isEmpty {
            result = createObject(from: T.self)
        } else {
            result = resultArray.first
        }
        
        return result
    }
    
    func fetchData<T: NSManagedObject>(for entity: T.Type, predicate: NSCompoundPredicate? = nil, sortDescriptor: NSSortDescriptor? = nil) -> [T] {
        let context = getContext()
        let request: NSFetchRequest<T>
        
        var fetchResult = [T]()
        
        if #available(iOS 10.0, *) {
            request = entity.fetchRequest() as! NSFetchRequest<T>
        } else {
            request = NSFetchRequest(entityName: String(describing: entity))
        }
        
        if let predicate = predicate {
            request.predicate = predicate
        }

        if let sortDescriptor = sortDescriptor {
            request.sortDescriptors = [sortDescriptor]
        }

        do {
            fetchResult = try context.fetch(request)
        } catch {
            debugPrint("fetchData ~~~~3~~~~Could not fetch: \(error.localizedDescription)")
        }
        
        return fetchResult
    }
}
