//
//  OrderView.swift
//  Foodier! Restaurant
//
//  Created by Biduit on 25/11/23.
//


import SwiftUI

struct OrderView: View {
    @State private var selectedTab = 1
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Order Queue")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()

                Picker("", selection: $selectedTab) {
                    Text("New Orders").tag(1)
                    Text("Processing").tag(2)
                    Text("On Way").tag(3)
                    Text("Delivered").tag(4)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)

                Spacer()

                switch selectedTab {
                case 1:
                    NewOrdersView()
                case 2:
                    ProcessingView()
                case 3:
                    OnWayView()
                case 4:
                    DeliveredView()
                default:
                    EmptyView()
                }

                Spacer()
            }
            .navigationBarHidden(true)
        }
    }
}

struct OrderView_Previews: PreviewProvider {
    static var previews: some View {
        OrderView()
    }
}
