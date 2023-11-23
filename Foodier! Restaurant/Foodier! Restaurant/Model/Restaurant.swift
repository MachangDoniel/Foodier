//
//  Restaurant.swift
//  Foodier! Restaurant
//
//  Created by Biduit on 13/11/23.
//

import Foundation

struct Restaurant: Identifiable, Codable {
    var id: String
    var full_name: String
    var email: String
//    let image:
    
    var initials: String {
        let formatter = PersonNameComponentsFormatter()
        if let components = formatter.personNameComponents(from: full_name) {
            formatter.style = .abbreviated
            return formatter.string(from: components)
        }
        return ""
    }
}

extension Restaurant {
    static var mock_user = Restaurant(id: NSUUID().uuidString, full_name: "Just Test", email: "justtest@gmail.com")
}
