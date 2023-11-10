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
