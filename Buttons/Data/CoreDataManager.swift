//
//  CoreDataManager.swift
//  Buttons
//
//  Created by Laurie on 2/7/25.
//
import SwiftUI
import CoreData

struct CoreDataManager {
    static let shared = CoreDataManager()
    
    let container: NSPersistentContainer
    
    init() {
        container = NSPersistentContainer(name: "Buttons")
        
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                print("Core Data failed to load: \(error.localizedDescription)")
            }
        }
        
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
