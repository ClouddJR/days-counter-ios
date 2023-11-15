import Foundation
import SwiftUI

protocol InternalGalleryDelegate {
    func onInternalImageChosen(_ image: UIImage)
}

final class InternalGalleryHostingController: UIHostingController<InternalGalleryView> {
    init(delegate: InternalGalleryDelegate) {
        super.init(rootView: InternalGalleryView(delegate: delegate))
    }
    
    required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
