//
//  ProfileView.swift
//  AccessEd
//
//  Created by Nahom Worku on 2024-11-03.
//

import SwiftUI
import SwiftData

struct EditProfileView: View {
    var body: some View {
        VStack {
            Text("Edit Profile view")
        }
    }
}


// MARK: - ProfileView

struct ProfileView: View {
    @Environment(\.modelContext) var modelContext
    @ObservedObject var courseViewModel: CourseViewModel
    @ObservedObject var profileViewModel: ProfileViewModel
    @ObservedObject var calendarViewModel: CalendarViewModel
    @State private var isInterestedCoursesExpanded: Bool = false
    @State private var isFieldsOfInterestExpanded: Bool = false
    @State private var showDeleteConfirmation: Bool = false
    @State private var showingImagePicker: Bool = false
    @State private var showEditProfileView: Bool = false
    @State private var showProfileDeletedAlert: Bool = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                
                // Settings / Options List
                Form {
                    // MARK: - update profile pic frame
                    HStack(spacing: 40) {
                        
                        ZStack {
                            profileViewModel.profilePicture
                                .resizable()
                                .fontWeight(.ultraLight)
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
                                .foregroundStyle(Color("Text-Colors"))
                            
                            Text("Grade: \(profileViewModel.profile?.grade ?? "")")
                                .font(.subheadline)
                                .foregroundStyle(Color("Text-Colors"))
                        }
                        
                    }
                    .padding(.leading, 30)
                    .padding(.horizontal, 50)
                    .frame(width: UIScreen.main.bounds.width, alignment: .leading)
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
                            showEditProfileView = true
                        }
                    }, label: {
                        Text("Edit")
                    })
                }
            }
            .sheet(isPresented: $showingImagePicker) {
                ProfilePicturePickerView(showPickerSheet: $showingImagePicker, profileViewModel: profileViewModel)
            }
            .sheet(isPresented: $showEditProfileView) {
                EditProfileView()
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
                calendarViewModel.DeleteAllTasks()
                courseViewModel.fetchCourses()
                profileViewModel.fetchProfile()
                
                showProfileDeletedAlert = true
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Are you sure you want to delete your profile? This action cannot be undone.")
        }
        .alert(isPresented: $showProfileDeletedAlert, content: {
            Alert(title: Text("Profile Deleted"), message: Text("Close the app and reopen it to setup your profile again."), dismissButton: .cancel())
        })
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


#Preview("Edit Profile view") {
    EditProfileView()
}

#Preview("profile view") {
    let profileViewModel = ProfileViewModel()
    let courseViewModel = CourseViewModel(profileViewModel: profileViewModel)
    let calendarViewModel = CalendarViewModel()
    ProfileView(courseViewModel: courseViewModel, profileViewModel: profileViewModel, calendarViewModel: calendarViewModel)
}

