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


// MARK: - Study card row

import SwiftUI

struct StudyCardRow: View {
    @ObservedObject var speechSynthesizer = SpeechSynthesizer()
    @State var card: StudyCardModel
    @State var readQuestion = false
    @State var readAnswer = false
    @State private var isAnimating = false

    var body: some View {
        ZStack {
            if !card.isFlipped { studyCardQuestionView }
            else { studyCardAnswerView }
        }
        .rotation3DEffect(.degrees(card.isFlipped ? -180 : 0), axis: (x: 0, y: 1, z: 0))
        .animation(.spring(response: 0.5, dampingFraction: 0.6, blendDuration: 0), value: card.isFlipped)
        .onTapGesture(count: 2) {
            stopSpeech()
            card.isFlipped.toggle()
        }
        .onChange(of: speechSynthesizer.isSpeaking) {
            if isAnimating && speechSynthesizer.isSpeaking {
                startAnimationLoop()  // Start animation when speech starts
            }
            
//            isAnimating = false
        }
    }
    
    
    var studyCardQuestionView: some View {
        VStack(spacing: 0) {
            
            HStack(alignment: .top) {
                Spacer()
                
                Button {
                    toggleQuestionSpeech()
                } label: {
                    Image(systemName: "microphone")
                        .font(.headline)
                        .foregroundColor(speechSynthesizer.isSpeaking && readQuestion ? .red : .blue) // 🔴 Change color dynamically
                        .scaleEffect(speechSynthesizer.isSpeaking && readQuestion ? 1.3 : 1.0) // 🔄 Pulsate effect
                        .animation(.easeInOut(duration: 0.5).repeatForever(autoreverses: true), value: true)
                        

                }
            }
            .padding()
            
            Spacer()
            
            VStack {
                Text("Question")
                    .font(.title3)
                
                Text(card.question)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)  // ✅ Allow unlimited lines
                    .fixedSize(horizontal: false, vertical: true) // ✅ Ensures vertical expansion
                    .padding()
            }
            
            Spacer()
            
            HStack {
                Spacer()
                
                Button {
                    stopSpeech()
                    card.isFlipped = true
                } label: {
                    Image(systemName: "arrow.trianglehead.2.counterclockwise.rotate.90")
                        .font(.headline)
                }
            }
            .padding()
        }
        .frame(width: UIScreen.main.bounds.width * 0.85)//, height: UIScreen.main.bounds.height * 0.25)
        .background(Color("StudyCard-Colors"))
        .cornerRadius(10)
        .shadow(radius: 2, x: 0, y: 0)
    }
    
    
    var studyCardAnswerView: some View {
        VStack(spacing: 0) {
            HStack(alignment: .top) {
                Spacer()
                
                Button {
                    toggleAnswerSpeech()
                } label: {
                    Image(systemName: "microphone")
                        .font(.headline)
                }
            }
            .padding()
            
            Spacer()
            
            VStack {
                Text("Answer")
                    .font(.title3)
                    .padding(.bottom)
                
                Text(card.answer)
                    .multilineTextAlignment(.center)
                    .padding()
            }
            
            Spacer()
            
            HStack {
                Spacer()
                
                Button {
                    stopSpeech()
                    card.isFlipped = false
                } label: {
                    Image(systemName: "arrow.trianglehead.2.counterclockwise.rotate.90")
                        .font(.headline)
                }
            }
            .padding()
        }
        .frame(width: UIScreen.main.bounds.width * 0.85) //, height: UIScreen.main.bounds.height * 0.25)
        .rotation3DEffect(.degrees(-180), axis: (x: 0, y: 1, z: 0))
        .background(Color("StudyCard-Colors"))
        .cornerRadius(10)
        .shadow(radius: 2, x: 0, y: 0)
    }
    
    /// Toggles the speech for the question
    private func toggleQuestionSpeech() {
        readQuestion.toggle()
        
        if readQuestion { speechSynthesizer.speak(text: card.question, studyCardItem: .question) }
        else { stopSpeech() }

        readAnswer = false  // Ensure answer speech is not toggled
        
    }

       /// Toggles the speech for the answer
    private func toggleAnswerSpeech() {
        readAnswer.toggle()
        
        if readAnswer { speechSynthesizer.speak(text: card.answer, studyCardItem: .answer) }
        else { stopSpeech() }
        
        readQuestion = false  // Ensure question speech is not toggled
    }

       /// Stops any ongoing speech
    private func stopSpeech() {
        speechSynthesizer.stopSpeaking()
        readQuestion = false
        readAnswer = false
        isAnimating = false
    }
    
    private func startAnimationLoop() {
        guard speechSynthesizer.isSpeaking else {
            isAnimating = false
            return
        }
        
        isAnimating = true
    }
}


#Preview {
    let card = StudyCardModel(question: "What is the capital city of Canada", answer: "Ottawa")
    StudyCardRow(card: card)
}



// MARK: - Text - to - speach

enum StudyCardItem {
    case question
    case answer
}

import AVFoundation

class SpeechSynthesizer: ObservableObject {
    private var synthesizer = AVSpeechSynthesizer()
    @Published var isSpeaking = false
    
    /// Dictionary for special word pronunciations
    private let customPronunciations: [String: String] = [
        "______": ": blank :"
    ]

    // MARK: - TODO: - read the word "Question" and "Answer"
    
    func speak(text: String, studyCardItem: StudyCardItem) {
        guard !text.isEmpty else { return }

        let prefix = (studyCardItem == .question) ? "Question: " : "Answer: "
        
        let modifiedText = modifyTextForPronunciation(prefix + text)
        
        let utterance = AVSpeechUtterance(string: modifiedText)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US") // Change as needed
        utterance.rate = 0.5  // Adjust speed
        utterance.pitchMultiplier = 0.75 // Adjust pitch

        isSpeaking = true
        synthesizer.speak(utterance)
        stopSpeaking()
    }
    
    func stopSpeaking() {
        if synthesizer.isSpeaking {
            isSpeaking = false
            synthesizer.stopSpeaking(at: .immediate)
        }
    }

    /// Function to modify text before speaking
    private func modifyTextForPronunciation(_ text: String) -> String {
        var modifiedText = text

        for (word, replacement) in customPronunciations {
            if text.contains(word) {
                modifiedText = modifiedText.replacingOccurrences(of: word, with: replacement)
            }
        }

        return modifiedText
    }
}



