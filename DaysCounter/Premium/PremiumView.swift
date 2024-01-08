import Foundation
import StoreKit
import SwiftUI

struct PremiumView: View {
    var body: some View {
        SubscriptionStoreView(groupID: "EB2739D3") {
            Header()
        }
        .subscriptionStoreControlStyle(.prominentPicker)
        .subscriptionStoreButtonLabel(.multiline)
    }
}

private struct Header: View {
    var body: some View {
        VStack(spacing: 30) {
            Text("Days Counter Premium")
                .font(.largeTitle)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
            
            VStack(spacing: 15) {
                FeatureRow(text: "Enable full sync between multiple devices (including images).")
                FeatureRow(text: "Fully customize each event.")
                FeatureRow(text: "Download beautiful images for your events right from the app.")
                FeatureRow(text: "Get access to all premium features released in the future.")
            }
        }
        .padding(30)
    }
}

private struct FeatureRow: View {
    let text: String
    
    var body: some View {
        HStack(alignment: .top) {
            Image(systemName: "checkmark.circle.fill")
                .foregroundStyle(.orange)
            Text(text)
                .frame(maxWidth: .infinity, alignment: .leading)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

#Preview {
    PremiumView()
}
