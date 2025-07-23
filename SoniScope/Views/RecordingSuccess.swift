//
//  RecordingSuccess.swift
//  SoniScope
//
//  Created by Venkata Siva Ramisetty on 7/23/25.
//

import SwiftUI

struct RecordingSuccess: View {
    @State private var navigateToResults = false

    var body: some View {
        NavigationStack {
            ZStack {
                // Background header
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 482, height: 104)
                    .background(Color(red: 0.11, green: 0.11, blue: 0.12))
                    .offset(y: -410)

                // Header text
                Text("Session")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                    .offset(y: -382)

                // Main content
                VStack {
                    Image(systemName: "checkmark.circle")
                        .font(.system(size: 96, weight: .medium))
                        .foregroundColor(Color(red: 0.56, green: 0.79, blue: 0.9))
                        .padding(10)

                    Text("Analysis\nComplete")
                        .font(.system(size: 37, weight: .bold))
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color(red: 0.56, green: 0.79, blue: 0.9))
                }
            }
            .frame(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
            .background(Color.black)
            .navigationBarBackButtonHidden(true)

            // Navigation trigger
            NavigationLink(destination: ResultsView(), isActive: $navigateToResults) {
                EmptyView()
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            // Automatically go to ResultsView after 2 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                navigateToResults = true
            }
        }
    }
}

#Preview {
    RecordingSuccess()
}
