//
//  FirebaseAuthManager.swift
//  Trezo
//
//  Created by Bekithemba Mdluli on 2024/09/18.
//

import Foundation
import FirebaseAuth

class FirebaseAuthManager: ObservableObject {
    let firebaseAuth = Auth.auth()
    
    
    func signUp(with email: String, password: String) async {
        do {
            try await firebaseAuth.createUser(withEmail: email, password: password)
        } catch {
            print("Error signing in: %@", error.localizedDescription)
        }
    }
    
    
    func signIn(with email: String, password: String) async {
        do {
            try await firebaseAuth.signIn(withEmail: email, password: password)
        } catch {
            print("Error signing in: %@", error.localizedDescription)
        }
    }
    
    func sendResetLink(with email: String) async {
        do {
            try await firebaseAuth.sendPasswordReset(withEmail: email)
        } catch {
            print("Error sending reset link", error.localizedDescription)
        }
    }
    
    
    func signOut() async {
        do {
          try firebaseAuth.signOut()
        } catch let signOutError as NSError {
          print("Error signing out: %@", signOutError)
        }
    }
}
