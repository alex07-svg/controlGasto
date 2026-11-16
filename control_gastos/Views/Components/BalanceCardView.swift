//
//  BalanceCardView.swift
//  control_gastos
//

import SwiftUI

/// Tarjeta moderna con diseño estilo Apple para mostrar el balance mensual, ingresos y gastos.
struct BalanceCardView: View {
    let balance: Double
    let totalIncome: Double
    let totalExpenses: Double
    let selectedMonth: Date
    let onPreviousMonth: () -> Void
    let onNextMonth: () -> Void

    private var monthYearFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateFormat = "LLLL yyyy"
        return formatter
    }

    private func formatCurrency(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale.current
        return formatter.string(from: NSNumber(value: value)) ?? String(format: "$%.2f", value)
    }

    var body: some View {
        VStack(spacing: 16) {
            // MARK: - Selector de Mes
            HStack {
                Button(action: onPreviousMonth) {
                    Image(systemName: "chevron.left")
                        .font(.subheadline.bold())
                        .foregroundStyle(.secondary)
                        .padding(8)
                        .background(Circle().fill(Color(uiColor: .systemGray6)))
                }
                .buttonStyle(.plain)

                Spacer()

                HStack(spacing: 6) {
                    Image(systemName: "calendar")
                        .font(.subheadline)
                        .foregroundStyle(.tint)
                    Text(monthYearFormatter.string(from: selectedMonth).capitalized)
                        .font(.headline)
                        .foregroundStyle(.primary)
                }

                Spacer()

                Button(action: onNextMonth) {
                    Image(systemName: "chevron.right")
                        .font(.subheadline.bold())
                        .foregroundStyle(.secondary)
                        .padding(8)
                        .background(Circle().fill(Color(uiColor: .systemGray6)))
                }
                .buttonStyle(.plain)
            }

            // MARK: - Balance Total
            VStack(spacing: 6) {
                Text("Balance Disponible")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .textCase(.uppercase)
                    .tracking(0.5)

                Text(formatCurrency(balance))
                    .font(.system(size: 38, weight: .bold, design: .rounded))
                    .foregroundStyle(balance >= 0 ? Color.primary : Color.red)
                    .contentTransition(.numericText())
            }
            .padding(.vertical, 4)

            // MARK: - Resumen Ingresos vs Gastos
            HStack(spacing: 12) {
                // Tarjeta Ingresos
                HStack(spacing: 10) {
                    Image(systemName: "plus")
                        .font(.title)
                        .foregroundStyle(.green)

                    VStack(alignment: .leading, spacing: 2) {
                        Text("Ingresos")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Text(formatCurrency(totalIncome))
                            .font(.subheadline.bold())
                            .foregroundStyle(.green)
                            .lineLimit(1)
                            .minimumScaleFactor(0.8)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.vertical, 10)
                .padding(.horizontal, 12)
                .background(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(Color.green.opacity(0.1))
                )

                // Tarjeta Gastos
                HStack(spacing: 10) {
                    Image(systemName: "minus")
                        .font(.title)
                        .foregroundStyle(.red)

                    VStack(alignment: .leading, spacing: 2) {
                        Text("Gastos")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Text(formatCurrency(totalExpenses))
                            .font(.subheadline.bold())
                            .foregroundStyle(.red)
                            .lineLimit(1)
                            .minimumScaleFactor(0.8)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.vertical, 10)
                .padding(.horizontal, 12)
                .background(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(Color.red.opacity(0.1))
                )
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(Color(uiColor: .secondarySystemGroupedBackground))
                .shadow(color: Color.black.opacity(0.06), radius: 10, x: 0, y: 4)
        )
    }
}

#Preview {
    ZStack {
        Color(uiColor: .systemGroupedBackground)
            .ignoresSafeArea()
        BalanceCardView(
            balance: 2985.50,
            totalIncome: 3100.00,
            totalExpenses: 114.50,
            selectedMonth: Date(),
            onPreviousMonth: {},
            onNextMonth: {}
        )
        .padding()
    }
}
