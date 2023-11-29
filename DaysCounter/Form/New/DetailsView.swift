import Foundation
import SwiftUI

struct DetailsView: View {
    @Environment(\.presentationMode) private var presentationMode
    
    @State private var isShowingPermissionAlert = false
    
    @Binding var details: DetailsData
    
    let onNextClick: () -> Void
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Basics")) {
                    TextField("Name", text: $details.name)
                    Toggle("Entire day", isOn: $details.isEntireDay)
                    DatePicker(
                        "Date",
                        selection: $details.date,
                        displayedComponents: details.isEntireDay ? [.date] : [.date, .hourAndMinute]
                    )
                }
                
                Section(header: Text("Optional")) {
                    Picker("Repetition", selection: $details.repetition) {
                        ForEach(EventRepetition.allCases) { repetition in
                            Text(repetition.title)
                        }
                    }
                    TextField(
                        "Notes",
                        text: $details.notes,
                        axis: .vertical
                    )
                    .lineLimit(3...)
                }
                
                Section(header: Text("Reminder")) {
                    Toggle("Reminder", isOn: $details.hasReminder)
                        .onChange(of: details.hasReminder) {
                            if details.hasReminder {
                                ensureHasNotificationsPermission()
                            }
                        }
                    if details.hasReminder {
                        DatePicker(
                            "Date",
                            selection: $details.reminderDate,
                            displayedComponents: [.date, .hourAndMinute]
                        )
                        TextField(
                            "Reminder message",
                            text: $details.reminderMessage,
                            axis: .vertical
                        )
                        .lineLimit(3...)
                    }
                }
                .alert(
                    "Grant Permission",
                    isPresented: $isShowingPermissionAlert,
                    actions: {
                        Button("Go To Settings") {
                            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                        }
                        Button("Cancel", role: .cancel) {}
                    },
                    message: {
                        Text("In order to send reminders, the app needs to have a permission for that. Please go to System settings and enable it.")
                    }
                )
            }
            .scrollDismissesKeyboard(.interactively)
            .navigationTitle("Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Next") {
                        onNextClick()
                    }
                    .disabled(details.name.isEmpty)
                }
            }
        }
    }
    
    private func ensureHasNotificationsPermission() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge] ) { granted, error in
            guard !granted else { return }
            
            details.hasReminder = false
            isShowingPermissionAlert = true
        }
    }
}
