//
//  ContentView.swift
//  DeliHood
//
//  Created by Vojta Fluger on 21.07.2025.
//

import SwiftUI

struct MainScreenView: View {
    @EnvironmentObject var authStore: AuthStore
    @EnvironmentObject var orderStore: OrderStore
    
    var body: some View {
        VStack {
            //Show different views depending on the appState
            switch authStore.appState {
            case .loading:
                ProgressView()
                    .scaleEffect(2)
                
            case .emailNotVerified:
                EmailVerificationView()
                
            case .loggedIn:
                switch orderStore.currentOrder?.status {
                case .notOrdered:
                    HomeView()
                case .pending:
                    switch orderStore.paymentStatus {
                    case .notStarted:
                        PaymentCanceledView()
                    case .pending:
                        ProgressView()
                    case .succeeded:
                        OrderView()
                    case .failed(let error):
                        PaymentFailedView(error: error)
                    case .canceled:
                        PaymentCanceledView()
                    }
                case nil:
                    HomeView()
                default:
                    OrderView()
                }
                
            case .loggedOut:
                LoggedOutWelcomeView()
                
            case .validatingMail:
                ProgressView()
                    .scaleEffect(2)
                Text("Validating mail...")
            case .resetingPassword:
                ResettingPasswordView()
            case .noConnection:
                NoConnectionView(retryFnc: authStore.syncUpdateState)
            }
        }
    }
}



#Preview {
    MainScreenView()
}
