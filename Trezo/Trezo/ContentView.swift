//
//  ContentView.swift
//  Trezo
//
//  Created by Bekithemba Mdluli on 2024/09/11.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("isOnboardingComplete") var isOnboardingComplete: Bool = false

    var body: some View {
        if isOnboardingComplete {
            WelcomeView()
        } else {
            OnboardingView()
        }
    }
}

#Preview {
    ContentView()
}
