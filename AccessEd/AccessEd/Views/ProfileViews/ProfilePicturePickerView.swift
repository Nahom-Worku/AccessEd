//
//  editprofilepicview.swift
//  AccessEd
//
//  Created by Nahom Worku on 2025-01-31.
//

import SwiftUI
import PhotosUI

struct ProfilePicturePickerView: View {
    @State private var selectedImage: UIImage? = nil
    @State private var photosPickerItem: PhotosPickerItem?
    @Binding var showPickerSheet: Bool

    @ObservedObject var profileViewModel: ProfileViewModel
    @Environment(\.modelContext) var modelContext
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Preview of selected image
                if let selectedImage = selectedImage {
                    Image(uiImage: selectedImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 200, height: 200)
                        .clipShape(Circle())
                        .shadow(radius: 2)
                } else {
                    Image(systemName: "person.circle")
                        .resizable()
                        .fontWeight(.ultraLight)
                        .aspectRatio(contentMode: .fill)
                        .foregroundStyle(.gray.opacity(0.5))
                        .frame(width: 100, height: 100)
                }
                
                // Photos picker
                VStack {
                    PhotosPicker(
                        "Select Profile Picture",
                        selection: $photosPickerItem,
                        matching: .images,
                        photoLibrary: .shared()
                    )
                    .onChange(of: photosPickerItem) {
                        if let newValue = photosPickerItem {
                            Task {
                                if let data = try? await newValue.loadTransferable(type: Data.self),
                                   let uiImage = UIImage(data: data) {
                                    self.selectedImage = uiImage
                                }
                            }
                        }
                    }
                }
                .padding()
                .padding(.horizontal)
                .frame(maxWidth: UIScreen.main.bounds.width - 100)
                
                
                // Save button
                Button(action: {
                    if let selectedImage = selectedImage {
                        profileViewModel.updateProfilePicture(with: selectedImage)
                    }
                    showPickerSheet = false
                }) {
                    Text("Save")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: UIScreen.main.bounds.width - 100)
                        .background(selectedImage != nil ? Color.blue : Color.gray.opacity(0.5))
                        .foregroundColor(selectedImage != nil ? Color.white : Color.gray.opacity(0.5))
                        .cornerRadius(10)
                }
                .disabled(selectedImage == nil)
                
                // Cancel button
                Button(action: {
                    showPickerSheet = false
                }) {
                    Text("Cancel")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: UIScreen.main.bounds.width - 100)
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .padding()
            .navigationTitle("Edit Profile Picture")
        }
        .onAppear {
            profileViewModel.modelContext = modelContext
            profileViewModel.fetchProfile()
        }
    }
}
