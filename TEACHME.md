# Foodier
##### Foodier is a Food Delivery App.
# How to build it?
## SetUp
1. Create a New project at XCode.

Product Name:
```bash
Foodier!
```
Interface:
```bash
SwiftUi
```
Initially We can ignore *Use Core Data* and *Include Data*

2. Set up Project Directory.
3. Organize your files in some couple of group.
Create 4 Group **App**, **Component**, **Core**, **Model**. Create **Authentication**, **Profile** and **Root** group inside **Core** group.
4. Initially there will be 2 file named *ContentView* and *Foodier_App*. Move *ContentView* at **Root** Group. Move *ContentView* at **Root** and *Foodier_App* at **App**.
5. Create a New File named *LoginView* inside **Authentication**.
6. Create a New File named *InputView* inside **Component** to make function view of input field and it's title.
```bash
//
//  InputView.swift
//  Foodier!
//
//  Created by Biduit on 11/11/23.
//

import SwiftUI

struct InputView: View {
    @Binding var text: String
    let title: String
    let placeHolder: String
    var isSecureField = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .foregroundColor(Color(.darkGray))
                .fontWeight(.semibold)
                .font(.system(size: 15))
            
            if isSecureField {
                SecureField(placeHolder, text: $text)
                    .font(.system(size: 16))
                    .padding(.vertical, 8)
                    .background(Color(.lightGray))
                    .cornerRadius(8)
            }
            else {
                TextField(placeHolder, text: $text)
                    .font(.system(size: 16))
                    .padding(.vertical, 8)
                    .background(Color(.lightGray))
                    .cornerRadius(8)
            }
            
            Divider()
        }
    }
}

struct InputView_Previews: PreviewProvider {
    static var previews: some View {
        InputView(text: .constant(""), title: "Email Address", placeHolder: "name@example.com")
    }
}
```
7. Create a New File named *RegistrationView* inside **Authentication**.
```bash
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
```
and write it at *LoginView*
```bash
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
```

