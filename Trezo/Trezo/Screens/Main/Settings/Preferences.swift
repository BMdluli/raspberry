//
//  Preferences.swift
//  Trezo
//
//  Created by Bekithemba Mdluli on 2024/12/12.
//

import SwiftUI

struct Preferences: View {
    @State private var isShowingPreferenceModal: Bool = true
    @AppStorage("selectedTheme") private var selectedTheme: Int = 1
    @StateObject private var viewModel = ThemeViewModel()
    
    var body: some View {
        List {
            Button {
                isShowingPreferenceModal = true
            } label: {
                
                
                HStack {
                    Picker(selection: $selectedTheme, label: Text("Theme")) {
                        Text("System Default").tag(1)
                        Text("Light").tag(2)
                        Text("Dark").tag(3)
                    }
                }
            }
        }
        .onChange(of: selectedTheme) { _, newValue in
            viewModel.applyTheme(newValue)
        }
        .onAppear {
            viewModel.applyTheme(selectedTheme)
        }
        
        
    }
    

}

#Preview {
    Preferences()
}


struct PreferenceModal<Content: View>: View {
    let title: String
    let actionButtonText: String
    let height: CGFloat
    @Binding var showingSheet: Bool
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


