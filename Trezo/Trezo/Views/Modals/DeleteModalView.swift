//
//  DeleteModalView.swift
//  Trezo
//
//  Created by Bekithemba Mdluli on 2025/02/20.
//

import SwiftUI

struct DeleteModalView: View {
    let title: String
    let actionButtonText: String
    let id: String
    let height: CGFloat
    @Binding var showingSheet: Bool
    @ObservedObject var viewModel: GoalViewModel
    
    // Custom initializer
    init(
        title: String,
        actionButtonText: String,
        id: String,
        height: CGFloat,
        showingSheet: Binding<Bool>,
        viewModel: GoalViewModel
    ) {
        self.title = title
        self.actionButtonText = actionButtonText
        self.id = id
        self.height = height
        self._showingSheet = showingSheet
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack(spacing: 30) {
            Text(title)
                .font(.system(size: 22, weight: .bold))
                .foregroundStyle(.red)
            
            Divider()
            
            Text("Sure you want to delete this goal?")
                .font(.system(size: 22, weight: .bold))
            
            Text(
                "You will lose all  savings progress. \n This action can not be undone."
            )
            .fontWeight(.light)
            .foregroundStyle(.gray)
            
            Divider()
            
            HStack(spacing: 20) {
                Button {
                    showingSheet = false
                } label: {
                    Text("Cancel")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(TreButtonStyle(backgroundColor: .treLightGray, textColor: .primaryPurple))
                
                Button {
                        viewModel.deleteGoal(id: id)
                } label: {
                    Text(actionButtonText)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(TreButtonStyle(backgroundColor: .primaryPurple, textColor: .white))
            }
        }
        .padding()
        .presentationDetents([.height(height)])
        .presentationDragIndicator(.visible)
        
        .alert("Error", isPresented: $viewModel.showAlert) {
            Button("OK", role: .cancel) { } // Correct, single button
        } message: {
            Text(viewModel.errorMessage ?? "Unknown error") // Prevents force unwrap
        }
    }
}

#Preview {
//    DeleteModalView()
}
