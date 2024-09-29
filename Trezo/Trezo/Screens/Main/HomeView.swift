//
//  HomeView.swift
//  Trezo
//
//  Created by Bekithemba Mdluli on 2024/09/14.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        VStack {
            Spacer()
            
            VStack(alignment: .center ,spacing: 20) {
                Image("Target")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 106, height: 106)
                Text("Ready to start saving?")
                    .font(.system(size: 20, weight: .bold))
                Text("You haven't set any goals yet.")
                    .font(.system(size: 20))
                    .foregroundStyle(.gray)
                Button {
                    
                } label: {
                    Label("Create Your First Goal", systemImage: "plus")
                        .foregroundStyle(.white)
                }
                .frame(width: 260, height: 59)
                .background(.primaryPurple)
                .clipShape(RoundedRectangle(cornerRadius: 29))
                .padding(.top, 20)
            }
            
            Spacer()
            HStack {
                Spacer()
                Button {
                    print("Clicked")
                } label: {
                    Image(systemName: "plus")
                        .foregroundStyle(.white)
                }
                .frame(width: 56, height: 56)
                .background(.primaryPurple)
                .clipShape(RoundedRectangle(cornerRadius: 28))
            }
            .padding()
            
        }
    }
}

#Preview {
    HomeView()
}
