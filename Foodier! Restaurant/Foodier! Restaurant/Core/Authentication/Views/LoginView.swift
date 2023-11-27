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
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        //        LinearGradient(gradient: Gradient(colors: [Color.red, Color.white]), startPoint: .top, endPoint: .bottom)
        //                        .edgesIgnoringSafeArea(.all)
        NavigationStack {
            Group {
                if viewModel.userSession != nil {
                    HomeView()
                }
            }
            VStack {
                // Image
                Image("signin")
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
                    Task {
                        try await viewModel.signIn(withEmail: email, password: password)
                        
                    }
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
                .disabled(!formIsValid)
                .opacity(formIsValid ? 1.0 : 0.5)
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
                    .font(.system(size: 14))
                }
                
            }
        }
    }
}
// MARK: -

extension LoginView: AuthenticationFormProtocol {
    var formIsValid: Bool {
        return !email.isEmpty
        && email.contains("@")
        && !password.isEmpty
        && password.count>5
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .environmentObject(AuthViewModel()) // Add this line
                        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
