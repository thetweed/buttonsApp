//
//  ThemeCard.swift
//  Buttons
//
//  Created by Laurie on 3/5/25.
//
import SwiftUI
import CoreData

struct ThemeCard: View {
    let theme: ThemeOption
    let isSelected: Bool
    let onSelect: () -> Void
    
    var body: some View {
        Button(action: onSelect) {
            VStack(spacing: 8) {
                HStack {
                    Circle()
                        .fill(theme.primaryColor)
                        .frame(width: 20, height: 20)
                    
                    Circle()
                        .fill(theme.secondaryColor)
                        .frame(width: 20, height: 20)
                }
                
                Image(systemName: theme.previewImage)
                    .font(.largeTitle)
                    .foregroundColor(theme.primaryColor)
                    .frame(height: 40)
                
                Text(theme.name)
                    .font(.headline)
                    .foregroundColor(theme.isLocked ? .secondary : .primary)
                
                if theme.isLocked {
                    Text("Unlocks at level \(theme.unlockLevel)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .strokeBorder(isSelected ? theme.primaryColor : Color.gray.opacity(0.3), lineWidth: 2)
                    .background(RoundedRectangle(cornerRadius: 12).fill(Color.secondary.opacity(0.1)))
            )
            .overlay(
                theme.isLocked ?
                    RoundedRectangle(cornerRadius: 12)
                    .fill(Color.black.opacity(0.3))
                    .overlay(
                        Image(systemName: "lock.fill")
                            .font(.largeTitle)
                            .foregroundColor(.white)
                    )
                    : nil
            )
            .opacity(theme.isLocked ? 0.7 : 1.0)
        }
        .disabled(theme.isLocked)
    }
}
