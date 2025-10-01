import SwiftUI
import StripePaymentSheet

@MainActor
class PaymentSheetManager: ObservableObject {
    private var paymentSheet: PaymentSheet?

    // Configure with the client secret
    func configure(with clientSecret: String) {
        
        var configuration = PaymentSheet.Configuration()
        configuration.merchantDisplayName = "DeliHood"
        
        paymentSheet = PaymentSheet(paymentIntentClientSecret: clientSecret, configuration: configuration)
    }

    func present(orderStore: OrderStore, order: Order) {
        guard let paymentSheet = paymentSheet else {
            //Payment sheet not configured
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

        paymentSheet.present(from: rootVC) { result in
            
            orderStore.currentOrder = order
            Task {
                // Update after delay to let Stripe process it...
                try await Task.sleep(nanoseconds: 2_000_000_000) //2s
                try await orderStore.updateStatus()
            }
            switch result {
            case .completed:
                orderStore.paymentStatus = .succeeded
            case .canceled:
                orderStore.paymentStatus = .canceled
            case .failed(let error):
                orderStore.paymentStatus = .failed(error: error)
            }
        }
    }
}
