//
//  StudyCardViewModel.swift
//  AccessEd
//
//  Created by Nahom Worku on 2025-02-04.
//

//import Foundation
//import SwiftData
////import PhotosUI
//import Vision
//import _PhotosUI_SwiftUI
//
//class StudyCardViewModel: ObservableObject {
//    var modelContext: ModelContext? = nil
//    @Published var studyCards: [StudyCardModel] = []
//    @Published var question: String = ""
//    @Published var answer: String = ""
//    
//    @Published var extractedText: String = ""
//    @Published var selectedPhotoItem: PhotosPickerItem? = nil
//    @Published var selectedImage: UIImage? = nil
//    
//    @Published var showCreateStudyCardsView: Bool = false
//    
//    private let StudyCardsGenearator = StudyCardsGenerator()
//    
//    
//    func fetchStudyCards() {
//        let fetchDescriptor = FetchDescriptor<StudyCardModel>(
//            sortBy: [SortDescriptor(\.id)]
//        )
//        studyCards = (try? (modelContext?.fetch(fetchDescriptor) ?? [])) ?? []
//    }
//    
//    func addStudyCard(question: String, answer: String) {
//        let newStudyCard = StudyCardModel( question: question, answer: answer)
//        modelContext?.insert(newStudyCard)
//        try? modelContext?.save()
//        
//        fetchStudyCards()
//    }
//    
//    func deleteStudyCard(_ studyCard: StudyCardModel) {
//        modelContext?.delete(studyCard)
//        try? modelContext?.save()
//        
//        fetchStudyCards()
//    }
//    
//    
//    func loadImage(from item: PhotosPickerItem) {
//        item.loadTransferable(type: Data.self) { result in
//            DispatchQueue.main.async {
//                switch result {
//                case .success(let data):
//                    if let data = data, let image = UIImage(data: data) {
//                        self.selectedImage = image
//                    } else {
//                        print("Error: Could not convert data to UIImage.")
//                    }
//                case .failure(let error):
//                    print("Error loading image: \(error)")
//                }
//            }
//        }
//    }
//
//    func processImage() {
//        guard let selectedImage = selectedImage else { return }
//        recognizeText(from: selectedImage) { text in
//            DispatchQueue.main.async {
//                self.extractedText = text
//            }
//        }
//    }
//    
//    func generateStudyCards(from extractedText: String) {
//            let generatedQAs = StudyCardsGenearator.generateQuestionsAndAnswers(from: extractedText)
//            
//            DispatchQueue.main.async {
//                for qa in generatedQAs {
//                    guard qa.question.contains("______") else { continue } // Ensure only valid Q&A pairs
//                    
//                    // Save study card to SwiftData
//                    let newCard = StudyCardModel(question: qa.question, answer: qa.answer)
//                    self.modelContext?.insert(newCard)
//                }
//                
//                // Fetch updated study cards from SwiftData
//                self.fetchStudyCards()
//            }
//        }
//    
//    func recognizeText(from image: UIImage, completion: @escaping (String) -> Void) {
//        guard let cgImage = image.cgImage else { return }
//
//        let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
//        let textRecognitionRequest = VNRecognizeTextRequest { (request, error) in
//            guard let observations = request.results as? [VNRecognizedTextObservation] else {
//                completion("")
//                return
//            }
//
//            let extractedText = observations.compactMap { $0.topCandidates(1).first?.string }.joined(separator: " ")
//            completion(extractedText)
//        }
//
//        textRecognitionRequest.recognitionLevel = .accurate
//        textRecognitionRequest.usesLanguageCorrection = true
//
//        DispatchQueue.global(qos: .userInitiated).async {
//            do {
//                try requestHandler.perform([textRecognitionRequest])
//            } catch {
//                print("Error recognizing text: \(error)")
//                completion("")
//            }
//        }
//    }
//}



// MARK: - 2nd


import SwiftUI
import _PhotosUI_SwiftUI
import Vision
import SwiftData

class StudyCardViewModel: ObservableObject {
    @Published var extractedText: String = ""
    @Published var studyCards: [StudyCardModel] = []
    @Published var generatedCards: [(question: String, answer: String)] = []
    @Published var selectedPhotoItem: PhotosPickerItem? = nil
    @Published var selectedImage: UIImage? = nil
    @Published var showReviewSheet: Bool = false  // Show review modal
    @Published var showCreateStudyCardsView: Bool = false
    
    var modelContext: ModelContext?

    private let studyCardsGenerator = StudyCardsGenerator()

    // ✅ Fetch Study Cards
    func fetchStudyCards() {
        guard let modelContext = modelContext else { return }
        let fetchDescriptor = FetchDescriptor<StudyCardModel>(sortBy: [SortDescriptor(\.id)])

        DispatchQueue.main.async {
            self.studyCards = (try? modelContext.fetch(fetchDescriptor)) ?? []
        }
    }

    func addStudyCard(question: String, answer: String) {
        let newStudyCard = StudyCardModel( question: question, answer: answer)
        modelContext?.insert(newStudyCard)
        try? modelContext?.save()
        
        fetchStudyCards()
    }
    
    // ✅ Add Study Card to SwiftData
    func saveGeneratedCards() {
        guard let modelContext = modelContext else { return }
        for qa in generatedCards {
            let newCard = StudyCardModel(question: qa.question, answer: qa.answer)
            modelContext.insert(newCard)
        }
        try? modelContext.save()
        fetchStudyCards()  // Reload UI
//        showReviewSheet = false  // Close modal after saving
    }

    // ✅ Load Image from Picker
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

    // ✅ Generate Study Cards and Show Review Sheet
//    func generateStudyCards() {
//        let generatedQAs = studyCardsGenerator.generateQuestionsAndAnswers(from: extractedText)
//        DispatchQueue.main.async {
//            self.generatedCards = generatedQAs.filter { $0.question.contains("______") }
//            if !self.generatedCards.isEmpty {
//                self.showReviewSheet = true  // Open review modal
//            }
//        }
//    }
    
    func generateStudyCards() {
        let generatedQAs = studyCardsGenerator.generateQuestionsAndAnswers(from: extractedText)
        
        // Ensure we are updating on the main thread
        DispatchQueue.main.async {
            print("✅ Generated Cards Count: \(generatedQAs.count)") // Debugging

            // **Filter valid Q&A pairs first**
            let validCards = generatedQAs.filter { $0.question.contains("______") }

            // **Now map them to StudyCardModel**
            self.studyCards = validCards.map { qa in
                let newCard = StudyCardModel(question: qa.question, answer: qa.answer)
                /*self.addStudyCard(question: qa.question, answer: qa.answer)*/ // Save in database
                return newCard
            }

            print("📌 studyCards Count After Assignment: \(self.studyCards.count)") // Debugging
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

