//
//  Session1.swift
//  SoniScope
//
//  Created by Venkata Siva Ramisetty on 7/23/25.
//


//
//  Session1.swift
//  SoniScope
//
//  Created by Venkata Siva Ramisetty on 7/22/25.
//

import SwiftUI

struct Session1: View {
    @State private var showStartView = false
    @State private var navigateToSession2 = false

    var body: some View {
        ZStack {
            if showStartView {
                StartView()
                    .transition(.move(edge: .leading)) // ⬅️ Slide from right to left
                    .animation(.easeInOut, value: showStartView)
            } else {
                mainView
                    .transition(.move(edge: .trailing)) // Optional: for coming in from left
                    .animation(.easeInOut, value: showStartView)
            }
        }
        .navigationBarBackButtonHidden(true)
        .background(Color.black)
    }

    var mainView: some View {
        ZStack {
            // Header background
            Rectangle()
                .foregroundColor(.clear)
                .frame(width: 482, height: 104)
                .background(Color(red: 0.11, green: 0.11, blue: 0.12))
                .offset(y: -400)

            // Body image
            Rectangle()
                .foregroundColor(.clear)
                .frame(width: 339, height: 412)
                .background(
                    Image(.bodyLowRes)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 339 * 1.4, height: 412 * 1.4)
                        .clipped()
                )
                .offset(y: -110)

            // Header title + "End" button
            ZStack {
                Text("Session")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)

                Button(action: {
                    showStartView = true // Triggers reverse slide
                }) {
                    HStack(spacing: 3) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(Color(red: 0.56, green: 0.79, blue: 0.9))
                        Text("End")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(Color(red: 0.56, green: 0.79, blue: 0.9))
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.horizontal, 50)
            .padding(.top, 10)
            .offset(y: -378)

            // Dot
            Circle()
                .frame(width: 25, height: 25)
                .foregroundColor(Color(red: 0.99, green: 0.52, blue: 0))
                .offset(x: -70, y: -230)

            // Bottom card
            Rectangle()
                .foregroundColor(.clear)
                .frame(width: 402, height: 423)
                .background(Color(red: 0.11, green: 0.11, blue: 0.12))
                .cornerRadius(30)
                .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: -10)
                .offset(y: 220)

            // NavigationLink for Session2 (still works normally)
            NavigationLink(destination: Session2().navigationBarBackButtonHidden(true), isActive: $navigateToSession2) {
                EmptyView()
            }

            // Next Step button
            Button(action: {
                navigateToSession2 = true
            }) {
                ZStack {
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 351, height: 45)
                        .background(
                            LinearGradient(
                                stops: [
                                    Gradient.Stop(color: Color(red: 0.99, green: 0.52, blue: 0), location: 0.00),
                                    Gradient.Stop(color: Color(red: 0.56, green: 0.79, blue: 0.9), location: 1.00),
                                ],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(15)
                        .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 4)

                    Label("Next Step", systemImage: "arrow.right")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.black)
                }
            }
            .offset(y: 325)

            // Instructions
            Text("Find the middle of your left torso, above your heart.")
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(60)
                .offset(y: 180)

            // Divider
            Rectangle()
                .foregroundColor(.clear)
                .frame(width: 370, height: 1)
                .background(Color(red: 0.25, green: 0.25, blue: 0.27))
                .offset(y: 90)

            // Step indicator
            ZStack {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                stops: [
                                    Gradient.Stop(color: Color(red: 0.56, green: 0.79, blue: 0.9), location: 0.00),
                                    Gradient.Stop(color: Color(red: 0.99, green: 0.52, blue: 0), location: 1.00),
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 32, height: 32)

                    Text("1")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.black)
                        .frame(width: 15, height: 34)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                Text("Locate Placement Point")
                    .font(.system(size: 25, weight: .bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .offset(x: 10)
            }
            .padding(60)
            .offset(y: 50)
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    }
}

#Preview {
    Session1()
}
