//
//  DataController.swift
//  DailyCoffee
//
//  Created by Jinseok on 2021/10/23.
//

import Foundation
import CoreData

class DataController {
    static let instance: DataController = DataController(modelName: "DailyCoffee")
    
    let persistentContainer: NSPersistentContainer

    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    init(modelName:String) {
        persistentContainer = NSPersistentContainer(name: modelName)
        
        load()
    }

    func configureContexts() {
        viewContext.automaticallyMergesChangesFromParent = true
        viewContext.mergePolicy = NSMergePolicy.mergeByPropertyStoreTrump
    }

    func load(completion: (() -> Void)? = nil) {
        persistentContainer.loadPersistentStores { storeDescription, error in
            guard error == nil else {
                fatalError(error!.localizedDescription)
            }
            self.configureContexts()
            completion?()
        }
    }
    
    func save() {
        do {
            try DataController.instance.viewContext.save()
        } catch {
            fatalError("Data cannot be saved: \(error.localizedDescription)")
        }
    }
}
