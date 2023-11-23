//
//  Fooditem.swift
//  Foodier! Restaurant
//
//  Created by Biduit on 16/11/23.
//

import Foundation

struct FoodItem: Identifiable, Encodable, Decodable {
    var id: String
    var image: String
    var title: String
    var type: String
    var descrip: String
    var stars: Int
    var price: Double
    
}

// Sample data
extension FoodItem {
    static let sampleData: [FoodItem] = [
        FoodItem(id: "1", image: "item1", title: "Item 1", type: "Burger", descrip: "Description 1", stars: 4, price: 9.99),
        FoodItem(id: "2", image: "item2", title: "Item 2", type: "Burger", descrip: "Description 2", stars: 5, price: 12.99),
        FoodItem(id: "3", image: "item2", title: "Item 2", type: "Burger", descrip: "Description 2", stars: 5, price: 12.99),
        FoodItem(id: "4", image: "item2", title: "Item 2", type: "Burger", descrip: "Description 2", stars: 5, price: 12.99),
        FoodItem(id: "5", image: "item2", title: "Item 2", type: "Burger", descrip: "Description 2", stars: 5, price: 12.99),
        FoodItem(id: "6", image: "item2", title: "Item 2", type: "Burger", descrip: "Description 2", stars: 5, price: 12.99),
        FoodItem(id: "7", image: "item2", title: "Item 2", type: "Burger", descrip: "Description 2", stars: 5, price: 12.99),
        FoodItem(id: "8", image: "item2", title: "Item 2", type: "Burger", descrip: "Description 2", stars: 5, price: 12.99),
        // Add more sample data...
    ]
}
