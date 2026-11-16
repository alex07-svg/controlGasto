//
//  Category.swift
//  control_gastos
//

import Foundation
import SwiftUI

/// Categorías para clasificar los movimientos con diseño visual estilo Apple (SF Symbols y Colores del sistema).
enum Category: String, CaseIterable, Codable, Identifiable {
    // Gastos
    case food = "Alimentación"
    case transport = "Transporte"
    case housing = "Vivienda"
    case entertainment = "Entretenimiento"
    case health = "Salud"
    case services = "Servicios"
    case shopping = "Compras"
    case travel = "Viajes"
    case otherExpense = "Otros gastos"

    // Ingresos
    case salary = "Sueldo"
    case freelance = "Freelance"
    case investments = "Inversiones"
    case gifts = "Regalos"
    case otherIncome = "Otros ingresos"

    var id: String { rawValue }

    /// Nombre amigable para mostrar en pantalla
    var displayName: String { rawValue }

    /// Tipo de movimiento al que pertenece comúnmente la categoría
    var defaultType: TransactionType {
        switch self {
        case .food, .transport, .housing, .entertainment, .health, .services, .shopping, .travel, .otherExpense:
            return .expense
        case .salary, .freelance, .investments, .gifts, .otherIncome:
            return .income
        }
    }

    /// Nombre del icono en SF Symbols
    var iconName: String {
        switch self {
        case .food:
            return "cart.fill"
        case .transport:
            return "car.fill"
        case .housing:
            return "house.fill"
        case .entertainment:
            return "film.fill"
        case .health:
            return "cross.fill"
        case .services:
            return "bolt.fill"
        case .shopping:
            return "bag.fill"
        case .travel:
            return "airplane.circle.fill"
        case .otherExpense:
            return "creditcard.fill"
        case .salary:
            return "banknote.fill"
        case .freelance:
            return "laptopcomputer"
        case .investments:
            return "chart.line.uptrend.xyaxis"
        case .gifts:
            return "gift.fill"
        case .otherIncome:
            return "plus.circle.fill"
        }
    }

    /// Color del sistema asignado para gráficos y badges
    var color: Color {
        switch self {
        case .food:
            return .orange
        case .transport:
            return .blue
        case .housing:
            return .indigo
        case .entertainment:
            return .purple
        case .health:
            return .pink
        case .services:
            return .yellow
        case .shopping:
            return .cyan
        case .travel:
            return .red
        case .otherExpense:
            return .gray
        case .salary:
            return .green
        case .freelance:
            return .teal
        case .investments:
            return .mint
        case .gifts:
            return .red
        case .otherIncome:
            return .secondary
        }
    }

    /// Filtra las categorías según el tipo de movimiento seleccionado
    static func categories(for type: TransactionType) -> [Category] {
        allCases.filter { $0.defaultType == type }
    }
}
