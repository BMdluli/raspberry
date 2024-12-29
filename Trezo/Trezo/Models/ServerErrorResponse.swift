//
//  ServerErrorResponse.swift
//  Trezo
//
//  Created by Bekithemba Mdluli on 2024/12/24.
//

import Foundation

struct ServerErrorResponse: Decodable {
    let status: String
    let message: String
}

enum ErrorMessage: Error {
    case invalidData
    case unableToComplete
    case custom(String) // To handle custom server messages
}
