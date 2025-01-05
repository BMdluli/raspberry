//
//  UpdateGoalBody.swift
//  Trezo
//
//  Created by Bekithemba Mdluli on 2024/11/21.
//

import Foundation
import FirebaseFirestore

struct UpdateGoalBody: Codable {
    let coverImage: String?
    let goalName: String?
    let goalAmount: Double?
    let goalCurrency: String?
    let goalDeadline: Date?
    let goalColour: String?
    let goalNote: String?
    
    // Convert UpdateGoalBody to a Firestore-compatible dictionary
    func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [:]
        
        if let coverImage = coverImage { dict["coverImage"] = coverImage }
        if let goalName = goalName { dict["goalName"] = goalName }
        if let goalAmount = goalAmount { dict["goalAmount"] = goalAmount }
        if let goalCurrency = goalCurrency { dict["goalCurrency"] = goalCurrency }
        if let goalDeadline = goalDeadline { dict["goalDeadline"] = goalDeadline }
        if let goalColour = goalColour { dict["goalColour"] = goalColour }
        if let goalNote = goalNote { dict["goalNote"] = goalNote }
        
        return dict
    }
}
