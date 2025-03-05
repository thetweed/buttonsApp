//
//  ParticleEffectView.swift
//  Buttons
//
//  Created by Laurie on 3/5/25.
//
import SwiftUI
import CoreData

struct ParticleEffectView: View {
    @State private var time = 0.0
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            ForEach(0..<15) { i in
                Circle()
                    .fill(particleColor(index: i))
                    .frame(width: 8, height: 8)
                    .offset(x: particleOffset(index: i).width, y: particleOffset(index: i).height)
                    .opacity(particleOpacity(index: i))
                    .animation(.spring(response: 0.8, dampingFraction: 0.8), value: time)
            }
        }
        .onReceive(timer) { _ in
            time += 0.1
        }
    }
    
    private func particleColor(index: Int) -> Color {
        let colors: [Color] = [.red, .orange, .yellow, .green, .blue, .purple]
        return colors[index % colors.count]
    }
    
    private func particleOffset(index: Int) -> CGSize {
        let angle = Double(index) * (360.0 / 15.0) * .pi / 180.0
        let distance = 50.0 * min(time, 1.0)
        return CGSize(
            width: cos(angle) * distance,
            height: sin(angle) * distance
        )
    }
    
    private func particleOpacity(index: Int) -> Double {
        return max(0, 1 - time)
    }
}
