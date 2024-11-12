//
//  ProfileView.swift
//  Trezo
//
//  Created by Bekithemba Mdluli on 2024/09/18.
//
import SwiftUI

struct ProfileView: View {
    @StateObject var authViewModel = AuthViewModel()
    @State private var isLoggedOut = false // State to track logout
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Welcome to your profile!")
                    .font(.largeTitle)
                    .padding()
                
                Button {
                    authViewModel.signOut()
                    isLoggedOut = true // Set to true on logout
                    authViewModel.isSignedIn = false
                } label: {
                    Text("Logout")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.red)
                        .cornerRadius(10)
                }
            }
            // Navigate back to the WelcomeView when logged out
            .navigationDestination(isPresented: $isLoggedOut) {
                ContentView()
            }
        }
    }
}


#Preview {
    ProfileView()
}

