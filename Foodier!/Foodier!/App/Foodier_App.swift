//
//  Foodier_App.swift
//  Foodier!
//
//  Created by Biduit on 11/11/23.
//

import SwiftUI
import Firebase

@main
struct Foodier_App: App {
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
