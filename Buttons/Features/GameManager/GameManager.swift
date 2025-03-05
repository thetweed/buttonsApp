//
//  GameManager.swift
//  Buttons
//
//  Created by Laurie on 3/5/25.
//
import SwiftUI
import CoreData

class GameManager: ObservableObject {
    @Published var achievements: [Achievement] = []
    @Published var themes: [ThemeOption] = []
    @Published var selectedTheme: String = "default"
    @Published var showAchievements: Bool = false
    @Published var showCustomization: Bool = false
    @Published var showNewAchievementAlert: Bool = false
    @Published var lastUnlockedAchievement: Achievement?
    
    // Tracking for timed achievements
    @Published var lastClickTime: Date = Date()
    @Published var clickTimes: [Date] = []
    @Published var sessionStartTime: Date = Date()
    @Published var lastLoginDate: Date?
    
    init() {
        setupAchievements()
        setupThemes()
        sessionStartTime = Date()
        
        // Load last login date
        if let lastLogin = UserDefaults.standard.object(forKey: "lastLoginDate") as? Date {
            lastLoginDate = lastLogin
        }
        // Save current login
        UserDefaults.standard.set(Date(), forKey: "lastLoginDate")
    }
    
    private func setupAchievements() {
        achievements = [
            // Regular progress achievements
            Achievement(id: "first_click", title: "First Step", description: "Make your first click", iconName: "1.circle.fill", requiredClicks: 1, requiredLevel: 1, reward: 0.1),
            Achievement(id: "level_5", title: "Getting Started", description: "Reach level 5", iconName: "5.circle.fill", requiredClicks: 0, requiredLevel: 5, reward: 0.2),
            Achievement(id: "clicks_100", title: "Century", description: "Reach 100 total clicks", iconName: "100.circle.fill", requiredClicks: 100, requiredLevel: 0, reward: 0.3),
            Achievement(id: "level_10", title: "Double Digits", description: "Reach level 10", iconName: "10.circle.fill", requiredClicks: 0, requiredLevel: 10, reward: 0.5),
            Achievement(id: "clicks_1000", title: "Clickmaster", description: "Reach 1,000 total clicks", iconName: "hand.tap.fill", requiredClicks: 1000, requiredLevel: 0, reward: 1.0),
            Achievement(id: "level_25", title: "Quarter Century", description: "Reach level 25", iconName: "star.fill", requiredClicks: 0, requiredLevel: 25, reward: 1.5),
            Achievement(id: "clicks_10000", title: "Click Enthusiast", description: "Reach 10,000 total clicks", iconName: "flame.fill", requiredClicks: 10000, requiredLevel: 0, reward: 4.0),
            Achievement(id: "level_50", title: "Half Century", description: "Reach level 50", iconName: "50.circle.fill", requiredClicks: 0, requiredLevel: 50, reward: 5.0),
            Achievement(id: "clicks_100000", title: "Click Wizard", description: "Reach 100,000 total clicks", iconName: "wand.and.stars", requiredClicks: 100000, requiredLevel: 0, reward: 10.0),
            Achievement(id: "level_100", title: "Century Club", description: "Reach level 100", iconName: "100.circle.fill", requiredClicks: 0, requiredLevel: 100, reward: 20.0),
            Achievement(id: "clicks_500000", title: "Click God", description: "Reach 500,000 total clicks", iconName: "bolt.fill", requiredClicks: 500000, requiredLevel: 0, reward: 50.0),
            Achievement(id: "victory", title: "Winner Winner", description: "Reach 1,000,000 clicks and complete the game", iconName: "trophy.fill", requiredClicks: 1000000, requiredLevel: 0, reward: 100.0),
            
            // Hidden achievements (shown as ??? until unlocked)
            Achievement(id: "speed_demon", title: "Speed Demon", description: "Click 10 times within 1 second", iconName: "hare.fill", requiredClicks: 0, requiredLevel: 0, reward: 2.0, isUnlocked: false, isHidden: true, isTimed: true, timeRequirement: .rapidClicks(count: 10, withinSeconds: 1.0)),
            
            Achievement(id: "precision_clicker", title: "Precision Clicker", description: "Click exactly 3 seconds apart (±0.1s) 5 times in a row", iconName: "timer", requiredClicks: 0, requiredLevel: 0, reward: 3.0, isUnlocked: false, isHidden: true, isTimed: true, timeRequirement: .preciseTiming(targetSeconds: 3.0, tolerance: 0.1)),
            
            Achievement(id: "rhythm_master", title: "Rhythm Master", description: "Make 10 clicks exactly 1 second apart (±0.15s)", iconName: "metronome.fill", requiredClicks: 0, requiredLevel: 0, reward: 3.5, isUnlocked: false, isHidden: true, isTimed: true, timeRequirement: .consistentClicks(count: 10, intervalSeconds: 1.0, tolerance: 0.15)),
            
            Achievement(id: "dedicated_clicker", title: "Dedicated Clicker", description: "Play for 15 minutes straight", iconName: "clock.fill", requiredClicks: 0, requiredLevel: 0, reward: 4.0, isUnlocked: false, isHidden: true, isTimed: true, timeRequirement: .longSession(minutes: 15)),
            
            Achievement(id: "daily_clicker", title: "Daily Clicker", description: "Return to the game after 24 hours", iconName: "calendar", requiredClicks: 0, requiredLevel: 0, reward: 5.0, isUnlocked: false, isHidden: true, isTimed: true, timeRequirement: .dailyLogin),
            
            Achievement(id: "prime_clicker", title: "Prime Clicker", description: "Reach exactly a prime number of clicks", iconName: "number", requiredClicks: 0, requiredLevel: 0, reward: 3.0, isUnlocked: false, isHidden: true),
            
            Achievement(id: "devil_number", title: "Devilish Clicks", description: "Reach exactly 666 clicks", iconName: "flame.circle.fill", requiredClicks: 666, requiredLevel: 0, reward: 6.66, isUnlocked: false, isHidden: true),
            
            Achievement(id: "lucky_number", title: "Lucky Seven", description: "Reach exactly 777 clicks", iconName: "dice.fill", requiredClicks: 777, requiredLevel: 0, reward: 7.0, isUnlocked: false, isHidden: true)
        ]
    }
    
    private func setupThemes() {
        themes = [
            // Basic themes
            ThemeOption(
                id: "default",
                name: "Classic",
                primaryColor: .blue,
                secondaryColor: .indigo,
                accentColor: .blue,
                fontName: nil,
                unlockLevel: 1,
                buttonEffect: nil,
                isLocked: false,
                previewImage: "paintpalette"
            ),
            
            ThemeOption(
                id: "dark",
                name: "Dark Mode",
                primaryColor: .black,
                secondaryColor: .gray,
                accentColor: .white,
                fontName: nil,
                unlockLevel: 5,
                buttonEffect: nil,
                isLocked: true,
                previewImage: "moon.fill"
            ),
            
            ThemeOption(
                id: "neon",
                name: "Neon",
                primaryColor: .green,
                secondaryColor: .pink,
                accentColor: .yellow,
                fontName: "Menlo",
                unlockLevel: 10,
                buttonEffect: .glow,
                isLocked: true,
                previewImage: "light.beacon.max.fill"
            ),
            
            ThemeOption(
                id: "pastel",
                name: "Pastel",
                primaryColor: .pink,
                secondaryColor: .purple,
                accentColor: .mint,
                fontName: "Avenir-Light",
                unlockLevel: 15,
                buttonEffect: nil,
                isLocked: true,
                previewImage: "cloud.fill"
            ),
            
            // Additional themes
            ThemeOption(
                id: "fire",
                name: "Fire & Ice",
                primaryColor: .red,
                secondaryColor: .blue,
                accentColor: .orange,
                fontName: "Futura",
                unlockLevel: 25,
                buttonEffect: .pulse,
                isLocked: true,
                previewImage: "flame.fill"
            ),
            
            ThemeOption(
                id: "gold",
                name: "Golden",
                primaryColor: Color(red: 0.8, green: 0.7, blue: 0.0),
                secondaryColor: Color(red: 0.6, green: 0.4, blue: 0.2),
                accentColor: Color(red: 1.0, green: 0.9, blue: 0.0),
                fontName: "Copperplate",
                unlockLevel: 50,
                buttonEffect: .particles,
                isLocked: true,
                previewImage: "crown.fill"
            ),
            
            ThemeOption(
                id: "cosmic",
                name: "Cosmic",
                primaryColor: Color(red: 0.1, green: 0.0, blue: 0.3),
                secondaryColor: Color(red: 0.5, green: 0.0, blue: 0.5),
                accentColor: Color(red: 1.0, green: 0.5, blue: 1.0),
                fontName: "Futura-Medium",
                unlockLevel: 30,
                buttonEffect: .rainbow,
                isLocked: true,
                previewImage: "sparkles"
            ),
            
            ThemeOption(
                id: "retro",
                name: "8-Bit Retro",
                primaryColor: Color(red: 0.0, green: 0.5, blue: 0.0),
                secondaryColor: Color(red: 0.0, green: 0.0, blue: 0.0),
                accentColor: Color(red: 1.0, green: 1.0, blue: 1.0),
                fontName: "Courier",
                unlockLevel: 35,
                buttonEffect: nil,
                isLocked: true,
                previewImage: "gamecontroller.fill"
            ),
            
            ThemeOption(
                id: "ocean",
                name: "Deep Ocean",
                primaryColor: Color(red: 0.0, green: 0.3, blue: 0.6),
                secondaryColor: Color(red: 0.0, green: 0.2, blue: 0.4),
                accentColor: Color(red: 0.0, green: 0.8, blue: 1.0),
                fontName: "GillSans-Light",
                unlockLevel: 40,
                buttonEffect: .pulse,
                isLocked: true,
                previewImage: "water.waves"
            ),
            
            ThemeOption(
                id: "bubblegum",
                name: "Bubblegum",
                primaryColor: Color(red: 1.0, green: 0.4, blue: 0.7),
                secondaryColor: Color(red: 0.7, green: 0.9, blue: 1.0),
                accentColor: Color(red: 1.0, green: 1.0, blue: 0.6),
                fontName: "MarkerFelt-Thin",
                unlockLevel: 45,
                buttonEffect: .bounce,
                isLocked: true,
                previewImage: "bubble.right.fill"
            ),
            
            ThemeOption(
                id: "matrix",
                name: "Matrix",
                primaryColor: Color(red: 0.0, green: 0.5, blue: 0.0),
                secondaryColor: Color(red: 0.0, green: 0.2, blue: 0.0),
                accentColor: Color(red: 0.0, green: 1.0, blue: 0.0),
                fontName: "Courier-Bold",
                unlockLevel: 70,
                buttonEffect: .pulse,
                isLocked: true,
                previewImage: "terminal.fill"
            ),
            
            ThemeOption(
                id: "candy",
                name: "Candy Crush",
                primaryColor: Color(red: 1.0, green: 0.5, blue: 0.7),
                secondaryColor: Color(red: 0.9, green: 0.8, blue: 0.2),
                accentColor: Color(red: 0.2, green: 0.8, blue: 1.0),
                fontName: "ChalkboardSE-Bold",
                unlockLevel: 60,
                buttonEffect: .rainbow,
                isLocked: true,
                previewImage: "seal.fill"
            ),
            
            ThemeOption(
                id: "galaxy",
                name: "Galaxy",
                primaryColor: Color(red: 0.1, green: 0.0, blue: 0.2),
                secondaryColor: Color(red: 0.5, green: 0.0, blue: 0.7),
                accentColor: Color(red: 0.9, green: 0.9, blue: 1.0),
                fontName: "AvenirNext-Bold",
                unlockLevel: 80,
                buttonEffect: .particles,
                isLocked: true,
                previewImage: "star.circle.fill"
            ),
            
            ThemeOption(
                id: "sunset",
                name: "Sunset",
                primaryColor: Color(red: 0.9, green: 0.4, blue: 0.0),
                secondaryColor: Color(red: 0.7, green: 0.1, blue: 0.2),
                accentColor: Color(red: 1.0, green: 0.8, blue: 0.0),
                fontName: "Verdana",
                unlockLevel: 90,
                buttonEffect: .glow,
                isLocked: true,
                previewImage: "sun.max.fill"
            )
        ]
    }
    
    func checkAchievements(clicks: Int64, level: Int64) -> Double {
        var bonusMultiplier: Double = 0.0
        var newUnlocks = false
        
        // Check regular achievements
        for i in 0..<achievements.count {
            if !achievements[i].isUnlocked {
                // Regular click/level based achievements
                if (achievements[i].requiredClicks > 0 && clicks >= achievements[i].requiredClicks) ||
                   (achievements[i].requiredLevel > 0 && level >= achievements[i].requiredLevel) {
                    
                    achievements[i].isUnlocked = true
                    bonusMultiplier += achievements[i].reward
                    lastUnlockedAchievement = achievements[i]
                    newUnlocks = true
                }
                
                // Special case for prime numbers
                if achievements[i].id == "prime_clicker" && isPrime(number: clicks) && clicks > 10 {
                    achievements[i].isUnlocked = true
                    bonusMultiplier += achievements[i].reward
                    lastUnlockedAchievement = achievements[i]
                    newUnlocks = true
                }
                
                // Exact number achievements (like 666 or 777)
                if achievements[i].id == "devil_number" && clicks == 666 {
                    achievements[i].isUnlocked = true
                    bonusMultiplier += achievements[i].reward
                    lastUnlockedAchievement = achievements[i]
                    newUnlocks = true
                }
                
                if achievements[i].id == "lucky_number" && clicks == 777 {
                    achievements[i].isUnlocked = true
                    bonusMultiplier += achievements[i].reward
                    lastUnlockedAchievement = achievements[i]
                    newUnlocks = true
                }
            }
        }
        
        if newUnlocks {
            showNewAchievementAlert = true
        }
        
        return bonusMultiplier
    }
    
    func checkTimedAchievements() -> Double {
        var bonusMultiplier: Double = 0.0
        var newUnlocks = false
        let currentTime = Date()
        
        // Add current time to tracking array
        clickTimes.append(currentTime)
        
        // Keep only the last 20 clicks for efficiency
        if clickTimes.count > 20 {
            clickTimes.removeFirst(clickTimes.count - 20)
        }
        
        // Check each timed achievement
        for i in 0..<achievements.count {
            if !achievements[i].isUnlocked && achievements[i].isTimed,
               let timeReq = achievements[i].timeRequirement {
                
                switch timeReq {
                case .rapidClicks(let count, let seconds):
                    // Check if we have enough recent clicks
                    if clickTimes.count >= count {
                        // Get the subset of clicks to check
                        let recentClicks = Array(clickTimes.suffix(count))
                        // Calculate time difference between first and last click
                        if let firstClick = recentClicks.first,
                           let lastClick = recentClicks.last,
                           lastClick.timeIntervalSince(firstClick) <= seconds {
                            achievements[i].isUnlocked = true
                            bonusMultiplier += achievements[i].reward
                            lastUnlockedAchievement = achievements[i]
                            newUnlocks = true
                        }
                    }
                    
                case .preciseTiming(let target, let tolerance):
                    // Need at least 2 clicks to check timing
                    if clickTimes.count >= 2 {
                        let last = clickTimes.last!
                        let previous = clickTimes[clickTimes.count - 2]
                        let interval = last.timeIntervalSince(previous)
                        
                        // Check if interval is within tolerance
                        if abs(interval - target) <= tolerance {
                            achievements[i].isUnlocked = true
                            bonusMultiplier += achievements[i].reward
                            lastUnlockedAchievement = achievements[i]
                            newUnlocks = true
                        }
                    }
                    
                case .consistentClicks(let count, let interval, let tolerance):
                    // Need enough clicks to check the pattern
                    if clickTimes.count >= count {
                        let recentClicks = Array(clickTimes.suffix(count))
                        var isConsistent = true
                        
                        // Check each pair of clicks
                        for j in 1..<recentClicks.count {
                            let currentInterval = recentClicks[j].timeIntervalSince(recentClicks[j-1])
                            if abs(currentInterval - interval) > tolerance {
                                isConsistent = false
                                break
                            }
                        }
                        
                        if isConsistent {
                            achievements[i].isUnlocked = true
                            bonusMultiplier += achievements[i].reward
                            lastUnlockedAchievement = achievements[i]
                            newUnlocks = true
                        }
                    }
                    
                case .longSession(let minutes):
                    // Check session duration
                    let sessionDuration = currentTime.timeIntervalSince(sessionStartTime)
                    if sessionDuration >= (minutes * 60) {
                        achievements[i].isUnlocked = true
                        bonusMultiplier += achievements[i].reward
                        lastUnlockedAchievement = achievements[i]
                        newUnlocks = true
                    }
                    
                case .dailyLogin:
                    // Check if last login was at least 24 hours ago
                    if let lastLogin = lastLoginDate,
                       currentTime.timeIntervalSince(lastLogin) >= (24 * 60 * 60) {
                        achievements[i].isUnlocked = true
                        bonusMultiplier += achievements[i].reward
                        lastUnlockedAchievement = achievements[i]
                        newUnlocks = true
                    }
                }
            }
        }
        
        if newUnlocks {
            showNewAchievementAlert = true
        }
        
        // Update last click time
        lastClickTime = currentTime
        
        return bonusMultiplier
    }
    
    func unlockThemes(level: Int64) {
        for i in 0..<themes.count {
            if themes[i].isLocked && level >= themes[i].unlockLevel {
                themes[i].isLocked = false
            }
        }
    }
    
    // Helper function to check if a number is prime
    private func isPrime(number: Int64) -> Bool {
        if number <= 1 {
            return false
        }
        if number <= 3 {
            return true
        }
        if number % 2 == 0 || number % 3 == 0 {
            return false
        }
        var i: Int64 = 5
        while i * i <= number {
            if number % i == 0 || number % (i + 2) == 0 {
                return false
            }
            i += 6
        }
        return true
    }
}
