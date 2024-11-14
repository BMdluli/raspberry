//
//  GoalViewModel.swift
//  Trezo
//
//  Created by Bekithemba Mdluli on 2024/11/13.
//

import Foundation

class GoalViewModel: ObservableObject {
    
    @Published var goals: [Goal] = []
    @Published var isLoading: Bool = false
    
    
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
                    print("Goals updated:", self.goals)
                }
            }
            
            DispatchQueue.main.async {
                self.isLoading = false
            }
            
            
        }
        
    }

}
