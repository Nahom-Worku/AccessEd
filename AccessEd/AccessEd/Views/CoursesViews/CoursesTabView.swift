//
//  CoursesTabView.swift
//  AccessEd
//
//  Created by Nahom Worku on 2024-12-21.
//

import SwiftUI
import SwiftData

struct CoursesTabView: View {
    
    var modelContext: ModelContext
    var course: CourseModel
    
    @State var showAddStudyCard: Bool = false
//    @State var studyCardName: String = ""
//    @FocusState private var isTaskFieldFocused: Bool
    @Environment(\.dismiss) var dismiss
    
    
    var body: some View {
        ZStack {
            List {
                Section(header: Text(course.studyCards.isEmpty ? "" : "Study Cards")) {
                    ForEach(course.distinctStudyCardNames, id: \.self) { cardName in
                        NavigationLink(destination: StudyCardsView(modelContext: modelContext, course: course, studyCardName: cardName) ){ // course: $course/*, cardNumber: 5*/)
                            RoundedRectangle(cornerRadius: 10)
                                .fill(course.courseColor) //Color("StudyCard-Colors"))
                                .padding(.horizontal, 25)
                                .padding(.leading)
                                .frame(width: UIScreen.main.bounds.width, height: 75)
                                .shadow(radius: 1, x: 0, y: 1)
                                .overlay(
                                    HStack {
                                        Image(systemName: "rectangle.fill.on.rectangle.angled.fill")
                                            .resizable()
                                            .frame(width: 40, height: 40)
                                            .foregroundStyle(Color.gray.opacity(0.5)) //Color("StudyCard-Colors"))
                                            .scaledToFit()
                                            .padding(.leading)
                                            .padding(.horizontal, 7)
                                        
                                        Text("\(cardName)")
                                            .font(.subheadline)
                                            .foregroundStyle(Color("Text-Colors"))
                                        
                                        Spacer()
                                        
                                        Image(systemName: "chevron.right")
                                            .padding(.trailing, 5)
                                    }
                                    .padding(.horizontal, 40)
                                )
                        }
                        .listRowBackground(Color("Light-Dark Mode Colors"))
                    }
//                    .onDelete(perform: deleteStudyCardGroup)
                }
                
//                Section(header: Text("Quiz")) {
//                    NavigationLink(destination: QuizView()) {
//                        RoundedRectangle(cornerRadius: 10)
//                            .fill(Color("StudyCard-Colors")) //course.courseColor)
//                            .padding(.horizontal, 30)
//                            .padding(.leading)
//                            .frame(width: UIScreen.main.bounds.width, height: 75)
//                            .shadow(radius: 1, x: 0, y: 1)
//                            .overlay(
//                                HStack {
//                                    Image(systemName: "rectangle.fill.on.rectangle.angled.fill")
//                                        .resizable()
//                                        .frame(width: 40, height: 40)
//                                        .foregroundStyle(Color.gray.opacity(0.5)) //Color("StudyCard-Colors"))
//                                        .scaledToFit()
//                                        .padding()
//                                    
//                                    Text("Quiz")
//                                        .font(.headline)
//                                        .foregroundStyle(Color("Text-Colors"))
//                                    
//                                    Spacer()
//                                    
//                                    Image(systemName: "chevron.right")
//                                }
//                                    .padding(.horizontal, 60)
//                            )
//                    }
//                    .listRowBackground(Color("Light-Dark Mode Colors"))
//                }
                .navigationTitle(course.name)
            }
            .listStyle(InsetGroupedListStyle())
            .scrollContentBackground(.hidden)
            .background(Color("Light-Dark Mode Colors"))
            
            
            if !course.studyCards.isEmpty {
                addCourseButton
            } else {
//                VStack {
//                    Text("Add a study card to get started!")
//                        .font(.headline)
//                    
//                    Button("Add Study Card") {
//                        showAddStudyCard = true
//                    }
//                    .buttonStyle(.borderedProminent)
//                }
                
                VStack(alignment: .center) {
                    Image(systemName: "rectangle.stack.fill")
                        .font(Font.system(size: 60))
                        .padding(5)
                        .foregroundStyle(.gray.opacity(0.8))
                        .fontWeight(.light)
                    
                    Text("No Study Cards")
                        .font(.title2)
                        .bold()
                        .opacity(0.8)
                        .padding(.bottom, 5)
                    
                    Text("Start adding Study Cards to get started!")
                        .font(.subheadline)
                        .foregroundStyle(.gray)
                        .padding(.bottom)
                        .padding(.horizontal, 50)
                        .multilineTextAlignment(.center)
                    
                    
                    Button(action: {
                        showAddStudyCard = true
                    }, label: {
                        Text("Add Study Card")
                            .font(.headline)
                    })
                }
            }
        }
        .sheet(isPresented: $showAddStudyCard) {
            CreateStudyCardsView(modelContext: modelContext, course: course)
        }
    }
    
    var addCourseButton: some View {
        VStack {
            Spacer()
            
            HStack {
                Spacer()
                
                // add courses button
                Button(action: {
//                    showAddCoursesBottomView = true
                    showAddStudyCard = true
                }) {
                    Circle()
                        .fill(Color.blue.opacity(0.8))
                        .frame(width: 50)
                        .shadow(radius: 3)
                        .overlay(
                            Image(systemName: "plus")
                                .font(.headline)
                                .foregroundStyle(.white)
                        )
                        .padding()
                }
                .buttonStyle(PlainButtonStyle())
                .padding(.vertical)
                
            }
//            .padding(.trailing)
        }
    }
    
    
    // TODO: edit study card name function
    
    
    
    // TODO: delete study card

}

//#Preview {
//    CoursesTabView()
//}
