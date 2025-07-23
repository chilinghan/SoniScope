//
//  SignInView.swift
//  SoniScope
//
//  Created by Chiling Han on 7/23/25.
//

import SwiftUI
import AuthenticationServices

struct SignInView: View {
    let coordinator = SignInWithAppleCoordinator()
    
    var body: some View {
        ZStack {
            Color.black
                .edgesIgnoringSafeArea(.all)
            SignInWithAppleButton(
                .signIn,
                onRequest: { request in
                    request.requestedScopes = [.fullName, .email]
                },
                onCompletion: { result in
                    switch result {
                    case .success(let authResults):
                        coordinator.authorizationController(controller: ASAuthorizationController(authorizationRequests: []),
                                                            didCompleteWithAuthorization: authResults)
                    case .failure(let error):
                        print("❌ Sign in with Apple failed: \(error.localizedDescription)")
                    }
                }
            )
            .signInWithAppleButtonStyle(.white)
            .padding(.horizontal, 15)
            .padding(.vertical, 0)
            .frame(width: 267, height: 54, alignment: .center)
            .cornerRadius(14)
        }

        
    }
}

#Preview {
    SignInView()
}
