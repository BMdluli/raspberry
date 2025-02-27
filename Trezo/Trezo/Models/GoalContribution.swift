//
//  GoalContribution.swift
//  Trezo
//
//  Created by Bekithemba Mdluli on 2025/01/05.
//

import Foundation

struct GoalContribution: Codable {
    let amount: Double
    let date: Date // Use timestamp in seconds or milliseconds
    let note: String?
    
    // Convert GoalContribution to a Firestore-compatible dictionary
    func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [
            "amount": amount,
            "date": date
        ]
        if let note = note {
            dict["note"] = note
        }
        return dict
    }
}
