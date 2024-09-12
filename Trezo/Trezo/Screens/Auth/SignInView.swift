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
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 25) {
                Text("Sign in to continue saving.")
                    .foregroundStyle(.gray)
                    .font(.system(size: 16))
                
                TextFieldWithLabel(text: email, title: "Email", placeholder: "Email")
                TextFieldWithLabel(text: password, title: "Password", placeholder: "Password")
                
                HStack() {
                    Text("Already have an account?")
                    NavigationLink {
                        SignUpView()
                    } label: {
                        Text("Sign up")
                            .foregroundStyle(.primaryPurple)
                    }
                }
                .frame(maxWidth: .infinity)
                
                
                
                Spacer()
                
                Divider()
                Button {
                    
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
}

#Preview {
    SignInView()
}
