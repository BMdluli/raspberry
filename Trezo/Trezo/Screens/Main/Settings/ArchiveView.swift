//
//  ArchiveView.swift
//  Trezo
//
//  Created by Bekithemba Mdluli on 2025/01/08.
//

import SwiftUI

struct ArchiveView: View {
    @State private var showModal = false
    @State private var showingSettingsModal = false
    
    @StateObject private var viewModel = GoalViewModel()
    @State private var shouldRefresh: Bool = false
    
    var tempGoals: [Goal] = []
    
    let columns = [GridItem(.flexible()),
                   GridItem(.flexible())]
    
    var body: some View {
        VStack {
            // Once loading is complete, either show goals or an empty view
            if viewModel.isLoading {
                LoadingView()
            } else {
                NavigationStack {
                    
                    VStack {
                        
                        // Main content
                        ArchiveGoalsView(viewModel: viewModel, refresh: $shouldRefresh)
                    }
                    
                    .padding(.horizontal)
                    .background(.treBackground)
                    .fullScreenCover(isPresented: $showModal) {
                        CreateGoalView(showModal: $showModal, shouldRefresh: $shouldRefresh)
                    }
                }
                
                .navigationTitle("Archived")
                .navigationBarTitleDisplayMode(.inline)
                .sheet(isPresented: $showingSettingsModal) {
                    ProfileView(showModal: $showingSettingsModal)
                }
                .alert("Error", isPresented: $viewModel.showAlert) {
                    Button("OK", role: .cancel) { } // Correct, single button
                } message: {
                    Text(viewModel.errorMessage ?? "Unknown error") // Prevents force unwrap
                }
                .onChange(of: shouldRefresh, { _, newValue in
                    if newValue {
                        Task {
                            await viewModel.fetchGoals(archived: true)
                        }
                    }
                })
                .onAppear() {
                    Task {
                        if !viewModel.allDataFetched {
                            await viewModel.fetchGoals(archived: true)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    ArchiveView()
}

struct ArchiveGoalsView: View {
    @State var viewModel: GoalViewModel
    @Binding var refresh: Bool
    
    var body: some View {
        VStack {
            if viewModel.goals.isEmpty {
                Text("No Archived Goals")
            } else {
                ScrollView {
                    VStack(spacing: 20) {
                        ForEach(viewModel.goals, id: \.id) { goal in
                            NavigationLink {
                                ArchiveGoalView(shouldRefresh: $refresh, id: goal.id ?? "")
                            } label: {
                                GoalCardView(goal: goal)
                                    .foregroundStyle(.black)
                            }
                        }
                    }
                }
                .refreshable {
                    Task {
                        await viewModel.fetchGoals(archived: true)
                    }
                }
            }
        }
        .padding(.top, 16)
        .background(.treBackground)
    }
}
