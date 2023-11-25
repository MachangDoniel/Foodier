//
//  HomeView.swift
//  Foodier! Restaurant
//
//  Created by Biduit on 13/11/23.
//

// HomeView.swift

import SwiftUI

struct HomeView: View {
    @State private var selection = 1
    var body: some View {
        TabView(selection: $selection) {
            
            OurItemView().tabItem {
                VStack {
                    Image(systemName: "leaf.fill")
                    Text("Home")
                }
                
            }.tag(1)
            
            AddItemView().tabItem {
                VStack {
                    Image(systemName: "plus.circle.fill")
                    Text("Add Item")
                }
                
            }.tag(2)
            
            OrderView().tabItem {
                VStack {
                    Image(systemName: "tray.full.fill")
                    Text("My Orders")
                }
                
            }.tag(3)
            
            MyKitchenView().tabItem {
                VStack {
                    Image(systemName: "person.fill")
                    Text("My Kitchen")
                }
                
            }.tag(4)
            
        }
        .accentColor(.red)
    }
    
    private func currentDateTimeFormatted() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMMM d, yyyy - h:mm a"
        return formatter.string(from: Date())
    }
}


struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
