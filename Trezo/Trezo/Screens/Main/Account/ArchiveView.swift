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
    
    var tempGoals: [Goal] = []
    
    let columns = [GridItem(.flexible()),
                   GridItem(.flexible())]
    
    var body: some View {
        
        // Once loading is complete, either show goals or an empty view
        if viewModel.isLoading {
            LoadingView()
        } else {
            NavigationStack {
                
                VStack {
                        
                        // Main content
                        VStack {
                            if viewModel.goals.isEmpty {
                                Spacer()
                                Text("No Archived Goals")
                                Spacer()
                            } else {
                                ScrollView {
                                    VStack(spacing: 20) {
                                        ForEach(viewModel.goals, id: \.id) { goal in
                                            NavigationLink {
                                                ArchiveGoalView(id: goal.id ?? "")
                                            } label: {
                                                GoalCardView(goal: goal)
                                                    .foregroundStyle(.black)
                                            }
                                        }
                                    }
                                }
                                .refreshable {
                                    viewModel.fetchGoals(archived: true)
                                }
                            }
                        }
                        .padding(.top, 16)
                        .background(.treBackground)
                    }
                    
                    .padding(.horizontal)
                    .background(.treBackground)
                    .fullScreenCover(isPresented: $showModal) {
                        CreateGoalView(showModal: $showModal)
                    }
                }

                .navigationTitle("Archieve")
                .navigationBarTitleDisplayMode(.inline)
                .sheet(isPresented: $showingSettingsModal) {
                    ProfileView(showModal: $showingSettingsModal)
                }
                .onAppear() {
                    if viewModel.goals.isEmpty {
                        viewModel.fetchGoals(archived: true)
                    }
                }
            }

    }
}

#Preview {
    ArchiveView()
}
