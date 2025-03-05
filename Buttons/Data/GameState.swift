//
//  GameState.swift
//  Buttons
//
//  Created by Laurie on 2/7/25.
//

import Foundation
import CoreData

public class GameState: NSManagedObject {
}

extension GameState {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GameState> {
        return NSFetchRequest<GameState>(entityName: "GameState")
    }

    @NSManaged public var clicks: Int64
    @NSManaged public var level: Int64
    @NSManaged public var multiplier: Double
    @NSManaged public var theme: String?
    @NSManaged public var unlockedAchievements: [String]?
}

extension GameState : Identifiable {
}

extension GameState {
    static var defaultGameState: NSFetchRequest<GameState> {
        let request = NSFetchRequest<GameState>(entityName: "GameState")
        request.sortDescriptors = [NSSortDescriptor(keyPath: \GameState.level, ascending: true)]
        request.fetchLimit = 1
        return request
    }
}
