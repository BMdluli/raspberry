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
    @Binding var showModal: Bool
    
    var body: some View {
        NavigationStack {
            VStack {

                List {
                    
                    NavigationLink {
                        Preferences()
                    } label: {
                        Label("Preferences", systemImage: "gearshape")
                    }
                    
                    

                    
                    
                    Section {
                        Link(destination: URL(string: "https://apple.com")!) {
                            Label("Privacy Policy", systemImage: "lock.fill")
                        }
                        Link(destination: URL(string: "https://www.apple.com/legal/internet-services/itunes/dev/stdeula/")!) {
                            Label("Terms of Use", systemImage: "signature")
                        }
                    } header: {
                        Text("")
                    }
                    
                    
                    
                    Button {
                        authViewModel.signOut()
                        isLoggedOut = true // Set to true on logout
                        authViewModel.isSignedIn = false
                    } label: {
                        Label("Logout", systemImage: "rectangle.portrait.and.arrow.right")
                            .foregroundStyle(.brandRed)
                    }
                    
                    

                }

                

            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showModal = false
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .resizable()
                            .frame(width: 28, height: 28)
                            .foregroundStyle(.treAlertnateBackground)
                            
                    }
                }
            }
            // Navigate back to the WelcomeView when logged out
            .navigationDestination(isPresented: $isLoggedOut) {
                ContentView()
            }
            
        }
    }
}


//#Preview {
//    ProfileView(showModal: Binding<true>)
//}

