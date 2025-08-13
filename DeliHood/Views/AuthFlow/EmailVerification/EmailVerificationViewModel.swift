//
//  EmailVerificationViewModel.swift
//  DeliHood
//
//  Created by Vojta Fluger on 13.08.2025.
//

import SwiftUI

@MainActor
final class EmailVerificationViewModel: ObservableObject {
    @Published var secondsRemaining = 30
    @Published var timerActive = true
    
    @Published var sendSuccess: Bool? = nil
    
    var notificationHaptic = UINotificationFeedbackGenerator()
    
    func openMail() {
        if let url = URL(string: "mailto:") {
                UIApplication.shared.open(url)
            }
    }
    
    func sendMail() {
        Task {
            do {
                try await NetworkManager.shared.getConfirmMail()
                sendSuccess = true
                notificationHaptic.notificationOccurred(.success)
            } catch {
                print(error)
                sendSuccess = false
                notificationHaptic.notificationOccurred(.error)
            }
            // Show icon for 3 seconds
            try? await Task.sleep(nanoseconds: 2 * 1_000_000_000)
            sendSuccess = nil
            
            // Restart countdown
            secondsRemaining = 30
            timerActive = true
        }
    }
    
    func appearSendMail() {
        Task {
                do {
                    try await NetworkManager.shared.getConfirmMail()
                    notificationHaptic.notificationOccurred(.success)
                } catch {
                    print(error)
                    notificationHaptic.notificationOccurred(.error)
                }
            }
    }
}
