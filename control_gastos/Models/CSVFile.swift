//
//  CSVFile.swift
//  control_gastos
//

import SwiftUI
import UniformTypeIdentifiers

/// Documento transferible para exportar archivos CSV mediante ShareLink en SwiftUI.
struct CSVFile: Transferable {
    let content: String
    let filename: String

    static var transferRepresentation: some TransferRepresentation {
        DataRepresentation(exportedContentType: .commaSeparatedText) { file in
            file.content.data(using: .utf8) ?? Data()
        }
        .suggestedFileName { file in
            file.filename
        }
    }
}
