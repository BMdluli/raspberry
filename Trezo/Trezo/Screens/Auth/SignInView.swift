//
//  SignInView.swift
//  Trezo
//
//  Created by Bekithemba Mdluli on 2024/09/11.
//
import SwiftUI

struct SignInView: View {
    @State var email: String = ""
    @State var password: String = ""
    @StateObject var authViewModel = AuthViewModel()
    
    var body: some View {
        ZStack {
            if authViewModel.isSignedIn { // Use isSignedIn instead of isLoading for screen switching
                TabBar()// Show ProfileView or TabBar on successful sign-in
            } else {
                NavigationStack {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 25) {
                            Text("Sign in to continue saving.")
                                .foregroundStyle(.gray)
                                .font(.system(size: 16))
                            
                            TextFieldWithLabel(text: $email, title: "Email", placeholder: "Email")
                            SecureTextFieldWithLabel(text: $password, title: "Password", placeholder: "Password")
                            
                            HStack {
                                Text("Don't have an account?")
                                NavigationLink {
                                    SignUpView() // Navigate to sign-up view
                                } label: {
                                    Text("Sign up")
                                        .foregroundStyle(.primaryPurple)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            
                            Spacer()
                            
                            
                            Divider()
                            Button {
                                Task {
                                    await authViewModel.signIn(with: email, password: password)
                                }
                            } label: {
                                Text("Sign in")
                                    .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(TreButtonStyle(backgroundColor: .primaryPurple, textColor: .white))
                            .padding()
                            
                        }
                        .navigationTitle("Welcome back! 👋")
                        .navigationBarTitleDisplayMode(.large)
                        .padding(.horizontal)
                    }
                }
                // Show loading screen as an overlay if isLoading is true
                if authViewModel.isLoading {
                    Color.black.opacity(0.5)
                        .edgesIgnoringSafeArea(.all)
                    
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(1.5) // Adjust size of the spinner
                }
            }
        }
    }
}

#Preview {
    SignInView()
}
