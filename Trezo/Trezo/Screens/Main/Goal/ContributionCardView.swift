//
//  ContributionCardView.swift
//  Trezo
//
//  Created by Bekithemba Mdluli on 2024/12/25.
//

import SwiftUI

struct ContributionCardView: View {
    let date: Date
    let note: String
    let amount: Double
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 10) {
                Text(date.formatted(.dateTime.month().day().year()))
                Text(note)
            }
            
            Spacer()
            VStack(spacing: 10) {
                Text(String(format: "R %.f", amount))
                Text("Savings")
            }
        }
        .padding()
        .background(Color.treCardBackground)
    }
}


#Preview {
    ContributionCardView(date: Date(), note: "Some Note", amount: 50)
}
