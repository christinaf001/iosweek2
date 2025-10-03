//
//  ContentView.swift
//  Back4App
//
//  Created by cecetoni on 10/3/25.
//

import SwiftUI

import SwiftUI
import Parse

struct ContentView: View {
    @State private var username = ""
    @State private var password = ""
    @State private var isLoggedIn = false
    @State private var showingSignup = false
    
    var body: some View {
        if isLoggedIn {
            FeedView()
        } else {
            VStack(spacing: 20) {
                TextField("Username", text: $username)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                
                Button("Login") {
                    loginUser()
                }
                Button("Sign Up") {
                    showingSignup = true
                }
            }
            .sheet(isPresented: $showingSignup) {
                SignupView(isPresented: $showingSignup)
            }
        }
    }
    
    func loginUser() {
        PFUser.logInWithUsername(inBackground: username, password: password) { user, error in
            if let user = user {
                print("Logged in as \(user.username!)")
                isLoggedIn = true
            } else if let error = error {
                print("Login failed: \(error.localizedDescription)")
            }
        }
    }
}
