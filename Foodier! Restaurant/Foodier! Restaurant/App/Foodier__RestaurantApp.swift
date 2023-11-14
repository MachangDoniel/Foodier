//
//  Foodier__RestaurantApp.swift
//  Foodier! Restaurant
//
//  Created by Biduit on 13/11/23.
//

import SwiftUI
import Firebase

@main
struct Foodier__RestaurantApp: App {
//    let persistenceController = PersistenceController.shared
    @StateObject var viewModel = AuthViewModel()
    
    init() {
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
//                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(viewModel)
        }
    }
}
