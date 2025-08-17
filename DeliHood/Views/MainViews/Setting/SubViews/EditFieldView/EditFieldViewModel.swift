import SwiftUI

enum EditFieldKey: String {
    case name
    case email
    case phone
    case deliveryAddress
}

final class EditFieldViewModel: ObservableObject {
    @Published var title: String
    @Published var fieldKey: EditFieldKey
    @Published var currentValue: String
    @Published var newValue: String
    @Published var alertItem: AlertItem?
    
    var isValid: Bool {
        switch fieldKey {
        case .name:
            //Non empty without spaces
            return !newValue.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        case .email:
            return Validator.validateEmail(newValue)
        case .phone:
            return Validator.validatePhone(newValue)
        case .deliveryAddress:
            return true
        }
    }
    
    init(title: String, fieldKey: EditFieldKey, currentValue: String) {
        self.title = title
        self.fieldKey = fieldKey
        self.currentValue = currentValue
        self.newValue = currentValue
    }
    
    func save(dismiss: @escaping () -> Void) {
        if currentValue == newValue { return } //dismiss() }
        if fieldKey == .deliveryAddress { return } //dismiss() }
        if newValue.isEmpty {
            alertItem = AlertContext.invalidValue
            return
        }
        Task {
            do {
                try await NetworkManager.shared.changeAccSetting(newValue, type: fieldKey)
                currentValue = newValue
                //dismiss()
            } catch {
                print(error)
                alertItem = AlertContext.networkFail
            }
        }
    }
}
