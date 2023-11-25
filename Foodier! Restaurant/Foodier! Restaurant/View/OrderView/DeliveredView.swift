//
//  NewOrdersView.swift
//  Foodier! Restaurant
//
//  Created by Biduit on 25/11/23.
//

import SwiftUI
import Firebase



struct DeliveredView: View {
    @State private var orders: [Order] = []

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(orders) { order in
                    if order.status == 4 {
                        OrderCardView3(order: order)
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
            .whereField("status", isEqualTo: 4) // Assuming 1 is the raw value for OrderStatus.pending
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




struct DeliveredView_Previews: PreviewProvider {
    static var previews: some View {
        DeliveredView()
    }
}
