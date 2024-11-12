//
//  OnboardingView.swift
//  Trezo
//
//  Created by Bekithemba Mdluli on 2024/09/11.
//
import SwiftUI

struct OnboardingView: View {
    private var viewModel = OnboardingViewModel()
    @State private var selectedTab = 0 // Track the current tab index
    @AppStorage("isOnboardingComplete") var isOnboardingComplete: Bool = false
    
    var body: some View {
            VStack {
                TabView(selection: $selectedTab) {
                    ForEach(0..<viewModel.items.count, id: \.self) { index in
                        OnboardingItemView(
                            image: viewModel.items[index].image,
                            title: viewModel.items[index].title,
                            description: viewModel.items[index].description
                        )
                        .tag(index) // Tag each view with its index
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .always))
                .indexViewStyle(.page(backgroundDisplayMode: .always))
                .ignoresSafeArea(.container, edges: .top) // Apply to top area only
                
                Divider()
                
                HStack(spacing: 20) {
                    if selectedTab < viewModel.items.count - 1 {
                        Button {
                            // Skip action
                        } label: {
                            Text("Skip")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(TreButtonStyle(backgroundColor: .treLightGray, textColor: .primaryPurple))
                        
                        Button {
                            if selectedTab < viewModel.items.count - 1 {
                                selectedTab += 1
                            }
                        } label: {
                            Text("Continue")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(TreButtonStyle(backgroundColor: .primaryPurple, textColor: .white))
                    } else {
                        Button {
                            isOnboardingComplete = true
                        } label: {
                            Text("Let's get Started")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(TreButtonStyle(backgroundColor: .primaryPurple, textColor: .white))
                    }
                }
                .padding()
                
            }
        }
}

#Preview {
    OnboardingView()
}
