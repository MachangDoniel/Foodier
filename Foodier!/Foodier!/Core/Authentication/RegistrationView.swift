//
//  RegistrationView.swift
//  Foodier!
//
//  Created by Biduit on 11/11/23.
//

import SwiftUI

struct RegistrationView: View {
    
    @State private var email = ""
    @State private var full_name = ""
    @State private var password = ""
    @State private var confirm_password = ""
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            // Image
            Image("foodier")
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
                InputView(text: $confirm_password,
                    title: "Confirm Password",
                    placeHolder: "Confirm Your password",
                          isSecureField: true)
            }
            .padding(.horizontal)
            .padding(.top, 12)
            
            // Sign Uo Button
            
            Button {
                print("Sign user up...")
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
                .font(.system(size: 15))
            }
        }
    }
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView()
    }
}
