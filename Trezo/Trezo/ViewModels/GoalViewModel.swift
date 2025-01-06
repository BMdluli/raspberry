//
//  GoalViewModel.swift
//  Trezo
//
//  Created by Bekithemba Mdluli on 2024/11/13.
//

import Foundation
import FirebaseFirestore

class GoalViewModel: ObservableObject {
    
    @Published var goals: [FirebaseGoal] = []
    @Published var goal: FirebaseGoal = FirebaseGoal()
    @Published var isLoading: Bool = false
    @Published var isUpdated: Bool = false
    @Published var isDeleted: Bool = false
    @Published var alertItem: AlertItem? // For handling alerts
    
    private var db = Firestore.firestore()
    
    func fetchGoals() {
        GoalManager.shared.fetchGoals { goals, error in
            if let error = error {
                print("Error fetching goals: \(error)")
            } else if let goals = goals {
                self.goals = goals
            } else {
                print("No goals found.")
            }
        }
        
    }
    
    
    func fetchGoal(id: String) {
        print("id \(id)")
        self.isLoading = true
        
        
        GoalManager.shared.fetchGoal(by: id) { goal, error in
            if let error = error {
                print("Error fetching goal: \(error)")
                self.isLoading = false
            } else if let goal = goal {
                self.goal = goal
                self.isLoading = false
            } else {
                print("Goal not found.")
                self.isLoading = false
            }
        }
        
        
    }
    
    
    func createNewGoal(goal: FirebaseGoal) {
        
        GoalManager.shared.createGoal(goal: goal) { error in
            if let error = error {
                print("Error creating goal: \(error)")
            } else {
                print("Goal successfully created!")
                self.isUpdated = true
            }
        }
        
    }
    
    func updateGoal(id: String, updateGoal: UpdateGoalBody) {
        
        GoalManager.shared.updateGoal(documentId: id, goalBody: updateGoal) { result in
            switch result {
            case .success:
                print("Goal updated successfully!")
                self.isUpdated = true
            case .failure(let error):
                print("Error updating goal: \(error.localizedDescription)")
            }
        }
    }
    
    func deleteGoal(id: String) {
        GoalManager.shared.deleteGoal(by: id) { error in
            if let error = error {
                print("Error deleting goal: \(error)")
            } else {
                print("Goal successfully deleted!")
                DispatchQueue.main.async {
                    self.isDeleted = true
                }
            }
        }
    }
    
    func addContribuution(id: String, contribution: GoalContribution) {
        
        GoalManager.shared.addGoalContribution(id: id, contribution: contribution) { result in
            switch result {
            case .success:
                print("Contribution appended successfully!")
                self.isUpdated = true
            case .failure(let error):
                print("Error appending contribution: \(error.localizedDescription)")
            }
        }
    }
    
    
    
    
    func withdrawContribuution(id: String, contribution: GoalContribution) {
        
        GoalManager.shared.addGoalContribution(id: id, contribution: contribution) { result in
            switch result {
            case .success:
                print("Contribution appended successfully!")
                self.isUpdated = true
            case .failure(let error):
                print("Error appending contribution: \(error.localizedDescription)")
            }
        }
        
        
    }
}

extension CreateGoal {
    func validate() -> String? {
        if coverImage.isEmpty {
            return "Cover image is required."
        }
        if goalName.isEmpty {
            return "Goal name is required."
        }
        if goalAmount <= 0 {
            return "Goal amount must be greater than zero."
        }
        if goalCurrency.isEmpty {
            return "Currency is required."
        }
        if goalColour.isEmpty {
            return "Colour is required."
        }
        if userId.isEmpty {
            return "User ID is required."
        }
        return nil // Validation passed
    }
}

