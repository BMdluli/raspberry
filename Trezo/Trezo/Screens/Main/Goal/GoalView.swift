//
//  GoalView.swift
//  Trezo
//
//  Created by Bekithemba Mdluli on 2024/11/17.
//

import SwiftUI

struct GoalView: View {
    @Environment(\.dismiss) var dismiss
    
    //    @Binding var shouldRefreshHome: Bool
    @Binding var shouldRefresh: Bool
    @State var changeOccured: Bool = false
    var id: String
    @State private var selectedView = 0
    @StateObject private var viewModel = GoalViewModel()
    @State private var showingDeleteSheet = false
    @State private var showingArchiveSheet = false
    @State private var showingEditSheet = false
    
    @State private var isShowingSavingsSheet = false
    @State private var isShowingWithdrawSheet = false
    
    
    @State private var note: String = ""
    @State private var amount: String = ""
    @State private var date = Date.now
    
    @State private var shouldRefetch = false
    
    var body: some View {
        
        NavigationStack {
            VStack {
                if viewModel.isLoading {
                    LoadingOverlay()
                } else {
                    VStack {
                        
                        
                        VStack(spacing: 20) {
                            Picker("Select", selection: $selectedView) {
                                Text("Goal").tag(0)
                                Text("Records").tag(1)
                            }
                            .pickerStyle(.segmented)
                            
                            
                            
                            ScrollView {
                                if selectedView == 1
                                {
                                    LazyVStack {
                                        if (viewModel.goal.goalAmountContributed ?? []).count > 0 {
                                            ForEach(viewModel.goal.goalAmountContributed ?? [], id: \.self) { contribution in
                                                ContributionCardView(
                                                    date: contribution.date,
                                                    note: contribution.note,
                                                    amount: contribution.amount
                                                )
                                            }
                                        }                                    }
                                }
                                else {
                                    VStack {
                                        
                                        VStack(spacing: 30) {
                                            
                                            ZStack {
                                                CircularProgressView(
                                                    progress: viewModel.percentage,
                                                    colour: viewModel.goal.goalColour
                                                )
                                                .frame(width: 230, height: 230)
                                                
                                                Circle()
                                                    .stroke(
                                                        .treLightGray,
                                                        lineWidth: 2
                                                    )
                                                
                                                    .frame(width: 130, height: 130)
                                                
                                                Text(viewModel.goal.coverImage)
                                                    .font(.system(size: 50))
                                                    .frame(width: 80, height: 80)
                                                
                                            }
                                            .padding(.top, 30)
                                            
                                            Text(
                                                "\(String(format: "%.f", viewModel.percentage * 100))%"
                                            )
                                            .font(.system(size: 26, weight: .bold))
                                            
                                            
                                            VStack {
                                                GoalDetailTitle(text: "Savings")
                                                
                                                HStack(spacing: 20) {
                                                    DetailView(
                                                        amount: viewModel.amountContributed,
                                                        subTitle: "Saved",
                                                    goalCurrency: viewModel.goal.goalCurrency
                                                    )
                                                    Divider()
                                                    DetailView(
                                                        amount: viewModel.remainingAmount,
                                                        subTitle: "Remaining",
                                                    goalCurrency: viewModel.goal.goalCurrency
                                                        )
                                                    Divider()
                                                    DetailView(
                                                        amount: viewModel.goal.goalAmount,
                                                        subTitle: "Goal",
                                                        goalCurrency: viewModel.goal.goalCurrency
                                                    )
                                                }
                                                .frame(height: 60)
                                            }
                                            
                                            VStack(alignment: .leading) {
                                                GoalDetailTitle(text: "Note")
                                                
                                                Text(viewModel.goal.goalNote)
                                            }
                                            
                                            VStack(alignment: .leading) {
                                                GoalDetailTitle(text: "Deadline")
                                                
                                                Text(viewModel.formatted)
                                            }
                                        }
                                        .padding(.all)
                                        
                                        
                                    }
                                    .background(.treCardBackground)
                                }
                                
                                
                            }
                            
                        }
                        .padding(.horizontal, 16)
                        .background(.treBackground)
                        
                        VStack {
                            HStack(spacing: 20) {
                                Button {
                                    isShowingWithdrawSheet = true
                                } label: {
                                    Text("Withdraw")
                                        .frame(maxWidth: .infinity)
                                }
                                .buttonStyle(
                                    TreButtonStyle(
                                        backgroundColor: .treLightGray,
                                        textColor: .primaryPurple
                                    )
                                )
                                
                                
                                Button {
                                    isShowingSavingsSheet = true
                                } label: {
                                    Text("Add Savings")
                                        .frame(maxWidth: .infinity)
                                }
                                .buttonStyle(
                                    TreButtonStyle(
                                        backgroundColor: .primaryPurple,
                                        textColor: .white
                                    )
                                )
                            }
                        }
                        .padding()
                    }
                }
                
                
                
            }
            .ignoresSafeArea(.keyboard)
            .navigationTitle(viewModel.goal.goalName)
            .navigationBarTitleDisplayMode(.inline)
            
            
            .onChange(of: viewModel.isDeleted) {
                oldValue,
                newValue in
                if newValue {
                    showingDeleteSheet = false
                    changeOccured = true
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        viewModel.isDeleted = false
                        dismiss()
                    }
                    
                }
            }
            
            .onChange(of: viewModel.isUpdated) {
                oldValue,
                newValue in
                if newValue {
                    isShowingSavingsSheet = false
                    isShowingWithdrawSheet = false
                    showingDeleteSheet = false
                    showingArchiveSheet = false
                    amount = ""
                    note = ""
                    date = Date.now
                    changeOccured = true
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        viewModel.isUpdated = false
                        viewModel.fetchGoal(id: id)
                    }
                    
                }
            }
            
            .onChange(of: shouldRefetch) { _, newValue in
                if newValue {
                    viewModel.fetchGoal(id: id)
                    shouldRefetch = false // Reset the flag after fetching
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
                            Label(
                                "Archive",
                                systemImage: "square.and.arrow.down.on.square"
                            )
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
                EditGoalView(
                    id: id,
                    shouldRefetch: $shouldRefetch,
                    viewModel: viewModel,
                    showModal: $showingEditSheet
                )
            }
            
            .sheet(isPresented:$showingDeleteSheet) {
                DeleteModalView(
                    title: "Delete",
                    actionButtonText: "Yes, Delete",
                    id: id,
                    height: 350,
                    showingSheet: $showingDeleteSheet,
                    viewModel: viewModel
                )
            }
            
            .sheet(isPresented: $showingArchiveSheet){
                ArchiveModalView(title: "Archive", actionButtonText: "Yes, Archive", id: id, height: 290, archive: true, showingSheet: $showingArchiveSheet, viewModel: viewModel)
            }
            
            .sheet(isPresented: $isShowingSavingsSheet) {
                ModalWithDescription(
                    title: "Add Savings",
                    actionButtonText: "Add",
                    id: id,
                    height: 500,
                    contribution: GoalContribution(
                        amount: Double(amount) ?? 0,
                        date: date,
                        note: note
                    ),
                    showingSheet: $isShowingSavingsSheet,
                    viewModel: viewModel, remainingAmount: viewModel.remainingAmount ,
                    
                    middleSection: {
                        
                        TextFieldWithLabel(
                            text: $amount,
                            title: "Goal Amount",
                            placeholder: "10.000"
                        )
                        .keyboardType(.numberPad)
                        .ignoresSafeArea(.keyboard, edges: .bottom)
                        
                        
                        DatePicker("Deadline (Optional)",
                                   selection: $date, displayedComponents: .date)
                        .frame(height: 56)
                        
                        TextFieldWithLabel(
                            text: $note,
                            title: "Note Optional",
                            placeholder: "Add your note."
                        )
                        .ignoresSafeArea(.keyboard, edges: .bottom)
                    })
                
            }
            
            .sheet(isPresented: $isShowingWithdrawSheet) {
                let convertedDouble = Double(amount) ?? 0
                
                ModalWithDescription(
                    title: "Withdraw",
                    actionButtonText: "Withdraw",
                    id: id,
                    height: 500,
                    contribution: GoalContribution(
                        amount: -convertedDouble,
                        date: date,
                        note: note
                    ),
                    showingSheet: $isShowingWithdrawSheet,
                    viewModel: viewModel ,
                    amountContributed: viewModel.amountContributed,
                    middleSection: {
                        
                        TextFieldWithLabel(
                            text: $amount,
                            title: "Amount",
                            placeholder: "10.000"
                        )
                        .keyboardType(.numberPad)
                        
                        
                        DatePicker("Date",
                                   selection: $date, displayedComponents: .date)
                        .frame(height: 56)
                        
                        TextFieldWithLabel(
                            text: $note,
                            title: "Note Optional",
                            placeholder: "Add your note."
                        )
                    })
                .ignoresSafeArea(.keyboard)
                
            }
            .onAppear() {
                viewModel.fetchGoal(id: id)
            }
            .onDisappear() {
                if changeOccured {
                    shouldRefresh = true
                }
                    
            }
            
        }
    }
    
}

struct DetailView: View {
    let amount: Double
    let subTitle: String
    let goalCurrency: String
    
    var body: some View {
        VStack {
            Text(String(format: "\(goalCurrency)%.f", amount))
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


struct LoadingOverlay: View {
    var body: some View {
        ZStack {
            Color.black.opacity(0.5)
                .edgesIgnoringSafeArea(.all)
            
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                .scaleEffect(1.5)
        }
    }
}




#Preview {
    @Previewable @State var refresh = false
    NavigationStack {
        GoalView(shouldRefresh: $refresh, id: "4v6crbEehgoA9jARop3v")
    }
}
