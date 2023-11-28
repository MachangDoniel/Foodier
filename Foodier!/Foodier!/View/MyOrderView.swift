//
//  OrderView.swift
//  Foodier!
//
//  Created by Biduit on 25/11/23.
//


import SwiftUI
import Firebase

struct OrderCardView: View {
    @State private var order: Order
    @State private var foodName: String = ""
    @State private var userName: String = ""
    @State private var isStatusUpdated: Bool = false
    @State private var showAlert: Bool = false
    @State private var confirmCancel: Bool = false
    @State private var confirmDelete: Bool = false

    init(order: Order) {
        _order = State(initialValue: order)
    }

    var body: some View {
        VStack(alignment: .leading) {
            Text("Food Item Name: \(foodName)")
                .font(.headline)
                .fontWeight(.bold)

//            Text("User Name: \(userName)")
            Text("Contact Number: \(order.contact_no)")
            Text("Location: \(order.location)")
            Text("Quantity: \(order.quantity)")

            Spacer()

            switch order.status {
            case 1:
                Text("Order pending")
                Button(action: {
                    confirmCancel = true
                }) {
                    Text("Cancel Order")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red)
                        .cornerRadius(10)
                }
                .alert(isPresented: $confirmCancel) {
                    Alert(
                        title: Text("Confirmation"),
                        message: Text("Are you sure you want to cancel the order?"),
                        primaryButton: .default(Text("Yes")) {
                            rejectOrder()
                        },
                        secondaryButton: .cancel(Text("No"))
                    )
                }

            case 2:
                Text("Processing")

            case 3:
                Text("On Way")
                Button(action: {
                    showAlert = true
                }) {
                    Text("Received")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(10)
                }
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("Confirmation"),
                        message: Text("Have you received the order?"),
                        primaryButton: .default(Text("Yes")) {
                            acceptOrder()
                        },
                        secondaryButton: .cancel(Text("No"))
                    )
                }

            case 4:
                Text("Delivered")
                Button(action: {
                    confirmDelete = true
                }) {
                    Text("Delete Order")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red)
                        .cornerRadius(10)
                }
                .alert(isPresented: $confirmDelete) {
                    Alert(
                        title: Text("Confirmation"),
                        message: Text("Are you sure you want to delete the order?"),
                        primaryButton: .default(Text("Yes")) {
                            deleteOrder()
                        },
                        secondaryButton: .cancel(Text("No"))
                    )
                }

            case 0:
                Text("Your order has been canceled")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.red)
                    .cornerRadius(10)
                Button(action: {
                    confirmDelete = true
                }) {
                    Text("Delete Order")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red)
                        .cornerRadius(10)
                }
                .alert(isPresented: $confirmDelete) {
                    Alert(
                        title: Text("Confirmation"),
                        message: Text("Are you sure you want to delete the order?"),
                        primaryButton: .default(Text("Yes")) {
                            deleteOrder()
                        },
                        secondaryButton: .cancel(Text("No"))
                    )
                }

            default:
                Text("Unknown Status")
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
        order.status = 4

        // Update the order status in the database
        updateOrderStatus()
    }

    private func rejectOrder() {
        // Update the local order status
        order.status = 0

        // Update the order status in the database
        updateOrderStatus()
    }

    private func deleteOrder() {
        // Delete the order from the database
        let db = Firestore.firestore()
        let orderRef = db.collection("orders").document(order.id!)
        
        orderRef.delete { error in
            if let error = error {
                print("Error deleting order: \(error)")
            } else {
                print("Order deleted successfully!")
                isStatusUpdated = true
            }
        }
    }

    private func updateOrderStatus() {
        let db = Firestore.firestore()

        // Assuming the collection is named "orders"
        let orderRef = db.collection("orders").document(order.id!)

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

struct MyOrderView: View {
    @State private var orders: [Order] = []
    @State private var rotationAngle: Double = 0.0
    @State private var forceRedraw = false // Add this line

    var body: some View {
        NavigationView {
            VStack {
                // Navigation Bar
                VStack {
                    Text("My Orders")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.red)

                    HStack {
                        Spacer()
                        Button(action: {
                            // Add your refresh logic here
                            fetchOrdersFromFirestore()
                            forceRedraw.toggle() // Force a redraw
                        }) {
                            Image(systemName: "arrow.clockwise.circle")
                                .imageScale(.large)
                                .rotationEffect(.degrees(rotationAngle))
                        }
                        .padding()
                    }
                }
                .padding(.horizontal)
                .background(Color.white)

                // Orders List
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(orders, id: \.id) { order in
                            OrderCardView(order: order)
                        }
                    }
                    .padding()
                }
            }
            .id(forceRedraw) // Use the forceRedraw variable to force a redraw
            .onAppear {
                fetchOrdersFromFirestore()
            }
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
            .whereField("user_id", isEqualTo: currentUserID)
            .addSnapshotListener { querySnapshot, error in
                if let error = error {
                    print("Error getting orders: \(error)")
                } else {
                    // Use flatMap to transform documents into Order objects
                    let newOrders = querySnapshot?.documents.compactMap { document in
                        return try? document.data(as: Order.self)
                    } ?? []

                    // Update the orders after the rotation animation completes
                    withAnimation {
                        rotationAngle += 360.0
                    }

                    // Ensure UI updates on the main thread
                    DispatchQueue.main.async {
                        rotationAngle = 0.0
                        orders = newOrders
                    }
                }
            }
    }
}

struct MyOrderView_Previews: PreviewProvider {
    static var previews: some View {
        MyOrderView()
    }
}
