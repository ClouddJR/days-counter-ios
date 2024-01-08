import Foundation
import SwiftUI
import FirebaseAuthUI
import FirebaseEmailAuthUI
import FirebaseOAuthUI
import FirebaseGoogleAuthUI

protocol LoginViewDelegate: FUIAuthDelegate {}

struct LoginView: View {
    @AppStorage(Defaults.Key.premium.rawValue, store: UserDefaults.forAppGroup()) private var isPremium = false
    
    @State private var isShowingPremium = false
    @State private var isShowingAuthUi = false
    
    let delegate: LoginViewDelegate
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text("Welcome!")
                    .bold()
                    .font(.title)
                    .padding(.bottom, 5)
                
                Text("Login to sync your events with the cloud to make them accessible on all of your devices.")
                
                if isPremium {
                    CtaButton(
                        title: "Sign In",
                        systemImage: "person.icloud.fill",
                        tint: .indigo
                    ) {
                        isShowingAuthUi = true
                    }
                    .padding([.top, .bottom], 15)
                } else {
                    Text("This feature is for premium users only.")
                        .bold()
                        .padding(.top, 10)
                    
                    CtaButton(
                        title: "More info",
                        systemImage: "crown.fill",
                        tint: .orange
                    ) {
                        isShowingPremium = true
                    }
                    .padding(.bottom, 15)
                }
                
                InfoRow(
                    systemImage: "lock.shield.fill",
                    tint: isPremium ? .indigo : .orange,
                    text: "We only store your events data on our servers. You can ask for a complete data deletion by contacting us via our email."
                )
                .padding([.bottom, .top], 10)
                
                InfoRow(
                    systemImage: "doc.text.fill",
                    tint: isPremium ? .indigo : .orange,
                    text: "You can find our email and privacy policy on the settings page."
                )
            }
            .padding([.leading, .trailing], 20)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .sheet(isPresented: $isShowingPremium) {
            PremiumView()
        }
        .sheet(isPresented: $isShowingAuthUi) {
            AuthUiView(delegate: delegate)
        }
    }
}

private struct CtaButton: View {
    let title: String
    let systemImage: String
    let tint: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Label(title, systemImage: systemImage)
                .frame(height: 28)
                .frame(maxWidth: .infinity)
                .font(.headline)
        }
        .buttonStyle(.borderedProminent)
        .tint(tint)
    }
}

private struct InfoRow: View {
    let systemImage: String
    let tint: Color
    let text: String
    
    var body: some View {
        HStack(
            alignment: .top,
            spacing: 15
        ) {
            Image(systemName: systemImage)
                .foregroundColor(tint)
                .font(.title3)
            Text(text)
                .font(.footnote)
        }
    }
}

private struct AuthUiView: UIViewControllerRepresentable {
    let delegate: LoginViewDelegate
    
    func makeUIViewController(context: Context) -> UINavigationController {
        let authUI = FUIAuth.defaultAuthUI()!
        
        authUI.delegate = delegate
        authUI.providers = [
            FUIEmailAuth(
                authAuthUI: authUI,
                signInMethod: EmailPasswordAuthSignInMethod,
                forceSameDevice: false,
                allowNewEmailAccounts: true,
                requireDisplayName: false,
                actionCodeSetting: ActionCodeSettings()
            ),
            FUIGoogleAuth.init(authUI: authUI),
            FUIOAuth.appleAuthProvider()
        ]
        
        return authUI.authViewController()
    }
    
    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
        // nop
    }
}

#Preview {
    LoginView(delegate: EmptyDelegate())
}

private final class EmptyDelegate: NSObject, LoginViewDelegate {}
