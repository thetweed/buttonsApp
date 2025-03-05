//
//  ClickerButton.swift
//  Buttons
//
//  Created by Laurie on 2/8/25.
//
import SwiftUI
import CoreData


struct ClickerButton: View {
    let action: () -> Void
    let buttonText: String
    let level: Int64
    var themeColors: (primary: Color, secondary: Color, accent: Color)
    var fontName: String?
    var buttonEffect: ThemeOption.ButtonEffect?
    
    // Define button styles for different level tiers
    private var buttonColor: Color {
        if level >= 50 {
            return themeColors.primary
        }
        
        switch level {
        case 1..<10:
            return themeColors.primary
        case 10..<20:
            return .purple
        case 20..<30:
            return .red
        case 30..<40:
            return .orange
        case 40..<50:
            return .green
        default:
            return themeColors.primary
        }
    }
    
    private var buttonFont: Font {
        let baseFont: Font
        switch level {
        case 1..<10:
            baseFont = .headline
        case 10..<20:
            baseFont = .title3
        case 20..<30:
            baseFont = .title2
        default:
            baseFont = .title
        }
        
        // Use custom font if available
        if let fontName = fontName {
            switch baseFont {
            case .headline:
                return .custom(fontName, size: 17)
            case .title3:
                return .custom(fontName, size: 20)
            case .title2:
                return .custom(fontName, size: 25)
            case .title:
                return .custom(fontName, size: 30)
            default:
                return baseFont
            }
        }
        
        return baseFont
    }
    
    private var buttonShape: CGFloat {
        switch level {
        case 1..<10:
            return 15
        case 10..<20:
            return 20
        case 20..<30:
            return 25
        case 30..<40:
            return 10
        case 40..<50:
            return 5
        default:
            return 0 // square for levels 50+
        }
    }
    
    private var buttonSize: CGFloat {
        let baseSize: CGFloat = 100
        let levelMultiplier = CGFloat(min(level / 10, 5)) * 10
        return baseSize + levelMultiplier
    }
    
    var body: some View {
        ButtonWithEffect(action: action, effect: buttonEffect) {
            VStack {
                Text(buttonText)
                    .font(buttonFont)
                    .foregroundColor(.white)
                
                if level >= 20 {
                    Text("Level \(level)")
                        .font(fontName != nil ? .custom(fontName!, size: 12) : .caption)
                        .foregroundColor(.white.opacity(0.8))
                }
            }
            .padding()
            .frame(minWidth: buttonSize, minHeight: buttonSize)
            .background(
                RoundedRectangle(cornerRadius: buttonShape)
                    .fill(buttonColor)
                    .shadow(radius: min(10, CGFloat(level) / 5))
            )
            .overlay(
                level >= 30 ?
                RoundedRectangle(cornerRadius: buttonShape)
                    .strokeBorder(Color.white.opacity(0.3), lineWidth: 2) : nil
            )
        }
    }
}

struct ScaleButtonStyle: ButtonStyle {
    let level: Int64
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
            .rotationEffect(level >= 40 && configuration.isPressed ? Angle(degrees: 3) : Angle(degrees: 0))
    }
}

// Helper Types
enum ColorType {
    case primary
    case secondary
}
