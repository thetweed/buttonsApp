//
//  PreviewCoreDataManager.swift
//  Buttons
//
//  Created by Laurie on 2/7/25.
//
import SwiftUI
import CoreData

class PreviewCoreDataManager {
    static let preview: CoreDataManager = {
        let manager = CoreDataManager()
        let viewContext = manager.container.viewContext
        do {
            try viewContext.save()
        } catch {
            fatalError("Failed to create preview game state: \(error)")
        }
        return manager
    }()
}
