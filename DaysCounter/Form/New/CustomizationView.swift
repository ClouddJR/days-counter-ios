import Foundation
import SwiftUI

struct CustomizationView: View {
    let details: DetailsData
    
    @Binding var customization: CustomizationData
    
    var body: some View {
        let screenWidth = UIScreen.main.bounds.size.width
        let screenHeight = UIScreen.main.bounds.size.height
        let ratio = min(screenWidth, screenHeight) / max(screenWidth, screenHeight)
        
        ZStack {
            Image(uiImage: #imageLiteral(resourceName: "nature1.jpg"))
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            VisualEffectView(effect: UIBlurEffect(style: .dark))
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 15) {
                Image(uiImage: #imageLiteral(resourceName: "nature1.jpg"))
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(
                        minWidth: 0,
                        maxWidth: .infinity,
                        minHeight: 0,
                        maxHeight: .infinity
                    )
                    .aspectRatio(ratio, contentMode: .fit)
                    .clipped()
                
                VStack(spacing: 20) {
                    Button {
                        // Open gallery chooser
                    } label: {
                        Text("Choose background")
                            .font(.title3)
                    }
                    
                    Button {
                        // Open personaliation modal
                    } label: {
                        Text("Personalize")
                            .font(.title3)
                    }
                }
            }
            .padding([.leading, .trailing], 20)
            .padding([.top, .bottom], 15)
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

#Preview {
    CustomizationView(
        details: DetailsData(),
        customization: .constant(CustomizationData())
    )
}
