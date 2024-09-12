//
//  SignupView.swift
//  Trezo
//
//  Created by Bekithemba Mdluli on 2024/09/11.
//

import SwiftUI

struct SignUpView: View {
    @State var email: String = ""
    @State var password: String = ""
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 25) {
                Text("Start your savings journey.")
                    .foregroundStyle(.gray)
                    .font(.system(size: 16))
                    
                TextFieldWithLabel(text: email, title: "Email", placeholder: "Email")
                TextFieldWithLabel(text: password, title: "Password", placeholder: "Password")
                
                HStack() {
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
}

#Preview {
    SignUpView()
}


