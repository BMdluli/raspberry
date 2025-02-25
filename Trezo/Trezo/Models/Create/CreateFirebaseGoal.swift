//
//  CreateFirebaseGoal.swift
//  Trezo
//
//  Created by Bekithemba Mdluli on 2025/02/25.
//

import Foundation
import FirebaseFirestore



struct CreateFirebaseGoal: Codable {
    @DocumentID var id: String? = nil // Optional: Document ID
    var coverImage: String = ""
    var goalAmount: Double = 0
    var goalColour: String = ""
    var goalCurrency: String = ""
    var goalDeadline: Date = Date() // Default to current date
    var goalName: String = ""
    var goalNote: String = ""
    var isArchived: Bool = false
    var userId: String = ""
}
