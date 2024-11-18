//
//  GoalResponse.swift
//  Trezo
//
//  Created by Bekithemba Mdluli on 2024/11/17.
//

import Foundation

struct GoalResponse: Decodable {
    let status: String
    let data: Goal
}

struct GoalResponseData: Codable {
    let _id: String
    let coverImage: String
    let goalName: String
    let goalAmount: Int
    let goalAmountContributed: Int
    let goalCurrency: String
    let goalDeadline: Date
    let goalNote: String
    let goalColour: String
    let userId: String
}
