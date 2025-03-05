//
//  ButtonWithEffect.swift
//  Buttons
//
//  Created by Laurie on 3/5/25.
//
import SwiftUI
import CoreData

struct ButtonWithEffect: View {
    let action: () -> Void
    let content: AnyView
    let effect: ThemeOption.ButtonEffect?
    @State private var isAnimating = false
    
    init<Content: View>(action: @escaping () -> Void, effect: ThemeOption.ButtonEffect?, @ViewBuilder content: () -> Content) {
        self.action = action
        self.effect = effect
        self.content = AnyView(content())
    }
    
    var body: some View {
        Button(action: {
            action()
            if effect != nil {
                withAnimation {
                    isAnimating = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                    withAnimation {
                        isAnimating = false
                    }
                }
            }
        }) {
            content
                .scaleEffect(effectScale)
                .rotationEffect(effectRotation)
                .overlay(effectOverlay)
                .animation(effectAnimation, value: isAnimating)
        }
    }
    
    // Dynamic properties based on effect type
    private var effectScale: CGSize {
        guard isAnimating else { return CGSize(width: 1, height: 1) }
        
        switch effect {
        case .pulse:
            return CGSize(width: 1.05, height: 1.05)
        case .bounce:
            return CGSize(width: 0.97, height: 1.1)
        default:
            return CGSize(width: 1, height: 1)
        }
    }
    
    private var effectRotation: Angle {
        guard isAnimating else { return .zero }
        
        switch effect {
        case .rotate:
            return Angle(degrees: 5)
        case .shake:
            return Angle(degrees: Double.random(in: -3...3))
        default:
            return .zero
        }
    }
    
    private var effectOverlay: some View {
        Group {
            switch effect {
            case .glow:
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.white.opacity(isAnimating ? 0.3 : 0))
                    .blur(radius: 5)
            case .particles where isAnimating:
                ParticleEffectView()
            case .rainbow where isAnimating:
                LinearGradient(
                    gradient: Gradient(colors: [.red, .orange, .yellow, .green, .blue, .purple]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .opacity(0.3)
                .mask(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(lineWidth: 3)
                )
            default:
                EmptyView()
            }
        }
    }
    
    private var effectAnimation: Animation? {
        guard effect != nil else { return nil }
        
        switch effect {
        case .pulse:
            return Animation.easeInOut(duration: 0.5).repeatCount(1)
        case .bounce:
            return Animation.spring(response: 0.4, dampingFraction: 0.6)
        case .shake:
            return Animation.spring(response: 0.2, dampingFraction: 0.2)
        case .rotate:
            return Animation.easeInOut(duration: 0.3).repeatCount(1, autoreverses: true)
        default:
            return Animation.easeInOut(duration: 0.5)
        }
    }
}
