//
//  BodyImageWithPulsingDot.swift
//  SoniScope
//
//  Created by Chiling Han on 7/25/25.
//


import SwiftUI

struct BodyImageWithPulsingDot: View {
    @State private var pulse = false
    @EnvironmentObject var healthManager: HealthDataManager

    var body: some View {
        ZStack {
            // Background image clipped inside a rounded rectangle frame
            if healthManager.biologicalSex == "Female" {
                Image(.femaleLowRes)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 450, height: 470)
                .clipped()
                .cornerRadius(12)
            }
            else {
                Image(.bodyLowRes)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 450, height: 470)
                .clipped()
                .cornerRadius(12)
            }
                

            // Pulsing Dot (e.g., placement indicator)
            ZStack {
                Circle()
                    .stroke(Color(red: 0.99, green: 0.52, blue: 0), lineWidth: 2)
                    .frame(width: 40, height: 40)
                    .scaleEffect(pulse ? 1.4 : 1.0)
                    .opacity(pulse ? 0.0 : 0.8)
                    .animation(
                        Animation.easeOut(duration: 1.0).repeatForever(autoreverses: false),
                        value: pulse
                    )

                Circle()
                    .frame(width: 25, height: 25)
                    .foregroundColor(Color(red: 0.99, green: 0.52, blue: 0))
            }
            // Adjust this offset to place dot over desired body part
            .offset(x: -70, y: -90)
        }
        .onAppear {
            pulse = true
        }
    }
}
