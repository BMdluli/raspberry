//
//  FirebaseGoal.swift
//  Trezo
//
//  Created by Bekithemba Mdluli on 2025/01/04.
//

import Foundation
import FirebaseFirestore



struct FirebaseGoal: Codable {
    @DocumentID var id: String? = nil // Optional: Document ID
    var coverImage: String = ""
    var goalAmount: Double = 0
    var goalAmountContributed: [GoalAmountContributed]?
    var goalColour: String = ""
    var goalCurrency: String = ""
    var goalDeadline: Date = Date() // Default to current date
    var goalName: String = ""
    var goalNote: String = ""
    var isArchived: Bool = false
    var userId: String = ""
}

struct GoalAmountContributed: Codable, Hashable {
    var amount: Double = 0
    var date: Date = Date() // Default to current date
    var note: String = ""
}


