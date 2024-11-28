//
//  HomeView.swift
//  Trezo
//
//  Created by Bekithemba Mdluli on 2024/09/14.
//

import SwiftUI

struct HomeView: View {
    @State private var showModal = false
    
    @StateObject private var viewModel = GoalViewModel()
    
    var tempGoals: [Goal] = []
    
    let columns = [GridItem(.flexible()),
                   GridItem(.flexible())]
    
    var body: some View {
        
        
        VStack {
            Text("Trezo")
                .font(.system(size: 20, weight: .bold))
                .padding(.bottom)
            
            
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
                                        // TODO: Prevent forefround colour from changing
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
    var goal: Goal
    
    
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
                    Spacer()
                    Text(String(format: "R%.1f", goal.goalAmount))
                }
                
                ProgressView(value: percentage)
                    .tint(Color(goal.goalColour))
                
                HStack {
                    Text(String(format: "R%.1f", total))
                        .font(.system(size: 14, weight: .light))
                    Spacer()
                    Text(String(format: "R%.1f", total))
                        .font(.system(size: 14, weight: .light))
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
