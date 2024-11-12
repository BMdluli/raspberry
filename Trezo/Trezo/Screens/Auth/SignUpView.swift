//
//  SignupView.swift
//  Trezo
//
//  Created by Bekithemba Mdluli on 2024/09/11.
//
import SwiftUI

struct SignUpView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @StateObject var authViewModel = AuthViewModel()

    var body: some View {
        NavigationStack {
            ZStack {
                if authViewModel.isSignedIn {
                    TabBar() // Show TabBar on successful sign-in
                } else {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 25) {
                            Text("Start your savings journey.")
                                .foregroundStyle(.gray)
                                .font(.system(size: 16))
                            
                            TextFieldWithLabel(text: $email, title: "Email", placeholder: "Email")
                            SecureTextFieldWithLabel(text: $password, title: "Password", placeholder: "Password")
                            
                            HStack {
                                Text("Already have an account?")
                                NavigationLink {
                                    SignInView()
                                } label: {
                                    Text("Sign in")
                                        .foregroundStyle(.primaryPurple)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            
                            Spacer()
                            
                            Divider()
                            
                            Button {
                                Task {
                                    await authViewModel.signUp(with: email, password: password)
                                }
                            } label: {
                                Text("Sign up")
                                    .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(TreButtonStyle(backgroundColor: .primaryPurple, textColor: .white))
                            .padding()
                        }
                        .navigationTitle("Join Trezo Today 🚀")
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
    SignUpView()
}
