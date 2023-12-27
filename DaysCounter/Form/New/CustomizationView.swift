import Foundation
import SwiftUI

struct CustomizationView: View {
    let details: DetailsData
    
    @Binding var customization: CustomizationData
    
    @State private var isShowingImageSourceOptions = false
    @State private var isShowingInternalGallery = false
    
    var body: some View {
        let screenWidth = UIScreen.main.bounds.size.width
        let screenHeight = UIScreen.main.bounds.size.height
        let ratio = min(screenWidth, screenHeight) / max(screenWidth, screenHeight)
        
        ZStack {
            BlurredEventImage(image: customization.image)
            
            VStack(spacing: 15) {
                EventImage(image: customization.image)
                    .aspectRatio(ratio, contentMode: .fit)
                    .clipped()
                    .overlay {
                        Color(UIColor.black)
                            .opacity(customization.opacity)
                    }
                    .overlay {
                        VStack {
                            Spacer()
                            HStack {
                                VStack(
                                    alignment: .leading,
                                    spacing: 5
                                ) {
                                    Text(details.name)
                                        .font(.title2)
                                        .foregroundStyle(.white)
                                    Text(details.formattedDate)
                                        .font(.subheadline)
                                        .foregroundStyle(.white)
                                }
                                Spacer()
                            }
                        }
                        .padding(15)
                    }
                
                VStack(spacing: 20) {
                    Button {
                        isShowingImageSourceOptions = true
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
                .confirmationDialog(
                    "Choose background",
                    isPresented: $isShowingImageSourceOptions,
                    titleVisibility: .hidden
                ) {
                    Button("Pre-installed images") {
                        isShowingInternalGallery = true
                    }
                    Button("From the Internet") {
                        
                    }
                    Button("Photo library") {
                        
                    }
                    Button("Camera") {
                        
                    }
                }
                .sheet(isPresented: $isShowingInternalGallery) {
                    InternalGalleryView(delegate: self)
                }
            }
            .padding([.leading, .trailing], 20)
            .padding([.top, .bottom], 15)
        }
    }
}

extension CustomizationView: InternalGalleryDelegate {
    func onInternalImageChosen(_ image: UIImage) {
        customization.image = image
    }
}

private struct BlurredEventImage: View {
    let image: UIImage
    
    var body: some View {
        ZStack {
            EventImage(image: image)
                .ignoresSafeArea()
            
            VisualEffectView(effect: UIBlurEffect(style: .dark))
                .ignoresSafeArea()
        }
    }
}

private struct EventImage: View {
    let image: UIImage
    
    var body: some View {
        Image(uiImage: image)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(
                minWidth: 0,
                maxWidth: .infinity,
                minHeight: 0,
                maxHeight: .infinity
            )
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

#Preview {
    CustomizationView(
        details: DetailsData(
            name: "Birthday"
        ),
        customization: .constant(CustomizationData())
    )
}
