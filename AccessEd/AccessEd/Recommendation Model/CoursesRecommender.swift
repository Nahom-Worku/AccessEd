//
//  CoursesRecommender.swift
//  AccessEd
//
//  Created by Nahom Worku on 2024-12-14.
//

import Foundation
import CoreML


func CoursesRecommender(userPreferences: [String: Double], excludeList: [String]) -> [String] {
    do {
        // Load the CoursesRecommendationModel
        let model = try CoursesRecommendationModel(configuration: MLModelConfiguration())
        
        // Create an input object for the model
        let input = CoursesRecommendationModelInput(items: userPreferences, k: 15, exclude: excludeList)
        
        // Perform the prediction
        let output = try model.prediction(input: input)
        
        // Return the recommended courses from the model's output
        return output.recommendations
    } catch {
        // Handle any errors during the model prediction
        print("Error using CoursesRecommendationModel: \(error.localizedDescription)")
        return []
    }
}

