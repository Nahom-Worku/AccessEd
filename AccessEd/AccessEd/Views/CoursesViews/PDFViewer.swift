//
//  PDFViewer.swift
//  AccessEd
//
//  Created by Nahom Worku on 2024-12-21.
//

import SwiftUI
import PDFKit

struct PDFViewer: UIViewRepresentable {
    let pdfName: String // Name of the PDF file (without extension)

    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.autoScales = true // Automatically adjusts to fit the view

        if let url = Bundle.main.url(forResource: pdfName, withExtension: "pdf") {
            pdfView.document = PDFDocument(url: url) // Load the PDF document
        } else {
            print("Error: Could not load \(pdfName).pdf")
        }

        return pdfView
    }

    func updateUIView(_ uiView: PDFView, context: Context) {
        // No update needed for static PDFs
    }
}

//#Preview {
//    PDFViewer()
//}
