//
//  GoalsResponse.swift
//  Trezo
//
//  Created by Bekithemba Mdluli on 2024/11/21.
//

import Foundation

// Model for each contribution entry
struct Contribution: Codable {
    let amount: Double
    let date: Date
    let note: String
    
    // Empty initializer
    init(amount: Double = 0.0, date: Date = Date(), note: String = "") {
        self.amount = amount
        self.date = date
        self.note = note
    }
}

// Main model for the goal
struct GoalsResponseRO: Codable {
    let coverImage: String
    let goalName: String
    let goalAmount: Double
    let goalAmountContributed: [Contribution]
    let goalCurrency: String
    let goalDeadline: Date
    let goalNote: String
    let goalColour: String
    let userId: String
    
    // Empty initializer
    init(
        coverImage: String = "",
        goalName: String = "",
        goalAmount: Double = 0.0,
        goalAmountContributed: [Contribution] = [],
        goalCurrency: String = "",
        goalDeadline: Date = Date(),
        goalNote: String = "",
        goalColour: String = "",
        userId: String = ""
    ) {
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
