//
//  Home.swift
//  Foodier!
//
//  Created by Biduit on 11/11/23.
//

import SwiftUI

struct Home: View {
    
    @StateObject var HomeModel = HomeViewModel()
    
    var body: some View {
        VStack(spacing: 10) {
            HStack(spacing: 15) {
                Button(action: {}, label: {
                    Image(systemName: "line.horizontal.3")
                        .font(.title)
                        .foregroundColor(.pink)
                })
                
                Text("Foodier!")
                    .foregroundColor(.black)
                
                Text("Apple")
                    .font(.caption)
                    .fontWeight(.heavy)
                    .foregroundColor(.pink)
                Spacer(minLength: 0)
            }
            .padding([.horizontal,.top])
            .padding(.top,10)
            
            Divider()
            
            HStack(spacing: 15) {
                TextField("Search", text: $HomeModel.search)
                
                if HomeModel.search != "" {
                    Button(action: {}, label: {
                        Image(systemName: "magnifyingglass")
                            .font(.title2)
                            .foregroundColor(.gray)
                    })
                    .onTapGesture {
                        withAnimation(.easeIn) {
                            // Your action code here
                        }
                    }
                }
            }
            .padding(.horizontal)
            .padding(.top, 10)
            
            Divider()
            
            Spacer()
        }
        .onAppear(perform: {
            // Calling Location Deligate....
            HomeModel.locationManager.delegate = HomeModel
            HomeModel.locationManager.requestWhenInUseAuthorization()
            // Modifying Info.plist
        })
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
