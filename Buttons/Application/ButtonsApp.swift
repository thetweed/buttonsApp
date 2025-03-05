//
//  ButtonsApp.swift
//  Buttons
//
//  Created by Laurie on 2/7/25.
//

import SwiftUI
import CoreData

@main
struct ButtonsApp: App {
    let persistenceController = CoreDataManager.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
