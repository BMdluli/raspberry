//
//  ArchiveModalView.swift
//  Trezo
//
//  Created by Bekithemba Mdluli on 2025/02/20.
//

import SwiftUI

struct ArchiveModalView: View  {
    let title: String
    let actionButtonText: String
    let id: String
    let height: CGFloat
    let archive: Bool?
    @Binding var showingSheet: Bool
    @ObservedObject var viewModel: GoalViewModel

    
    var body: some View {
        VStack(spacing: 30) {
            Text(title)
                .font(.system(size: 22, weight: .bold))
            
            Divider()
            
            Text("Sure you want to archive this goal?")
                .font(.system(size: 22, weight: .bold))
            
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
                        viewModel.archieveGoal(id: id, isArchieved: archive ?? false)
                } label: {
                    Text(actionButtonText)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(TreButtonStyle(backgroundColor: .primaryPurple, textColor: .white))
                .disabled(viewModel.isLoading)
            }
        }
        .padding()
        .presentationDetents([.height(height)])
        .presentationDragIndicator(.visible)
        // LOOK INTO
        
        .alert("Error", isPresented: $viewModel.showAlert) {
            Button("OK", role: .cancel) { } // Correct, single button
        } message: {
            Text(viewModel.errorMessage ?? "Unknown error") // Prevents force unwrap
        }
    }
}

#Preview {
//    ArchiveModalView()
}
