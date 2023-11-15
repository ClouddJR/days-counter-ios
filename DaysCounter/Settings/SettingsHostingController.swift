import Foundation
import SwiftUI

final class SettingsHostingController: UIHostingController<SettingsView> {
    required init?(coder: NSCoder) {
        super.init(coder: coder, rootView: SettingsView());
    }
}
