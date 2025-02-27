//
//  ProfileView.swift
//  Trezo
//
//  Created by Bekithemba Mdluli on 2024/09/18.
//
import SwiftUI


struct ProfileView: View {
    @StateObject var authViewModel = AuthViewModel()
    @State private var isLoggedOut = false
    @Binding var showModal: Bool
    @State private var showingConfirmation = false

    var body: some View {
        ZStack {
            // Main content
            NavigationStack {
                VStack {
                    List {
                        Section {
                            Button { } label: {
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

                        NavigationLink { Preferences() } label: {
                            Label("Preferences", systemImage: "gearshape")
                        }
                        NavigationLink { ArchiveView() } label: {
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
                        } label: {
                            Label("Logout", systemImage: "rectangle.portrait.and.arrow.right")
                                .foregroundStyle(.brandRed)
                        }

                        Section {
                            Button {
                                showingConfirmation = true
                            } label: {
                                Label("Delete Account", systemImage: "trash.fill")
                                    .foregroundStyle(.brandRed)
                                    .bold()
                            }
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
                .onChange(of: authViewModel.navigateBackToWelcome) { _, newValue in
                    if newValue {
                        isLoggedOut = true
                    }
                }
                .fullScreenCover(isPresented: $isLoggedOut) {
                    ContentView()
                }
                .alert("Error", isPresented: $authViewModel.showAlert) {
                    Button("OK", role: .cancel) { }
                } message: {
                    Text(authViewModel.errorMessage ?? "Unknown error")
                }
                .confirmationDialog("Delete Account", isPresented: $showingConfirmation) {
                    Button("Delete Account") {
                        Task {
                            await authViewModel.deleteUser()
                        }
                    }
                    Button("Cancel", role: .cancel) { }
                } message: {
                    Text("Please note this action is not reversible. Do you wish to delete your account?")
                }
            }
            
            // Loading Overlay (kept at the top)
            if authViewModel.isLoading {
                ZStack {
                    Color.black.opacity(0.5)
                        .edgesIgnoringSafeArea(.all)
                        .transition(.opacity)
                    
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(1.5)
                }
                .allowsHitTesting(authViewModel.isLoading) // Prevents interaction with background
                .animation(.easeInOut, value: authViewModel.isLoading)
            }
        }
    }
}




#Preview {
    @Previewable @State var value: Bool = true
    ProfileView(showModal: $value)
}

