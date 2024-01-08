import Foundation
import StoreKit
import SwiftUI

struct PremiumView: View {
    var body: some View {
        SubscriptionStoreView(groupID: "EB2739D3")
            .subscriptionStoreControlStyle(.prominentPicker)
            .subscriptionStoreButtonLabel(.multiline)
    }
}
