//
//  StepCardView.swift
//  SoniScope
//
//  Created by Chiling Han on 7/25/25.
//


import SwiftUI

struct StepCardView: View {
    var stepNumber: Int = 3
    var title: String = "Record & Analyze"
    var subtitle: String = "Breathe normally and deeply. Maintain quiet environment during recording."
    var buttonText: String = "Record"
    var onRecord: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            // Top: Step number + Title
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color(red: 0.56, green: 0.79, blue: 0.9),
                                    Color(red: 0.99, green: 0.52, blue: 0)
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 32, height: 32)

                    Text("\(stepNumber)")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.black)
                }

                Text(title)
                    .font(.system(size: 25, weight: .bold))
                    .foregroundColor(.white)

                Spacer()
            }

            Divider()
                .background(Color(red: 0.25, green: 0.25, blue: 0.27))

            // Instructions
            Text(subtitle)
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(Color.gray)
                .fixedSize(horizontal: false, vertical: true)

            Spacer()

            // Record Button
            Button(action: {
                onRecord()
            }) {
                HStack {
                    Image(systemName: "play.fill")
                    Text(buttonText)
                        .fontWeight(.semibold)
                }
                .font(.system(size: 18))
                .frame(maxWidth: .infinity, minHeight: 45)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            .soniscopeOrange,
                            .soniscopeBlue
                        ]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .foregroundColor(.black)
                .cornerRadius(15)
                .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 4)
            }
        }
        .padding(24)
        .background(Color(red: 0.11, green: 0.11, blue: 0.12))
        .cornerRadius(24)
        .frame(width: 350, height: 300)
    }
}

#Preview {
    StepCardView(onRecord:{})
}
