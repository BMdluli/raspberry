//
//  GoalCardView.swift
//  Trezo
//
//  Created by Bekithemba Mdluli on 2025/02/22.
//

import SwiftUI


struct GoalCardView: View {
    var goal: FirebaseGoal
    
    
    var body: some View {
        let total = goal.goalAmountContributed.count > 0 ? goal.goalAmountContributed.reduce(0) { $0 + $1.amount } : 0
        
        let percentage = total > 0 ? total / goal.goalAmount : 0
        
        HStack(spacing: 20) {
            
            ZStack {
                Circle()
                    .stroke(.treLightGray, lineWidth: 2)
                
                    .frame(width: 72, height: 72)
                
                Text(goal.coverImage)
                    .font(.system(size: 40))
                .frame(width: 70, height: 70)            }
            
            VStack {
                HStack {
                    Text(goal.goalName)
                        .foregroundStyle(.text)
                        .lineLimit(1)
                        .minimumScaleFactor(0.75)
                    Spacer()
                    Text(String(format: "R%.1f", goal.goalAmount))
                        .foregroundStyle(.text)
                }
                
                ProgressView(value: percentage)
                    .tint(Color(goal.goalColour))
                
                HStack {
                    Text(String(format: "R%.1f", total))
                        .font(.system(size: 14, weight: .light))
                        .foregroundStyle(.text)
                    Spacer()
                    Text(String(format: "R%.1f", goal.goalAmount - total))
                        .font(.system(size: 14, weight: .light))
                        .foregroundStyle(.text)
                }
            }
            
            
        }
        .padding(.all, 8)
        .frame(height: 104)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(.treCardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(.treBackground, lineWidth: 2)
                )
        )
        
        
    }
}


#Preview {
    GoalCardView(goal: FirebaseGoal(id: "DEWIUFGEUFGEUGFUK", coverImage: "🔑", goalAmount: 5000, goalAmountContributed: [], goalColour: "BrandGreen", goalCurrency: "$", goalDeadline: Date.now, goalName: "Temp Goal", goalNote: "", isArchived: false, userId: "SOME USER ID"))
}
