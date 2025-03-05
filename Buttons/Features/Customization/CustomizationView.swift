//
//  CustomizationView.swift
//  Buttons
//
//  Created by Laurie on 3/5/25.
//
import SwiftUI
import CoreData

// CustomizationView.swift
struct CustomizationView: View {
    let themes: [ThemeOption]
    @Binding var selectedTheme: String
    let onClose: () -> Void
    
    var body: some View {
        VStack {
            HStack {
                Text("Customization")
                    .font(.title)
                    .bold()
                
                Spacer()
                
                Button(action: onClose) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title2)
                        .foregroundColor(.secondary)
                }
            }
            .padding(.bottom)
            
            Text("Unlock themes as you level up!")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .padding(.bottom)
            
            ScrollView {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                    ForEach(themes) { theme in
                        ThemeCard(
                            theme: theme,
                            isSelected: selectedTheme == theme.id,
                            onSelect: {
                                if !theme.isLocked {
                                    selectedTheme = theme.id
                                }
                            }
                        )
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
