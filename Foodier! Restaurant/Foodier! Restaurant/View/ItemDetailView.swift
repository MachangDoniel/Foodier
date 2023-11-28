//
//  Restaurant.swift
//  Foodier! Restaurant
//
//  Created by Biduit on 13/11/23.
//

import SwiftUI
import FirebaseFirestoreSwift
import FirebaseCoreExtension
import FirebaseFirestoreInternalWrapper

struct ItemDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    var item: FoodItem
    @State private var restaurantName: String = ""
    

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
                    Text("\(item.type)")
                    Spacer()
                    Text(String(format: "$%.2f", item.price))
                }
                .font(.caption)
                .padding()
                
                Text("Restaurant: \(restaurantName)")
                                    .font(.headline)
                                    .padding()
                
                Spacer()
            }
            .onAppear {
                       fetchRestaurantName()
                   }
        
            //.navigationTitle(item.title)
            .navigationBarItems(leading: backButton)
            Image(systemName: "xmark")
                .foregroundColor(.white)
                .padding()
                .background(Color.black.opacity(0.8))
                .clipShape(Circle())
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
