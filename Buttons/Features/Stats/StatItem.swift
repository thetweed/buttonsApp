//
//  StatItem.swift
//  Buttons
//
//  Created by Laurie on 3/5/25.
//
import SwiftUI

struct StatItem: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.headline)
                .foregroundColor(.secondary)
            
            Spacer()
            
            Text(value)
                .font(.title3)
                .fontWeight(.bold)
        }
        .padding(.horizontal)
    }
}
