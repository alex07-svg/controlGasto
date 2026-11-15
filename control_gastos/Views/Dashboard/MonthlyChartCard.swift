//
//  MonthlyChartCard.swift
//  control_gastos
//

import SwiftUI
import Charts

/// Tarjeta que visualiza los gastos mensuales clasificados por categoría utilizando Swift Charts.
struct MonthlyChartCard: View {
    let summaries: [CategoryExpenseSummary]
    let totalExpenses: Double

    private func formatCurrency(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale.current
        return formatter.string(from: NSNumber(value: value)) ?? String(format: "$%.2f", value)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // MARK: - Encabezado
            HStack {
                Label("Distribución de Gastos", systemImage: "chart.pie.fill")
                    .font(.headline)
                    .foregroundStyle(.primary)

                Spacer()

                if !summaries.isEmpty {
                    Text(formatCurrency(totalExpenses))
                        .font(.subheadline.bold())
                        .foregroundStyle(.secondary)
                }
            }

            if summaries.isEmpty {
                // MARK: - Estado Vacío
                VStack(spacing: 10) {
                    Image(systemName: "chart.pie")
                        .font(.system(size: 44))
                        .foregroundStyle(.tertiary)

                    Text("No hay gastos registrados en este mes")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 30)
            } else {
                // MARK: - Gráfico Circular (Donut Chart con Swift Charts)
                Chart(summaries) { item in
                    SectorMark(
                        angle: .value("Monto", item.amount),
                        innerRadius: .ratio(0.65),
                        angularInset: 1.5
                    )
                    .cornerRadius(5)
                    .foregroundStyle(item.category.color)
                }
                .frame(height: 180)
                .chartBackground { chartProxy in
                    GeometryReader { geometry in
                        if let plotFrame = chartProxy.plotFrame {
                            let frame = geometry[plotFrame]
                            VStack(spacing: 2) {
                                Text("Total Gastos")
                                    .font(.caption2)
                                    .foregroundStyle(.secondary)
                                Text(formatCurrency(totalExpenses))
                                    .font(.system(.subheadline, design: .rounded).weight(.bold))
                                    .foregroundStyle(.primary)
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.7)
                            }
                            .position(x: frame.midX, y: frame.midY)
                        }
                    }
                }

                // MARK: - Leyenda de Categorías
                VStack(spacing: 8) {
                    ForEach(summaries.prefix(4)) { item in
                        HStack {
                            Circle()
                                .fill(item.category.color)
                                .frame(width: 10, height: 10)

                            Text(item.category.displayName)
                                .font(.caption)
                                .foregroundStyle(.primary)

                            Spacer()

                            Text(formatCurrency(item.amount))
                                .font(.caption.bold())
                                .foregroundStyle(.secondary)

                            let percentage = totalExpenses > 0 ? (item.amount / totalExpenses) * 100 : 0
                            Text(String(format: "(%.0f%%)", percentage))
                                .font(.caption2)
                                .foregroundStyle(.tertiary)
                                .frame(width: 42, alignment: .trailing)
                        }
                    }
                }
                .padding(.top, 4)
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
        MonthlyChartCard(
            summaries: [
                CategoryExpenseSummary(category: .food, amount: 85.50),
                CategoryExpenseSummary(category: .transport, amount: 45.00),
                CategoryExpenseSummary(category: .entertainment, amount: 24.00)
            ],
            totalExpenses: 154.50
        )
        .padding()
    }
}
