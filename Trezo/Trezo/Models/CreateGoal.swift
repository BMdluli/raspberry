//
//  Goal.swift
//  Trezo
//
//  Created by Bekithemba Mdluli on 2024/11/12.
//

import Foundation

// MARK: - Goal model
struct CreateGoal: Codable {
    let coverImage: String
    let goalName: String
    let goalAmount: Double
    let goalAmountContributed: Double
    let goalCurrency: String
    let goalDeadline: Double?
    let goalNote: String?
    let goalColour: String
    let userId: String
}
