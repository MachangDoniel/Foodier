//
//  Restaurant.swift
//  Foodier! Restaurant
//
//  Created by Biduit on 13/11/23.
//

import SwiftUI
import Firebase

struct ItemDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    var item: FoodItem
    @State private var restaurantName: String = ""
    @State private var location: String = ""
    @State private var contactNumber: String = ""
    @State private var quantity: String = ""
    @State private var restoID: String = ""
    @State private var isShowingConfirmation = false

    var body: some View {
        NavigationView {
            VStack {
                Text(item.title)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()

                // Display item details
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
                            .padding(.bottom, 10)
                    case .failure:
                        Image(systemName: "photo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 250)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                            .padding(.bottom, 10)
                    @unknown default:
                        fatalError()
                    }
                }

                Text(item.descrip)
                    .font(.body)
                    .padding()

                HStack {
                    Text("Stars: \(item.stars)")
                    Spacer()
                    Text(String(format: "$%.2f", item.price))
                }
                .font(.caption)
                .padding()
                
                Text("Restaurant: \(restaurantName)")
                    .font(.headline)
                    .padding()
                
                // User input fields
                TextField("Location", text: $location)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                TextField("Contact Number", text: $contactNumber)
                    .keyboardType(.numberPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                TextField("Quantity", text: $quantity)
                    .keyboardType(.numberPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                // Place Order button
                Button("Place Order") {
                    createOrder()
                }
                .padding()
                .foregroundColor(.white)
                .background(Color.blue)
                .cornerRadius(10)
                .padding()
                .alert(isPresented: $isShowingConfirmation) {
                       Alert(title: Text("Order Placed"), message: Text("Your order has been successfully placed."), dismissButton: .default(Text("OK")))
                   }


                Spacer()
            }
            .onAppear {
                fetchRestaurantName()
            }
            .navigationBarItems(leading: backButton)
            .navigationBarTitle(Text(item.title), displayMode: .inline)
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
            quantity: Int(quantity) ?? 0,
            status: 1
        )

        let db = Firestore.firestore()
        
        do {
            let documentReference = try db.collection("orders").addDocument(from: order)
            let generatedID = documentReference.documentID
            
            // Update the order with the generated ID
            order.id = generatedID
            
            // Update the document with the generated ID
            try db.collection("orders").document(generatedID).setData(from: order)
            
            print("Order placed successfully! Generated ID: \(generatedID)")
            isShowingConfirmation = true
        } catch let error {
            print("Error placing order: \(error.localizedDescription)")
        }
    }

    
    
    
    private func fetchRestaurantName() {
        let db = Firestore.firestore()

        // Assuming item.id represents the ID of the document in "foodItems"
        let foodItemDocRef = db.collection("foodItems").document(item.id)

        foodItemDocRef.getDocument { document, error in
            if let error = error {
                print("Error getting food item document: \(error)")
            } else {
                if let foodItemData = document?.data(),
                   let restoID = foodItemData["id"] as? String {
                    
                    self.restoID = restoID
                    // Now fetch the restaurant document using restoID
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
}


struct ItemDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleFoodItem = FoodItem(id: "8", image: "item2", title: "Item 2", type: "Burger", descrip: "Description 2", stars: 5, price: 12.99)

        return ItemDetailView(item: sampleFoodItem)
    }
}






