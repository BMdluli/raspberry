//
//  CreatedGoal.swift
//  Trezo
//
//  Created by Bekithemba Mdluli on 2024/11/17.
//

import Foundation

// Root Response
struct CreatedGoalResponse: Decodable {
    let status: String
    let data: GoalData
}

struct GoalData: Decodable {
    let newGoal: NewGoal
}

struct NewGoal: Decodable {
    let coverImage: String
    let goalName: String
    let goalAmount: Double
    let goalAmountContributed: Double
    let goalCurrency: String
    let goalDeadline: String
    let goalNote: String
    let goalColour: String
    let userId: String
    let _id: String
}

