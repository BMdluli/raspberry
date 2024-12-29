//
//  Untitled.swift
//  Trezo
//
//  Created by Bekithemba Mdluli on 2024/12/24.
//

import SwiftUI

struct AlertItem: Identifiable {
    let id = UUID()
    let title: Text
    let message: Text
    let dismissButton: Alert.Button
}

struct AlertContext {
    static let exceededContribution = AlertItem(title: Text("Exceeded Contribution"), message: Text("Your contribution cannot exceed your goal amount"), dismissButton: .default(Text("Ok")))
    static let exceededWithdrawContribution = AlertItem(title: Text("Exceeded Contribution"), message: Text("Amount should not exceed total contributions"), dismissButton: .default(Text("Ok")))
}
