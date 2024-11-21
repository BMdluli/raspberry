//
//  UpdateResponse.swift
//  Trezo
//
//  Created by Bekithemba Mdluli on 2024/11/21.
//

struct UpdateResponse: Decodable {
    let status: String
    let data: Data
}

struct Data: Decodable {
    let updatedGoal: Goal
}
