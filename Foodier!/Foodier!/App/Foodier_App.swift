//
//  Foodier_App.swift
//  Foodier!
//
//  Created by Biduit on 11/11/23.
//

import SwiftUI

@main
struct Foodier_App: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
