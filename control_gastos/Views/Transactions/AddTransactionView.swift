//
//  AddTransactionView.swift
//  control_gastos
//

import SwiftUI

/// Formulario modal para registrar un nuevo ingreso o gasto.
struct AddTransactionView: View {
    @Environment(\.dismiss) private var dismiss

    var onSave: (Transaction) -> Void

    // MARK: - Estado del formulario
    @State private var title: String = ""
    @State private var amountText: String = ""
    @State private var selectedType: TransactionType = .expense
    @State private var selectedCategory: Category = .food
    @State private var date: Date = Date()
    @State private var note: String = ""

    // MARK: - Validación
    private var isValid: Bool {
        guard !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return false }
        guard let amount = Double(amountText.replacingOccurrences(of: ",", with: ".")), amount > 0 else {
            return false
        }
        return true
    }

    private var availableCategories: [Category] {
        Category.categories(for: selectedType)
    }

    var body: some View {
        NavigationStack {
            Form {
                // MARK: - Tipo de Movimiento (Selector Segmentado)
                Section {
                    Picker("Tipo de Movimiento", selection: $selectedType) {
                        ForEach(TransactionType.allCases) { type in
                            Text(type.rawValue).tag(type)
                        }
                    }
                    .pickerStyle(.segmented)
                    .onChange(of: selectedType) { _, newType in
                        // Actualizar categoría por defecto al cambiar de tipo
                        if let firstCategory = Category.categories(for: newType).first {
                            selectedCategory = firstCategory
                        }
                    }
                }

                // MARK: - Monto y Título
                Section("Detalles del movimiento") {
                    HStack {
                        Text("Monto")
                            .font(.body)
                            .foregroundStyle(.secondary)
                        Spacer()
                        TextField("0.00", text: $amountText)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .font(.system(.title3, design: .rounded).weight(.bold))
                            .foregroundStyle(selectedType.color)
                    }

                    TextField("Descripción (ej. Supermercado, Cine)", text: $title)
                }

                // MARK: - Categoría y Fecha
                Section("Clasificación") {
                    Picker("Categoría", selection: $selectedCategory) {
                        ForEach(availableCategories) { category in
                            HStack {
                                Label(category.displayName, systemImage: category.iconName)
                            }
                            .tag(category)
                        }
                    }

                    DatePicker("Fecha", selection: $date, displayedComponents: [.date])
                }

                // MARK: - Nota opcional
                Section("Nota adicional (opcional)") {
                    TextField("Escribe una nota o detalle...", text: $note, axis: .vertical)
                        .lineLimit(2...4)
                }
            }
            .navigationTitle("Nuevo Movimiento")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Guardar") {
                        save()
                    }
                    .disabled(!isValid)
                    .fontWeight(.semibold)
                }
            }
        }
    }

    private func save() {
        guard let amount = Double(amountText.replacingOccurrences(of: ",", with: ".")) else { return }

        let newTransaction = Transaction(
            title: title.trimmingCharacters(in: .whitespacesAndNewlines),
            amount: amount,
            date: date,
            type: selectedType,
            category: selectedCategory,
            note: note.trimmingCharacters(in: .whitespacesAndNewlines)
        )

        onSave(newTransaction)
        dismiss()
    }
}

#Preview {
    AddTransactionView { _ in }
}
