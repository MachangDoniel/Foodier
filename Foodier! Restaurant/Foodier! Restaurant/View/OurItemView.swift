//
//  Restaurant.swift
//  Foodier! Restaurant
//
//  Created by Biduit on 13/11/23.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift

struct OurItemView: View {
    @State private var searchText = ""
    @State private var items: [FoodItem] = []

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
                Text("Available Restaurants \n\t\t\t  & Items !")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()

                // Search Bar
                SearchBar(text: $searchText)

                // Display Cards
                ScrollView {
                    LazyVGrid(columns: [
                        GridItem(.flexible(), spacing: 16),
                        GridItem(.flexible(), spacing: 16)
                    ], spacing: 20) { // Increase the spacing value as needed
                        ForEach(filteredItems.indices, id: \.self) { index in
                            CardView(item: filteredItems[index])
                                .frame(width: 150, height: 250) // Adjust the size as needed
                        }
                        .padding()
                    }
                    .padding()
                }

            }
            .onAppear {
                fetchDataFromFirestore()
            }
        }
    }

    private func fetchDataFromFirestore() {
        let db = Firestore.firestore()
        db.collection("foodItems").addSnapshotListener { querySnapshot, error in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                items = querySnapshot?.documents.compactMap { document in
                                var foodItem = try? document.data(as: FoodItem.self)
                                foodItem?.id = document.documentID // Set the document ID as the item ID
                                return foodItem
                } ?? []

                // Explicitly request a UI update on the main thread
                DispatchQueue.main.async {
                    // This ensures the UI updates when the data changes
                    // without relying on automatic SwiftUI updates
                }
            }
        }
    }
}


struct CardView: View {
    @State private var isDetailViewPresented = false
    var item: FoodItem

    var body: some View {
        VStack(spacing: 8) {
            Text(item.title)
                .font(.headline)
                .padding(.bottom, 5)

            Button(action: {
                isDetailViewPresented.toggle()
            }) {
                // Use AsyncImage to load and display the image from the URL
                AsyncImage(url: URL(string: item.image)) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(height: 150)
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 150)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                            .padding(.bottom, 5)
                    case .failure:
                        Image(systemName: "photo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 150)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                            .padding(.bottom, 5)
                    @unknown default:
                        fatalError()
                    }
                }
            }
            .fullScreenCover(isPresented: $isDetailViewPresented) {
                ItemDetailView(item: item)
            }

            Text(item.descrip)
                .font(.caption)
                .foregroundColor(.gray)
                .padding(.bottom, 5)

            HStack {
                Text("Stars: \(item.stars)")
                Spacer()
                Text(String(format: "$%.2f", item.price))
            }
            .font(.caption)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
        .padding(.bottom, 10)
    }
}



struct OurItemView_Previews: PreviewProvider {
    static var previews: some View {
        OurItemView()
    }
}
