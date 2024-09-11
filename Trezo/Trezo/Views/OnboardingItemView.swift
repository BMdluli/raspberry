//
//  OnboardingItemView.swift
//  Trezo
//
//  Created by Bekithemba Mdluli on 2024/09/11.
//

import SwiftUI

struct OnboardingItemView: View {
    let image: String
    let title: String
    let description: String
    
    
    var body: some View {
        VStack(spacing: 20) {
            
            Image(image)
                .resizable()
                .scaledToFill()
                .frame(height: 460)
            
            Text(title)
                .font(.system(size: 28, weight: .bold))
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Text(description)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
                .foregroundStyle(.gray)
            
            Spacer()
            

                
        }
        .ignoresSafeArea(.all)
    }
}

#Preview {
    OnboardingItemView(image: "Onboarding1", title: "Set, Track & Achieve Your Finacial Goals", description: "Easily create savings goals, record income and withdrawals, and monitor your progress from time to time effor")
}

struct TreButtonStyle: ButtonStyle {
    let backgroundColor: Color
    let textColor: Color
    func makeBody(configuration: Self.Configuration) -> some View {
        return configuration.label
            .frame(height: 50)
            .background(backgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: 25.0))
            .foregroundStyle(textColor)
            .bold()
    }
}
