//
//  SignInViewModel.swift
//  Trezo
//
//  Created by Bekithemba Mdluli on 2024/09/14.
//
import SwiftUI
import FirebaseAuth

class AuthViewModel: ObservableObject {
    @Published var user: User? = nil
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    @Published var isSignedIn = false
    @Published var resetSuccess = false
    
    private let auth = Auth.auth()
    
//    var isSignedIn: Bool {
//        return user != nil
//    }
//    
    
    
    init() {
        // Check if the user is already signed in when the app loads
        self.isSignedIn = Auth.auth().currentUser != nil
    }
    
    func signIn(with email: String, password: String) async {
        DispatchQueue.main.async {
            self.isLoading = true
            self.errorMessage = nil
        }
        do {
            let result = try await auth.signIn(withEmail: email, password: password)
            DispatchQueue.main.async {
                self.user = result.user
                self.isSignedIn = true
            }
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = error.localizedDescription
            }
        }
        DispatchQueue.main.async {
            self.isLoading = false
        }
    }
    
    func signUp(with email: String, password: String) async {
        DispatchQueue.main.async {
            self.isLoading = true
            self.errorMessage = nil
        }
        do {
            let result = try await auth.createUser(withEmail: email, password: password)
            DispatchQueue.main.async {
                self.user = result.user
                self.isSignedIn = true
            }
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = error.localizedDescription
            }
        }
        DispatchQueue.main.async {
            self.isLoading = false
        }
    }
    
    
    func resetPassword(with email: String) async {
        DispatchQueue.main.async {
            self.isLoading = true
            self.errorMessage = nil
        }
        
        
        do {
            try await auth.sendPasswordReset(withEmail: email)
            DispatchQueue.main.async {
                self.resetSuccess = true
            }
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = error.localizedDescription
            }
        }
        
        
        DispatchQueue.main.async {
            self.isLoading = false
        }
    }
    
    func signOut() {
        do {
            try auth.signOut()
            DispatchQueue.main.async {
                self.isSignedIn = false
            }
        } catch let error {
            DispatchQueue.main.async {
                self.errorMessage = error.localizedDescription
            }
        }
    }
}
