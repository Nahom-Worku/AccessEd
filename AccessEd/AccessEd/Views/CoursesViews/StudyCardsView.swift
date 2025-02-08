//
//  StudyCardsView.swift
//  AccessEd
//
//  Created by Nahom Worku on 2024-12-21.
//


import SwiftUI
import _PhotosUI_SwiftUI

struct StudyCardsView: View {
    /*@Environment(\.modelContext)*/
    var modelContext: ModelContext
//    @StateObject var studyCardViewModel: StudyCardViewModel = StudyCardViewModel()
    var course: CourseModel
    var studyCardName: String
    
    @State var showCreateStudyCardsView: Bool = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                ForEach(course.getStudyCards(with: studyCardName), id: \.id) { card in
                    StudyCardRow(card: card)
                }
            }
            .padding()
        }
        .padding()
        .navigationTitle("\(studyCardName)")
        .sheet(isPresented: $showCreateStudyCardsView) {
            CreateStudyCardsView(modelContext: modelContext, course: course, studyCardName: studyCardName)
        }
    }
}



import SwiftUI
import _PhotosUI_SwiftUI
import Vision
import SwiftData

struct CreateStudyCardsView: View {
//    @ObservedObject var viewModel: StudyCardViewModel
    /*@Environment(\.modelContext)*/
    var modelContext: ModelContext
    @Environment(\.dismiss) var dismiss
    
    @State var extractedText: String = ""
    @State var selectedPhotoItem: PhotosPickerItem? = nil
    @State var selectedImage: UIImage? = nil
    
    var course: CourseModel
//    var studyCardName: String

    private let studyCardsGenerator = StudyCardsGenerator()
    
    @State var studyCardName: String = ""
    @FocusState private var isTaskFieldFocused: Bool
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("Add a Study Card")
                    .font(.title3)
                    .bold()
                    .foregroundStyle(Color("Text-Colors"))
                
                VStack (alignment: .leading) {
                    Text("Add The Study Card Name")
                        .font(.subheadline)
                        .padding(.leading)
                    
                    TextField("Enter Study Card Name", text: $studyCardName)
                        .focused($isTaskFieldFocused)
                        .padding(10)
                        .background(Color.gray.opacity(0.05).cornerRadius(5.0))
                        .padding([.horizontal, .bottom], 20)
                        .font(.subheadline)
                }
                .foregroundStyle(Color("Text-Colors"))
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        isTaskFieldFocused = true
                    }
                }
            }
            
            VStack {
                Text("Extract Text and Generate Study Cards")
                    .font(.headline)
//                    .bold()
                    .padding(.top)

                // Display selected image
                if let selectedImage = selectedImage {
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
                PhotosPicker(selection: $selectedPhotoItem, matching: .images, photoLibrary: .shared()) {
                    Text("Choose Image")
                        .padding()
                        .frame(maxWidth: UIScreen.main.bounds.width)
                        .background(studyCardName.isEmpty ? .gray.opacity(0.25) : .blue)
                        .foregroundColor(studyCardName.isEmpty ? .gray.opacity(0.3) : .white)
                        .cornerRadius(8)
                }
                .padding()
                .disabled(studyCardName.isEmpty)
                .onChange(of: selectedPhotoItem) { newItem in
                    if let newItem = newItem {
                        loadImage(from: newItem)
                    }
                }

                // TextEditor for editing extracted text
                if !extractedText.isEmpty {
                    VStack(alignment: .leading) {
                        Text("Edit Extracted Text:")
                            .font(.headline)
                            .padding(.vertical)

                        TextEditor(text: $extractedText)
                            .frame(height: 150)
                            .padding(4)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray, lineWidth: 1)
                            )
                            .padding(.horizontal)
                    }
                }

                
                VStack(spacing: 0) {
                    // Buttons
                    Button(action: processImage) {
                        Text("Extract Text")
                            .padding()
                            .frame(maxWidth: UIScreen.main.bounds.width)
                            .background(selectedImage == nil ? .gray.opacity(0.25) : .green)
                            .foregroundColor(selectedImage == nil ? .gray.opacity(0.3) : .white)
                            .cornerRadius(8)
                    }
                    .padding()
                    .disabled(selectedImage == nil)
                    
                    
                    Button(action: {
                        generateStudyCards(studyCardName: studyCardName)
                        
                        dismiss()
                    }, label: {
                        Text("Generate Study Cards")
                            .padding()
                            .frame(maxWidth: UIScreen.main.bounds.width)
                            .background(extractedText.isEmpty || studyCardName.isEmpty ? .gray.opacity(0.25) : .blue)
                            .foregroundColor(extractedText.isEmpty || studyCardName.isEmpty ? .gray.opacity(0.3) : .white)
                            .cornerRadius(8)
                    })
                    .padding()
                    .disabled(extractedText.isEmpty || studyCardName.isEmpty)
                    
                    Button {
                        dismiss()
                    } label: {
                        Text("Cancel")
                            .padding()
                            .frame(maxWidth: UIScreen.main.bounds.width)
                            .background(.red.opacity(0.3))
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .padding()
                }
            }
        }
        .padding()
        .onAppear {
//            viewModel.modelContext = modelContext
//            viewModel.fetchStudyCards()
        }
    }
    
    func loadImage(from item: PhotosPickerItem) {
        item.loadTransferable(type: Data.self) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    if let data = data, let image = UIImage(data: data) {
                        self.selectedImage = image
                    }
                case .failure(let error):
                    print("Error loading image: \(error)")
                }
            }
        }
    }

    // ✅ Process Image and Extract Text
    func processImage() {
        guard let selectedImage = selectedImage else { return }
        recognizeText(from: selectedImage) { text in
            DispatchQueue.main.async {
                self.extractedText = text
            }
        }
    }
    
    func generateStudyCards(studyCardName: String) {
        let generatedQAs = studyCardsGenerator.generateQuestionsAndAnswers(from: extractedText)
        
        modelContext.insert(course)
        
        
        var studyCards: [StudyCardModel] = []
        for qa in generatedQAs {
            if qa.question.contains("______") && qa.answer.count > 0 {
                studyCards.append(StudyCardModel(studyCardName: studyCardName, question: qa.question, answer: qa.answer, course: course))
            }
        }
        
        for card in studyCards {
            course.studyCards.append(card)
        }
    }



    // ✅ Text Recognition with Vision
    private func recognizeText(from image: UIImage, completion: @escaping (String) -> Void) {
        guard let cgImage = image.cgImage else { return }

        let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        let textRecognitionRequest = VNRecognizeTextRequest { (request, error) in
            guard let observations = request.results as? [VNRecognizedTextObservation] else {
                completion("")
                return
            }

            let extractedText = observations.compactMap { $0.topCandidates(1).first?.string }.joined(separator: " ")
            completion(extractedText)
        }

        textRecognitionRequest.recognitionLevel = .accurate
        textRecognitionRequest.usesLanguageCorrection = true

        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try requestHandler.perform([textRecognitionRequest])
            } catch {
                print("Error recognizing text: \(error)")
                completion("")
            }
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


