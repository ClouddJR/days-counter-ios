import Foundation
import SwiftUI

struct InternalGalleryView: View {
    var delegate: InternalGalleryDelegate
    
    @Environment(\.presentationMode) var presentationMode
    
    private let images = [
        #imageLiteral(resourceName: "nature1.jpg"),#imageLiteral(resourceName: "nature2.jpg"),#imageLiteral(resourceName: "nature3.jpg"),#imageLiteral(resourceName: "nature4.jpg"),#imageLiteral(resourceName: "nature5.jpg"),#imageLiteral(resourceName: "nature6.jpg"),#imageLiteral(resourceName: "nature7.jpg"),#imageLiteral(resourceName: "nature8.jpg"),#imageLiteral(resourceName: "nature9.jpg"),#imageLiteral(resourceName: "nature10.jpg"),#imageLiteral(resourceName: "nature11.jpg"),#imageLiteral(resourceName: "nature12.jpg"),#imageLiteral(resourceName: "nature13.jpg"),#imageLiteral(resourceName: "nature14.jpg"),#imageLiteral(resourceName: "nature15.jpg"),#imageLiteral(resourceName: "nature16.jpg"),#imageLiteral(resourceName: "nature17.jpg"),#imageLiteral(resourceName: "nature18.jpg"),#imageLiteral(resourceName: "birth1.jpg"),#imageLiteral(resourceName: "birth2.jpg"),#imageLiteral(resourceName: "birthday1.jpg"),#imageLiteral(resourceName: "birthday2.jpg"),#imageLiteral(resourceName: "birthday3.jpg"),#imageLiteral(resourceName: "book1.jpg"),#imageLiteral(resourceName: "book2.jpg"),#imageLiteral(resourceName: "book3.jpg"),#imageLiteral(resourceName: "book4.jpg"),#imageLiteral(resourceName: "book5.jpg"),#imageLiteral(resourceName: "book6.jpg"),#imageLiteral(resourceName: "book7.jpg"),#imageLiteral(resourceName: "book8.jpg"),#imageLiteral(resourceName: "christmas1.jpg"),#imageLiteral(resourceName: "christmas2.jpg"),#imageLiteral(resourceName: "christmas3.jpg"),#imageLiteral(resourceName: "wedding1.jpg"),#imageLiteral(resourceName: "wedding2.jpg"),#imageLiteral(resourceName: "wedding3.jpg"),#imageLiteral(resourceName: "wedding4.jpg")
    ]
    
    var body: some View {
        let screenWidth = UIScreen.main.bounds.size.width
        let screenHeight = UIScreen.main.bounds.size.height
        let screenRatio = max(screenWidth, screenHeight) / min(screenWidth, screenHeight)
       
        let imageWidth = min(screenWidth, screenHeight) * 0.32
        let imageHeight = imageWidth * screenRatio
        
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: imageWidth), spacing: 2)]) {
                    ForEach(images, id: \.self) { image in
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: imageWidth, height: imageHeight)
                            .clipped()
                            .contentShape(Rectangle())
                            .onTapGesture {
                                delegate.onInternalImageChosen(image)
                                presentationMode.wrappedValue.dismiss()
                            }
                    }
                }
            }
            .navigationTitle("Pick an image")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
}

struct InternalGalleryView_Previews: PreviewProvider {
    static var previews: some View {
        InternalGalleryView(delegate: EmptyDelegate())
    }
}

final class EmptyDelegate: InternalGalleryDelegate {
    func onInternalImageChosen(_ image: UIImage) {}
}
