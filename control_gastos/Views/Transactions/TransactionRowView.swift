//
//  TransactionRowView.swift
//  control_gastos
//

import SwiftUI

/// Celda visual para mostrar los detalles de un movimiento con estética nativa de iOS.
struct TransactionRowView: View {
    let transaction: Transaction

    var body: some View {
        HStack(spacing: 14) {
            // MARK: - Icono de la Categoría
            ZStack {
                Circle()
                    .fill(transaction.category.color.opacity(0.15))
                    .frame(width: 46, height: 46)

                Image(systemName: transaction.category.iconName)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(transaction.category.color)
            }

            // MARK: - Título, Categoría y Fecha
            VStack(alignment: .leading, spacing: 4) {
                Text(transaction.title)
                    .font(.body.weight(.medium))
                    .foregroundStyle(.primary)
                    .lineLimit(1)

                HStack(spacing: 6) {
                    Text(transaction.category.displayName)
                    Text("•")
                    Text(transaction.date.formatted(date: .abbreviated, time: .omitted))
                }
                .font(.caption)
                .foregroundStyle(.secondary)

                if !transaction.note.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    Text(transaction.note)
                        .font(.caption2)
                        .foregroundStyle(.tertiary)
                        .lineLimit(1)
                }
            }

            Spacer()

            // MARK: - Monto
            Text(transaction.formattedAmount)
                .font(.system(.body, design: .rounded).weight(.semibold))
                .foregroundStyle(transaction.type == .expense ? Color.primary : Color.green)
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    List {
        TransactionRowView(transaction: Transaction.samples[0])
        TransactionRowView(transaction: Transaction.samples[1])
    }
}
