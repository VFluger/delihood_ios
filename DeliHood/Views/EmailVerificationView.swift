import SwiftUI

struct EmailVerificationView: View {
    @EnvironmentObject var authState: AuthState
    
    @State private var secondsRemaining = 30
    @State private var timerActive = true
    @State private var sendSuccess: Bool? = nil
    
    var notificationHaptic = UINotificationFeedbackGenerator()
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack {
            Text("Verify your email address")
                .font(.title)
                .fontWeight(.semibold)
                .padding()
            Spacer()
                .frame(height: 50)
            Image("envelope-icon")
                .resizable()
                .scaledToFit()
                .frame(width: 250)
            Text("Please check your email for a verification link.\n If you don't see it, check your spam folder.")
                .font(.body)
                .multilineTextAlignment(.center)
            Spacer()
            Button {
                if let url = URL(string: "mailto:") {
                        UIApplication.shared.open(url)
                    }
            }label: {
                Label("Open mail app", systemImage: "envelope.badge")
                    .padding()
                    .foregroundStyle(Color(UIColor.label))
                    .glassEffect(
                        .regular
                            .tint(.brand.opacity(0.3))
                            .interactive()
                    )
            }
            Spacer()
            HStack {
                Button {
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
                } label: {
                    if let success = sendSuccess {
                        if success {
                            BrandIconBtn(imageName: "checkmark.seal")
                        } else {
                            BrandIconBtn(imageName: "xmark.seal")
                        }
                    } else {
                        BrandBtn(text: timerActive ? "Send again in \(secondsRemaining)s" : "Send Again", disabled: timerActive)
                    }
                }
                .disabled(timerActive)
                Spacer()
                    .frame(width: 20)
                Button {
                    AuthManager.shared.logout()
                    authState.userState = .loggedOut
                    authState.user = nil
                    notificationHaptic.notificationOccurred(.error)
                }label: {
                    Label("Logout", systemImage: "rectangle.portrait.and.arrow.right")
                        .padding()
                        .foregroundStyle(Color(UIColor.label))
                        .glassEffect(.clear.interactive())
                }
            }
            Spacer()
                .frame(height: 30)
        }
        .onAppear {
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
        .onReceive(timer) { _ in
            guard timerActive else { return }
            if secondsRemaining > 0 {
                secondsRemaining -= 1
            } else {
                timerActive = false
            }
        }
    }
}


#Preview {
    EmailVerificationView()
}
