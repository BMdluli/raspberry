//
//  Goal.swift
//  Trezo
//
//  Created by Bekithemba Mdluli on 2024/11/12.
//

import Foundation

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
    let goalAmountContributed: Double
    let goalCurrency: String
    let goalDeadline: Date?
    let goalNote: String?
    let goalColour: String
    let userId: String
}
