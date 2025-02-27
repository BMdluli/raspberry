//
//  HomeView 2.swift
//  Trezo
//
//  Created by Bekithemba Mdluli on 2024/12/30.
//


import SwiftUI

struct HomeView: View {
    @State private var showModal = false
    @State private var showingSettingsModal = false
    
    @StateObject private var viewModel = GoalViewModel()
    @StateObject private var authViewModel = AuthViewModel()
    
    var tempGoals: [Goal] = []
    
    let columns = [GridItem(.flexible()),
                   GridItem(.flexible())]
    
    var body: some View {
        NavigationStack {
            VStack {
                if authViewModel.isSignedIn {
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
                                        ForEach(viewModel.goals, id: \._id) { goal in
                                            NavigationLink {
                                                GoalView(id: goal._id)
                                            } label: {
                                                // TODO: Prevent foreground color from changing
                                                GoalCardView(goal: goal)
                                                    .foregroundStyle(.black)
                                            }
                                        }
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
                        CreateGoalView(showModal: $showModal)
                    }
                    .onAppear() {
                        viewModel.fetchGoals()
                    }
                } else {
                    // Show a login or welcome screen if the user is not signed in
                    VStack {
                        Text("Please sign in to access your goals.")
                            .font(.title)
                            .padding()
                        
                        Button("Sign In") {
                            authViewModel.signIn() // Call your sign-in logic here
                        }
                        .buttonStyle(.borderedProminent)
                        .padding()
                    }
                }
            }
            .navigationTitle("Trezo")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                if authViewModel.isSignedIn {
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
            }
            .sheet(isPresented: $showingSettingsModal) {
                ProfileView(showModal: $showingSettingsModal)
            }
        }
    }
}
