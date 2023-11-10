//
//  LoginView.swift
//  Foodier!
//
//  Created by Biduit on 11/11/23.
//

import SwiftUI

struct LoginView: View {
    
    @State private var email = ""
    @State private var password = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                // Image
                Image("foodier")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 200, height: 260)
                    .padding(.vertical, 32)
                
                // Form Fields
                
                VStack(spacing: 0) {
                    InputView(text: $email,
                        title: "Email Address",
                        placeHolder: "name@example.com")
                    .autocapitalization(.none)
                        
                    InputView(text: $password,
                        title: "Password",
                        placeHolder: "Enter Your password",
                              isSecureField: true)
                }
                .padding(.horizontal)
                .padding(.top, 12)
                
                // Sign In Button
                
                Button {
                    print("Sign user in...")
                } label: {
                    HStack {
                        Text("Sign In")
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
                
                // Sign Up Button
                
                NavigationLink {
                    RegistrationView()
                        .navigationBarBackButtonHidden(true)
                } label: {
                    HStack(spacing: 3) {
                        Text("Don't have an account?")
                        Text("Sign Up")
                            .fontWeight(.bold)
                    }
                    .font(.system(size: 15))
                }
                
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
