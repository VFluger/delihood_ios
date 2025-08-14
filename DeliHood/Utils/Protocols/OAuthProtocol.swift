//
//  OAuthProtocol.swift
//  DeliHood
//
//  Created by Vojta Fluger on 13.08.2025.
//

import Foundation
import GoogleSignIn

//TODO: Error handling
protocol OAuthVMProtocol {
    func googleSign() async -> AuthResult?
}

extension OAuthVMProtocol {
    func googleSign() async -> AuthResult? {
        guard let clientID = Bundle.main.object(forInfoDictionaryKey: "CLIENT_ID") as? String else {
            return nil
        }

        let config = GIDConfiguration(clientID: clientID)

        guard let windowScene = await UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootViewController = await windowScene.windows.first?.rootViewController else {
            return nil
        }

        GIDSignIn.sharedInstance.configuration = config

        return await withCheckedContinuation { continuation in
            GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { result, error in
                if let error = error {
                    print("Google Sign-In failed: \(error.localizedDescription)")
                    continuation.resume(returning: nil)
                    return
                }

                guard let user = result?.user else {
                    continuation.resume(returning: nil)
                    return
                }

                let idToken = user.idToken?.tokenString ?? ""
                let accessToken = user.accessToken.tokenString
                print("Google Sign-In success. ID Token: \(idToken), Access Token: \(accessToken)")
                UINotificationFeedbackGenerator().notificationOccurred(.success)

                Task {
                    let authResult = try? await NetworkManager.shared.postGoogleToken(token: idToken)
                    continuation.resume(returning: authResult)
                }
            }
        }
    }
}
