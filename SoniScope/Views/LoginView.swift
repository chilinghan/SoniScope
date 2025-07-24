//
//  Login.swift
//  SoniScope
//
//  Created by Venkata Siva Ramisetty on 7/23/25.
//


//
//  login.swift
//  SoniScope
//
//  Created by Venkata Siva Ramisetty on 7/22/25.
//

import SwiftUI
import AuthenticationServices

struct LoginView: View {
    @AppStorage("isSignedIn") var isSignedIn: Bool = false
    let coordinator = SignInWithAppleCoordinator()
    
    var body: some View {

        ZStack {
            // Background Gradient
            LinearGradient(
                stops: [
                    Gradient.Stop(color: .black, location: 0.33),
                    Gradient.Stop(color: Color(red: 0.01, green: 0.19, blue: 0.27), location: 1.00),
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 20) {
                Spacer().frame(height: 40)

                // Title
                Text("SoniScope")
                    .font(.system(size: 55, weight: .bold))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: 343, height: 70, alignment: .center)
                    .offset(x:0,y:270)

                // Subtitle
                Text("Health in every breath")
                    .font(.system(size: 20, weight: .bold))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: 343, height: 30, alignment: .center)
                    .offset(x:0, y:250)

                // Image
                Image(.copyOfMinimalistHospitalAndMedicalHealthLogoRemovebgPreview)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 394, height: 394)
                    .clipped()
                    .cornerRadius(20)
                    .offset(x:0.0,y:-100)
                
                

                SignInWithAppleButton(
                       .signIn,
                       onRequest: { request in
                              request.requestedScopes = [.fullName, .email]
                          },
                          onCompletion: { result in
                              switch result {
                              case .success(let authResults):
                                  // ✅ Process auth result
                                  coordinator.authorizationController(
                                      controller: ASAuthorizationController(authorizationRequests: []),
                                      didCompleteWithAuthorization: authResults
                                  )
                                  // ✅ Set login state
                                  isSignedIn = true
                              case .failure(let error):
                                  print("❌ Sign in with Apple failed: \(error.localizedDescription)")
                              }
                          }
                   )
                   .signInWithAppleButtonStyle(.white)
                   .frame(width: 267, height: 54)
                   .cornerRadius(14)

                Spacer()
            }
        }
        .frame(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        .overlay(
            RoundedRectangle(cornerRadius: 44)
                .stroke(Color.black, lineWidth: 1)
        )
    }
}

#Preview {
    LoginView()
}
