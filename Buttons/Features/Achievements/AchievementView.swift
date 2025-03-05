//
//  AchievementView.swift
//  Buttons
//
//  Created by Laurie on 3/5/25.
//
import SwiftUI
import CoreData

struct AchievementView: View {
    let achievements: [Achievement]
    let onClose: () -> Void
    @State private var showHidden: Bool = false
    
    var body: some View {
        VStack {
            HStack {
                Text("Achievements")
                    .font(.title)
                    .bold()
                
                Spacer()
                
                Toggle("Show Hidden", isOn: $showHidden)
                    .labelsHidden()
                
                Button(action: onClose) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title2)
                        .foregroundColor(.secondary)
                }
            }
            .padding(.bottom)
            
            Text("Unlock achievements to earn multiplier bonuses!")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .padding(.bottom)
            
            ScrollView {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                    ForEach(achievements.filter { !$0.isHidden || $0.isUnlocked || showHidden }) { achievement in
                        AchievementCard(achievement: achievement)
                    }
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.systemBackground))
                .shadow(radius: 10)
        )
        .padding()
    }
}
