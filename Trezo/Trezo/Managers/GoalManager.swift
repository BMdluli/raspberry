//
//  GoalManager.swift
//  Trezo
//
//  Created by Bekithemba Mdluli on 2024/11/12.
//

import Foundation


enum ErrorMessage: String {
    case invalidUsername = "This username created an invalid request. Please try again."
    case unableToComplete = "unable to complete your request. Please check your internet connection"
    case invalidResponse = "Invalid response from the server. Please try again"
    case invalidData = "The data recieved from the server was invalid. Please try again."
}


class GoalManager {
    
    static let shared = GoalManager()
    let baseUrl = ""
    private init() {}
    
    
    func getGoals(completed: @escaping ([Goal]?, ErrorMessage?) -> Void) {
        print("called")
        let urlString = "http://localhost:3000/api/v1/goals"
        
        guard let url = URL(string: urlString) else {
            completed(nil, .invalidData)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            // Handle error first
            if let error = error {
                completed(nil, .invalidData)
                return
            }
            
            // Check response status code
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(nil, .unableToComplete)
                return
            }
            
            // Check that data exists
            guard let data = data else {
                completed(nil, .invalidData)
                return
            }
            
            // Decode JSON data
            do {
                let decoder = JSONDecoder()
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                dateFormatter.timeZone = TimeZone(secondsFromGMT: 0) // Ensure it interprets the 'Z' as UTC
                decoder.dateDecodingStrategy = .formatted(dateFormatter)
                
                let goalsResponse = try decoder.decode(GoalsResponse.self, from: data)
//                print(goalsResponse.data.goals)
                completed(goalsResponse.data.goals, nil)
            } catch {
                print("Decoding error: \(error)")
            }
        }
        
        task.resume()
    }

}
