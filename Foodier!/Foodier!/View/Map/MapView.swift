//
//  MapView.swift
//  Foodier!
//
//  Created by Biduit on 27/11/23.
//


import SwiftUI
import MapKit
import CoreLocation

struct MapView: View {
    @Binding var selectedLocation: CLLocation?
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 22.8747, longitude: 89.5403), // KUET, Khulna
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )

    // Closure to notify the parent view about the selected location and address
    var onLocationSelected: ((CLLocation?, String) -> Void)?
    @State private var isLocationAlertPresented = false

    var body: some View {
        VStack {
            Map(coordinateRegion: $region, showsUserLocation: true)
                .onAppear {
                    if let location = LocationManager.shared.location?.coordinate {
                        region.center = location
                    }
                }
                .onTapGesture {
                    let tappedLocation = CLLocation(latitude: region.center.latitude, longitude: region.center.longitude)
                    if tappedLocation.coordinate.latitude != 22.8747 && tappedLocation.coordinate.longitude != 89.5403 {
                        selectedLocation = tappedLocation
                    }

                    // Get the address for the tapped location
                    getAddress(for: tappedLocation) { address in
                        // Notify the parent view about the selected location and address
                        onLocationSelected?(selectedLocation, address)
                    }
                }


            Button("Use Current Location") {
                if let location = LocationManager.shared.location {
                    print("Selected Location: \(location.coordinate.latitude), \(location.coordinate.longitude)")

                    selectedLocation = location

                    // Get the address for the current location
                    getAddress(for: selectedLocation) { address in
                        // Notify the parent view about the selected location and address
                        onLocationSelected?(selectedLocation, address)
                    }
                } else {
                    print("Current location not available.")
                    isLocationAlertPresented = true
                }
            }
            .padding()
            .foregroundColor(.white)
            .background(Color.blue)
            .cornerRadius(10)

            Button("Choose Another Location") {
            }
            .padding()
            .foregroundColor(.white)
            .background(Color.green)
            .cornerRadius(10)
        }
        .alert(isPresented: $isLocationAlertPresented) {
            Alert(
                title: Text("Location Services Disabled"),
                message: Text("Please turn on your device's location services in Settings."),
                dismissButton: .default(Text("OK"))
            )
        }
    }

    // Function to get the address for a given location
    private func getAddress(for location: CLLocation?, completion: @escaping (String) -> Void) {
        guard let location = location else {
            completion("")
            return
        }

        // Use reverse geocoding to get the address from the location
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            if let error = error {
                print("Reverse geocoding failed with error: \(error.localizedDescription)")
                completion("")
            } else if let placemark = placemarks?.first {
                var addressString = ""

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

                completion(addressString)
            }
        }
    }
}
