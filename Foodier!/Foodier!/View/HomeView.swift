//
//  Restaurant.swift
//  Foodier! Restaurant
//
//  Created by Biduit on 13/11/23.
//


import SwiftUI
import Firebase
import CoreLocation

struct HomeView: View {
    @State private var searchText = ""
        @State private var items: [FoodItem] = []
        @State private var selectedLocation: CLLocation?
        @State private var selectedType: String = "X" // Default type
        @State private var isShowingMapView = false
        @State private var selectedAddress: String?

    var filteredItems: [FoodItem] {
        if searchText.isEmpty {
            if selectedType == "X" {
                return items
            } else {
                return items.filter { $0.type == selectedType }
            }
        } else {
            if selectedType == "X" {
                return items.filter { $0.title.lowercased().contains(searchText.lowercased()) }
            } else {
                return items.filter { $0.type == selectedType && $0.title.lowercased().contains(searchText.lowercased()) }
            }
        }
    }

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Text("Available Items!")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding()
                        .foregroundColor(.primary)
                        .lineLimit(nil)
                        .shadow(radius: 5)
                }

                HStack {
                    Button(action: {
                        isShowingMapView = true
                    }) {
                        Image(systemName: "location.fill")
                            .font(.system(size: 15))
                            .foregroundColor(.blue)
                    }
                    .fullScreenCover(isPresented: $isShowingMapView) {
                        MapView(selectedLocation: $selectedLocation) { location, address in
                            // Handle the selected location and address
                            selectedLocation = location
                            selectedAddress = address
                            isShowingMapView = false
                        }
                        .edgesIgnoringSafeArea(.all)
                    }

                    if let selectedAddress = selectedAddress {
                        Text("Selected: \(selectedAddress)")
                            .font(.system(size: 12))
                            .foregroundColor(.primary)
                            .lineLimit(nil)
                            .background(Color.green)
                            .cornerRadius(8)
                    } else {
                        Text("Not selected")
                            .font(.system(size: 12))
                            .padding()
                            .foregroundColor(.primary)
                            .lineLimit(nil)
                            .cornerRadius(8)
                    }
                }
                // Search Bar
                SearchBar(text: $searchText)

                // Types Horizontal ScrollView
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(["X","Pizza","Pasta","Burger","Chicken Biriyani","Beef Biriyani","Mutton Biriyani","Chicken Fry","Chicken Wings","Mutton Curry","Sushi","Bekari","Dessert","Pestry","Ice Cream","Nachos","Juices","Coffee","Vegan Food","Asian Cuisine","Itaian Cuisine","Chinese Cuisine","Other"], id: \.self) { type in
                            Button(action: {
                                withAnimation {
                                    selectedType = type
                                    searchText = "" // Reset search text when a type is selected
                                }
                            }) {
                                Text(type)
                                    .font(.subheadline)
                                    .padding(8)
                                    .foregroundColor(type == selectedType ? .white : .blue)
                                    .background(type == selectedType ? Color.blue : Color.white)
                                    .cornerRadius(10)
                            }
                        }
                    }
                    .padding()
                }
                .background(Color.gray.opacity(0.1))
                .cornerRadius(15)
                .padding(.horizontal, 16)
                .padding(.bottom, 10)
                
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


struct CardView: View {
    @State private var isDetailViewPresented = false
    var item: FoodItem
    var selectedAddress: String?

    var body: some View {
        VStack(spacing: 8) {
            Text(item.title)
                .font(.headline)
                .padding(.bottom, 5)

            Button(action: {
                isDetailViewPresented.toggle()
                // Print selectedAddress when the button is tapped
                print("Selected Address in CardView: \(selectedAddress ?? "Not available")")
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
                ItemDetailView(item: item, selectedAddress: selectedAddress)
            }

            Text(item.descrip)
                .font(.caption)
                .foregroundColor(.gray)
                .padding(.bottom, 5)

            HStack {
                Text("\(item.type)")
                Spacer()
                Text(String(format: "$%.2f", item.price))
            }
            .font(.caption)

//            if let selectedAddress = selectedAddress {
//                Text("Selected Address: \(selectedAddress)")
//                    .font(.caption)
//                    .foregroundColor(.blue)
//                    .padding(.bottom, 5)
//            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
        .padding(.bottom, 10)
    }
}




struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

