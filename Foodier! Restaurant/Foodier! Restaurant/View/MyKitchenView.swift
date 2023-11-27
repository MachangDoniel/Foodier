//
//  MyKitchenView.swift
//  Foodier! Restaurant
//
//  Created by Biduit on 25/11/23.
//

import SwiftUI
import Firebase
import FirebaseAuth

struct MyKitchenView: View {
    @State private var searchText = ""
    @State private var items: [FoodItem] = []
    @State private var currentRestaurantId: String = ""
    @State private var showAlert = false

    var filteredItems: [FoodItem] {
        if searchText.isEmpty {
            return items
        } else {
            return items.filter { $0.title.lowercased().contains(searchText.lowercased()) }
        }
    }

    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: ProfileView()) {
                    Text("My Kitchen")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding()
                }
                .navigationBarBackButtonHidden(true)
                // Search Bar
                SearchBar(text: $searchText)

                // Display Cards
                ScrollView {
                    LazyVGrid(columns: [
                        GridItem(.flexible(), spacing: 16),
                        GridItem(.flexible(), spacing: 16)
                    ], spacing: 20) {
                        ForEach(filteredItems.indices, id: \.self) { index in
                            CardView(item: filteredItems[index])
                                .frame(width: 150, height: 250)
                        }
                        .padding()
                    }
                    .padding()
                }
            }
            .onAppear {
                fetchCurrentRestaurantId()
                fetchDataFromFirestore()
            }
        }
    }

    private func fetchCurrentRestaurantId() {
        if let currentUser = Auth.auth().currentUser {
            // Assuming you have a field like 'restaurantId' in your user data
            // Replace 'restaurantId' with the actual field in your user data
            // that holds the restaurant id
            currentRestaurantId = currentUser.uid
            showAlert = true // Show the alert when the restaurant ID is obtained
        } else {
            // Handle the case where no user is logged in
            print("No user is logged in")
        }
    }

    private func fetchDataFromFirestore() {
        let db = Firestore.firestore()

        db.collection("foodItems")
            .whereField("id", isEqualTo: currentRestaurantId)
            .addSnapshotListener { querySnapshot, error in
                if let error = error {
                    print("Error getting documents: \(error)")
                } else {
                    items = querySnapshot?.documents.compactMap { document in
                        var foodItem = try? document.data(as: FoodItem.self)
                        foodItem?.id = document.documentID
                        return foodItem
                    } ?? []

                    // Print the fetched items for debugging
                    print(items)

                    DispatchQueue.main.async {}
                }
            }
    }
}

struct MyKitchenView_Previews: PreviewProvider {
    static var previews: some View {
        MyKitchenView()
    }
}
