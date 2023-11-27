//
//  ItemDetailView.swift
//  Foodier! Restaurant
//
//  Created by Biduit on 13/11/23.
//

import SwiftUI
import Firebase
import CoreLocation

struct ItemDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    var item: FoodItem
    var selectedAddress: String?
    @State private var restaurantName: String = ""
    @State private var location: String = ""
    @State private var contactNumber: String = ""
    @State private var quantityValue: Int = 0
    @State private var restoID: String = ""
    @State private var isShowingConfirmation = false
    @State private var isFavorite = false

    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    AsyncImage(url: URL(string: item.image)) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                                .frame(height: 250)
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 250)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                        case .failure:
                            Image(systemName: "photo")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 250)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                        @unknown default:
                            fatalError()
                        }
                    }

                    Text(item.descrip)
                        .font(.body)
                        .padding()

                    HStack {
                        Text(String(format: "৳%.2f", item.price))
                        Spacer()

                        Button(action: {
                                                    isFavorite.toggle()
                                                    updateFavoriteStatus()
                                                }) {
                                                    Image(systemName: isFavorite ? "heart.fill" : "heart")
                                                        .font(.title)
                                                        .foregroundColor(.red)
                                                }

                    }
                    .font(.caption)



                    Text("Restaurant: \(restaurantName)")
                        .font(.headline)

                    HStack {
                        Button(action: {
                            quantityValue = max(quantityValue - 1, 0)
                        }) {
                            Image(systemName: "minus.circle")
                                .imageScale(.large)
                        }

                        Text("Add to Cart")
                            .font(.headline)
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)

                        Button(action: {
                            quantityValue += 1
                        }) {
                            Image(systemName: "plus.circle")
                                .imageScale(.large)
                        }
                    }

                    TextField("Quantity", value: $quantityValue, formatter: NumberFormatter())
                        .keyboardType(.numberPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()

                    TextField("Location", text: $location)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                        .onAppear {
                            location = selectedAddress ?? ""
                        }

                    TextField("Contact Number", text: $contactNumber)
                        .keyboardType(.numberPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()

                    Button("Place Order") {
                        createOrder()
                    }
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(10)
                    .padding()

                }
                .onAppear {
                    fetchRestaurantName()
                    setLocationAddress()
                    checkFavoriteStatus()
                }
                .navigationBarItems(leading: backButton)
                .navigationBarTitle(Text(item.title), displayMode: .inline)
                .padding()
            }
        }
    }

    var backButton: some View {
        Button(action: {
            presentationMode.wrappedValue.dismiss()
        }) {
            Image(systemName: "chevron.left")
                .font(.title)
                .foregroundColor(.blue)
        }
    }

    private func createOrder() {
        guard let user = Auth.auth().currentUser else {
            print("User not logged in")
            return
        }

        var order = Order(
            restaurant_id: restoID,
            user_id: user.uid,
            food_id: item.id,
            location: location,
            contact_no: contactNumber,
            quantity: quantityValue,
            status: 1
        )

        let db = Firestore.firestore()

        do {
            let documentReference = try db.collection("orders").addDocument(from: order)
            let generatedID = documentReference.documentID

            order.id = generatedID
            try db.collection("orders").document(generatedID).setData(from: order)

            print("Order placed successfully! Generated ID: \(generatedID)")
            isShowingConfirmation = true

            presentationMode.wrappedValue.dismiss()
        } catch let error {
            print("Error placing order: \(error.localizedDescription)")
        }
    }

    private func fetchRestaurantName() {
        let db = Firestore.firestore()

        let foodItemDocRef = db.collection("foodItems").document(item.id)

        foodItemDocRef.getDocument { document, error in
            if let error = error {
                print("Error getting food item document: \(error)")
            } else {
                if let foodItemData = document?.data(),
                   let restoID = foodItemData["id"] as? String {

                    self.restoID = restoID
                    let restaurantDocRef = db.collection("restaurants").document(restoID)

                    restaurantDocRef.getDocument { restaurantDocument, restaurantError in
                        if let restaurantError = restaurantError {
                            print("Error getting restaurant document: \(restaurantError)")
                        } else {
                            if let restaurantData = restaurantDocument?.data(),
                               let fullName = restaurantData["full_name"] as? String {
                                restaurantName = fullName
                            } else {
                                print("Failed to retrieve restaurant name")
                            }
                        }
                    }
                } else {
                    print("Food item data is nil or id field is missing")
                }
            }
        }
    }

    private func setLocationAddress() {
        guard let currentLocation = LocationManager.shared.location else {
            print("Current location not available.")
            return
        }

        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(currentLocation) { placemarks, error in
            if let error = error {
                print("Reverse geocoding failed with error: \(error.localizedDescription)")
            } else if let placemark = placemarks?.first {
                var addressString = ""

                if let locationName = placemark.name {
                    addressString += locationName
                }
                if let city = placemark.locality {
                    if !addressString.isEmpty {
                        addressString += ", "
                    }
                    addressString += city
                }
                if let country = placemark.country {
                    if !addressString.isEmpty {
                        addressString += ", "
                    }
                    addressString += country
                }
                location = addressString
            }
        }
    }

    private func checkFavoriteStatus() {
        guard let user = Auth.auth().currentUser else {
            print("User not logged in")
            return
        }

        let db = Firestore.firestore()
        let favoritesRef = db.collection("favourites").document(user.uid)

        favoritesRef.getDocument { document, error in
            if let error = error {
                print("Error checking favorite status: \(error)")
            } else {
                if let data = document?.data(),
                   let favorites = data["favorites"] as? [String],
                   favorites.contains(item.id) {
                    isFavorite = true
                }
            }
        }
    }

    private func updateFavoriteStatus() {
        guard let user = Auth.auth().currentUser else {
            print("User not logged in")
            return
        }

        let db = Firestore.firestore()
        let favoritesRef = db.collection("favourites").document(user.uid)

        favoritesRef.getDocument { document, error in
            if let error = error {
                print("Error updating favorite status: \(error)")
            } else {
                var favorites = document?.data()?["favorites"] as? [String] ?? []

                if isFavorite {
                    favorites.append(item.id)
                } else {
                    favorites.removeAll { $0 == item.id }
                }

                favoritesRef.setData(["favorites": favorites])
            }
        }
    }
}



struct ItemDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleFoodItem = FoodItem(id: "8", image: "item2", title: "Item 2", type: "Burger", descrip: "Description 2", stars: 5, price: 12.99)

        return ItemDetailView(item: sampleFoodItem)
    }
}
