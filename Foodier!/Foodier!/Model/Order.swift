//
//  Order.swift
//  Foodier!
//
//  Created by Biduit on 24/11/23.
//


import Foundation

struct Order: Encodable, Decodable, Identifiable {
    var id: String?
    var restaurant_id: String
    var user_id: String
    var food_id: String
    var location: String
    var contact_no: String
    var quantity: Int
    var status: Int = 1

    // Computed property for Identifiable
//    var id: String {
//        "\(restaurant_id)_\(user_id)_\(food_id)"
//    }
}
