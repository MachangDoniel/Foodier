//
//  AddItemView.swift
//  Foodier! Restaurant
//
//  Created by Biduit on 16/11/23.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseStorage

struct AddItemView: View {
    @State private var id: String = "0"
    @State private var image: UIImage? = nil
    @State private var title: String = ""
    @State private var type: String = ""
    @State private var descrip: String = ""
    @State private var price: Double = 100.0
    @State private var stars: Int = 0
    @State private var isImagePickerPresented: Bool = false
    @State private var isMessageSheetPresented = false
    
    @Environment(\.presentationMode) var presentationMode

    // Define the types you want to show in the Picker
    let types = ["Pizza","Pasta","Burger","Chicken Biriyani","Beef Biriyani","Mutton Biriyani","Chicken Fry","Chicken Wings","Mutton Curry","Sushi","Bekari","Dessert","Pestry","Ice Cream","Nachos","Juices","Coffee","Vegan Food","Asian Cuisine","Itaian Cuisine","Chinese Cuisine","Other"]

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Item Details")) {
                    // TextField("ID", value: $id, formatter: NumberFormatter())
                    
                    HStack {
                        Text("Title:")
                        TextField("Title", text: $title)
                        
                    }
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    // Use Picker for the "Type" field
                    Picker("Type", selection: $type) {
                        ForEach(types, id: \.self) {
                            Text($0)
                        }
                    }
                    HStack {
                        Text("Price:")
                        TextField("Price", value: $price, formatter: NumberFormatter())
                        
                    }
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    HStack {
                            Text("Description")
                            Spacer() // Add spacer for better alignment
                        }

                        TextEditor(text: $descrip)
                            .frame(minHeight: 100) // Set a minimum height for better visibility
                            .cornerRadius(8)

                }

//                Section(header: Text("Rating")) {
//                    Stepper(value: $stars, in: 0...5, step: 1) {
//                        Text("Stars: \(stars)")
//                    }
//                }

                Section(header: Text("Item Image")) {
                    Button(action: {
                        isImagePickerPresented.toggle()
                    }) {
                        Text("Select Image")
                    }

                    // Display the selected image in a small block
                    if let selectedImage = image {
                        Image(uiImage: selectedImage)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .cornerRadius(8)
                            .padding(.top, 8)
                    }
                }

                // Submit button
                Section {
                    Button("Submit") {
                        // Handle the form submission here
                        submitForm()
                    }
                }
            }
            .imagePicker(isPresented: $isImagePickerPresented, image: $image)
            .navigationTitle("Add Item")
            .overlay(
                MessageSheet(
                    message: "Data added successfully!",
                    onDone: {
                        // Handle "Done" button action
                        // You can navigate to the HomeView or perform other actions
                        clearForm()
                        isMessageSheetPresented = false
                        presentationMode.wrappedValue.dismiss()
                    }
                )
                .offset(y: isMessageSheetPresented ? 0 : UIScreen.main.bounds.height)
                //                .animation(.spring())
            )
            .onAppear {
                id = getRestaurantId()
            }
        }
    }
    
    private func clearForm() {
        id = getRestaurantId()
        image = nil
        title = ""
        type = ""
        descrip = ""
        price = 100.0
        stars = 0
    }

    func submitForm() {
        // Check if any value is empty
        guard !title.isEmpty, !type.isEmpty, !descrip.isEmpty else {
            print("Please fill in all required fields.")
            return
        }

        // Convert UIImage to Data
        guard let imageData = image?.jpegData(compressionQuality: 0.5) else {
            print("Error converting image to data.")
            return
        }

        // Create a unique ID based on the current date and time
        let uniqueID = UUID().uuidString

        // Get the Storage reference path without uploading the image
        let storagePath = "item_images/\(uniqueID).jpg"

        // Create a Firestore document reference
        let db = Firestore.firestore()
        let foodItemsCollection = db.collection("foodItems")

        // Create a Storage reference
        let storage = Storage.storage()
        let storageRef = storage.reference().child(storagePath)

        // Inside the image upload completion block
        storageRef.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                print("Error uploading image: \(error.localizedDescription)")
            } else {
                print("Image uploaded successfully!")
                print("Image path: \(storagePath)")

                // Inside the URL retrieval completion block
                storageRef.downloadURL { url, error in
                    if let error = error {
                        print("Error getting download URL: \(error.localizedDescription)")
                    } else if let downloadURL = url?.absoluteString {
                        print("Download URL: \(downloadURL)")

                        // Continue with the Firestore document creation
                        let newItem = FoodItem(
                            id: getRestaurantId(),
                            image: downloadURL,
                            title: title,
                            type: type,
                            descrip: descrip,
                            stars: stars,
                            price: price
                        )

                        // Add the data to Firestore
                        do {
                            try foodItemsCollection.addDocument(from: newItem) { error in
                                if let error = error {
                                    print("Error adding document to Firestore: \(error)")
                                } else {
                                    print("Document added to Firestore successfully!")
                                    // Show the message sheet
                                    isMessageSheetPresented = true
                                }
                            }
                        } catch {
                            print("Error encoding item: \(error)")
                        }
                    }
                }
            }
        }
    }

    private func getRestaurantId() -> String {
        // Add your logic to retrieve the current user's restaurant ID from Firebase Authentication or wherever it's stored
        // For example, if you have a user object, you might do something like:
        if let currentUser = Auth.auth().currentUser {
            return currentUser.uid
        }
        return "0" // Return a default value if the user is not logged in or if the ID is not available
    }
}

struct AddItemView_Previews: PreviewProvider {
    static var previews: some View {
        AddItemView()
    }
}

struct MessageSheet: View {
    var message: String
    var onDone: () -> Void

    var body: some View {
        VStack {
            Text(message)
                .font(.headline)
                .padding()

            HStack {
                Spacer()

                Button("Done") {
                    onDone()
                }
                .foregroundColor(.green)
            }
            .padding()
        }
        .frame(width: 300, height: 150)
        .background(Color.white)
        .cornerRadius(16)
        .padding()
    }
}
