import SwiftUI



struct EditFieldView: View {
    @StateObject var vm: EditFieldViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 24) {
            VStack(alignment: .leading, spacing: 8) {
                Text(vm.title)
                    .font(.headline)
                    .foregroundColor(.secondary)
                    TextField(vm.currentValue, text: $vm.newValue)
                        .brandStyle(isFieldValid: vm.isValid)
                        .autocorrectionDisabled()
                        .padding()
            }

            Button(action: {
                vm.save { dismiss() }
            }) {
                BrandBtn(text: "Save", width: 325)
            }

            Spacer()
        }
        .padding()
        .navigationTitle(vm.title)
        .navigationBarTitleDisplayMode(.inline)
        .alert(item: $vm.alertItem) { alert in
            Alert(title: Text(alert.title), message: Text(alert.description))
        }
    }
}

#Preview {
    NavigationStack {
        EditFieldView(vm: .init(title: "Edit Name", fieldKey:  .name, currentValue: "Jane Doe"))
    }
}
