//
//  ProfileView.swift
//  Trezo
//
//  Created by Bekithemba Mdluli on 2024/09/18.
//
import SwiftUI
import RevenueCat
import RevenueCatUI

struct ProfileView: View {
    @StateObject var authViewModel = AuthViewModel()
    @State private var isLoggedOut = false // State to track logout
    @Binding var showModal: Bool
    @State private var isPaywallPresented = false

    var body: some View {
        NavigationStack {
            VStack {

                    List {
                        
                        Section {
                            Button {
                                print("Clicked")
                            } label: {
                                HStack(spacing: 20) {
                                    AnimatedSparklesView()
                                    
                                    VStack(alignment: .leading) {
                                        Text("COMING SOON")
                                            .foregroundStyle(.white)
                                            .font(.headline)
                                        Text("Enjoy all the benefits")
                                            .foregroundStyle(.white)
                                            .font(.footnote)
                                    }
                                }
                                .padding(.all, 0)

                            }
                            
                        }
                        .listRowBackground(Color.primaryPurple)
                        
                        
                        
                        NavigationLink {
                            Preferences()
                        } label: {
                            Label("Preferences", systemImage: "gearshape")
                        }
                        NavigationLink {
                            ArchiveView()
                        } label: {
                            Label("Archive", systemImage: "archivebox")
                        }
                        
                        Section {
                            Link(destination: URL(string: "https://apple.com")!) {
                                Label("Privacy Policy", systemImage: "lock.fill")
                            }
                            Link(destination: URL(string: "https://www.apple.com/legal/internet-services/itunes/dev/stdeula/")!) {
                                Label("Terms of Use", systemImage: "signature")
                            }
                        }
                        Button {
                            authViewModel.signOut()
                            isLoggedOut = true // Trigger logout state
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
                .fullScreenCover(isPresented: $isLoggedOut) {
                    ContentView()
                }
            }
    }
}



#Preview {
    @Previewable @State var value: Bool = true
    ProfileView(showModal: $value)
}

