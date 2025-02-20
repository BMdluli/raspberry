//
//  HomeView.swift
//  Trezo
//
//  Created by Bekithemba Mdluli on 2024/09/14.
//

import SwiftUI

struct HomeView: View {
    @State private var showModal = false
    @State private var showingSettingsModal = false
    
    @StateObject private var viewModel = GoalViewModel()
    @State private var shouldRefresh: Bool = false
    
    var tempGoals: [Goal] = []
    
    let columns = [GridItem(.flexible()),
                   GridItem(.flexible())]
    
    var body: some View {
        
        if viewModel.isLoading {
            LoadingView()
        } else {
            NavigationStack {
                
                VStack {
                    ZStack {
                        
                        // Main content
                        VStack {
                            if viewModel.goals.isEmpty {
                                Spacer()
                                EmptyView(showModal: $showModal)
                                Spacer()
                            } else {
                                ScrollView {
                                    VStack(spacing: 20) {
                                        ForEach(viewModel.goals, id: \.id) { goal in
                                            NavigationLink {
                                                GoalView(id: goal.id ?? "")
                                            } label: {
                                                GoalCardView(goal: goal)
                                                    .foregroundStyle(.black)
                                            }
                                        }
                                    }
                                }
                                .refreshable {
                                    Task {
                                        await viewModel.fetchGoals(archived: false)
                                    }
                                }
                            }
                        }
                        .padding(.top, 16)
                        .background(.treBackground)
                        
                        // Floating Action Button
                        VStack {
                            Spacer()
                            HStack {
                                Spacer()
                                Button {
                                    showModal = true
                                } label: {
                                    Image(systemName: "plus")
                                        .foregroundStyle(.white)
                                        .frame(width: 56, height: 56)
                                        .background(.primaryPurple)
                                        .clipShape(Circle())
                                        .shadow(radius: 5)
                                }
                                .padding(.trailing, 16)
                                .padding(.bottom, 16)
                            }
                        }
                    }
                    
                    .padding(.horizontal)
                    .background(.treBackground)
                    .fullScreenCover(isPresented: $showModal) {
                        CreateGoalView(showModal: $showModal, shouldRefresh: $shouldRefresh)
                    }
                }
                .onAppear() {
                    Task {
                        if !viewModel.allDataFetched {
                            await viewModel.fetchGoals(archived: false)
                        }
                    }
                    print("Home View On Appear called")
                }
                
                .navigationTitle("Raspberry")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Menu {
                            Button(action: {
                                showingSettingsModal = true
                            }) {
                                Label("Settings", systemImage: "gearshape")
                            }
                        } label: {
                            Image(systemName: "switch.2")
                                .foregroundStyle(.treAlertnateBackground)
                        }
                    }
                }
                .fullScreenCover(isPresented: $showingSettingsModal) {
                    ProfileView(showModal: $showingSettingsModal)
                }
            }

            .onChange(of: shouldRefresh, { _, newValue in
                print("Should refresh called")
                if newValue {
                    Task {
                        await viewModel.fetchGoals(archived: false)
                    }
                    viewModel.isCreated = false
                    shouldRefresh = false
                }
            })
            .alert("Error", isPresented: $viewModel.showAlert) {
                Button("OK", role: .cancel) { } // Correct, single button
            } message: {
                Text(viewModel.errorMessage ?? "Unknown error") // Prevents force unwrap
            }
            .navigationBarBackButtonHidden(true)
        }
    }
}

#Preview {
    NavigationStack {
        HomeView()
    }
}

struct EmptyView: View {
    @Binding var showModal: Bool
    
    var body: some View {
        VStack(alignment: .center ,spacing: 20) {
            Image("Target")
                .resizable()
                .scaledToFit()
                .frame(width: 106, height: 106)
            Text("Ready to start saving?")
                .font(.system(size: 20, weight: .bold))
            Text("You haven't set any goals yet.")
                .font(.system(size: 20))
                .foregroundStyle(.gray)
            Button {
                showModal = true
            } label: {
                Label("Create Your First Goal", systemImage: "plus")
                    .foregroundStyle(.white)
            }
            .frame(width: 260, height: 59)
            .background(.primaryPurple)
            .clipShape(RoundedRectangle(cornerRadius: 29))
            .padding(.top, 20)
        }
    }
}

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
