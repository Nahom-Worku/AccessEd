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
                    
                    
//                    // Learning Style
//                    Picker("Learning Style", selection: $profile.learningStyle) {
//                        Text("Visual").tag("Visual")
//                        Text("Auditory").tag("Auditory")
//                        Text("Hands-On").tag("Hands-On")
//                    }
//
//                    // Study Hours
//                    Picker("Study Hours", selection: $profile.studyHours) {
//                        Text("Morning").tag("Morning")
//                        Text("Afternoon").tag("Afternoon")
//                        Text("Evening").tag("Evening")
//                    }
//
//                    // Time Zone
//                    Picker("Time Zone", selection: $profile.timeZone) {
//                        ForEach(TimeZone.knownTimeZoneIdentifiers, id: \.self) { timeZone in
//                            Text(timeZone).tag(timeZone)
//                        }
//                    }
                    
                    
                    Button {
//                        let profile = ProfileModel(name: name, grade: grade, preferredLanguage: preferredLanguage, fieldsOfInterest: fieldsOfInterest)
                        
//                        context.insert(profile)
//                        try? context.save()
                        
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


// MARK: - design 2

struct ProfileView2: View {
    @State private var showingImagePicker = false
    @State private var profileImage: Image? = Image("Profile pic")

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                
                // Profile Image & Edit Button
                ZStack {
                    
                    if let image = profileImage {
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                            .shadow(radius: 2)
                    }
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

                // Name & Username
                Text("John Doe")
                    .font(.title2)
                    .fontWeight(.semibold)
                Text("@jaiychetram")
                    .font(.caption)
                    .foregroundColor(.gray)

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
                    
                    .listRowBackground(Color("List-Colors"))
                    .listRowSeparatorTint(Color("List-Colors"))
                }
                .scrollDisabled(true)
                .scrollContentBackground(.hidden)
                .padding(.vertical)
                .frame(width: UIScreen.main.bounds.width)

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


#Preview("set up page") {
    SetUpProfileView()
}

#Preview("Test 2") {
    ProfileView2()
}


// MARK: - 4th (current )design

struct ProfileView: View {
    @Environment(\.modelContext) var modelContext
    @StateObject var profileViewModel: ProfileViewModel = ProfileViewModel()
    @StateObject var courseViewModel: CourseViewModel = CourseViewModel()
    @State var profile: ProfileModel?
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .top) {
                
                // 1) The “wave” / angled background
                WaveShape()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [Color(#colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)), Color(#colorLiteral(red: 0, green: 0.9914394021, blue: 1, alpha: 1))]),
                            startPoint: .top,
                            endPoint: .bottom)
                    )
                    .frame(height: 220)
                
                // 2) Main content
                VStack(alignment: .leading, spacing: 16) {
                    
                    // 2a) Profile image & name
                    HStack {
                        Spacer()
                        
                        // Circle Avatar
                        ZStack {
                            Circle()
                                .fill(Color.white)
                                .frame(width: 100, height: 100)
                            Image("Profile pic") // replace w/ real image
                                .resizable()
                                .scaledToFill()
                                .clipShape(Circle())
                                .frame(width: 90, height: 90)
                        }
                        .offset(y: 50) // 40 // bumps it down so it “overlaps” the wave shape
                    }
                    .padding(.trailing, 16)
                    .frame(width: UIScreen.main.bounds.width - 50)
                    
                    // 2b) Name text (placed under wave)
                    Text("Nahom Worku")
                        .font(.title2)
                        .fontWeight(.semibold)
//                        .padding(.top, 25)
                        .padding()
                    
                    // 2c) Profile details below
                    VStack(alignment: .leading, spacing: 24) {
                        ProfileRowView(icon: "graduationcap.fill", text: "My School")
                        ProfileRowView(icon: "book.closed.fill",   text: "CS")
                        ProfileRowView(icon: "person.fill",         text: "My Mentor")
                        ProfileRowView(icon: "phone.fill",          text: "### - #### - ####")
                        
                        if let name  = profileViewModel.profile?.name {
                            Text("Name: \(name)")
                        }
                        
                        if let grade = profileViewModel.profile?.grade {
                            Text("Grade: \(grade)")
                        }
                        
                        if let preferredLanguage = profileViewModel.profile?.preferredLanguage {
                            Text("Preferred Language: \(preferredLanguage)")
                        }
                        
                        HStack(spacing: 10) {
                            
                            Text("Fields of Interest: ")
                            
                            VStack(alignment: .leading, spacing: 8) {
                                if let fieldsOfInterest = profileViewModel.profile?.fieldsOfInterest,
                                   !fieldsOfInterest.isEmpty {
                                    
                                    ForEach(fieldsOfInterest, id: \.self) { field in
                                        Text(field)
                                    }
                                }
                            }
                        }
                        
                        
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
                    .background(Color("Light-Dark Mode Colors"))
                    
                    
                    Button("Delete profile") {
                        profileViewModel.deleteProfile()
                        courseViewModel.clearUserPreferences()
                    }
                    
                    Spacer()
                }
                .padding(.top, 80) // ensures content starts below wave
                .padding(.horizontal)
            }
            .ignoresSafeArea(edges: .top)
            .navigationTitle("Profile")
        }
        .onAppear{
            profileViewModel.modelContext = modelContext
            courseViewModel.fetchCourses()
            profileViewModel.fetchProfile()
        }
    }
}

// MARK: - Wave Shape
struct WaveShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        // Start at top-left
        path.move(to: .zero)
        // Down some portion
        path.addLine(to: CGPoint(x: 0, y: rect.height * 0.75)) // - , 0.65
        
        // Curve across to top-right
        path.addQuadCurve(
            to: CGPoint(x: rect.width * 0.7, y: rect.height * 0.9), // 0.4, 0.9
            control: CGPoint(x: rect.width * 0.4, y: rect.height * 0.75) // 0.2, 0.8
        )
        path.addQuadCurve(
            to: CGPoint(x: rect.width, y: rect.height * 0.6), // 0.6
            control: CGPoint(x: rect.width * 0.9, y: rect.height * 0.95) // 0.8, 1.0
        )
        
        // Finally, straight up to top-right
        path.addLine(to: CGPoint(x: rect.width, y: 0))
        
        // Close
        path.closeSubpath()
        return path
    }
}

// MARK: - Row View (icon + text)
struct ProfileRowView: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .foregroundColor(.blue)
            Text(text)
                .foregroundColor(.black)
            Spacer()
        }
    }
}


// MARK: - Preview
struct ProfilePageView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
