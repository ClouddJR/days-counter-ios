import Foundation
import SwiftUI

struct FormView: View {
    @Environment(\.presentationMode) private var presentationMode
    
    @State private var isShowingCustomization = false
    @State private var details = DetailsData()
    @State private var customization = CustomizationData()
    
    var body: some View {
        NavigationStack {
            DetailsView(details: $details)
                .navigationDestination(isPresented: $isShowingCustomization) {
                    CustomizationView(
                        details: details,
                        customization: $customization
                    )
                    .navigationTitle("Customization")
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            Button("Save") {
                                // Save the event here
                            }
                        }
                    }
                    .tint(nil)
                }
                .navigationTitle("Details")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button("Cancel") {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Next") {
                            isShowingCustomization = true
                        }
                        .disabled(details.name.isEmpty)
                    }
                }
                .tint(nil)
        }
        .tint(isShowingCustomization ? .white : nil)
    }
}

#Preview {
    FormView()
}
