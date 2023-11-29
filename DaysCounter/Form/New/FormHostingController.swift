import Foundation
import SwiftUI

final class FormHostingController: UIHostingController<FormView> {
    required init?(coder: NSCoder) {
        super.init(coder: coder, rootView: FormView());
    }
}
