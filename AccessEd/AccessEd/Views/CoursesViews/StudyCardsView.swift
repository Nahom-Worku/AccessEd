//
//  StudyCardsView.swift
//  AccessEd
//
//  Created by Nahom Worku on 2024-12-21.
//


import SwiftUI
import _PhotosUI_SwiftUI

struct StudyCardsView: View {
    @Environment(\.modelContext) var modelContext
    @StateObject var studyCardViewModel: StudyCardViewModel = StudyCardViewModel()
//    @Binding var course: CourseModel
    
    var body: some View {
        VStack(spacing: 30) {
            if studyCardViewModel.studyCards.isEmpty {
                
                VStack() {
                    Text("Start adding study cards!")
                    
                    Button("Add Cards") {
                        studyCardViewModel.showCreateStudyCardsView = true
                    }
                }
                .padding()
                .padding(.horizontal, 20)
                .frame(width: UIScreen.main.bounds.width, height: 300, alignment: .center)
                
            } else {
                ScrollView {
                    VStack(spacing: 30) {
                        ForEach(studyCardViewModel.studyCards, id: \.id) { card in
                            StudyCardRow(card: card)
                        }
                    }
                    .padding()
                }
            }
            
        }
        .padding()
        .navigationTitle("Study Cards")
        .sheet(isPresented: $studyCardViewModel.showCreateStudyCardsView) {
            CreateStudyCardsView(viewModel: studyCardViewModel)
        }
        .onAppear {
            studyCardViewModel.modelContext = modelContext
            studyCardViewModel.fetchStudyCards()
        }
    }
}



import SwiftUI
import _PhotosUI_SwiftUI

struct CreateStudyCardsView: View {
    @ObservedObject var viewModel: StudyCardViewModel
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ScrollView {
            VStack {
                Text("Extract Text and Generate Study Cards")
                    .font(.title2)
                    .bold()
                    .padding(.top)

                // Display selected image
                if let selectedImage = viewModel.selectedImage {
                    Image(uiImage: selectedImage)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 200)
                        .cornerRadius(8)
                        .padding()
                } else {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 200)
                        .cornerRadius(8)
                        .overlay(
                            Text("Select an Image")
                                .foregroundColor(.gray)
                        )
                        .padding()
                }

                // Image selection
                PhotosPicker(selection: $viewModel.selectedPhotoItem, matching: .images, photoLibrary: .shared()) {
                    Text("Choose Image")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding()
                .onChange(of: viewModel.selectedPhotoItem) { newItem in
                    if let newItem = newItem {
                        viewModel.loadImage(from: newItem)
                    }
                }

                // TextEditor for editing extracted text
                if !viewModel.extractedText.isEmpty {
                    VStack(alignment: .leading) {
                        Text("Edit Extracted Text:")
                            .font(.headline)
                            .padding(.vertical)

                        TextEditor(text: $viewModel.extractedText)
                            .frame(height: 100)
                            .padding(4)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray, lineWidth: 1)
                            )
                    }
                }

                

                // Buttons
                Button(action: viewModel.processImage) {
                    Text("Extract Text")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding()
                .disabled(viewModel.selectedImage == nil)

                Button(action: {
                    viewModel.generateStudyCards()
                    viewModel.saveGeneratedCards()
                    
                    for qa in viewModel.generatedCards {
                        viewModel.addStudyCard(question: qa.question, answer: qa.answer)
                    }
                    
                    dismiss()
                }, label: {
                    Text("Generate Study Cards")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                })
                .padding()
                .disabled(viewModel.extractedText.isEmpty)
                
                Button {
                    dismiss()
                } label: {
                    Text("Cancel")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.red.opacity(0.3))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                
            }
        }
        .padding()
        .onAppear {
            viewModel.modelContext = modelContext
            viewModel.fetchStudyCards()
        }
    }
}

import SwiftUI

struct StudyCardRow: View {
    @State var card: StudyCardModel

    var body: some View {
        ZStack {
            if !card.isFlipped {
                // Front Side (Question)
                VStack {
                    Text("Question")
                        .font(.title3)
                        .padding(.vertical)

                    Text(card.question)
                        .multilineTextAlignment(.center)
                        .padding()
                }
                .frame(width: 350, height: 200)
                .background(Color("StudyCard-Colors"))
                .cornerRadius(10)
                .shadow(radius: 3, x: 0, y: 0)
            } else {
                // Back Side (Answer)
                VStack {
                    Text("Answer")
                        .font(.title3)
                        .padding(.vertical)

                    Text(card.answer)
                        .multilineTextAlignment(.center)
                        .padding()
                }
                .frame(width: 350, height: 200)
                .rotation3DEffect(.degrees(-180), axis: (x: 0, y: 1, z: 0))
                .background(Color("StudyCard-Colors"))
                .cornerRadius(10)
                .shadow(radius: 3, x: 0, y: 0)
            }
        }
        .rotation3DEffect(.degrees(card.isFlipped ? -180 : 0), axis: (x: 0, y: 1, z: 0))
        .animation(.spring(response: 0.5, dampingFraction: 0.6, blendDuration: 0), value: card.isFlipped)
        .onTapGesture(count: 2) {
            card.isFlipped.toggle()
        }
    }
}


