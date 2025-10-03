//
//  SignUpView.swift
//  Back4App
//
//  Created by cecetoni on 10/3/25.
//

import Foundation
import SwiftUI
import Parse

struct SignupView: View {
    @Binding var isPresented: Bool
    @State private var username = ""
    @State private var password = ""
    
    var body: some View {
        VStack(spacing: 20) {
            TextField("Username", text: $username)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
            
            Button("Sign Up") {
                signUpUser()
            }
            Button("Cancel") {
                isPresented = false
            }
        }
    }
    
    func signUpUser() {
        let user = PFUser()
        user.username = username
        user.password = password
        
        user.signUpInBackground { success, error in
            if success {
                print("User registered!")
                isPresented = false
            } else if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
}
