//
//  ContentView.swift
//  Trezo
//
//  Created by Bekithemba Mdluli on 2024/09/11.
//

import SwiftUI
import FirebaseAuth


struct ContentView: View {
    @StateObject var authManager = AuthViewModel()
    @AppStorage("isOnboardingComplete") var isOnboardingComplete: Bool = false
    @AppStorage("selectedTheme") private var selectedTheme: Int = 1
    @StateObject private var themeManager = ThemeViewModel()
    
    
    var body: some View {
        
        VStack {
            if authManager.isSignedIn {
                TabBar()
            }
            else if isOnboardingComplete {
                WelcomeView()
            } else {
                OnboardingView()
            }
        }
        .onAppear {
            themeManager.applyTheme(selectedTheme)
        }
        
        
        
    }
    
}

#Preview {
    ContentView()
}
