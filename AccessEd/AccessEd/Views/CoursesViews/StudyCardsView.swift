//
//  StudyCardsView.swift
//  AccessEd
//
//  Created by Nahom Worku on 2024-12-21.
//

import SwiftUI

struct Card: Identifiable {
    let id = UUID()
    let question: String
    let answer: String
    var isFlipped: Bool = false
}

struct StudyCardsView: View {
    @Binding var course: CourseModel
    @State private var cards: [Card] = [
        Card(question: "What is the answer to question 1?", answer: "Answer: 10,000"),
        Card(question: "What is the answer to question 2?", answer: "Answer: 20,000")
    ]
    
    var body: some View {
//        ZStack {
        VStack(spacing: 30) {
                ForEach(Array(cards.enumerated()), id: \.element.id) { index, card in
                    ZStack {
                        // Front Side
                        if !card.isFlipped {
                            VStack {
                                Text("Question \(index + 1)")
                                    .font(.title3)
                                    .padding(.vertical)
                                
                                Text(card.question)
                            }
                            .frame(width: 350, height: 200)
                            .background(Color("StudyCard-Colors")) //course.courseColor)
                            .foregroundStyle(Color("Text-Colors"))
                            .cornerRadius(10)
                            .shadow(radius: 1, x: 0, y: 1) // .shadow(radius: 1, x: 1, y: 1)
                        } else {
                            // Back Side
                            VStack {
                                Text("Answer \(index + 1)")
                                    .font(.title3)
                                    .padding(.vertical)
                                
                                Text(card.answer)
                            }
                            .frame(width: 350, height: 200)
                            .rotation3DEffect(.degrees(-180), axis: (x: 0, y: 1, z: 0))
                            .background(Color("StudyCard-Colors"))
                            .cornerRadius(10)
                            .shadow(radius: 1, x: 0, y: 1)
                        }
                    }
                    .rotation3DEffect(
                        .degrees(card.isFlipped ? -180 : 0),
                        axis: (x: 0, y: 1, z: 0)
                    )
                    .animation(.bouncy(duration: 0.6), value: card.isFlipped)
                    .onTapGesture(count: 2) {
                        cards[index].isFlipped.toggle()
                    }
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("Study Cards")
//        }
    }
}


//#Preview {
//    StudyCardsView()
//}
