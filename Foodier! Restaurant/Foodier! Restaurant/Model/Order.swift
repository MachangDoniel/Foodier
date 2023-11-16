//
//  Order.swift
//  Foodier! Restaurant
//
//  Created by Biduit on 16/11/23.
//

import Foundation

struct Order: Identifiable {
    var id: Int
    var image: String
    var title: String
    var descrip: String
    var stars: Int
    var price: Double
}

// Sample data
extension Order{
    static let sampleData: [Order] = [
        Order(id: 1, image: "item1", title: "Item 1", descrip: "Description 1", stars: 4, price: 9.99),
        Order(id: 2, image: "item2", title: "Item 2", descrip: "Description 2", stars: 5, price: 12.99),
        // Add more sample data...
    ]
}
