import SwiftUI
import StripePaymentSheet

@MainActor
class PaymentSheetManager: ObservableObject {
    private var paymentSheet: PaymentSheet?

    // Configure with the client secret
    func configure(with clientSecret: String) {
        print("Configuring payment sheet with client secret: \(clientSecret.prefix(10))...")
        
        var configuration = PaymentSheet.Configuration()
        configuration.merchantDisplayName = "DeliHood"
        // Optional: Add a return URL for 3D Secure authentication
//        configuration.returnURL = "delihood://stripe-redirect"
        
        paymentSheet = PaymentSheet(paymentIntentClientSecret: clientSecret, configuration: configuration)
        print("Payment sheet configured successfully")
    }

    func present(orderStore: OrderStore, order: Order) {
        guard let paymentSheet = paymentSheet else {
            print("Payment sheet not configured")
            return
        }
        
        guard var rootVC = UIApplication.shared.connectedScenes
              .compactMap({ ($0 as? UIWindowScene)?.windows.first?.rootViewController })
              .first else {
            print(" Cannot find root view controller")
            return
        }
        
        // Walk down the chain until we find the top-most presented view controller
        while let presented = rootVC.presentedViewController {
            rootVC = presented
        }

        print("Presenting payment sheet...")
        paymentSheet.present(from: rootVC) { result in
            
            orderStore.currentOrder = order
            Task {
                try await orderStore.updateStatus()
            }
            switch result {
            case .completed:
                print("Payment complete")
                orderStore.paymentStatus = .succeeded
            case .canceled:
                print("Payment canceled")
                orderStore.paymentStatus = .canceled
            case .failed(let error):
                print("Payment failed: \(error)")
                orderStore.paymentStatus = .failed(error: error)
            }
        }
    }
}
