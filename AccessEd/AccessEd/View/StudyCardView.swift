//
//  StudyCardView.swift
//  AccessEd
//
//  Created by Nahom Worku on 2024-11-01.
//

import SwiftUI
import Vision
import VisionKit
import UIKit

struct StudyCardView: View {
    @State private var selectedImage: UIImage?
       @State private var recognizedText = ""
       @State private var isShowingImagePicker = false

       var body: some View {
           VStack {
               if let image = selectedImage {
                   Image(uiImage: image)
                       .resizable()
                       .scaledToFit()
                       .frame(height: 200)
                   
                   Text("Extracted Text:")
                       .font(.headline)
                       .padding(.top)
                   
                   ScrollView {
                       Text(recognizedText)
                           .padding()
                   }
                   .frame(maxHeight: 200)
               } else {
                   Text("Select an Image")
                       .font(.headline)
               }
               
               Button("Choose Image") {
                   isShowingImagePicker = true
               }
               .padding()
               .sheet(isPresented: $isShowingImagePicker) {
                   ImagePicker(selectedImage: $selectedImage)
               }
           }
           .onChange(of: selectedImage) { newImage in
               if let newImage = newImage {
                   recognizeText(in: newImage) { text in
                       recognizedText = text
                   }
               }
           }
           .padding()
       }
    
    func recognizeText(in image: UIImage, completion: @escaping (String) -> Void) {
        guard let cgImage = image.cgImage else {
            print("Invalid image")
            return
        }
        
        let textRecognitionRequest = VNRecognizeTextRequest { (request, error) in
            guard error == nil else {
                print("Error recognizing text: \(error!.localizedDescription)")
                return
            }
            
            var recognizedText = ""
            if let results = request.results as? [VNRecognizedTextObservation] {
                for observation in results {
                    if let topCandidate = observation.topCandidates(1).first {
                        recognizedText += topCandidate.string + "\n"
                    }
                }
            }
            completion(recognizedText)
        }
        textRecognitionRequest.recognitionLevel = .accurate
        textRecognitionRequest.usesLanguageCorrection = true

        let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        do {
            try requestHandler.perform([textRecognitionRequest])
        } catch {
            print("Failed to perform text recognition: \(error.localizedDescription)")
        }
    }

}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Environment(\.presentationMode) private var presentationMode

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.selectedImage = image
            }
            parent.presentationMode.wrappedValue.dismiss()
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}

#Preview {
    StudyCardView()
}
