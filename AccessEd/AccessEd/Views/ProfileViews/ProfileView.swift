//
//  ProfileView.swift
//  AccessEd
//
//  Created by Nahom Worku on 2024-11-03.
//

import SwiftUI
import SwiftData

//MARK: - Set up profile View
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
                            ForEach(Languages.allLanguages, id: \.self) { language in
                                Text(language).tag(language)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                    }
                    
                    QuestionView(question: "What are your fields of interest in education?") {
                        MultiSelectList(title: "Fields of Interest", items: FieldsOfStudy.allFields, selectedItems: $fieldsOfInterest)
                    }
                    
                    
                    
                    
                    Button {
                        
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

// MARK: - question view
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

// MARK:- multi selct List
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
                            ForEach(Languages.allLanguages, id: \.self) { language in
                                Text(language).tag(language)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                    }
                    
//                    QuestionView(question: "What are your fields of interest in education?") {
//                        MultiSelectList(title: "Fields of Interest", items: FieldsOfStudy.allFields, selectedItems: $profile.fieldsOfInterest)
//                    }
                    
                    
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


// MARK: - design 2 :- current desgin

struct ProfileView: View {
    @Environment(\.modelContext) var modelContext
    @ObservedObject var courseViewModel: CourseViewModel
    @ObservedObject var profileViewModel: ProfileViewModel
    @State private var isInterestedCoursesExpanded: Bool = false
    @State private var isFieldsOfInterestExpanded: Bool = false
    @State private var showDeleteConfirmation: Bool = false
    @State private var showingImagePicker: Bool = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                
                // Settings / Options List
                Form {
                    // MARK: - update profile pic frame
                    HStack(spacing: 30) {
                        Spacer()
                        
                        ZStack {
                            profileViewModel.profilePicture
                                .resizable()
                                .fontWeight(.thin)
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 100, height: 100)
                                .clipShape(Circle())
                                .shadow(radius: 2)
                            
                            Button(action: {
                                showingImagePicker.toggle()
                            }) {
                                Circle()
                                    .fill(Color.black.opacity(0.5))
                                    .frame(width: 30, height: 30)
                                    .overlay(Image(systemName: "pencil")
                                        .foregroundColor(.white))
                                    .offset(x: 40, y: 40)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                        .padding(.vertical)
                        
                        
                        VStack(alignment: .center, spacing: 10) {
                            Text(profileViewModel.profile?.name ?? "")
                                .font(.title2)
                                .fontWeight(.semibold)
                            
                            Text("Grade: \(profileViewModel.profile?.grade ?? "")")
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.8))
                        }
                        
                        Spacer()
                            .frame(width: UIScreen.main.bounds.width * 0.15)
                    }
//                    .padding(.horizontal, 50)
                    .frame(width: UIScreen.main.bounds.width - 50, alignment: .leading)
                    .background(
                        RoundedRectangle(cornerRadius: 25)
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color(#colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 0.5140987169)), Color(#colorLiteral(red: 0.2279692888, green: 0.9256613255, blue: 0.9985740781, alpha: 1))]),
                                    startPoint: .bottomTrailing,
                                    endPoint: .topLeading)
                            )
                            .padding(.horizontal, 30)
                            .frame(width: UIScreen.main.bounds.width, height: 150)
                    )
                    .listRowBackground(Color("List-Colors"))
                    .listRowSeparatorTint(Color("List-Colors"))
                    
                    
                    Section(header: Text("Account")) {
                        NavigationLink(destination: AchievementsView()) {
                            Label("Achievements", systemImage:  "medal") //"trophy")
                        }
                        
                        HStack {
                            Label("Notifications", systemImage: "bell")
                            
                            Spacer()
                            
                            Toggle("", isOn: Binding(
                                get: { profileViewModel.profile?.isNotificationsOn ?? false },
                                set: { newNotificationSetting in
                                    profileViewModel.updateNotificationsSettings(isOn: newNotificationSetting)
                                    print(newNotificationSetting)
                                }
                            ))
                            .labelsHidden()
                            .scaleEffect(0.75)
                        }
                        
                    }
                    
                    Section(header: Text("Your Preferences")) {
                        DisclosureGroup(
                            isExpanded: $isInterestedCoursesExpanded,
                            content: {
                                if let interestedCourses = profileViewModel.profile?.interestedCourses {
                                    ForEach(interestedCourses, id: \.self) { course in
                                        Text(course)
                                            .padding(.leading, 50)
                                    }
                                } else {
                                    Text("No courses added yet.")
                                        .foregroundColor(.gray)
                                }
                            },
                            label: {
                                HStack(spacing: 18) {
                                    Image(systemName: "books.vertical")
                                        .foregroundColor(.blue)
                                    Text("Courses")
                                }
                                .padding(.leading, 3)
                            }
                        )
                        
                        
                        DisclosureGroup(
                            isExpanded: $isFieldsOfInterestExpanded,
                            content: {
                                if let fieldsOfInterest = profileViewModel.profile?.fieldsOfInterest {
                                    ForEach(fieldsOfInterest, id: \.self) { field in
                                        Text(field)
                                            .padding(.leading, 50)
                                    }
                                } else {
                                    Text("No fields of interest added yet.")
                                        .foregroundColor(.gray)
                                }
                            },
                            label: {
                                HStack(spacing: 22) {
                                    Image(systemName: "lightbulb")
                                        .foregroundColor(.blue)
                                    Text("Fields of Interest")
                                }
                                .padding(.leading, 8)
                            }
                        )
                    }
                    
                    Section(header: Text("About")) {
                        // MARK: - TODO: about app page
                        NavigationLink(destination: AppInfoView()) {
                            Label("About the App", systemImage: "info.circle")
                        }
                    }
                    
                    
                    HStack {
                        Spacer()
                        
                        Button(action: {
                            showDeleteConfirmation = true
                        }) {
                            Text("Delete Profile")
                                .foregroundColor(.red)
                        }
                        
                        Spacer()
                    }
                    .frame(width: UIScreen.main.bounds.width)
                }
                .scrollContentBackground(.hidden)
                .frame(width: UIScreen.main.bounds.width)
                
            }
            .padding()
            .navigationTitle("Profile")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        withAnimation(.spring()) {
                            //MARK: - TODO: edit profile page
                            
                        }
                    }, label: {
                        Text("Edit")
                    })
                }
            }
            .sheet(isPresented: $showingImagePicker) {
                ProfilePicturePickerView(showPickerSheet: $showingImagePicker, profileViewModel: profileViewModel)
            }
        }
        .onAppear{
            profileViewModel.modelContext = modelContext
            courseViewModel.modelContext = modelContext
            profileViewModel.fetchProfile()
            courseViewModel.fetchCourses()
        }
        .confirmationDialog("Delete Profile", isPresented: $showDeleteConfirmation) {
            Button("Delete", role: .destructive) {
                profileViewModel.deleteProfile()
                profileViewModel.profile?.interestedCourses.removeAll()
                courseViewModel.deleteAllCourses()
                courseViewModel.clearAllRecommendedCourses()
                courseViewModel.clearUserPreferences()
                courseViewModel.resetUserPreferences()
                courseViewModel.fetchCourses()
                profileViewModel.fetchProfile()
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Are you sure you want to delete your profile? This action cannot be undone.")
        }
    }
}



// Placeholder Views
struct AchievementsView: View {
    var body: some View {
        Text("Achievements view - placehoder")
            .navigationTitle("Achievements")
    }
}

struct AppInfoView: View {
    var body: some View {
        Text("About the App - Placeholder")
            .navigationTitle("About the App")
    }
}


#Preview("set up page") {
    SetUpProfileView()
}

#Preview("profile view") {
    let profileViewModel = ProfileViewModel()
    let courseViewModel = CourseViewModel(profileViewModel: profileViewModel)
    ProfileView(courseViewModel: courseViewModel, profileViewModel: profileViewModel)
}

