//
//  UpdateGoalBody.swift
//  Trezo
//
//  Created by Bekithemba Mdluli on 2024/11/21.
//

import Foundation

struct UpdateGoalBody: Codable {
    let coverImage: String?
    let goalName: String?
    let goalAmount: Double?
    let goalCurrency: String?
    let goalDeadline: Double?
    let goalColour: String?
    let goalNote: String?
}
