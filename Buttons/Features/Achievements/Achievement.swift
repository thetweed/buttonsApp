//
//  Achievement.swift
//  Buttons
//
//  Created by Laurie on 3/5/25.
//
import SwiftUI
import CoreData

struct Achievement: Identifiable, Equatable {
    let id: String
    let title: String
    let description: String
    let iconName: String
    let requiredClicks: Int64
    let requiredLevel: Int64
    let reward: Double  // Multiplier bonus
    var isUnlocked: Bool = false
    var isHidden: Bool = false  // Hidden until unlocked
    var isTimed: Bool = false   // Requires a timed challenge
    
    // For timed achievements
    var timeRequirement: TimeRequirement?
    
    static func == (lhs: Achievement, rhs: Achievement) -> Bool {
        return lhs.id == rhs.id
    }
}

// Time requirement type for achievements
enum TimeRequirement {
    case rapidClicks(count: Int, withinSeconds: Double)
    case preciseTiming(targetSeconds: Double, tolerance: Double)
    case consistentClicks(count: Int, intervalSeconds: Double, tolerance: Double)
    case longSession(minutes: Double)
    case dailyLogin
    
    var description: String {
        switch self {
        case .rapidClicks(let count, let seconds):
            return "\(count) clicks within \(String(format: "%.1f", seconds)) seconds"
        case .preciseTiming(let target, let tolerance):
            return "Click exactly \(String(format: "%.1f", target)) seconds apart (±\(String(format: "%.2f", tolerance)))"
        case .consistentClicks(let count, let interval, let tolerance):
            return "\(count) clicks, each \(String(format: "%.1f", interval)) seconds apart (±\(String(format: "%.2f", tolerance)))"
        case .longSession(let minutes):
            return "Play for \(String(format: "%.1f", minutes)) minutes straight"
        case .dailyLogin:
            return "Return to the game after 24 hours"
        }
    }
}
