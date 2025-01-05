//
//  ModalWithDescription.swift
//  Trezo
//
//  Created by Bekithemba Mdluli on 2024/12/25.
//

import SwiftUI


struct ModalWithDescription<Content: View>: View {
    let title: String
    let actionButtonText: String
    let id: String
    let height: CGFloat
    let contribution: GoalContribution?
    @Binding var showingSheet: Bool
    @ObservedObject var viewModel: GoalViewModel
    @ViewBuilder var middleSection: Content
    
    // Custom initializer
    init(
        title: String,
        actionButtonText: String,
        id: String,
        height: CGFloat,
        contribution: GoalContribution? = nil,
        showingSheet: Binding<Bool>,
        viewModel: GoalViewModel,
        @ViewBuilder middleSection: @escaping () -> Content
    ) {
        self.title = title
        self.actionButtonText = actionButtonText
        self.id = id
        self.height = height
        self.contribution = contribution
        self._showingSheet = showingSheet
        self.viewModel = viewModel
        self.middleSection = middleSection()
    }
    
    var body: some View {
        VStack(spacing: 30) {
            Text(title)
                .font(.system(size: 22, weight: .bold))
                .foregroundStyle(.red)
            
            Divider()
            
            middleSection
            
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
                    if contribution != nil {
                        if actionButtonText == "Add" {
                            viewModel.addContribuution(id: id, contribution: contribution!)
                        } else {
                            viewModel.withdrawContribuution(id: id, contribution: contribution!)
                        }
                    } else {
                        viewModel.deleteGoal(id: id)
                    }
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
        .alert(item: $viewModel.alertItem) { alertItem in
            Alert(title: alertItem.title, message: alertItem.message, dismissButton: alertItem.dismissButton)
        }
        
    }
}


#Preview {
//    ModalWithDescription<<#Content: View#>>()
}
