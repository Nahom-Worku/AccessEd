//
//  BookView.swift
//  AccessEd
//
//  Created by Nahom Worku on 2024-12-21.
//

import SwiftUI

struct BookView: View {
    @Binding var course: CourseModel
    let bookNumber: Int
    @State var chapter: Int
    
    var body: some View {
        VStack {
            PDFViewer(pdfName: "EECS 2101 3.0 Fundamentals of Data Structures") //"W1 - PartB - I")
                .background(Color.gray.opacity(0.1))
                .padding()
        }
        .navigationTitle("TextBook")
        .navigationBarTitleDisplayMode(.inline)
    }
}

//#Preview {
//    BookView()
//}
