//
//  User.swift
//  Foodier!
//
//  Created by Biduit on 11/11/23.
//

import Foundation

struct User: Identifiable, Codable {
    let id: String
    let full_name: String
    let email: String
    
    var initials: String {
        let formatter = PersonNameComponentsFormatter()
        if let components = formatter.personNameComponents(from: full_name) {
            formatter.style = .abbreviated
            return formatter.string(from: components)
        }
        return ""
    }
}

extension User {
    static var mock_user = User(id: NSUUID().uuidString, full_name: "Just Test", email: "justtest@gmail.com")
}
