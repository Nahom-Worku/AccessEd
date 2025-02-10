//
//  TextProcessor.swift
//  AccessEd
//
//  Created by Nahom Worku on 2025-02-04.
//

import Foundation
import NaturalLanguage
import CoreML

class StudyCardsGenerator {
    private var tagger: NLTagger
    private let model: NLModel?

    init() {
        tagger = NLTagger(tagSchemes: [.lexicalClass])
        if let wordTaggingModel = try? NLModel(mlModel: MyWordTagger_Model().model) {
            self.model = wordTaggingModel
        } else {
            self.model = nil
            print("⚠️ Failed to load ML model!")
        }
    }

    func processText(_ text: String) -> [(word: String, tag: String)] {
        var results: [(String, String)] = []
        tagger.string = text

        tagger.enumerateTags(in: text.startIndex..<text.endIndex, unit: .word, scheme: .lexicalClass, options: [.omitWhitespace, .omitPunctuation]) { tag, tokenRange in
            let word = String(text[tokenRange])
            let predictedTag = model?.predictedLabel(for: word) ?? tag?.rawValue ?? ""
            results.append((word, predictedTag))
            return true
        }
        return results
    }

    func extractProperNounsWithIndices(from text: String) -> [(word: String, index: Int)] {
        let processedTokens = processText(text)
        var properNounsWithIndices: [(String, Int)] = []

        for (index, (word, tag)) in processedTokens.enumerated() {
            if tag == "PROPN" {
                properNounsWithIndices.append((word, index))
            }
        }
        return properNounsWithIndices
    }

    private func combineProperNouns(indices: [(String, Int)]) -> String {
        return indices.sorted(by: { $0.1 < $1.1 }).map { $0.0 }.joined(separator: " ")
    }

    func generateQuestionAndAnswer(from text: String) -> (question: String, answer: String)? {
        let processedTokens = processText(text)
        var question = text
        var answer = ""
        
        // Collect all replaceable candidates (proper nouns, numbers, etc.)
        var replaceableTokens: [(word: String, tag: String)] = []
        for (index, (word, tag)) in processedTokens.enumerated() {
            // Handle hyphenated words as single tokens
            if word.contains("-") {
                replaceableTokens.append((word, tag))
                continue
            }
            
            if tag == "NUM" || tag == "PROPN" || tag == "NOUN" || word == "°C" || word.lowercased() == "january" || word.lowercased() == "february" || word.lowercased() == "march" || word.lowercased() == "april" || word.lowercased() == "may" || word.lowercased() == "june" || word.lowercased() == "july" || word.lowercased() == "august" || word.lowercased() == "september" || word.lowercased() == "october" || word.lowercased() == "november" || word.lowercased() == "december" || word.allSatisfy({ $0.isNumber }) {
                // Check if adjacent words are proper nouns and group them together
                if tag == "PROPN" && index + 1 < processedTokens.count && processedTokens[index + 1].1 == "PROPN" {
                    let combinedWord = word + " " + processedTokens[index + 1].0
                    replaceableTokens.append((combinedWord, "PROPN"))
                } else {
                    replaceableTokens.append((word, tag))
                }
            }
        }
        
        // Randomly pick one token to replace, if any exist
        if let tokenToReplace = replaceableTokens.randomElement() {
            if tokenToReplace.word == "°C" {
                if let numIndex = processedTokens.firstIndex(where: { $0.1 == "NUM" }) {
                    let numWord = processedTokens[numIndex].0
                    let fullUnit = numWord + tokenToReplace.word
                    
                    if Bool.random() {
                        question = question.replacingOccurrences(of: fullUnit, with: "______")
                        answer = fullUnit
                    } else {
                        question = question.replacingOccurrences(of: numWord, with: "______")
                        answer = numWord
                    }
                } else {
                    question = question.replacingOccurrences(of: tokenToReplace.word, with: "______")
                    answer = tokenToReplace.word
                }
            } else if tokenToReplace.word.contains("-") {
                question = question.replacingOccurrences(of: tokenToReplace.word, with: "______")
                answer = tokenToReplace.word
            } else if tokenToReplace.tag == "PROPN" && tokenToReplace.word.contains(" ") {
                question = question.replacingOccurrences(of: tokenToReplace.word, with: "______")
                answer = tokenToReplace.word
            } else {
                question = question.replacingOccurrences(of: tokenToReplace.word, with: "______")
                answer = tokenToReplace.word
            }
        }
        
        return refineQuestion(question: question, answer: answer)
    }
    
    func refineQuestion(question: String, answer: String) -> (String, String)? {
        let words = question.split(separator: " ")  // Split the question into words
        
        // Check if the first word is a blank
        let isFirstWordBlank = words.first?.contains("______") ?? false
        
        // Check if the answer starts with an uppercase letter
        let isAnswerUppercased = answer.first?.isUppercase ?? false
        
        // Validation conditions
        if isFirstWordBlank {
            // If the first word is blank, the answer **must** be capitalized
            if isAnswerUppercased {
                return (question, answer)
            } else {
                return nil // Discard the question
            }
        } else if question.contains("______") && words.count > 2 {
            // If blank is somewhere else in the sentence, accept it
            return (question, answer)
        }
        
        return nil // Discard all other cases
    }

    
    func generateQuestionsAndAnswers(from paragraph: String) -> [(question: String, answer: String)] {
        let sentences = paragraph.components(separatedBy: ".")
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty }

        var previousContext: String? // To store the context from the previous sentence
        var results: [(question: String, answer: String)] = []

        for sentence in sentences {
            let properNounsWithIndices = extractProperNounsWithIndices(from: sentence)
            let fullProperNoun = combineProperNouns(indices: properNounsWithIndices)

            // Log current sentence being processed
            print("🔹 Processing sentence: \(sentence)")

            if let firstWord = sentence.split(separator: " ").first, ["This", "It", "These"].contains(String(firstWord)) {
                if let previousContext = previousContext {
                    let modifiedSentence = sentence.replacingOccurrences(of: String(firstWord), with: "______")
                    let generatedQA = (modifiedSentence + ".", previousContext)

                    // ✅ Validation: Ensure that if first word is blank, answer starts with uppercase
                    if isValidQuestion(generatedQA.0, answer: generatedQA.1) {
                        print("✅ Valid (Context-Based) Q&A: \(generatedQA)")
                        results.append(generatedQA)
                    } else {
                        print("❌ Discarded Q&A (Invalid Format): \(generatedQA)")
                    }
                    continue
                } else {
                    print("❌ Discarded (No Context for 'It', 'This', 'These'): \(sentence)")
                }
            } else {
                // Generate a question and answer for the current sentence
                if let result = generateQuestionAndAnswer(from: sentence) {
                    // ✅ Ensure question validity before adding it to results
                    if isValidQuestion(result.0, answer: result.1) {
                        print("✅ Valid Q&A: \(result)")
                        results.append(result)
                    } else {
                        print("❌ Discarded Q&A (Invalid Format): \(result)")
                    }
                } else {
                    print("❌ Discarded Q&A: \(sentence)")
                }
                
                if !fullProperNoun.isEmpty {
                    previousContext = fullProperNoun
                }
            }
        }
        
        print("📌 Final Q&A Output: \(results.count) questions generated")
        return results
    }

    func isValidQuestion(_ question: String, answer: String) -> Bool {
        let words = question.split(separator: " ")  // Split question into words
        
        // Check if the first word is blank (______).
        let isFirstWordBlank = words.first?.contains("______") ?? false
        
        // Check if the answer starts with an uppercase letter.
        let isAnswerUppercased = answer.first?.isUppercase ?? false

        // ✅ Validation Logic:
        if isFirstWordBlank {
            return isAnswerUppercased // If first word is blank, answer **must** be capitalized.
        } else if question.contains("______") && words.count > 2 && answer.count > 0 {
            return true // If blank is anywhere else, accept it.
        }
        
        return false // ❌ Discard any invalid cases.
    }

}

