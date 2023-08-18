import Foundation
import SwiftUI
import MessageUI

struct SettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @AppStorage(Defaults.Key.SortingOrder.rawValue) private var sortingOrder: Defaults.SortingOrder = .TimeAdded
    @AppStorage(Defaults.Key.DefaultSection.rawValue) private var defaultSection: Defaults.DefaultSection = .Future
    @AppStorage(Defaults.Key.EventViewType.rawValue) private var eventViewType: Defaults.EventViewType = .Large
    
    @State private var isShowingPremium = false
    @State private var isShowingMail = false
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("General")) {
                    Picker("Sort", selection: $sortingOrder) {
                        ForEach(Defaults.SortingOrder.allCases) { order in
                            Text(order.title)
                        }
                    }
                    Picker("Default section", selection: $defaultSection) {
                        ForEach(Defaults.DefaultSection.allCases) { section in
                            Text(section.title)
                        }
                    }
                    Picker("Event view type", selection: $eventViewType) {
                        ForEach(Defaults.EventViewType.allCases) { type in
                            Text(type.title)
                        }
                    }
                }
                Section {
                    Button(action: { isShowingPremium = true }) {
                        Label("Premium", systemImage: "gift.fill")
                    }
                }
                Section(header: Text("About")) {
                    Link(
                        "Privacy policy",
                        destination: URL(string: "https://sites.google.com/view/privacy-policy-dayscounterios")!
                    )
                    Button("Contact me") {
                        isShowingMail = true
                    }
                    .disabled(!MFMailComposeViewController.canSendMail())
                }
            }
            .navigationBarTitle("Settings", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("OK") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
            .sheet(isPresented: $isShowingPremium) {
                PremiumView()
            }
            .sheet(isPresented: $isShowingMail) {
                MailView()
            }
        }
        .navigationViewStyle(.stack)
    }
}

struct PremiumView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UINavigationController {
        UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "premiumNavigationController") as! UINavigationController
    }
    
    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
        // nop
    }
}

struct MailView: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentation
    
    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        private var parent: MailView
        
        init(_ parent: MailView) {
            self.parent = parent
        }
        
        func mailComposeController(
            _ controller: MFMailComposeViewController,
            didFinishWith result: MFMailComposeResult,
            error: Error?
        ) {
            parent.presentation.wrappedValue.dismiss()
        }
    }
    
    func makeUIViewController(context: Context) -> MFMailComposeViewController {
        let composer = MFMailComposeViewController()
        composer.setToRecipients(["arekchmura@gmail.com"])
        composer.setSubject("Days Counter iOS")
        composer.mailComposeDelegate = context.coordinator
        return composer
    }
    
    func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: Context) {
        // nop
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
}
