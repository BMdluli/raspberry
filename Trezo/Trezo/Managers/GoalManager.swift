//
//  GoalManager.swift
//  Trezo
//
//  Created by Bekithemba Mdluli on 2024/11/12.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore


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
    private let urlString = "https://trezo.onrender.com/api/v1/goals"
    
    func fetchGoals(completion: @escaping ([FirebaseGoal]?, Error?) -> Void) {
        // Reference to Firestore
        let db = Firestore.firestore()
        let userID = Auth.auth().currentUser?.uid ?? ""
        
        print("Current user \(userID)")
        
        db.collection("goals").whereField("userId", isEqualTo: userID).getDocuments { (snapshot, error) in
            if let error = error {
                // Handle error
                completion(nil, error)
                return
            }
            
            guard let documents = snapshot?.documents else {
                completion(nil, nil) // No documents found
                return
            }
            
            // Map the documents to your Goal model
            let goals = documents.compactMap { doc -> FirebaseGoal? in
                do {
                    // Try decoding each document into the Goal model
                    return try doc.data(as: FirebaseGoal.self)
                } catch {
                    print("Error decoding document: \(error)")
                    return nil
                }
            }
            
            // Pass the array of goals to the completion handler
            completion(goals, nil)
        }
    }
    
    func fetchGoal(by id: String, completion: @escaping (FirebaseGoal?, Error?) -> Void) {
        // Reference to Firestore
        let db = Firestore.firestore()
        
        // Access the specific document in the "goals" collection
        db.collection("goals").document(id).getDocument { (document, error) in
            if let error = error {
                // Handle any errors
                completion(nil, error)
                return
            }
            
            guard let document = document, document.exists else {
                // Document not found
                completion(nil, nil)
                return
            }
            
            do {
                // Decode the document into the Goal model
                let goal = try document.data(as: FirebaseGoal.self)
                completion(goal, nil)
            } catch {
                // Handle decoding errors
                completion(nil, error)
            }
        }
    }
    
    func createGoal(goal: FirebaseGoal, completion: @escaping (Error?) -> Void) {
        // Reference to Firestore
        let db = Firestore.firestore()
        
        do {
            // Add the goal to the "goals" collection
            try db.collection("goals").addDocument(from: goal) { error in
                if let error = error {
                    // Handle any errors during the write
                    completion(error)
                } else {
                    // Success
                    completion(nil)
                }
            }
        } catch {
            // Handle encoding errors
            completion(error)
        }
    }
    
    
    func updateGoal(documentId: String, goalBody: UpdateGoalBody, completion: @escaping (Result<Void, Error>) -> Void) {
        let db = Firestore.firestore()
        let docRef = db.collection("goals").document(documentId)
        
        // Convert the model to a Firestore-compatible dictionary
        let updatedData = goalBody.toDictionary()
        
        // Update the document
        docRef.updateData(updatedData) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    
    
    
    func deleteGoal(by id: String, completion: @escaping (Error?) -> Void) {
        // Reference to Firestore
        let db = Firestore.firestore()
        
        // Access the specific document in the "goals" collection
        db.collection("goals").document(id).delete { error in
            if let error = error {
                // Handle any errors during deletion
                completion(error)
            } else {
                // Successfully deleted the document
                completion(nil)
            }
        }
    }
    
    
    func addGoalContribution(id: String, contribution: GoalContribution, completion: @escaping (Result<Void, Error>) -> Void) {
        let db = Firestore.firestore()
        let goalRef = db.collection("goals").document(id)
        
        // Add the contribution to the contributions array
        goalRef.updateData([
            "goalAmountContributed": FieldValue.arrayUnion([contribution.toDictionary()])
        ]) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    

}
