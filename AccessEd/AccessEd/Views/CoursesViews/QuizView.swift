//
//  QuizView.swift
//  AccessEd
//
//  Created by Nahom Worku on 2025-01-23.
//

import SwiftUI

struct QuizView: View {
    
    var body: some View {
        ScrollView {
            VStack(spacing: 25) {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color("StudyCard-Colors"))
                    .frame(width: UIScreen.main.bounds.width - 70, height: 225)
                    .shadow(radius: 3, x: 0, y: 1)
                    .overlay (
                        VStack {
                            HStack {
                                VStack {
                                    Divider()
                                        .frame(width: 40, height: 5)
                                        .background(Color.green)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                    
                                    Text("Easy")
                                        .font(.subheadline)
                                        .foregroundStyle(Color.green)
                                }
                                
                                Spacer()
                                
                                VStack {
                                    Button(action: {
                                        // TODO: read question out loud functionality
                                        
                                    }) {
                                        Image(systemName: "microphone")
                                            .font(.headline)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                                .padding(.vertical)
                                .padding(.top)
                                
                            }
                            .padding()
                            .padding(.top)
                            .frame(width: UIScreen.main.bounds.width - 90, height: 20, alignment: .leading)
                            
                            // MARK: - TODO: double tap this to show the answer on the back by rotating 180 degrees
                            LazyVStack(alignment: .leading, spacing: 10) {
                                Text("Question #1")
                                    .font(.title3)
                                    .bold(true)
                                
                                Text("What is the capital of France?")
                            }
                            .padding()
                            .padding(.vertical)
                            .frame(width: UIScreen.main.bounds.width - 90, height: 200, alignment: .topLeading)
                        }
                            .frame(width: UIScreen.main.bounds.width - 80, height: 225)
                            .background(Color("StudyCard-Colors"))
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                    )
                
                
                // Question 2
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color("StudyCard-Colors"))
                    .frame(width: UIScreen.main.bounds.width - 70, height: 225)
                    .shadow(radius: 3, x: 0, y: 1)
                    .overlay (
                        VStack {
                            HStack {
                                VStack {
                                    Divider()
                                        .frame(width: 40, height: 5)
                                        .background(Color.yellow)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                    
                                    Text("Medium")
                                        .font(.subheadline)
                                        .foregroundStyle(Color.yellow)
                                }
                                
                                Spacer()
                                
                                VStack {
                                    Button(action: {
                                        // TODO: read question out loud functionality
                                        
                                    }) {
                                        Image(systemName: "microphone")
                                            .font(.headline)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                                .padding(.vertical)
                                .padding(.top)
                                
                            }
                            .padding()
                            .padding(.top)
                            .frame(width: UIScreen.main.bounds.width - 90, height: 20, alignment: .leading)
                            
                            // MARK: - TODO: double tap this to show the answer on the back by rotating 180 degrees
                            LazyVStack(alignment: .leading, spacing: 10) {
                                Text("Question #2")
                                    .font(.title3)
                                    .bold(true)
                                
                                Text("What is the capital of France?")
                            }
                            .padding()
                            .padding(.vertical)
                            .frame(width: UIScreen.main.bounds.width - 90, height: 200, alignment: .topLeading)
                        }
                            .frame(width: UIScreen.main.bounds.width - 80, height: 225)
                            .background(Color("StudyCard-Colors"))
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                    )
                
                // Question 3
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color("StudyCard-Colors"))
                    .frame(width: UIScreen.main.bounds.width - 70, height: 225)
                    .shadow(radius: 3, x: 0, y: 1)
                    .overlay (
                        VStack {
                            HStack {
                                VStack {
                                    Divider()
                                        .frame(width: 40, height: 5)
                                        .background(Color.red)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                    
                                    Text("Hard")
                                        .font(.subheadline)
                                        .foregroundStyle(Color.red)
                                }
                                
                                Spacer()
                                
                                VStack {
                                    Button(action: {
                                        // TODO: read question out loud functionality
                                        
                                    }) {
                                        Image(systemName: "microphone")
                                            .font(.headline)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                                .padding(.vertical)
                                .padding(.top)
                                
                            }
                            .padding()
                            .padding(.top)
                            .frame(width: UIScreen.main.bounds.width - 90, height: 20, alignment: .leading)
                            
                            // MARK: - TODO: double tap this to show the answer on the back by rotating 180 degrees
                            LazyVStack(alignment: .leading, spacing: 10) {
                                Text("Question #3")
                                    .font(.title3)
                                    .bold(true)
                                
                                Text("What is the capital of France?")
                            }
                            .padding()
                            .padding(.vertical)
                            .frame(width: UIScreen.main.bounds.width - 90, height: 200, alignment: .topLeading)
                        }
                            .frame(width: UIScreen.main.bounds.width - 80, height: 225)
                            .background(Color("StudyCard-Colors"))
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                    )
                
            }
            .padding()
            .padding(.vertical, 5)
            .frame(width: UIScreen.main.bounds.width)
            .listRowBackground(Color.clear) //("Light-Dark Mode Colors"))
            .navigationTitle("Quiz")
        }
    }
}

#Preview {
    QuizView()
}
