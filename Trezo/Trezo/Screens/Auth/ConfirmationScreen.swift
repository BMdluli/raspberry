//
//  ConfirmationScreen.swift
//  Trezo
//
//  Created by Bekithemba Mdluli on 2025/01/08.
//

import SwiftUI

struct ConfirmationScreen: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                
                Spacer()
                
                ZStack {
                    Color.primaryPurple
                    
                    Image(systemName: "bird.fill")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .foregroundStyle(.white)
                }
                .frame(width: 120, height: 120)
                .clipShape(Circle())
                
                Text("Reset Link Sent")
                    .font(.title)
                    .bold()
                
                Text("Please check your email for instructions")
                
                Spacer()
                
                
                NavigationLink {
                    SignInView()
                } label: {
                    Text("Sign in")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(TreButtonStyle(backgroundColor: .primaryPurple, textColor: .white))
                .padding()
                .navigationBarBackButtonHidden(true)
                
                
            }
        }
        
    }
}

#Preview {
    ConfirmationScreen()
}
