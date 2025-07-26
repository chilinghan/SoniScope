//
//  SignInWithAppleCoordinator.swift
//  SoniScope
//
//  Created by Chiling Han on 7/23/25.
//

import AuthenticationServices

class SignInWithAppleCoordinator: NSObject {
    func startSignInWithAppleFlow() {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email] // Request user's name and email

        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }
}

extension SignInWithAppleCoordinator: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            let userID = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email
            
            print("🟢 AppleID Credential received")
            print("User ID: \(userID)")
            print("Name: \(fullName?.givenName ?? "") \(fullName?.familyName ?? "")")
            print("Email: \(email ?? "none")")
            
            // Save userID to Keychain for future silent login if needed
        }
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("❌ Authorization failed: \(error.localizedDescription)")
    }
}

extension SignInWithAppleCoordinator: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return UIApplication.shared.windows.first { $0.isKeyWindow }!
    }
}
