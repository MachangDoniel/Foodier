//
//  NewOrdersView.swift
//  Foodier! Restaurant
//
//  Created by Biduit on 25/11/23.
//

import SwiftUI
import Firebase

struct OrderCardView2: View {
    @State private var order: Order
    @State private var foodName: String = ""
    @State private var userName: String = ""
    @State private var isStatusUpdated: Bool = false
    init(order: Order) {
        _order = State(initialValue: order)
    }

    var body: some View {
        VStack(alignment: .leading) {
            Text("Food Item Name: \(foodName)")
                .font(.headline)
                .fontWeight(.bold)

            Text("User Name: \(userName)")
            Text("Contact Number: \(order.contact_no)")
            Text("Quantity: \(order.quantity)")

            Spacer()

            HStack {
                Button(action: {
                    acceptOrder()
                }) {
                    Text("Start Delivery")
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.green)
                        .cornerRadius(10)
                }

                Button(action: {
                    rejectOrder()
                }) {
                    Text("Cook Later")
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.red)
                        .cornerRadius(10)
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
        .padding(.horizontal)
        .onAppear {
            fetchFoodItemName(foodID: order.food_id) { itemName in
                foodName = itemName
            }
            fetchUserName(userID: order.user_id) { name in
                userName = name
            }
        }
        .onChange(of: isStatusUpdated) { _ in
            // Handle page refresh logic here
            if isStatusUpdated {
                // Refresh the page or perform any other necessary actions
            }
        }
    }

    private func acceptOrder() {
            // Update the local order status
            order.status = 3

            // Update the order status in the database
            updateOrderStatus()
        }

        private func rejectOrder() {
            // Update the local order status
            order.status = 1

            // Update the order status in the database
            updateOrderStatus()
        }

    private func updateOrderStatus() {
        let db = Firestore.firestore()

        // Assuming the collection is named "orders"
        let orderRef = db.collection("orders").document(order.id!)
//        print("Order_Id: \(orderRef.documentID)")

        orderRef.updateData(["status": order.status]) { error in
            if let error = error {
                print("Error updating order status: \(error)")
                print("Order_Id: \(order.contact_no)")
            } else {
                print("Order status updated successfully!")
                isStatusUpdated = true
            }
        }
    }

    private func fetchFoodItemName(foodID: String, completion: @escaping (String) -> Void) {
        let db = Firestore.firestore()

        // Fetch food item name from "foodItems" based on food_id
        db.collection("foodItems").document(foodID).getDocument { document, error in
            if let error = error {
                print("Error getting food item document: \(error)")
            } else {
                if let foodItemData = document?.data(),
                   let itemName = foodItemData["title"] as? String {
                    completion(itemName)
                } else {
                    print("Failed to retrieve food item name")
                    completion("")
                }
            }
        }
    }

    private func fetchUserName(userID: String, completion: @escaping (String) -> Void) {
        let db = Firestore.firestore()

        // Fetch user name from "users" based on user_id
        db.collection("users").document(userID).getDocument { document, error in
            if let error = error {
                print("Error getting user document: \(error)")
            } else {
                if let userData = document?.data(),
                   let name = userData["full_name"] as? String {
                    completion(name)
                } else {
                    print("Failed to retrieve user name")
                    completion("")
                }
            }
        }
    }
}


struct ProcessingView: View {
    @State private var orders: [Order] = []

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(orders) { order in
                    if order.status == 2 {
                        OrderCardView2(order: order)
                    }
                }
            }
            .padding()
        }
        .onAppear {
            fetchOrdersFromFirestore()
        }
    }

    private func fetchOrdersFromFirestore() {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            print("No user is logged in")
            return
        }

        let db = Firestore.firestore()

        // Assuming the collection is named "orders"
        db.collection("orders")
            .whereField("restaurant_id", isEqualTo: currentUserID)
            .whereField("status", isEqualTo: 2) // Assuming 1 is the raw value for OrderStatus.pending
            .addSnapshotListener { querySnapshot, error in
                if let error = error {
                    print("Error getting orders: \(error)")
                } else {
                    orders = querySnapshot?.documents.compactMap { document in
                        var order = try? document.data(as: Order.self)
                        order?.id = document.documentID // Set the document ID in the Order model
                        return order
                    } ?? []
                }
            }
    }
}




struct ProcessingView_Previews: PreviewProvider {
    static var previews: some View {
        ProcessingView()
    }
}
