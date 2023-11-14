//
//  HomeViewModel.swift
//  Foodier! Restaurant
//
//  Created by Biduit on 13/11/23.
//

import Foundation
import SwiftUI
import CoreLocation

// Fetching User Location....
class HomeViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var locationManager = CLLocationManager()
    @Published var search = ""
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        // checking Location Access
        
        switch manager.authorizationStatus {
        case .authorizedWhenInUse:
            print("authorized")
        case .denied:
            print("denied")
        default:
            print("unknown")
            // Direct Call
//            locationManager.requestWhenInUseAuthorization()
            // Modifying Info.plist
        }
        
        func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
            print(error.localizedDescription)
        }
        
//        func locationManager(
    }
}
