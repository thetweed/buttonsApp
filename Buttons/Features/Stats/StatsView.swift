//
//  StatsView.swift
//  Buttons
//
//  Created by Laurie on 3/5/25.
//

import SwiftUI
import CoreData

struct StatsView: View {
    let clicks: Int64
    let level: Int64
    let multiplier: Double
    let onClose: () -> Void
    
    var body: some View {
        VStack {
            HStack {
                Text("Game Statistics")
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
            
            VStack(spacing: 20) {
                StatItem(title: "Total Clicks", value: "\(clicks)")
                StatItem(title: "Current Level", value: "\(level)")
                StatItem(title: "Clicks Per Tap", value: "\(String(format: "%.1f", multiplier))")
                
                if clicks > 0 {
                    StatItem(title: "Progress to Goal", value: "\(String(format: "%.2f", Double(clicks) / 1_000_000.0 * 100))%")
                }
                
                StatItem(title: "Estimated Clicks to Win", value: "\(max(0, 1_000_000 - clicks))")
                
                if multiplier > 0 {
                    StatItem(title: "Estimated Taps to Win", value: "\(Int64(ceil(Double(max(0, 1_000_000 - clicks)) / multiplier)))")
                }
            }
            .padding()
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
