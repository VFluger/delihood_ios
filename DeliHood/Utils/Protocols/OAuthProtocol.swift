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
    func googleSign()
}

extension OAuthVMProtocol {
    func googleSign() {
        //Get clientID from info.plist and set it
        guard let clientID = Bundle.main.object(forInfoDictionaryKey: "CLIENT_ID") as? String else { return }
        let config = GIDConfiguration(clientID: clientID)
        
        // Get a proper UIViewController for presenting
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootViewController = windowScene.windows.first?.rootViewController else {
            return
        }
        
        // Present Google Sign-In
        GIDSignIn.sharedInstance.configuration = config
        GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { result, error in
            if let error = error {
                print("Google Sign-In failed: \(error.localizedDescription)")
                return
            }
            guard let user = result?.user else { return }
            let idToken = user.idToken?.tokenString ?? ""
            let accessToken = user.accessToken.tokenString
            print("Google Sign-In success. ID Token: \(idToken), Access Token: \(accessToken)")
            // Send tokens to backend or proceed in app
            UINotificationFeedbackGenerator().notificationOccurred(.success)
            
        }
    }
}
