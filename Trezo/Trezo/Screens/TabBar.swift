//
//  TabBar.swift
//  Trezo
//
//  Created by Bekithemba Mdluli on 2024/09/18.
//

import SwiftUI

struct TabBar: View {
    @StateObject var authViewModel = AuthViewModel()
    
    init() {
        UITabBarAppearance().backgroundColor = .systemBackground
    }
    
    var body: some View {
        NavigationStack {
            TabView {
                HomeView()
                    .tabItem {
                        Label("Home", systemImage: "house.fill")
                    }
                
                ProfileView()
                    .tabItem {
                        Label("Profile", systemImage: "person.fill")
                    }
            }
            .navigationBarBackButtonHidden(true)
            .background(.brandGreen)
        }
    }
    
}


#Preview {
    TabBar()
}
