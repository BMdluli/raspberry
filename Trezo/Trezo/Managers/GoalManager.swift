//
//  GoalManager.swift
//  Trezo
//
//  Created by Bekithemba Mdluli on 2024/11/12.
//

import Foundation
import FirebaseAuth


//enum Errors: Error {
//    case invalidUsername = "This username created an invalid request. Please try again."
//    case unableToComplete = "unable to complete your request. Please check your internet connection"
//    case invalidResponse = "Invalid response from the server. Please try again"
//    case invalidData = "The data recieved from the server was invalid. Please try again."
//}


class GoalManager {
    
    static let shared = GoalManager()
    let baseUrl = ""
    private init() {}
    private let urlString = "http://localhost:3000/api/v1/goals"
    
    func getGoals(completed: @escaping ([Goal]?, ErrorMessage?) -> Void) {
        
        guard let url = URL(string: urlString) else {
            completed(nil, .invalidData)
            return
        }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        request.setValue(Auth.auth().currentUser?.uid, forHTTPHeaderField: "Authorisation")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            // Handle error first
            if let _ = error {
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
    
    func getGoal(id: String, completed: @escaping (Goal?, ErrorMessage?) -> Void) {
        
        let goalUrl = urlString + "/\(id)"
        
        guard let url = URL(string: goalUrl) else {
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
                
                let goal = try decoder.decode(GoalResponse.self, from: data)
                //                print(goalsResponse.data.goals)
                completed(goal.data, nil)
                print("GETTING ONE GOAL", goal)
            } catch {
                print("Decoding error: \(error)")
            }
        }
        
        task.resume()
    }
    
    func createGoal(newGoal: CreateGoal ,completed: @escaping (String?, ErrorMessage?) -> Void) {
        guard let url = URL(string: urlString) else {
            completed(nil, .invalidData)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        guard let httpBody = try? JSONEncoder().encode(newGoal) else {
            print("Failed to encode data")
            completed(nil, .invalidData)
            return
        }
        request.httpBody = httpBody
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error making request:", error)
                completed(nil, .invalidData)
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(nil, .unableToComplete)
                return
            }
            
            guard let data = data else {
                completed(nil, .invalidData)
                return
            }
            
            completed("Goal Created Successfully", nil)
            
        }.resume()
        
        
    }
    
    
    func UpdateGoal(id: String ,updatedGoal: UpdateGoalBody ,completed: @escaping (Goal?, ErrorMessage?) -> Void) {
        let updateUrl = urlString + "/\(id)"
        
        guard let url = URL(string: updateUrl) else {
            completed(nil, .invalidData)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        guard let httpBody = try? JSONEncoder().encode(updatedGoal) else {
            print("Failed to encode data")
            completed(nil, .invalidData)
            return
        }
        request.httpBody = httpBody
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error making request:", error)
                completed(nil, .invalidData)
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(nil, .unableToComplete)
                return
            }
            
            guard let data = data else {
                completed(nil, .invalidData)
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                dateFormatter.timeZone = TimeZone(secondsFromGMT: 0) // Ensure it interprets the 'Z' as UTC
                decoder.dateDecodingStrategy = .formatted(dateFormatter)
                
                let goalResponse = try decoder.decode(UpdateResponse.self, from: data)
                completed(goalResponse.data.updatedGoal, nil)
            } catch {
                print("Decoding error: \(error)")
            }
            
        }.resume()
        
        
    }
    
    
    
    
    func deleteGoal(id: String, completed: @escaping (String?, ErrorMessage?) -> Void) {
        let deleteUrl = urlString + "/\(id)"
        
        guard let url = URL(string: deleteUrl) else {
            completed(nil, .invalidData)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error making request:", error)
                completed(nil, .invalidData)
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 204 else {
                completed(nil, .unableToComplete)
                return
            }
            
            guard let _ = data else {
                completed(nil, .invalidData)
                return
            }
            
            completed("Deleted", nil)
            
        }.resume()
        
        
    }
    
    func addContribution(id: String, contribution: AddContribution, completed: @escaping (Result<String, ErrorMessage>) -> Void) {
        let addContributionUrl = urlString + "/\(id)/" + "contributions"
        
        guard let url = URL(string: addContributionUrl) else {
            completed(.failure(.invalidData))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        guard let httpBody = try? JSONEncoder().encode(contribution) else {
            print("Failed to encode data")
            completed(.failure(.invalidData))
            return
        }
        request.httpBody = httpBody
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error making request:", error)
                completed(.failure(.invalidData))
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                completed(.failure(.unableToComplete))
                return
            }
            
            if response.statusCode == 201 {
                completed(.success("Contribution added"))
            } else if let data = data {
                do {
                    // Parse the server's error response
                    if let errorResponse = try? JSONDecoder().decode(ServerErrorResponse.self, from: data) {
                        completed(.failure(.custom(errorResponse.message)))
                    } else {
                        completed(.failure(.invalidData))
                    }
                }
            } else {
                completed(.failure(.unableToComplete))
            }
        }.resume()
    }
    func withdrawContribution(id: String, contribution: AddContribution, completed: @escaping (Result<String, ErrorMessage>) -> Void) {
        let addContributionUrl = urlString + "/\(id)/" + "contributions/withdraw"
        
        guard let url = URL(string: addContributionUrl) else {
            completed(.failure(.invalidData))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        guard let httpBody = try? JSONEncoder().encode(contribution) else {
            print("Failed to encode data")
            completed(.failure(.invalidData))
            return
        }
        request.httpBody = httpBody
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error making request:", error)
                completed(.failure(.invalidData))
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                completed(.failure(.unableToComplete))
                return
            }
            
            if response.statusCode == 201 {
                completed(.success("Contribution withdrawn"))
            } else if let data = data {
                // Attempt to parse the server's error response
                if let errorResponse = try? JSONDecoder().decode(ServerErrorResponse.self, from: data) {
                    completed(.failure(.custom(errorResponse.message)))
                } else {
                    completed(.failure(.invalidData))
                }
            } else {
                completed(.failure(.unableToComplete))
            }
        }.resume()
    }

}
