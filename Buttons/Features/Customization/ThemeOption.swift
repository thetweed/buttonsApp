//
//  ThemeOption.swift
//  Buttons
//
//  Created by Laurie on 3/5/25.
//
import SwiftUI
import CoreData

struct ThemeOption: Identifiable {
    let id: String
    let name: String
    let primaryColor: Color
    let secondaryColor: Color
    let accentColor: Color
    let fontName: String?
    let unlockLevel: Int64
    let buttonEffect: ButtonEffect?
    
    var isLocked: Bool
    var previewImage: String
    
    enum ButtonEffect {
        case pulse
        case glow
        case particles
        case rainbow
        case shake
        case rotate
        case bounce
    }
}
