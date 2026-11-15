//
//  ContentView.swift
//  control_gastos
//
//  Created by Iván Alejandro on 14-11-26.
//

import SwiftUI

/// Vista principal de la aplicación que orquesta el Dashboard, Gráficos y Lista de Movimientos.
struct ContentView: View {
    @State private var viewModel = ExpenseViewModel()
    @State private var showingAddSheet = false
    @State private var selectedFilter: FilterOption = .all

    enum FilterOption: String, CaseIterable, Identifiable {
        case all = "Todos"
        case expenses = "Gastos"
        case income = "Ingresos"

        var id: String { rawValue }
    }

    var body: some View {
        NavigationStack {
            List {
                // MARK: - Tarjeta de Balance
                Section {
                    BalanceCardView(
                        balance: viewModel.netBalance,
                        totalIncome: viewModel.totalIncome,
                        totalExpenses: viewModel.totalExpenses,
                        selectedMonth: viewModel.selectedMonth,
                        onPreviousMonth: {
                            withAnimation(.easeInOut) {
                                viewModel.previousMonth()
                            }
                        },
                        onNextMonth: {
                            withAnimation(.easeInOut) {
                                viewModel.nextMonth()
                            }
                        }
                    )
                }
                .listRowInsets(EdgeInsets(top: 4, leading: 16, bottom: 8, trailing: 16))
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)

                // MARK: - Gráfico de Gastos por Categoría
                Section {
                    MonthlyChartCard(
                        summaries: viewModel.expensesByCategory,
                        totalExpenses: viewModel.totalExpenses
                    )
                }
                .listRowInsets(EdgeInsets(top: 4, leading: 16, bottom: 8, trailing: 16))
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)

                // MARK: - Lista de Movimientos con Filtro
                Section {
                    // Selector de Filtro
                    Picker("Filtro", selection: $selectedFilter) {
                        ForEach(FilterOption.allCases) { option in
                            Text(option.rawValue).tag(option)
                        }
                    }
                    .pickerStyle(.segmented)
                    .listRowInsets(EdgeInsets(top: 10, leading: 16, bottom: 10, trailing: 16))
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                    .onChange(of: selectedFilter) { _, newOption in
                        withAnimation {
                            switch newOption {
                            case .all:
                                viewModel.filterType = nil
                            case .expenses:
                                viewModel.filterType = .expense
                            case .income:
                                viewModel.filterType = .income
                            }
                        }
                    }

                    if viewModel.filteredTransactions.isEmpty {
                        // Estado Vacío cuando no hay transacciones
                        VStack(spacing: 8) {
                            Image(systemName: "tray")
                                .font(.system(size: 36))
                                .foregroundStyle(.tertiary)
                            Text("No hay movimientos registrados")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 24)
                        .listRowBackground(Color.clear)
                    } else {
                        // Filas de Transacciones
                        ForEach(viewModel.filteredTransactions) { transaction in
                            TransactionRowView(transaction: transaction)
                        }
                        .onDelete { offsets in
                            withAnimation {
                                viewModel.deleteFilteredTransaction(at: offsets)
                            }
                        }
                    }
                } header: {
                    HStack {
                        Text("Movimientos")
                            .font(.title3.bold())
                            .foregroundStyle(.primary)

                        Spacer()

                        Text("\(viewModel.filteredTransactions.count)")
                            .font(.caption.bold())
                            .foregroundStyle(.secondary)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 3)
                            .background(Capsule().fill(Color(uiColor: .systemGray5)))
                    }
                    .textCase(nil)
                    .padding(.horizontal, -4)
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Control de Gastos")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingAddSheet = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title3)
                            .foregroundStyle(.tint)
                    }
                    .accessibilityLabel("Agregar movimiento")
                }
            }
            .sheet(isPresented: $showingAddSheet) {
                AddTransactionView { newTransaction in
                    withAnimation {
                        viewModel.addTransaction(newTransaction)
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
