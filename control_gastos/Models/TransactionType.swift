//
//  TransactionType.swift
//  control_gastos
//

import Foundation
import SwiftUI

/// Representa la naturaleza del movimiento financiero: Gasto o Ingreso.
enum TransactionType: String, CaseIterable, Codable, Identifiable {
    case expense = "Gasto"
    case income = "Ingreso"

    var id: String { rawValue }

    /// Símbolo de Apple SF Symbols representativo
    var iconName: String {
        switch self {
        case .expense:
            return "arrow.down.right.circle.fill"
        case .income:
            return "arrow.up.left.circle.fill"
        }
    }

    /// Color semántico según las directrices de diseño de Apple
    var color: Color {
        switch self {
        case .expense:
            return .red
        case .income:
            return .green
        }
    }
}
