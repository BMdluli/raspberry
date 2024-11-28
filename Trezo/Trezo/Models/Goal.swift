//
//  Goal.swift
//  Trezo
//
//  Created by Bekithemba Mdluli on 2024/11/12.
//

import Foundation

// MARK: - Top-level response
struct GoalsResponse: Decodable {
    let status: String
    let results: Int
    let data: GoalsData
}

struct GoalsData: Decodable {
    let goals: [Goal]
}

// MARK: - Goal model
struct Goal: Decodable {
    let _id: String
    let coverImage: String
    let goalName: String
    let goalAmount: Double
    let goalAmountContributed: [Contribution]
    let goalCurrency: String
    let goalDeadline: Date?
    let goalNote: String?
    let goalColour: String
    let userId: String
    
    
    init(_id: String = "", coverImage: String = "", goalName: String = "", goalAmount: Double = 0.0, goalAmountContributed: [Contribution] = [], goalCurrency: String = "", goalDeadline: Date? = Date(), goalNote: String? = "", goalColour: String = "", userId: String = "") {
        self._id = _id
        self.coverImage = coverImage
        self.goalName = goalName
        self.goalAmount = goalAmount
        self.goalAmountContributed = goalAmountContributed
        self.goalCurrency = goalCurrency
        self.goalDeadline = goalDeadline
        self.goalNote = goalNote
        self.goalColour = goalColour
        self.userId = userId
    }
}
