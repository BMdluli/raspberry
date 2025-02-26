//
//  SignInViewModel.swift
//  Trezo
//
//  Created by Bekithemba Mdluli on 2024/09/14.
//
import SwiftUI
@preconcurrency import FirebaseAuth

@MainActor
class AuthViewModel: ObservableObject {
    @Published var user: User? = nil
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    @Published var isSignedIn = false
    @Published var navigateBackToWelcome = false
    @Published var resetSuccess = false
    @Published var showAlert = false
    
    private let auth = Auth.auth()
    
    init() {
        // Check if the user is already signed in when the app loads
        self.isSignedIn = Auth.auth().currentUser != nil
    }
    
    func signIn(with email: String, password: String) async {
        if email.isEmpty || password.isEmpty {
            showAlert = true
            errorMessage = "Email and password fields cannot be empty."
            return
        }
        
        
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
                self.showAlert = true
                self.errorMessage = "Invalid email or password. Please try again."
            }
        }
        DispatchQueue.main.async {
            self.isLoading = false
        }
    }
    
    func signUp(with email: String, password: String) async {
        if email.isEmpty || password.isEmpty {
            showAlert = true
            errorMessage = "Email and password fields cannot be empty."
            return
        }
        
        
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
                self.showAlert = true
                self.errorMessage = error.localizedDescription
            }
        }
        DispatchQueue.main.async {
            self.isLoading = false
        }
    }
    
    
    func resetPassword(with email: String) async {
        
        if email.isEmpty {
            showAlert = true
            errorMessage = "Email field cannot be empty."
            return
        }
        
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
                self.showAlert = true
                self.errorMessage = error.localizedDescription
            }
        }
        
        
        DispatchQueue.main.async {
            self.isLoading = false
        }
    }
    
    func deleteUser() async {
        isLoading = true  // Start loading

        guard let user = Auth.auth().currentUser else {
            isLoading = false  // Stop loading
            showAlert = true
            errorMessage = "Please login and try again."
            return
        }

        do {
            try await user.delete()
            navigateBackToWelcome = true
        } catch let error as NSError {
            if error.code == AuthErrorCode.requiresRecentLogin.rawValue {
                showAlert = true
                errorMessage = "Please reauthenticate before deleting your account."
            } else {
                showAlert = true
                errorMessage = error.localizedDescription
            }
            
            // Log error for debugging
            print("Error deleting user: \(error.localizedDescription) (\(error.code))")
        }

        isLoading = false  // Stop loading
    }

    
    func signOut() {
        do {
            try auth.signOut()
            DispatchQueue.main.async {
                self.navigateBackToWelcome = true
            }
        } catch let error {
            DispatchQueue.main.async {
                self.errorMessage = error.localizedDescription
            }
        }
    }
}
