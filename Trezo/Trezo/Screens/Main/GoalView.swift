//
//  GoalView.swift
//  Trezo
//
//  Created by Bekithemba Mdluli on 2024/11/17.
//

import SwiftUI

struct GoalView: View {
    @Environment(\.dismiss) var dismiss
    
    var id: String
    @State private var selectedView = 0
    @StateObject private var viewModel = GoalViewModel()
    @State private var showingDeleteSheet = false
    @State private var showingArchiveSheet = false
    @State private var showingEditSheet = false
    
    
    var body: some View {
        let percentage = viewModel.goal.goalAmountContributed / viewModel.goal.goalAmount
        let formatted = viewModel.goal.goalDeadline!.formatted(.dateTime.day().month().year())
        
        
        NavigationStack {
            VStack {
                VStack(spacing: 20) {
                    Picker("Select", selection: $selectedView) {
                        Text("Goal").tag(0)
                        Text("Records").tag(1)
                    }
                    .pickerStyle(.segmented)
                    
                    
                    ScrollView {
                        VStack {
                            
                            VStack(spacing: 30) {
                                
                                ZStack {
                                    CircularProgressView(progress: percentage, colour: viewModel.goal.goalColour)
                                        .frame(width: 230, height: 230)
                                    
                                    Circle()
                                        .stroke(.treLightGray, lineWidth: 2)
                                    
                                        .frame(width: 130, height: 130)
                                    
                                    Image(systemName: "sailboat")
                                        .resizable()
                                        .frame(width: 50, height: 50)
                                    
                                }
                                .padding(.top, 30)
                                
                                Text("\(String(format: "%.f", percentage * 100))%")
                                    .font(.system(size: 26, weight: .bold))
                                
                                
                                VStack {
                                    GoalDetailTitle(text: "Savings")
                                    
                                    HStack(spacing: 20) {
                                        DetailView(amount: viewModel.goal.goalAmountContributed, subTitle: "Saved")
                                        Divider()
                                        DetailView(amount: viewModel.goal.goalAmount - viewModel.goal.goalAmountContributed, subTitle: "Remaining")
                                        Divider()
                                        DetailView(amount: viewModel.goal.goalAmount, subTitle: "Goal")
                                    }
                                    .frame(height: 60)
                                }
                                
                                VStack(alignment: .leading) {
                                    GoalDetailTitle(text: "Note")
                                    
                                    Text(viewModel.goal.goalNote ?? "No Not yet")
                                }
                                
                                VStack(alignment: .leading) {
                                    GoalDetailTitle(text: "Deadline")
                                    
                                    Text(formatted)
                                }
                            }
                            .padding(.all)
                            
                            
                        }
                        .background(.white)
                    }
                    
                    
                    
                    
                }
                .padding(.horizontal, 16)
                .background(.treBackground)
                
                VStack {
                    HStack(spacing: 20) {
                        Button {
                            
                        } label: {
                            Text("Withdraw")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(TreButtonStyle(backgroundColor: .treLightGray, textColor: .primaryPurple))
                        
                        
                        Button {
                            
                        } label: {
                            Text("Add Savings")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(TreButtonStyle(backgroundColor: .primaryPurple, textColor: .white))
                    }
                }
                .background(.white)
                .padding()
            }
            
            
        }
        .navigationTitle(viewModel.goal.goalName)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear() {
            viewModel.fetchGoal(id: id)
        }
        .onChange(of: viewModel.isUpdated) { oldValue, newValue in
            print("onChange triggered: isCreated changed from \(oldValue) to \(newValue)")
            if newValue {
                showingDeleteSheet = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    viewModel.isUpdated = false
                    dismiss()
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Button(action: {
                        showingEditSheet = true
                    }) {
                        Label("Edit", systemImage: "pencil.line")
                    }
                    
                    Button(action: {
                        showingArchiveSheet = true
                    }) {
                        Label("Archive", systemImage: "square.and.arrow.down.on.square")
                    }
                    
                    Button(action: {
                        showingDeleteSheet = true
                    }) {
                        Label("Delete", systemImage: "trash")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                        .imageScale(.large)
                }
            }
        }
        .fullScreenCover(isPresented: $showingEditSheet) {
            EditGoalView(id: id, showModal: $showingEditSheet)
        }
        .sheet(isPresented:$showingDeleteSheet) {
            ModalWithDescription(title: "Delete", actionButtonText: "Yes, Delete", id: id, height: 350, showingSheet: $showingDeleteSheet, viewModel: viewModel, middleSection: {
                Text("Sure you want to delete this goal?")
                    .font(.system(size: 22, weight: .bold))
                
                Text("You will lose all  savings progress. \n This action can not be undone.")
                    .fontWeight(.light)
                    .foregroundStyle(.gray)
            })
        }
        .sheet(isPresented: $showingArchiveSheet){
            ModalWithDescription(title: "Archive", actionButtonText: "Yes, Archive", id: id, height: 290, showingSheet: $showingArchiveSheet, viewModel: viewModel, middleSection: {
                Text("Sure you want to archive this goal?")
                    .font(.system(size: 22, weight: .bold))
            })
        }

    }
}

#Preview {
    NavigationStack {
        GoalView(id: "6739aad1fd11df244f4f1bd8")
    }
}

struct DetailView: View {
    let amount: Double
    let subTitle: String
    
    var body: some View {
        VStack {
            Text(String(format: "R%.f", amount))
                .font(.system(size: 20, weight: .medium))
                .minimumScaleFactor(0.6)
            Text(subTitle)
                .foregroundStyle(.gray)
        }
        
    }
}

struct GoalDetailTitle: View {
    let text: String
    var body: some View {
        HStack {
            Text(text)
            VStack {
                Divider()
            }
        }
    }
}

struct ModalWithDescription<Content: View>: View {
    let title: String
    let actionButtonText: String
    let id: String
    let height: CGFloat
    @Binding var showingSheet: Bool
    @ObservedObject var viewModel: GoalViewModel
    @ViewBuilder var middleSection: Content
    
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
    }
}
