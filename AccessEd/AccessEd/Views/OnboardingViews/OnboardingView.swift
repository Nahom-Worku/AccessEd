//
//  OnboardingView.swift
//  AccessEd
//
//  Created by Nahom Worku on 2024-12-31.
//

import SwiftUI

struct OnboardingView: View {
    
    @Environment(\.modelContext) var modelContext
    @StateObject var viewModel: CourseViewModel = CourseViewModel()
    
    @State var name: String = ""
    @State var grade: String = "9"
    @State var preferredLanguage: String = "English"
    @State var selectedFieldsOfStudy: Set<FieldsOfStudy> = []
    
    @State var onboardingState: Int = 0
    
    @State var alertTitle: String = ""
    @State var showAlert: Bool = false
    
    let transition: AnyTransition = .asymmetric(
        insertion: .move(edge: .trailing),
        removal: .move(edge: .leading))
    
    var body: some View {
        ZStack {
            // content
            ZStack {
                switch onboardingState {
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
            
            if onboardingState <= 4 {
                // buttons
                VStack {
                    Spacer()
                    bottomButton
                    
                    Spacer().frame(height: 75)
                }
                .padding(30)
            }
        }
        .alert(isPresented: $showAlert, content: {
            return Alert(title: Text(alertTitle))
        })
    }
}

extension OnboardingView {
    
    private var bottomButton: some View {
        Text(onboardingState == 0 ? "Get Started" :
            onboardingState == 4 ? "Finish" :
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
                
                if onboardingState == 4 {
                    viewModel.modelContext = modelContext
                    viewModel.addPredefinedCoursesToInput()
                    viewModel.loadUserPreferences()
                    viewModel.fetchCourses()
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
            TextField("Your name here...", text: $name)
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
                
                Picker(selection: $grade,
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
                
                Picker("Select Language", selection: $preferredLanguage) {
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
                    if selectedFieldsOfStudy.contains(field) {
                        Image(systemName: "checkmark")
                            .foregroundColor(.blue)
                    }
                }
                .contentShape(Rectangle()) // So tapping anywhere in the row toggles
                .padding(.horizontal)
                .frame(width: UIScreen.main.bounds.width - 100)
                .onTapGesture {
                    if selectedFieldsOfStudy.contains(field) {
                        selectedFieldsOfStudy.remove(field)
                    } else {
                        selectedFieldsOfStudy.insert(field)
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
        return selectedFieldsOfStudy.map { $0.rawValue }.joined(separator: ", ")
    }
}


// MARK: - FUNCTIONS

extension OnboardingView {
    
    
    func handleNextButtonPressed() {
        
        // CHECK INPUTS
        switch onboardingState {
        case 1:
            guard name.count >= 1 else {
                showAlert(title: "Please enter your name before proceeding!")
                return
            }
//        case 3:
//            guard grade < 9 else {
//                showAlert(title: "Please select a grade between 9-12!")
//                return
//            }
        case 4:
            guard !selectedFieldsOfStudy.isEmpty else {
                showAlert(title: "You must select at least one field of interest!")
                return
            }
        default:
            break
        }
        
        
        // GO TO NEXT SECTION
        if onboardingState == 5 {
            signIn()
        } else {
            withAnimation(.spring()) {
                onboardingState += 1
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
        alertTitle = title
        showAlert.toggle()
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
