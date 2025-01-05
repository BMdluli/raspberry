//
//  TrezoApp.swift
//  Trezo
//
//  Created by Bekithemba Mdluli on 2024/09/11.
//

import SwiftUI
import Firebase

@main
struct TrezoApp: App {
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
