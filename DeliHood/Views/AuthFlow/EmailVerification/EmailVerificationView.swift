import SwiftUI

struct EmailVerificationView: View {
    @EnvironmentObject var authState: AuthState
    
    @StateObject var vm = EmailVerificationViewModel()
    
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
                vm.openMail()
            }label: {
                Label("Open mail app", systemImage: "envelope.badge")
                    .padding()
                    .foregroundStyle(Color(UIColor.label))
                    .brandGlassEffect()
            }
            Spacer()
            HStack {
                Button {
                    vm.sendMail()
                } label: {
                    if let success = vm.sendSuccess {
                        if success {
                            BrandIconBtn(imageName: "checkmark.seal")
                        } else {
                            BrandIconBtn(imageName: "xmark.seal")
                        }
                    } else {
                        BrandBtn(text: vm.timerActive ? "Send again in \(vm.secondsRemaining)s" : "Send Again", disabled: vm.timerActive)
                    }
                }
                .disabled(vm.timerActive)
                Spacer()
                    .frame(width: 20)
                Button {
                    AuthManager.shared.logout()
                    authState.userState = .loggedOut
                    authState.user = nil
                    UINotificationFeedbackGenerator().notificationOccurred(.error)
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
            vm.appearSendMail()
        }
        .onReceive(timer) { _ in
            guard vm.timerActive else { return }
            if vm.secondsRemaining > 0 {
                vm.secondsRemaining -= 1
            } else {
                vm.timerActive = false
            }
        }
    }
}


#Preview {
    EmailVerificationView()
}
