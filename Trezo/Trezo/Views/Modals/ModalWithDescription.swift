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
    let remainingAmount: Double?
    let amountContributed: Double
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
        archive: Bool? = false,
        remainingAmount: Double = 0,
        amountContributed: Double = 0,
        @ViewBuilder middleSection: @escaping () -> Content
    ) {
        self.title = title
        self.actionButtonText = actionButtonText
        self.id = id
        self.height = height
        self.contribution = contribution
        self._showingSheet = showingSheet
        self.viewModel = viewModel
        self.remainingAmount = remainingAmount
        self.amountContributed = amountContributed
        self.middleSection = middleSection()
    }
    
    var body: some View {
        VStack {
            ScrollView {
                VStack(spacing: 10) {
                    Text(title)
                        .font(.system(size: 22, weight: .bold))
                    
                    Divider()
                    
                    middleSection
                    
                    Spacer()
                    
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
                            if actionButtonText == "Add" {
                                viewModel.addContribution(id: id, contribution: contribution!, remainingAmount: remainingAmount!)
                            } else {
                                viewModel.withdrawContribution(id: id, contribution: contribution!, totalContributions: amountContributed)
                            }
                        } label: {
                            Text(actionButtonText)
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(TreButtonStyle(backgroundColor: .primaryPurple, textColor: .white))
                        .disabled(viewModel.isLoading)
                    }
                }
            }
            .scrollDismissesKeyboard(.interactively) // Allows scrolling to dismiss the keyboard
        }
        .padding()
        .presentationDetents([.height(height)])
        .presentationDragIndicator(.visible)
        .ignoresSafeArea(.keyboard, edges: .bottom) // Prevents keyboard from pushing up
        .interactiveDismissDisabled() // Prevents sheet from being dismissed unintentionally
        
        .alert("Error", isPresented: $viewModel.showAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(viewModel.errorMessage ?? "Unknown error")
        }
    }
}


#Preview {
    //    ModalWithDescription<<#Content: View#>>()
}
