//
//  ProgressBar.swift
//  SoniScope
//
//  Created by Chiling Han on 7/25/25.
//
import SwiftUI

struct ProgressBar: View {
    var progress: CGFloat
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 3)
                .frame(width: 300, height: 6)
                .foregroundColor(Color.gray.opacity(0.3))
            
            HStack {
                LinearGradient(
                    colors: [
                        .soniscopeOrange,
                        .soniscopeBlue
                    ],
                    startPoint: .leading,
                    endPoint: .trailing
                )
                .frame(width: 300 * progress, height: 6)
                .cornerRadius(3)
                .animation(.linear(duration: 1), value: progress)
                
                Spacer()
            }
            .frame(width: 300, height: 6)
        }
    }
}

