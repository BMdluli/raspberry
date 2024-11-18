//
//  GoalViewModel.swift
//  Trezo
//
//  Created by Bekithemba Mdluli on 2024/11/13.
//

import Foundation

class GoalViewModel: ObservableObject {
    
    @Published var goals: [Goal] = []
    @Published var goal: Goal = Goal()
    @Published var isLoading: Bool = false
    @Published var isCreated: Bool = false
    
    
    
    func fetchGoals() {
        DispatchQueue.main.async {
            self.isLoading = true
        }
        GoalManager.shared.getGoals { [weak self] response, error in
            guard let self = self else { return }

            if let error = error {
                print("Error fetching goals: \(error)")
                return
            }

            // Successfully received response
            if let response = response {
                // Ensure UI updates happen on the main thread
                DispatchQueue.main.async {
                    self.goals = response
//                    print("Goals updated:", self.goals)
                }
            }
            
            DispatchQueue.main.async {
                self.isLoading = false
            }
            
            
        }
        
    }
    
    func fetchGoal(id: String) {
        DispatchQueue.main.async {
            self.isLoading = true
        }
        
        GoalManager.shared.getGoal(id: id) { [weak self] response, error in
            guard let self = self else { return }

            if let error = error {
                print("Error fetching goals: \(error)")
                return
            }

            // Successfully received response
            if let response = response {
                // Ensure UI updates happen on the main thread
                DispatchQueue.main.async {
                    self.goal = response
//                    print("Goals updated:", self.goals)
//                    print(response)
                }
            }
            
            DispatchQueue.main.async {
                self.isLoading = false
            }
            
        }
    }
    
    
    func createNewGoal(goal: CreateGoal) {
        
        if let validationError = goal.validate() {
            print("Validation Error: \(validationError)")
            return
        }
        
        GoalManager.shared.createGoal(newGoal: goal) { [weak self] response, error in
            guard let self = self else {
                return
            }
            
            if let error = error {
                print("Error creating goal: \(error)")
                return
            }
            
                
            if let response = response {
                DispatchQueue.main.async {
                    self.isCreated = true
                    print("Goal created successfully. isCreated set to \(self.isCreated)")
                }
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
