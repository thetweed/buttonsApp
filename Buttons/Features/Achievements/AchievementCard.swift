//
//  AchievementCard.swift
//  Buttons
//
//  Created by Laurie on 3/5/25.
//
import SwiftUI
import CoreData

struct AchievementCard: View {
    let achievement: Achievement
    
    var body: some View {
        VStack(spacing: 8) {
            if achievement.isHidden && !achievement.isUnlocked {
                Image(systemName: "questionmark.circle.fill")
                    .font(.largeTitle)
                    .foregroundColor(.gray)
                    .frame(height: 40)
                
                Text("???")
                    .font(.headline)
                    .foregroundColor(.secondary)
                
                Text("Hidden Achievement")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                
                if let timed = achievement.timeRequirement {
                    Text("Time-based challenge")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                        .italic()
                }
            } else {
                Image(systemName: achievement.isUnlocked ? achievement.iconName : "lock.fill")
                    .font(.largeTitle)
                    .foregroundColor(achievement.isUnlocked ? .blue : .gray)
                    .frame(height: 40)
                
                Text(achievement.title)
                    .font(.headline)
                    .foregroundColor(achievement.isUnlocked ? .primary : .secondary)
                    .multilineTextAlignment(.center)
                
                Text(achievement.description)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                
                if achievement.isUnlocked {
                    Text("+\(String(format: "%.1f", achievement.reward))x")
                        .font(.caption)
                        .foregroundColor(.green)
                        .padding(.top, 4)
                }
                
                if !achievement.isUnlocked && achievement.isTimed, let timeReq = achievement.timeRequirement {
                    Text(timeReq.description)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                        .italic()
                        .padding(.top, 2)
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .strokeBorder(achievement.isUnlocked ? Color.blue.opacity(0.5) : Color.gray.opacity(0.3), lineWidth: 2)
                .background(RoundedRectangle(cornerRadius: 12).fill(Color.secondary.opacity(0.1)))
        )
        .opacity(achievement.isUnlocked || !achievement.isHidden ? 1.0 : 0.7)
    }
}
