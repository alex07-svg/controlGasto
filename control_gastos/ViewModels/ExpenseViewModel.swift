//
//  ExpenseViewModel.swift
//  control_gastos
//

import Foundation
import SwiftUI
import Observation

/// ViewModel encargado de la lógica de negocio, cálculo de balances y persistencia de transacciones.
@Observable
final class ExpenseViewModel {
    // MARK: - Estado
    var transactions: [Transaction] = [] {
        didSet {
            saveTransactions()
        }
    }

    /// Mes seleccionado para filtrar los datos (por defecto, la fecha actual)
    var selectedMonth: Date = Date()

    /// Filtro de tipo: nil muestra todo, o filtra por .expense / .income
    var filterType: TransactionType? = nil

    /// Clave para guardar en UserDefaults
    private let storageKey = "SavedTransactions_v1"

    // MARK: - Inicialización
    init() {
        loadTransactions()
    }

    // MARK: - Propiedades Calculadas (Cálculos de negocio)

    /// Transacciones que corresponden al mes y año de `selectedMonth`
    var monthlyTransactions: [Transaction] {
        let calendar = Calendar.current
        let targetMonth = calendar.component(.month, from: selectedMonth)
        let targetYear = calendar.component(.year, from: selectedMonth)

        return transactions
            .filter { transaction in
                let month = calendar.component(.month, from: transaction.date)
                let year = calendar.component(.year, from: transaction.date)
                return month == targetMonth && year == targetYear
            }
            .sorted { $0.date > $1.date }
    }

    /// Transacciones del mes filtradas según el tipo seleccionado (o todas si filterType es nil)
    var filteredTransactions: [Transaction] {
        if let filterType = filterType {
            return monthlyTransactions.filter { $0.type == filterType }
        }
        return monthlyTransactions
    }

    /// Total de ingresos del mes seleccionado
    var totalIncome: Double {
        monthlyTransactions
            .filter { $0.type == .income }
            .reduce(0) { $0 + $1.amount }
    }

    /// Total de gastos del mes seleccionado
    var totalExpenses: Double {
        monthlyTransactions
            .filter { $0.type == .expense }
            .reduce(0) { $0 + $1.amount }
    }

    /// Balance neto del mes (Ingresos - Gastos)
    var netBalance: Double {
        totalIncome - totalExpenses
    }

    /// Gastos del mes agrupados por categoría, ordenados de mayor a menor (ideal para Swift Charts)
    var expensesByCategory: [CategoryExpenseSummary] {
        let expenses = monthlyTransactions.filter { $0.type == .expense }
        let grouped = Dictionary(grouping: expenses, by: { $0.category })

        return grouped.map { (category, items) in
            let total = items.reduce(0.0) { $0 + $1.amount }
            return CategoryExpenseSummary(category: category, amount: total)
        }
        .sorted { $0.amount > $1.amount }
    }

    // MARK: - Exportación de Reportes (CSV)

    /// Genera un objeto CSVFile con el reporte detallado del mes seleccionado listo para compartir.
    func generateMonthlyReportCSV() -> CSVFile {
        let calendar = Calendar.current
        let month = calendar.component(.month, from: selectedMonth)
        let year = calendar.component(.year, from: selectedMonth)
        let filename = "Reporte_Gastos_\(year)_\(String(format: "%02d", month)).csv"

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"

        var csv = "Fecha,Tipo,Categoría,Título,Monto,Nota\n"

        for item in monthlyTransactions {
            let formattedDate = dateFormatter.string(from: item.date)
            let type = item.type.rawValue
            let category = item.category.displayName
            let title = "\"\(item.title.replacingOccurrences(of: "\"", with: "\"\""))\""
            let amount = String(format: "%.2f", item.amount)
            let note = "\"\(item.note.replacingOccurrences(of: "\"", with: "\"\""))\""

            csv.append("\(formattedDate),\(type),\(category),\(title),\(amount),\(note)\n")
        }

        // Resumen al final del reporte
        csv.append("\n")
        csv.append("Resumen del Mes\n")
        csv.append("Ingresos Totales:,\(String(format: "%.2f", totalIncome))\n")
        csv.append("Gastos Totales:,\(String(format: "%.2f", totalExpenses))\n")
        csv.append("Balance Neto:,\(String(format: "%.2f", netBalance))\n")

        return CSVFile(content: csv, filename: filename)
    }

    // MARK: - Acciones (CRUD)

    /// Agrega una nueva transacción a la lista
    func addTransaction(_ transaction: Transaction) {
        transactions.append(transaction)
    }

    /// Elimina una transacción específica por su ID
    func deleteTransaction(_ transaction: Transaction) {
        transactions.removeAll { $0.id == transaction.id }
    }

    /// Elimina transacciones a partir de un IndexSet (usado comúnmente en listas de SwiftUI con .onDelete)
    func deleteFilteredTransaction(at offsets: IndexSet) {
        let itemsToDelete = offsets.map { filteredTransactions[$0] }
        transactions.removeAll { transaction in
            itemsToDelete.contains(where: { $0.id == transaction.id })
        }
    }

    /// Avanza al mes siguiente
    func nextMonth() {
        if let next = Calendar.current.date(byAdding: .month, value: 1, to: selectedMonth) {
            selectedMonth = next
        }
    }

    /// Retrocede al mes anterior
    func previousMonth() {
        if let prev = Calendar.current.date(byAdding: .month, value: -1, to: selectedMonth) {
            selectedMonth = prev
        }
    }

    // MARK: - Persistencia con UserDefaults y JSON
    private func saveTransactions() {
        if let encoded = try? JSONEncoder().encode(transactions) {
            UserDefaults.standard.set(encoded, forKey: storageKey)
        }
    }

    private func loadTransactions() {
        if let data = UserDefaults.standard.data(forKey: storageKey),
           let decoded = try? JSONDecoder().decode([Transaction].self, from: data) {
            self.transactions = decoded
        } else {
            // Si es la primera vez que abre la app, cargamos datos de muestra para que no esté vacía
            self.transactions = Transaction.samples
        }
    }
}

// MARK: - Modelo auxiliar para Gráficos
struct CategoryExpenseSummary: Identifiable {
    var id: String { category.id }
    let category: Category
    let amount: Double
}
