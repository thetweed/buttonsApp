//
//  ContentView.swift
//  Buttons
//
//  Created by Laurie on 2/7/25.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(fetchRequest: GameState.defaultGameState)
    private var gameStates: FetchedResults<GameState>
    
    @StateObject private var gameManager = GameManager()
    
    private var gameState: GameState? {
        gameStates.first
    }
    
    @State private var showError = false
    @State private var errorMessage = ""
    @State private var animateLevelUp = false
    @State private var showProgress = false
    @State private var showStats = false
    
    var body: some View {
        ZStack {
            // Main Game View
            VStack(spacing: 20) {
                // Top toolbar with buttons
                HStack {
                    Button(action: {
                        gameManager.showAchievements = true
                    }) {
                        Image(systemName: "trophy.fill")
                            .font(.title2)
                            .foregroundColor(themeColor(for: .primary))
                    }
                    
                    Spacer()
                    
                    Button(action: { showStats.toggle() }) {
                        Image(systemName: "chart.bar.fill")
                            .font(.title2)
                            .foregroundColor(themeColor(for: .primary))
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        gameManager.showCustomization = true
                    }) {
                        Image(systemName: "paintpalette.fill")
                            .font(.title2)
                            .foregroundColor(themeColor(for: .primary))
                    }
                }
                .padding(.horizontal)
                
                Text("Level: \(gameState?.level ?? 1)")
                    .font(customFont(.title))
                    .foregroundColor(levelTextColor)
                    .scaleEffect(animateLevelUp ? 1.2 : 1.0)
                    .animation(animateLevelUp ? .spring(response: 0.3, dampingFraction: 0.6) : .default, value: animateLevelUp)
                
                Text("Clicks: \(gameState?.clicks ?? 0) / 1,000,000")
                    .font(customFont(.headline))
                    .foregroundColor(themeColor(for: .primary))
                
                // Progress bar
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(themeColor(for: .secondary).opacity(0.3))
                        .frame(height: 12)
                    
                    RoundedRectangle(cornerRadius: 8)
                        .fill(themeColor(for: .primary))
                        .frame(width: progressBarWidth, height: 12)
                        .animation(.easeInOut, value: gameState?.clicks ?? 0)
                }
                .padding(.horizontal)
                
                // Stats display
                HStack {
                    VStack(alignment: .leading) {
                        Text("Multiplier:")
                            .font(customFont(.caption))
                            .foregroundColor(themeColor(for: .secondary))
                        
                        Text("x \(String(format: "%.1f", gameState?.multiplier ?? 1.0))")
                            .font(customFont(.subheadline))
                            .foregroundColor(themeColor(for: .primary))
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing) {
                        Text("Achievements:")
                            .font(customFont(.caption))
                            .foregroundColor(themeColor(for: .secondary))
                        
                        Text("\(unlockedAchievementsCount)/\(gameManager.achievements.count)")
                            .font(customFont(.subheadline))
                            .foregroundColor(themeColor(for: .primary))
                    }
                }
                .padding(.horizontal)
                
                // Next level info
                if let state = gameState, state.clicks < 1_000_000 {
                    let nextThreshold = calculateNextLevelThreshold(for: state.level)
                    let remaining = max(0, Int64(nextThreshold) - state.clicks)
                    Text("Next level: \(remaining) more clicks")
                        .font(customFont(.caption))
                        .foregroundColor(themeColor(for: .secondary))
                }
                
                // Main Button
                ClickerButton(
                    action: handleClick,
                    buttonText: buttonText,
                    level: gameState?.level ?? 1,
                    themeColors: (
                        primary: themeColor(for: .primary),
                        secondary: themeColor(for: .secondary),
                        accent: currentTheme?.accentColor ?? .blue
                    ),
                    fontName: currentTheme?.fontName,
                    buttonEffect: currentTheme?.buttonEffect
                )
                .padding(.vertical)
                
                // Game completion or tier unlocked message
                if let state = gameState {
                    if state.clicks >= 1_000_000 {
                        Text("🎉 GAME COMPLETED! 🎉")
                            .font(customFont(.headline))
                            .foregroundColor(.green)
                            .padding(.top, 10)
                            .scaleEffect(animateLevelUp ? 1.1 : 1.0)
                            .animation(Animation.easeInOut(duration: 0.5).repeatForever(), value: animateLevelUp)
                    } else if state.level >= 10 {
                        Text("Unlocked Tier \(state.level / 10)")
                            .font(customFont(.caption))
                            .padding(.top, 10)
                            .foregroundColor(themeColor(for: .secondary))
                    }
                }
                
                // Level Info Button
                Button("Show Level Info") {
                    showProgress.toggle()
                }
                .font(customFont(.caption))
                .foregroundColor(themeColor(for: .primary))
                .padding(.top, 10)
                
                // Level Progression Info
                if showProgress, let state = gameState {
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Game Progress:")
                            .font(customFont(.caption))
                            .fontWeight(.bold)
                        
                        Text("• Levels 1-4: +10 clicks per level")
                            .font(customFont(.caption))
                        Text("• Levels 5-9: +20 clicks per level")
                            .font(customFont(.caption))
                        Text("• Levels 10-19: +20% difficulty increase per level")
                            .font(customFont(.caption))
                        Text("• Levels 20+: +50% difficulty increase per level")
                            .font(customFont(.caption))
                        
                        Text("Current threshold: \(Int(calculateNextLevelThreshold(for: state.level))) clicks")
                            .font(customFont(.caption))
                            .fontWeight(.bold)
                            .padding(.top, 5)
                    }
                    .padding()
                    .background(themeColor(for: .secondary).opacity(0.1))
                    .cornerRadius(10)
                }
            }
            .padding()
            .onAppear(perform: initializeGameStateIfNeeded)
            .alert("Error", isPresented: $showError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(errorMessage)
            }
            
            // Stats Overlay
            if showStats {
                StatsView(clicks: gameState?.clicks ?? 0, level: gameState?.level ?? 1, multiplier: gameState?.multiplier ?? 1.0, onClose: { showStats = false })
                    .transition(.opacity)
                    .zIndex(1)
            }
            
            // Achievements Overlay
            if gameManager.showAchievements {
                Color.black.opacity(0.4)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        gameManager.showAchievements = false
                    }
                    .zIndex(1)
                
                AchievementView(
                    achievements: gameManager.achievements,
                    onClose: { gameManager.showAchievements = false }
                )
                .transition(.scale)
                .zIndex(2)
            }
            
            // Customization Overlay
            if gameManager.showCustomization {
                Color.black.opacity(0.4)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        gameManager.showCustomization = false
                    }
                    .zIndex(1)
                
                CustomizationView(
                    themes: gameManager.themes,
                    selectedTheme: $gameManager.selectedTheme,
                    onClose: { gameManager.showCustomization = false }
                )
                .transition(.scale)
                .zIndex(2)
            }
            
            // New Achievement Alert
            if gameManager.showNewAchievementAlert, let achievement = gameManager.lastUnlockedAchievement {
                VStack {
                    Spacer()
                    
                    HStack {
                        Image(systemName: achievement.iconName)
                            .font(.title)
                            .foregroundColor(.yellow)
                        
                        VStack(alignment: .leading) {
                            Text("Achievement Unlocked!")
                                .font(.headline)
                            
                            Text(achievement.title)
                                .font(.subheadline)
                            
                            Text("+\(String(format: "%.1f", achievement.reward))x multiplier!")
                                .font(.caption)
                                .foregroundColor(.green)
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            gameManager.showNewAchievementAlert = false
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color(.systemBackground))
                            .shadow(radius: 5)
                    )
                    .padding()
                }
                .transition(.move(edge: .bottom))
                .zIndex(3)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                        gameManager.showNewAchievementAlert = false
                    }
                }
            }
        }
    }
    
    // MARK: - Helper Properties
    
    private var progressBarWidth: CGFloat {
        let progress = min(Double(gameState?.clicks ?? 0) / 1_000_000.0, 1.0)
        let screenWidth = UIScreen.main.bounds.width - 40 // Account for padding
        return screenWidth * CGFloat(progress)
    }
    
    private var unlockedAchievementsCount: Int {
        gameManager.achievements.filter { $0.isUnlocked }.count
    }
    
    private var currentTheme: ThemeOption? {
        gameManager.themes.first { $0.id == gameManager.selectedTheme }
    }
    
    private func themeColor(for type: ColorType) -> Color {
        guard let theme = currentTheme else {
            return type == .primary ? .blue : .indigo
        }
        return type == .primary ? theme.primaryColor : theme.secondaryColor
    }
    
    private func customFont(_ font: Font) -> Font {
        guard let theme = currentTheme, let fontName = theme.fontName else {
            return font
        }
        
        switch font {
        case .title:
            return .custom(fontName, size: 34)
        case .title2:
            return .custom(fontName, size: 28)
        case .title3:
            return .custom(fontName, size: 22)
        case .headline:
            return .custom(fontName, size: 18)
        case .subheadline:
            return .custom(fontName, size: 16)
        case .body:
            return .custom(fontName, size: 16)
        case .callout:
            return .custom(fontName, size: 15)
        case .caption:
            return .custom(fontName, size: 12)
        case .caption2:
            return .custom(fontName, size: 10)
        default:
            return font
        }
    }
    
    private var buttonText: String {
        // If game is won, show special text
        if let clicks = gameState?.clicks, clicks >= 1_000_000 {
            return "WINNER!"
        }
        
        let level = gameState?.level ?? 1
        switch level {
        case 1..<10:
            return "Click Me!"
        case 10..<20:
            return "Tap Me!"
        case 20..<30:
            return "Smash Me!"
        case 30..<40:
            return "Power Up!"
        case 40..<50:
            return "Supercharge!"
        case 50..<75:
            return "ULTIMATE CLICK!"
        case 75..<100:
            return "MEGA POWER!"
        default:
            return "GOD MODE!"
        }
    }
    
    private var levelTextColor: Color {
        if let theme = currentTheme {
            return theme.primaryColor
        }
        
        let level = gameState?.level ?? 1
        switch level {
        case 1..<10:
            return .primary
        case 10..<20:
            return .purple
        case 20..<30:
            return .red
        case 30..<40:
            return .orange
        case 40..<50:
            return .green
        default:
            return .indigo
        }
    }
    
    // MARK: - Helper Methods
    
    private func initializeGameStateIfNeeded() {
        guard gameStates.isEmpty else {
            // If game state exists, check for themes to unlock and achievements
            if let state = gameState {
                gameManager.unlockThemes(level: state.level)
                gameManager.checkAchievements(clicks: state.clicks, level: state.level)
            }
            return
        }
        
        let newGameState = GameState(context: viewContext)
        newGameState.clicks = 0
        newGameState.level = 1
        newGameState.multiplier = 1.0
        
        do {
            try viewContext.save()
        } catch {
            print("Failed to initialize game state: \(error)")
            errorMessage = "Failed to initialize game state: \(error.localizedDescription)"
            showError = true
        }
    }
    
    // Calculate the exponentially increasing threshold for each level
    private func calculateNextLevelThreshold(for level: Int64) -> Double {
        // First few levels increase by 10 clicks each
        if level < 5 {
            return Double(level * 10)
        }
        // Levels 5-10 increase by 20 clicks each
        else if level < 10 {
            return Double(50 + (level - 5) * 20)
        }
        // Levels 10-20 increase exponentially but moderately
        else if level < 20 {
            return Double(150 * pow(1.2, Double(level - 10)))
        }
        // Levels 20+ increase more steeply
        else {
            return Double(450 * pow(1.5, Double(level - 20)))
        }
    }
    
    private func handleClick() {
        guard let gameState = gameState else {
            errorMessage = "No game state found"
            showError = true
            return
        }
        
        // Check if game is already won
        if gameState.clicks >= 1_000_000 {
            return
        }
        
        let clickValue = Int64(gameState.multiplier)
        gameState.clicks += clickValue
        
        // Check regular achievements and get bonus
        let achievementBonus = gameManager.checkAchievements(clicks: gameState.clicks, level: gameState.level)
        
        // Check timed achievements
        let timedBonus = gameManager.checkTimedAchievements()
        
        // Apply all bonuses
        if achievementBonus > 0 || timedBonus > 0 {
            gameState.multiplier += (achievementBonus + timedBonus)
        }
        
        // Check for win condition
        if gameState.clicks >= 1_000_000 {
            handleWin()
            return
        }
        
        // Level up logic with progressive difficulty
        let currentLevel = gameState.level
        let nextLevelThreshold = calculateNextLevelThreshold(for: gameState.level)
        
        if Double(gameState.clicks) >= nextLevelThreshold {
            gameState.level += 1
            gameState.multiplier += 0.5
            
            // Unlock themes based on new level
            gameManager.unlockThemes(level: gameState.level)
            
            // Animate level up if level changes
            if currentLevel != gameState.level {
                animateLevelUp = true
                // Reset animation after delay
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    animateLevelUp = false
                }
                
                // Play haptic feedback for level up
                let generator = UINotificationFeedbackGenerator()
                generator.notificationOccurred(.success)
            }
        }
        
        do {
            if viewContext.hasChanges {
                try viewContext.save()
            }
        } catch {
            print("Failed to save game state: \(error)")
            errorMessage = "Failed to save game state: \(error.localizedDescription)"
            showError = true
        }
    }
    
    private func handleWin() {
        // Play winning haptic feedback
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        
        // Set win state (if needed in the future)
        animateLevelUp = true
        
        // Check for victory achievement
        _ = gameManager.checkAchievements(clicks: 1_000_000, level: gameState?.level ?? 1)
        
        // Show winning alert
        errorMessage = "Congratulations! You've reached 1 million clicks and won the game!"
        showError = true
        
        // Keep animation running longer for victory
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            animateLevelUp = false
        }
        
        do {
            if viewContext.hasChanges {
                try viewContext.save()
            }
        } catch {
            print("Failed to save final game state: \(error)")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
                .environment(\.managedObjectContext, PreviewCoreDataManager.preview.container.viewContext)
                .previewDisplayName("Preview")

        }
    }
}
