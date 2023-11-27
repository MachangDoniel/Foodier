//
//  RegistrationView.swift
//  Foodier! Restaurant
//
//  Created by Biduit on 13/11/23.
//

import SwiftUI

struct RegistrationView: View {
    
    @State private var email = ""
    @State private var full_name = ""
    @State private var password = ""
    @State private var confirm_password = ""
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        VStack {
            // Image
            Image("signup")
                .resizable()
                .scaledToFill()
                .frame(width: 100, height: 180)
                .padding(.vertical, 32)
        
            
            // Form Fields
            
            VStack(spacing: 0) {
                InputView(text: $email,
                    title: "Email Address",
                    placeHolder: "name@example.com")
                .autocapitalization(.none)
                
                InputView(text: $full_name,
                    title: "Full Name",
                    placeHolder: "Enter Your Name")
                    
                InputView(text: $password,
                    title: "Password",
                    placeHolder: "Enter Your password",
                    isSecureField: true)
                ZStack(alignment: .trailing) {
                    InputView(text: $confirm_password,
                        title: "Confirm Password",
                        placeHolder: "Confirm Your password",
                        isSecureField: true)
                    
                    if !password.isEmpty && !confirm_password.isEmpty {
                        if password == confirm_password {
                            Image(systemName: "checkmark.circle.fill")
                                .imageScale(.large)
                                .fontWeight(.bold)
                                .padding(.top, 15)
                                .foregroundColor(Color(.systemGreen))
                        } else {
                            Image(systemName: "xmark.circle.fill")
                                .imageScale(.large)
                                .fontWeight(.bold)
                                .padding(.top, 15)
                                .foregroundColor(Color(.systemRed))
                        }
                    }
                }
            }
            .padding(.horizontal)
            .padding(.top, 12)
            
            // Sign Uo Button
            
            Button {
                Task {
                    try await viewModel.createUser(withEmail: email, password: password, fullname: full_name)
                }

            } label: {
                HStack {
                    Text("Sign Up")
                        .fontWeight(.semibold)
                    Image(systemName: "arrow.right")
                        
                }
                .foregroundColor(.white)
                .frame(width: UIScreen.main.bounds.width - 32, height: 40)
            }
            .background(Color(.systemBlue))
            .disabled(!formIsValid)
            .opacity(formIsValid ? 1.0 : 0.5)
            .cornerRadius(10)
            .padding(.top, 24)
            
            Spacer()
            
            Button {
                dismiss()
            } label: {
                HStack(spacing: 3) {
                    Text("Already have an account?")
                    Text("Sign In")
                        .fontWeight(.bold)
                }
                .font(.system(size: 14))
            }
        }
    }
}

// MARK: -

extension RegistrationView: AuthenticationFormProtocol {
    var formIsValid: Bool {
        return !email.isEmpty
        && email.contains("@")
        && !password.isEmpty
        && password.count>5
        && confirm_password == password
        && !full_name.isEmpty
    }
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView()
    }
}
