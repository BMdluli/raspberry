//
//  WelcomeView.swift
//  Trezo
//
//  Created by Bekithemba Mdluli on 2024/09/11.
//

import SwiftUI

struct WelcomeView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Image("logo-purple")
                    .resizable()
                    .frame(width: 70, height: 70)
                    .padding(.vertical, 35)
                
                Text("Let's Get Started!")
                    .font(.system(size: 30, weight: .semibold))
                
                Text("Let's dive in into your account")
                    .foregroundStyle(.secondary)
                
                Spacer()
                
                VStack(spacing: 20) {
                    NavigationLink {
                        SignUpView()
                    } label: {
                        Text("Sign up")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(TreButtonStyle(backgroundColor: .primaryPurple, textColor: .white))
                    
                    NavigationLink {
                        SignInView()
                    } label: {
                        Text("Sign in")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(TreButtonStyle(backgroundColor: .treLightGray, textColor: .primaryPurple))
                }
                
                
            }
            .padding(.horizontal)
            .navigationBarBackButtonHidden()
        }
    }
}

#Preview {
    WelcomeView()
}
