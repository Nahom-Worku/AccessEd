//
//  ProfileView.swift
//  AccessEd
//
//  Created by Nahom Worku on 2024-11-03.
//

import SwiftUI
import SwiftData

struct ProfileView: View {
    
    @State var showSetupProfileSheet: Bool = false
    @State var editProfileSheet: Bool = false
    
    @Environment(\.modelContext) private var context
    @Query var userProfile: [ProfileModel]
    


    
    var body: some View {
        
        NavigationView {
//            VStack {

            List{
                
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.white)
                    .padding()
                    .frame(width: UIScreen.main.bounds.width, height: 130)
                    .overlay(
                        VStack {
                            Circle()
                                .fill(Color.cyan)
                                .frame(width: 100, height: 100)
                                .overlay {
                                    Image(systemName: "graduationcap.circle")  //"person.circle")
                                        .resizable()
                                        .fontWeight(.ultraLight)
                                        .foregroundStyle(Color.white)
                                }
                            
                            Text("\(userProfile.first?.name ?? "User Name")")
                                .font(.caption)
                            
                            Spacer()
                        }
                            .padding()
                            .padding(.horizontal, 25)
                            .frame(width: UIScreen.main.bounds.width, height: 150, alignment: .center)
                    )
                

                if let profile = userProfile.first {
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Name: \(profile.name)")
                        Text("Grade: \(profile.grade)")
                        Text("Preferred Language: \(profile.preferredLanguage)") // choose from a list
                        Text("Field of Interest: \(profile.fieldsOfInterest)") // choose from a list --> multiple options --> rank or top 3 (5)
                        Text("Favorite Subjects from the last question: ") // Choose from a list --> multiple options
                        Text("Studying Method: ") // choose from a list
                    }
                    
                    HStack {
                        Button {
                            editProfileSheet = true
                        } label: {
                            Text("Edit Profile")
                                .foregroundStyle(.white)
                                .padding()
                                .padding(.horizontal)
                                .background(Color.blue)
                                .cornerRadius(10)
                        }
                        
                        Spacer()
                        
                        Button {
                            context.delete(profile)
                        } label: {
                            Text("Delete Profile")
                                .foregroundStyle(.white)
                                .padding()
                                .padding(.horizontal)
                                .background(Color.red.opacity(0.5))
                                .cornerRadius(10)
                        }
                    }
                    .frame(width: UIScreen.main.bounds.width - 20)
                    
                }
                else {
                    VStack(spacing: 20) {
                        Text("no profile found!")
                        
                        Button {
                            showSetupProfileSheet = true
                            
                        } label: {
                            Text("Setup Profile")
                                .foregroundStyle(.white)
                                .padding()
                                .padding(.horizontal)
                                .background(Color.blue)
                                .cornerRadius(10)
                        }

                    }
                    .frame(width: UIScreen.main.bounds.width, height: 300, alignment: .center)
                }
                //                    }
                
            }
                    
                    .listRowBackground(Color("List-Colors"))
                    .listRowSeparatorTint(Color("List-Colors"))
//                }
                
//            }
            .navigationTitle("Profile")
            .scrollContentBackground(.hidden)
                
                Spacer()
            .navigationTitle("Profile")
        }
        .sheet(isPresented: $showSetupProfileSheet) {
            SetUpProfileView()
        }
        .sheet(isPresented: $editProfileSheet) {
            if let profile = userProfile.first {
                EditProfileView(profile: profile)
            }
        }
    }
}

struct SetUpProfileView: View {
    @Environment(\.modelContext) var context
    @Environment(\.dismiss) var dismiss
    
    @State private var name: String = ""
    @State private var grade: String = ""
    @State private var preferredLanguage: String = "English"
    @State private var fieldsOfInterest: [String] = []
    
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    QuestionView(question: "What is your name?") {
                        TextField("Enter your name", text: $name)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    QuestionView(question: "What is your current grade?") {
                        TextField("Enter your grade", text: $grade)
                    }
                    
                    QuestionView(question: "Which language do you prefer for learning materials?") {
                        Picker("Select Language", selection: $preferredLanguage) {
                            ForEach(Language.allLanguages, id: \.self) { language in
                                Text(language).tag(language)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                    }
                    
                    QuestionView(question: "What are your fields of interest in education?") {
                        MultiSelectList(title: "Fields of Interest", items: FieldOfStudy.allFields, selectedItems: $fieldsOfInterest)
                    }
                    
                    
                    Button {
                        let profile = ProfileModel(name: name, grade: grade, preferredLanguage: preferredLanguage, fieldsOfInterest: fieldsOfInterest)
                        
                        context.insert(profile)
                        try? context.save()
                        
                        dismiss()
                        
                    } label: {
                        Text("Save")
                            .foregroundStyle(.white)
                            .padding()
                            .padding(.horizontal)
                            .background(Color.blue)
                            .cornerRadius(10)
                    }

                }
                .padding()
                .padding(.horizontal)
                .frame(width: UIScreen.main.bounds.width, alignment: .leading)
            }
            .navigationTitle("Set Up Profile")
        }
    }
}

struct QuestionView<Content: View>: View {
    let question: String
    @ViewBuilder let content: Content
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(question)
                .font(.subheadline)
            content
        }
        .padding(.vertical, 10)
    }
}

struct MultiSelectList: View {
    let title: String
    let items: [String]
    @Binding var selectedItems: [String]

    var body: some View {
        NavigationLink(destination: MultiSelectDetailView(items: items, selectedItems: $selectedItems)) {
            VStack(alignment: .leading) {
                Text(title)
                    .font(.headline)
                if selectedItems.isEmpty {
                    Text("None selected").foregroundColor(.gray)
                } else {
                    Text(selectedItems.joined(separator: ", "))
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            .padding(.vertical, 10)
        }
    }
}

struct MultiSelectDetailView: View {
    let items: [String]
    @Binding var selectedItems: [String]

    var body: some View {
        List(items, id: \.self) { item in
            Button(action: {
                if selectedItems.contains(item) {
                    selectedItems.removeAll { $0 == item }
                } else {
                    selectedItems.append(item)
                }
            }) {
                HStack {
                    Text(item)
                    Spacer()
                    if selectedItems.contains(item) {
                        Image(systemName: "checkmark")
                            .foregroundColor(.black)
                    }
                }
            }
            .buttonStyle(.plain)
        }
        .navigationTitle("Select Options")
    }
}

struct EditProfileView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    @Bindable var profile: ProfileModel
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    QuestionView(question: "What is your name?") {
                        TextField("Enter your name", text: $profile.name)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    QuestionView(question: "What is your current grade?") {
                        TextField("Enter your grade", text: $profile.grade)
                    }
                    
                    QuestionView(question: "Which language do you prefer for learning materials?") {
                        Picker("Select Language", selection: $profile.preferredLanguage) {
                            ForEach(Language.allLanguages, id: \.self) { language in
                                Text(language).tag(language)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                    }
                    
                    QuestionView(question: "What are your fields of interest in education?") {
                        MultiSelectList(title: "Fields of Interest", items: FieldOfStudy.allFields, selectedItems: $profile.fieldsOfInterest)
                    }
                    
                    
                    Button {
                        try? context.save()
                        
                        dismiss()
                        
                    } label: {
                        Text("Save Changes")
                            .foregroundStyle(.white)
                            .padding()
                            .padding(.horizontal)
                            .background(Color.blue)
                            .cornerRadius(10)
                    }

                }
                .padding()
                .padding(.horizontal)
                .frame(width: UIScreen.main.bounds.width, alignment: .leading)
            }
            .navigationTitle("Set Up Profile")
        }
    }
}

import SwiftUI

struct ProfileView2: View {
    @State private var showingImagePicker = false
    @State private var profileImage: Image? = Image(systemName: "person.crop.circle.fill")

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Profile Image & Edit Button
                ZStack {
                    if let image = profileImage {
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 120, height: 120)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.gray, lineWidth: 2))
                            .shadow(radius: 5)
                    }
                    Button(action: {
                        showingImagePicker.toggle()
                    }) {
                        Circle()
                            .fill(Color.black.opacity(0.5))
                            .frame(width: 40, height: 40)
                            .overlay(Image(systemName: "pencil")
                                        .foregroundColor(.white))
                            .offset(x: 40, y: 40)
                    }
                    .buttonStyle(PlainButtonStyle())
                }

                // Name & Username
                Text("Jai Y Chetram")
                    .font(.title2)
                    .fontWeight(.semibold)
                Text("@jaiychetram")
                    .font(.caption)
                    .foregroundColor(.gray)

                // A small progress or stats section
                VStack(alignment: .leading, spacing: 8) {
                    Text("Learning Progress")
                        .font(.headline)
                    ProgressView(value: 0.6)
                        .progressViewStyle(LinearProgressViewStyle(tint: Color.blue))
                    Text("60% Complete")
                        .font(.footnote)
                        .foregroundColor(.gray)
                }
                .padding()

                // Settings / Options List
                Form {
                    Section(header: Text("Account")) {
                        NavigationLink(destination: AccountSettingsView()) {
                            Label("Account Settings", systemImage: "gearshape")
                        }
                        NavigationLink(destination: NotificationsView()) {
                            Label("Notifications", systemImage: "bell")
                        }
                        NavigationLink(destination: PrivacyView()) {
                            Label("Privacy", systemImage: "hand.raised.slash")
                        }
                    }

                    Section {
                        Button(action: {
                            // Handle log out logic
                        }) {
                            Text("Log Out")
                                .foregroundColor(.red)
                        }
                    }
                }
            }
            .padding()
            .navigationTitle("Profile")
            .sheet(isPresented: $showingImagePicker) {
                // Image picker implementation here
                Text("Image Picker Placeholder")
            }
        }
    }
}

// Placeholder Views
struct AccountSettingsView: View {
    var body: some View {
        Text("Account Settings")
            .navigationTitle("Account Settings")
    }
}

struct NotificationsView: View {
    var body: some View {
        Text("Notifications")
            .navigationTitle("Notifications")
    }
}

struct PrivacyView: View {
    var body: some View {
        Text("Privacy")
            .navigationTitle("Privacy")
    }
}



//*********$$$$$$$$$$$$$$$$$$$$$##############

import SwiftUI

struct ProfileView3: View {
    @State private var username: String = "John Doe"
    @State private var bio: String = "iOS Developer and Educator"
    
    var body: some View {
        NavigationView {
            VStack {
                Image(systemName: "person.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white, lineWidth: 4))
                    .shadow(radius: 10)
                
                Text(username)
                    .font(.title)
                    .fontWeight(.bold)
                
                Text(bio)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                Form {
                    Section(header: Text("Settings")) {
                        NavigationLink(destination: Text("Account Details")) {
                            Text("Account Details")
                        }
                        NavigationLink(destination: Text("Privacy Settings")) {
                            Text("Privacy Settings")
                        }
                    }
                }
            }
            .navigationBarTitle("Profile", displayMode: .inline)
        }
    }
}



#Preview("Profile page main") {
    ProfileView()
}

#Preview("set up page") {
    SetUpProfileView()
}

#Preview("Test 2") {
    ProfileView2()
}

#Preview("Test 3") {
    ProfileView3()
}
