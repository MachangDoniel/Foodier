//
//  InputView.swift
//  Foodier! Restaurant
//
//  Created by Biduit on 13/11/23.
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
                .font(.headline)
            
            if isSecureField {
                SecureField(placeHolder, text: $text)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.vertical, 10)
                    .font(.subheadline)
            }
            else {
                TextField(placeHolder, text: $text)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.vertical, 10)
                    .font(.subheadline)
            }
        }
    }
}

struct InputView_Previews: PreviewProvider {
    static var previews: some View {
        InputView(text: .constant(""), title: "Email Address", placeHolder: "name@example.com")
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
