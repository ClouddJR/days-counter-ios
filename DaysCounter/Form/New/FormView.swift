import Foundation
import SwiftUI

struct FormView: View {
    @State private var detailsData = DetailsData()
    
    var body: some View {
        DetailsView(details: $detailsData) {
            // Go to customization view
        }
    }
}
