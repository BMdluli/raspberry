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
    @Published var isCreated: Bool = false
    @Published var allDataFetched: Bool = false
    @Published var alertItem: AlertItem? // For handling alerts
    @Published var errorMessage: String? = nil
    @Published var showAlert: Bool = false
    @Published var refresh: Bool = false
    
    private var db = Firestore.firestore()
    
    func fetchGoals(archived: Bool) async {
        DispatchQueue.main.async {
            self.isLoading = true
            self.allDataFetched = false
        }
        
        
        do {
            
            let goals = try await GoalManager.shared.fetchGoals(archived: archived)
            DispatchQueue.main.async {
                self.goals = goals
            }
        } catch {
            DispatchQueue.main.async {
                self.showAlert = true
                self.errorMessage = error.localizedDescription
            }
        }
        
        
        DispatchQueue.main.async {
            self.isLoading = false
            self.allDataFetched = true
        }
    }

    
    
    func fetchGoal(id: String) {
        print("id \(id)")
        self.isLoading = true
        
        
        GoalManager.shared.fetchGoal(by: id) { goal, error in
            if let error = error {
                self.showAlert = true
                self.errorMessage = error.localizedDescription
                
                self.isLoading = false
            } else if let goal = goal {
                self.goal = goal
                self.isLoading = false
            } else {
                self.showAlert = true
                self.errorMessage = "Goal not found"
                self.isLoading = false
            }
        }
        
        
    }
    
    
    func createNewGoal(goal: FirebaseGoal) {
        
        
        
        GoalManager.shared.createGoal(goal: goal) { error in
            DispatchQueue.main.async {
                self.isLoading = true
                if let error = error {
                    self.showAlert = true
                    self.errorMessage = error.localizedDescription
                    self.isLoading = false
                } else {
                    print("Goal successfully created!")
                    self.isCreated = true
                    self.isLoading = false
                }
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
                self.showAlert = true
                self.errorMessage = error.localizedDescription
            }
        }
    }
    
    func deleteGoal(id: String) {
        GoalManager.shared.deleteGoal(by: id) { error in
            if let error = error {
                DispatchQueue.main.async {
                    self.showAlert = true
                    self.errorMessage = error.localizedDescription
                }
            } else {
                print("Goal successfully deleted!")
                DispatchQueue.main.async {
                    self.isDeleted = true
                }
            }
        }
    }
    
    func addContribution(id: String, contribution: GoalContribution, remainingAmount: Double) {
        
        if contribution.amount > remainingAmount {
            DispatchQueue.main.async {
                self.showAlert = true
                self.errorMessage = "You can not exceed your contributions"
            }
            return
        }
        
        
        GoalManager.shared.addGoalContribution(id: id, contribution: contribution) { result in
            switch result {
            case .success:
                print("Contribution appended successfully!")
                self.isUpdated = true
            case .failure(let error):
                DispatchQueue.main.async {
                    self.showAlert = true
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    
    
    
    func withdrawContribution(id: String, contribution: GoalContribution, totalContributions: Double) {
        print("Withdraw called")
        
        if totalContributions - abs(contribution.amount) < 0 {
            print("Check called")
            
            DispatchQueue.main.async {
                self.showAlert = true
                self.errorMessage = "You can not withdraw more than you've contributed"
            }
            return
        }
        
        GoalManager.shared.addGoalContribution(id: id, contribution: contribution) { result in
            switch result {
            case .success:
                print("Contribution appended successfully!")
                self.isUpdated = true
            case .failure(let error):
                DispatchQueue.main.async {
                    self.showAlert = true
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func archieveGoal(id: String, isArchieved: Bool) {
        self.isLoading = true
        
        
        GoalManager.shared.archieveGoal(id: id, isArchieved: isArchieved) { result in
            
            switch result {
            case.success:
                self.isUpdated = true
                
            case .failure(let error):
                DispatchQueue.main.async {
                    self.showAlert = true
                    self.errorMessage = error.localizedDescription
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

