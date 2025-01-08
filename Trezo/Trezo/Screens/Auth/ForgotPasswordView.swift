//
//  ForgotPasswordView.swift
//  Trezo
//
//  Created by Bekithemba Mdluli on 2025/01/08.
//

import SwiftUI

struct ForgotPasswordView: View {
    @State var email: String = ""
    @StateObject var authViewModel = AuthViewModel()
    
    var body: some View {
        ZStack {
            if authViewModel.resetSuccess { // Use isSignedIn instead of isLoading for screen switching
                ConfirmationScreen()// Show ProfileView or TabBar on successful sign-in
            } else {
                NavigationStack {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 25) {
                            Text("Enter your registered email address, and we'll send you a code to reset your password.")
                                .foregroundStyle(.gray)
                                .font(.system(size: 16))
                            
                            TextFieldWithLabel(text: $email, title: "Registered email address", placeholder: "Email")
                            
                            
                            
                            Spacer()
                            
                            
                            Divider()
                            
                            Button {
                                Task {
                                    await authViewModel.resetPassword(with: email)
                                }
                            } label: {
                                Text("Send reset link")
                                    .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(TreButtonStyle(backgroundColor: .primaryPurple, textColor: .white))
                            .padding()
                            
                        }
                        .navigationTitle("Forgot Password? 🔑")
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
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    ForgotPasswordView()
}
