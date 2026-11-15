//
//  Transaction.swift
//  control_gastos
//

import Foundation

/// Estructura que modela un movimiento financiero individual (Ingreso o Gasto).
struct Transaction: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var title: String
    var amount: Double
    var date: Date
    var type: TransactionType
    var category: Category
    var note: String

    init(
        id: UUID = UUID(),
        title: String,
        amount: Double,
        date: Date = Date(),
        type: TransactionType,
        category: Category,
        note: String = ""
    ) {
        self.id = id
        self.title = title
        self.amount = amount
        self.date = date
        self.type = type
        self.category = category
        self.note = note
    }

    /// Formatea el monto con signo y moneda según la configuración regional
    var formattedAmount: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale.current

        let prefix = type == .expense ? "- " : "+ "
        let formattedNumber = formatter.string(from: NSNumber(value: amount)) ?? String(format: "$%.2f", amount)
        return "\(prefix)\(formattedNumber)"
    }
}

// MARK: - Datos de prueba (Mock Data)
extension Transaction {
    static let samples: [Transaction] = [
        Transaction(
            title: "Supermercado semanal",
            amount: 85.50,
            date: Calendar.current.date(byAdding: .day, value: 0, to: Date()) ?? Date(),
            type: .expense,
            category: .food,
            note: "Compras para el mes"
        ),
        Transaction(
            title: "Nómina Mensual",
            amount: 2500.00,
            date: Calendar.current.date(byAdding: .day, value: -2, to: Date()) ?? Date(),
            type: .income,
            category: .salary,
            note: "Pago de fin de mes"
        ),
        Transaction(
            title: "Gasolina",
            amount: 45.00,
            date: Calendar.current.date(byAdding: .day, value: -3, to: Date()) ?? Date(),
            type: .expense,
            category: .transport,
            note: "Tanque lleno"
        ),
        Transaction(
            title: "Cine y palomitas",
            amount: 24.00,
            date: Calendar.current.date(byAdding: .day, value: -4, to: Date()) ?? Date(),
            type: .expense,
            category: .entertainment,
            note: "Salida de viernes"
        ),
        Transaction(
            title: "Proyecto Freelance UI",
            amount: 600.00,
            date: Calendar.current.date(byAdding: .day, value: -5, to: Date()) ?? Date(),
            type: .income,
            category: .freelance,
            note: "Diseño de landing page"
        ),
        Transaction(
            title: "Internet y Fibra",
            amount: 50.00,
            date: Calendar.current.date(byAdding: .day, value: -6, to: Date()) ?? Date(),
            type: .expense,
            category: .services,
            note: "Factura mensual"
        )
    ]
}
