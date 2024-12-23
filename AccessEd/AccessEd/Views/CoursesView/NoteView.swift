//
//  NoteView.swift
//  AccessEd
//
//  Created by Nahom Worku on 2024-12-21.
//

import SwiftUI

struct NoteView: View {
    var body: some View {
        VStack {
            PDFViewer(pdfName: "MATH 1014 3.0 Fundamentals of Calculus") //"W1 - PartB - I")
                .background(Color.gray.opacity(0.1))
                .padding()
        }
        .navigationTitle("Notes")
        .navigationBarTitleDisplayMode(.inline)
    }
}

//#Preview {
//    NoteView()
//}
