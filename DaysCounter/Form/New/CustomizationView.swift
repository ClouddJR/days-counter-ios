import Foundation
import SwiftUI

struct CustomizationView: View {
    let details: DetailsData
    
    @Binding var customization: CustomizationData
    
    var body: some View {
        ZStack {
            Image(uiImage: #imageLiteral(resourceName: "nature1.jpg"))
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            VisualEffectView(effect: UIBlurEffect(style: .dark))
                .edgesIgnoringSafeArea(.all)
        }
    }
    
    
    private struct VisualEffectView: UIViewRepresentable {
        let effect: UIVisualEffect?
        
        func makeUIView(context: UIViewRepresentableContext<Self>) -> UIVisualEffectView {
            UIVisualEffectView(effect: self.effect)
        }
        
        func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
            // no-op
        }
    }
}
