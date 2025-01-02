//
//  OnboardingView.swift
//  AccessEd
//
//  Created by Nahom Worku on 2024-12-31.
//

import SwiftUI

struct OnboardingView: View {
    
    @Environment(\.modelContext) var modelContext
    @StateObject var courseViewModel: CourseViewModel = CourseViewModel()
    @StateObject var profileViewModel: ProfileViewModel = ProfileViewModel()
    
    let transition: AnyTransition = .asymmetric(
        insertion: .move(edge: .trailing),
        removal: .move(edge: .leading))
    
    var body: some View {
        ZStack {
            // content
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
                    addpreferredLanguageSection
                        .transition(transition)
                case 4:
                    addFieldsOfInterestSection
                        .transition(transition)
                default:
                    AccessEdTabView()
                        .transition(.move(edge: .trailing).combined(with: .opacity))
                }
            }
            
            if profileViewModel.onboardingState <= 4 {
                // buttons
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
        }
    }
}

extension OnboardingView {
    
    private var bottomButton: some View {
        Text(profileViewModel.onboardingState == 0 ? "Get Started" :
                profileViewModel.onboardingState == 4 ? "Finish" :
            "Next"
        )
        .font(.system(size: 17, weight: .bold))
        .padding(.horizontal)
        .frame(maxWidth: UIScreen.main.bounds.width, minHeight: 50)
        .foregroundColor(Color("Light-Dark Mode Colors"))
        .background(Color("Text-Colors"))
        .cornerRadius(10)
        .padding(.horizontal, 0)
            .onTapGesture {
                handleNextButtonPressed()
                
                if profileViewModel.onboardingState == 4 {
                    let profile = ProfileModel(name: profileViewModel.name, grade: profileViewModel.grade, preferredLanguage: profileViewModel.preferredLanguage, fieldsOfInterest: profileViewModel.selectedFieldsOfStudy)
                    
                    courseViewModel.modelContext = modelContext
                    courseViewModel.addPredefinedCoursesToInput()
                    courseViewModel.loadUserPreferences()
                    courseViewModel.fetchCourses()
                }
            }
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
    
    private var addpreferredLanguageSection: some View {
        VStack(spacing: 30) {
            Spacer()
            Text("What's your preferred language?")
                .font(.largeTitle)
                .fontWeight(.semibold)
                .foregroundStyle(Color("Text-Colors"))
            
            
            HStack {
                Text("Language: ")
                
                Picker("Select Language", selection: $profileViewModel.preferredLanguage) {
                    ForEach(Languages.allLanguages, id: \.self) { language in
                        Text(language).tag(language)
                    }
                }
                .pickerStyle(MenuPickerStyle())
            }
            
            Spacer()
            Spacer()
        }
        .padding(30)
    }
    
    private var addFieldsOfInterestSection: some View {
        
        VStack(spacing: 20) {
//            Spacer()
            Spacer().frame(height: 80)
            
            Text("What are your fields of interest?")
                .font(.largeTitle)
                .fontWeight(.semibold)
                .foregroundStyle(Color("Text-Colors"))
            
            
//            HStack {
//                Text("Selected: ")
//                    .font(.headline)
//                Text(displaySelectedFieldsOfStudy())
//                    .font(.subheadline)
//            }
//            .padding()
//            .foregroundStyle(Color("Text-Colors"))
                        
            List(FieldsOfStudy.allCases, id: \.self) { field in
                HStack {
                    Text(field.rawValue)
                    Spacer()
                    if profileViewModel.selectedFieldsOfStudy.contains(field) {
                        Image(systemName: "checkmark")
                            .foregroundColor(.blue)
                    }
                }
                .contentShape(Rectangle()) // So tapping anywhere in the row toggles
                .padding(.horizontal)
                .frame(width: UIScreen.main.bounds.width - 100)
                .onTapGesture {
                    if profileViewModel.selectedFieldsOfStudy.contains(field) {
                        profileViewModel.selectedFieldsOfStudy.remove(field)
                    } else {
                        profileViewModel.selectedFieldsOfStudy.insert(field)
                    }
                }
                
                .listRowBackground(Color.gray.opacity(0.1))
//                .listRowSeparatorTint(Color("List-Colors"))
            }
            .scrollDisabled(true)
            .scrollContentBackground(.hidden)
           
            
            
//            Spacer()
            Spacer()
        }
        .padding(20)
    }
    
    func displaySelectedFieldsOfStudy() -> String {
        return profileViewModel.selectedFieldsOfStudy.map { $0.rawValue }.joined(separator: ", ")
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
        case 4:
            guard !profileViewModel.selectedFieldsOfStudy.isEmpty else {
                showAlert(title: "You must select at least one field of interest!")
                return
            }
        default:
            break
        }
        
        
        // GO TO NEXT SECTION
        if profileViewModel.onboardingState == 5 {
            signIn()
        } else {
            withAnimation(.spring()) {
                profileViewModel.onboardingState += 1
            }
        }
    }
    
    func signIn() {
        
        // MARK: - TODO thing here
        // TODO: maybe set isProfileSetUp = true here
        
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
