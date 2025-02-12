//
//  OnboardingView.swift
//  AccessEd
//
//  Created by Nahom Worku on 2024-12-31.
//

import SwiftUI

struct OnboardingView: View {
    
    @Environment(\.modelContext) var modelContext
    @StateObject var courseViewModel: CourseViewModel
    @StateObject var profileViewModel: ProfileViewModel = ProfileViewModel()
    
    @State private var isMovingForward: Bool = true
    
    var transition: AnyTransition {
        isMovingForward
            ? .asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading))
        : .asymmetric(insertion: .move(edge: .leading), removal: .move(edge: .trailing))
    }
    
    init() {
            let profileViewModel = ProfileViewModel()
            _profileViewModel = StateObject(wrappedValue: profileViewModel)
        _courseViewModel = StateObject(wrappedValue: CourseViewModel(profileViewModel: profileViewModel))
        }
    
    var body: some View {
        ZStack {
            // content
            
            Color("On-boarding-bg-colors").edgesIgnoringSafeArea(.all)
            
            // MARK: - TODO: add a back button here
            backButton
            
            
            
            ZStack {
                switch profileViewModel.onboardingState {
                case 0:
                    WelcomeView()
                        .transition(transition)
                case 1:
                    addNameSection
                        .transition(transition)
                case 2:
                    addGradeSection
                        .transition(transition)
                case 3:
                    addFieldsOfInterestSection
                        .transition(transition)
                case 4:
                    adduserSelectedCourses
                        .transition(transition)
                default:
                    if profileViewModel.isUserSignedIn {
                        AccessEdTabView()
                            .transition(.move(edge: .trailing).combined(with: .opacity))
                    }
                }
            }
            
            // MARK: - TODO: disable button instead of alert
            if profileViewModel.onboardingState <= 4 {
                VStack {
                    Spacer()
                    bottomButton
                    
                    Spacer().frame(height: 75)
                }
                .padding(30)
            }
        }
        .alert(isPresented: $profileViewModel.showAlert, content: {
            return Alert(title: Text(profileViewModel.alertTitle))
        })
        .onAppear{
            profileViewModel.modelContext = modelContext
            profileViewModel.fetchProfile()
            
            courseViewModel.modelContext = modelContext
            courseViewModel.addPredefinedCoursesToInput(predefinedCourses: profileViewModel.profile?.interestedCourses ?? [])
            courseViewModel.loadUserPreferences()
            courseViewModel.fetchCourses()
        }
    }
}

extension OnboardingView {
    
    private var bottomButton: some View {
        Text(profileViewModel.onboardingState == 0 ? "Get Started" :
                profileViewModel.onboardingState == 4 ? "Finish" :
            "Next"
        )
        .font(.system(size: 15, weight: .bold))
        .padding(.horizontal)
        .frame(maxWidth: UIScreen.main.bounds.width, minHeight: 50)
        .foregroundColor(Color("Light-Dark Mode Colors"))
        .background(Color("Text-Colors"))
        .cornerRadius(10)
        .padding(.horizontal, 0)
            .onTapGesture {
                isMovingForward = true
                handleNextButtonPressed()
                        
                
                if profileViewModel.onboardingState > 4 {
                    let profile = ProfileModel(name: profileViewModel.name, grade: profileViewModel.grade, fieldsOfInterest: profileViewModel.fieldsOfInterest, interestedCourses: profileViewModel.interestedCourses)
                    
                    profileViewModel.modelContext = modelContext
                    profileViewModel.setUpProfile(profile: profile)
                    profileViewModel.fetchProfile()
                    
                    
                    courseViewModel.modelContext = modelContext
                    courseViewModel.addPredefinedCoursesToInput(predefinedCourses: profileViewModel.profile?.interestedCourses ?? [])
                    courseViewModel.loadUserPreferences()
                    
                    // add the interested courses in the courses list
                    for course in profileViewModel.profile?.interestedCourses ?? [] {
                        courseViewModel.addCourse(courseName: course, category: CourseCategory.map[course] ?? .other)
                    }
                    
                    courseViewModel.fetchCourses()
                    
                    NotificationManager.shared.requestAuthorization()
                    NotificationManager.shared.notifyProfileSetup(userName: profileViewModel.profile?.name ?? "")

                    withAnimation {
                        profileViewModel.updateStatus()
                    }

                }
            }
    }
    
    private var backButton: some View {
        VStack {
            if profileViewModel.onboardingState > 0 && profileViewModel.onboardingState <= 5 {
                HStack {
                    Button {
                        withAnimation {
                           
                            if profileViewModel.onboardingState > 0 {
                                profileViewModel.onboardingState -= 1
                            }
                            
                            isMovingForward = false
                        }
                    } label: {
                        Image(systemName: "arrow.backward.circle")
                            .font(.largeTitle)
                    }
                    
                    
                    Spacer()
                }
                .padding(.horizontal)
                
                Spacer()
            }
        }
        .padding(.vertical)
    }
    
    private var addNameSection: some View {
        VStack(spacing: 20) {
            Spacer()
            Text("What's your name?")
                .font(.largeTitle)
                .fontWeight(.semibold)
                .foregroundColor(Color("Text-Colors"))
            TextField("Your name here...", text: $profileViewModel.name)
                .font(.headline)
                .frame(height: 50)
                .padding(.horizontal, 20)
                .foregroundColor(Color("Text-Colors"))
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
            Spacer()
            Spacer()
        }
        .padding(30)
    }
    
    private var addGradeSection: some View {
        VStack(spacing: 30) {
            Spacer()
            Text("What grade are you in?")
                .font(.largeTitle)
                .fontWeight(.semibold)
                .foregroundColor(Color("Text-Colors"))
            
            
            HStack {
                Text("Grade: ")
                
                Picker(selection: $profileViewModel.grade,
                       label:
                        Text("Grade: ")
                    .font(.headline)
                    .foregroundStyle(Color("Text-Colors"))
                    .frame(height: 55)
                    .cornerRadius(10)
                       ,
                       content: {
                    Text("9").tag("9")
                    Text("10").tag("10")
                    Text("11").tag("11")
                    Text("12").tag("12")
                })
                .pickerStyle(MenuPickerStyle())
            }
            
            Spacer()
            Spacer()
        }
        .padding(20)
    }
    
    
    private var addFieldsOfInterestSection: some View {
        
        VStack(spacing: 20) {
            Spacer().frame(height: 80)
            
            Text("What are your fields of interest?")
                .font(.largeTitle)
                .fontWeight(.semibold)
                .foregroundStyle(Color("Text-Colors"))
            
                        
            List(FieldsOfStudy.allCases, id: \.self) { field in
                HStack {
                    Text(field.rawValue)
                    Spacer()
                    if profileViewModel.fieldsOfInterest.contains(field.rawValue) {
                        Image(systemName: "checkmark")
                            .foregroundColor(.blue)
                    }
                }
                .contentShape(Rectangle()) // So tapping anywhere in the row toggles
                .padding(.horizontal)
                .frame(width: UIScreen.main.bounds.width - 100)
                .onTapGesture {
                    if profileViewModel.fieldsOfInterest.contains(field.rawValue) {
                        profileViewModel.removeField(field.rawValue)
                    } else {
                        profileViewModel.addField(field.rawValue)
                        profileViewModel.profile?.fieldsOfInterest = profileViewModel.fieldsOfInterest
                    }
                }
                
                .listRowBackground(Color.gray.opacity(0.1))
            }
            .scrollDisabled(true)
            .scrollContentBackground(.hidden)
           
            Spacer()
        }
        .padding(20)
    }
    
    private var adduserSelectedCourses: some View {
        //        GeometryReader { geometry in
        VStack {
            Spacer() // Push content down to start in the middle of the screen
            
            LazyVStack(alignment: .leading, spacing: 15) {
                Text("Select up to 3 courses you're interested in")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color("Text-Colors"))
                    .padding(.horizontal)
                
                // Iterate through the selected fields of interest
                ForEach(profileViewModel.fieldsOfInterest, id: \.self) { field in
                    VStack(alignment: .leading) {
                        Text(field)
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundStyle(Color("Text-Colors"))
                            .padding(.horizontal)
                            .padding(.top, 3)
                        
                        // Horizontal ScrollView for Courses in Each Field
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 15) {
                                if let courses = CourseCategory.coursesByField[field] {
                                    ForEach(courses, id: \.self) { course in
                                        Button(action: {
                                            toggleCourseSelection(course: course)
                                        }) {
                                            HStack {
                                                Text(course)
                                                    .font(.subheadline)
                                                    .foregroundColor(.white)
                                                    .padding()
                                                    .frame(width: 150, height: 30)
                                                    .background(
                                                        profileViewModel.interestedCourses.contains(course)
                                                        ? Color.blue
                                                        : Color.gray.opacity(0.5)
                                                    )
                                                    .cornerRadius(6)
                                            }
                                        }
                                    }
                                } else {
                                    Text("No courses available for \(field)")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                }
            }
            .padding(.horizontal)
            .padding(.vertical, CGFloat(profileViewModel.fieldsOfInterest.count) * 10)
            
            Spacer()
            
            Spacer().frame(height: 120)
        }
    }
    
    // Helper Function to Handle Course Selection
    private func toggleCourseSelection(course: String) {
        if profileViewModel.interestedCourses.contains(course) {
            profileViewModel.removeCourse(course)
        } else if profileViewModel.interestedCourses.count < 3 {
            profileViewModel.addCourse(course)
        }
    }

}


// MARK: - FUNCTIONS

extension OnboardingView {
    
    
    func handleNextButtonPressed() {
        
        // CHECK INPUTS
        switch profileViewModel.onboardingState {
        case 1:
            guard profileViewModel.name.count > 0 else {
                showAlert(title: "Please enter your name before proceeding!")
                return
            }
//        case 3:
//            guard grade < 9 else {
//                showAlert(title: "Please select a grade between 9-12!")
//                return
//            }
        case 3:
            guard !profileViewModel.fieldsOfInterest.isEmpty else {
                showAlert(title: "You must select at least one field of interest!")
                return
            }
        case 4:
            guard profileViewModel.interestedCourses.count >= 1 else {
                showAlert(title: "You must select at least one courses!")
                return
            }
        default:
            break
        }
        
        
        // GO TO NEXT SECTION
        if profileViewModel.onboardingState > 4 {
            
            // MARK: - sign in here maybe
//            signIn()
        } else {
            withAnimation(.easeOut) {
                profileViewModel.onboardingState += 1
            }
        }
    }
    
    func signIn() {
        
        // MARK: - TODO thing here
        // TODO: maybe set isProfileSetUp = true here
        
        let profile = ProfileModel(name: profileViewModel.name, grade: profileViewModel.grade, fieldsOfInterest: profileViewModel.fieldsOfInterest, interestedCourses: profileViewModel.interestedCourses)
        
        profileViewModel.setUpProfile(profile: profile)
        
//        currentUserName = name
//        currentUserAge = Int(age)
//        currentUserGender = gender
//        withAnimation(.spring()) {
//            currentUserSignedIn = true
//        }
    }
    
    func showAlert(title: String) {
        profileViewModel.alertTitle = title
        profileViewModel.showAlert.toggle()
    }
    
    
}

#Preview("Light mode") {
    OnboardingView()
        .preferredColorScheme(.light)
}

#Preview("Dark mode") {
    OnboardingView()
        .preferredColorScheme(.dark)
}
