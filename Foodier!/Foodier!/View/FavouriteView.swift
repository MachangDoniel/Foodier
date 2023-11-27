//
//  FavouriteView.swift
//  Foodier!
//
//  Created by Biduit on 27/11/23.
//

import SwiftUI
import Firebase
import CoreLocation

struct FavouriteView: View {
    @State private var searchText = ""
    @State private var items: [FoodItem] = []
    @State private var selectedLocation: CLLocation?
    @State private var isShowingMapView = false
    @State private var selectedAddress: String?
    @State private var userId: String?

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
                HStack {
                    Text("My Favourite Items!")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding()
                        .foregroundColor(.primary)
                        .lineLimit(nil)
                        .shadow(radius: 5)
                }

                HStack {
//                    Button(action: {
//                        isShowingMapView = true
//                    }) {
//                        Image(systemName: "location.fill")
//                            .font(.system(size: 15))
//                            .foregroundColor(.blue)
//                    }
//                    .fullScreenCover(isPresented: $isShowingMapView) {
//                        MapView(selectedLocation: $selectedLocation) { location, address in
//                            // Handle the selected location and address
//                            selectedLocation = location
//                            selectedAddress = address
//                            isShowingMapView = false
//                        }
//                        .edgesIgnoringSafeArea(.all)
//                    }

//                    if let selectedAddress = selectedAddress {
//                        Text("Selected: \(selectedAddress)")
//                            .font(.system(size: 12))
//                            .foregroundColor(.primary)
//                            .lineLimit(nil)
//                            .background(Color.green)
//                            .cornerRadius(8)
//                    } else {
//                        Text("Not selected")
//                            .font(.system(size: 12))
//                            .padding()
//                            .foregroundColor(.primary)
//                            .lineLimit(nil)
//                            .cornerRadius(8)
//                    }
                }
                // Search Bar
//                SearchBar(text: $searchText)

                // Display Cards
                ScrollView {
                    LazyVGrid(columns: [
                        GridItem(.flexible(), spacing: 16),
                        GridItem(.flexible(), spacing: 16)
                    ], spacing: 20) { // Increase the spacing value as needed
                        ForEach(filteredItems.indices, id: \.self) { index in
                            let selectedItem = filteredItems[index]
                            CardView(item: selectedItem, selectedAddress: selectedAddress)
                                .frame(width: 150, height: 250) // Adjust the size as needed
                        }
                        .padding()

                    }
                    .padding()
                }
            }
            .onAppear {
                print("Fetching data from firestore")
                if let user = Auth.auth().currentUser {
                    userId = user.uid
//                    self.userId = userId
                    fetchDataFromFirestore()
                } else {
                    print("No user is currently authenticated.")
                }
            }
        }
    }
    
    
    private func fetchDataFromFirestore() {
        guard let userId = userId else {
            print("Return")
            return
        }

        let db = Firestore.firestore()
        let favoritesRef = db.collection("favourites").document(userId)

        favoritesRef.addSnapshotListener { documentSnapshot, error in
            if let error = error {
                print("Error getting favorites document: \(error)")
                return
            }

            guard let document = documentSnapshot else {
                print("Favorites document does not exist")
                return
            }

            if let data = document.data(),
               let favoriteItemIds = data["favorites"] as? [String] {
                print("Favorite Item IDs: \(favoriteItemIds)")
                fetchFoodItems(for: favoriteItemIds)
            } else {
                print("No favorite item IDs found")
                // If there are no favorite item IDs, clear the items array
                items = []
            }
        }
    }

    

    private func fetchFoodItems(for itemIds: [String]) {
        let db = Firestore.firestore()
        let foodItemsRef = db.collection("foodItems")

        foodItemsRef.whereField(FieldPath.documentID(), in: itemIds).getDocuments { querySnapshot, error in
            if let error = error {
                print("Error getting documents: \(error)")
                return
            }

            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }

            // Update the items array on the main thread
            DispatchQueue.main.async {
                items = documents.compactMap { document in
                    var foodItem = try? document.data(as: FoodItem.self)
                    foodItem?.id = document.documentID
                    return foodItem
                }
            }
        }
    }




    

    private func getAddress(from location: CLLocation) -> String {
        // Use reverse geocoding to get the address from the location
        let geocoder = CLGeocoder()
        var addressString = ""

        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            if let error = error {
                print("Reverse geocoding failed with error: \(error.localizedDescription)")
            } else if let placemark = placemarks?.first {
                if let city = placemark.locality {
                    addressString += city
                }
                if let country = placemark.country {
                    if !addressString.isEmpty {
                        addressString += ", "
                    }
                    addressString += country
                }
                // Add more components as needed
            }
        }

        return addressString
    }
}

//struct CardView: View {
//    @State private var isDetailViewPresented = false
//    var item: FoodItem
//    var selectedAddress: String?
//
//    var body: some View {
//        VStack(spacing: 8) {
//            Text(item.title)
//                .font(.headline)
//                .padding(.bottom, 5)
//
//            Button(action: {
//                isDetailViewPresented.toggle()
//                // Print selectedAddress when the button is tapped
//                print("Selected Address in CardView: \(selectedAddress ?? "Not available")")
//            }) {
//                // Use AsyncImage to load and display the image from the URL
//                AsyncImage(url: URL(string: item.image)) { phase in
//                    switch phase {
//                    case .empty:
//                        ProgressView()
//                            .frame(height: 150)
//                    case .success(let image):
//                        image
//                            .resizable()
//                            .aspectRatio(contentMode: .fit)
//                            .frame(height: 150)
//                            .clipShape(RoundedRectangle(cornerRadius: 10))
//                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
//                            .padding(.bottom, 5)
//                    case .failure:
//                        Image(systemName: "photo")
//                            .resizable()
//                            .aspectRatio(contentMode: .fit)
//                            .frame(height: 150)
//                            .clipShape(RoundedRectangle(cornerRadius: 10))
//                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
//                            .padding(.bottom, 5)
//                    @unknown default:
//                        fatalError()
//                    }
//                }
//            }
//            .fullScreenCover(isPresented: $isDetailViewPresented) {
//                ItemDetailView(item: item, selectedAddress: selectedAddress)
//            }
//
//            Text(item.descrip)
//                .font(.caption)
//                .foregroundColor(.gray)
//                .padding(.bottom, 5)
//
//            HStack {
//                Text("Stars: \(item.stars)")
//                Spacer()
//                Text(String(format: "$%.2f", item.price))
//            }
//            .font(.caption)
//
////            if let selectedAddress = selectedAddress {
////                Text("Selected Address: \(selectedAddress)")
////                    .font(.caption)
////                    .foregroundColor(.blue)
////                    .padding(.bottom, 5)
////            }
//        }
//        .padding()
//        .background(Color.white)
//        .cornerRadius(10)
//        .shadow(radius: 5)
//        .padding(.bottom, 10)
//    }
//}

struct Favourite_Previews: PreviewProvider {
    static var previews: some View {
        FavouriteView()
    }
}

