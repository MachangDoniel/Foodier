//
//  SettingsView.swift
//  Foodier!
//
//  Created by Biduit on 13/11/23.
//

import SwiftUI

struct SettingsView: View {
    @State private var isProfileViewActive = false

    var body: some View {
        NavigationView {
            ScrollView {
                ZStack {
                    Color(#colorLiteral(red: 0.9021687508, green: 0.1747280955, blue: 0.318703413, alpha: 1))
                        .frame(width: 600, height: 600)
                        .edgesIgnoringSafeArea(.all)
                        .cornerRadius(300)
                        .offset(x: -50, y: -350)
                    Color(#colorLiteral(red: 0.9617715478, green: 0.1775636971, blue: 0.3371206522, alpha: 1))
                        .frame(width: 300, height: 300)
                        .edgesIgnoringSafeArea(.all)
                        .cornerRadius(300)

                    NavigationLink(
                        destination: ProfileView(),
                        label: {
                            Text("Go to Profile")
                                .font(.headline)
                                .padding()
                                .foregroundColor(.white)
                                .background(Color.blue)
                                .cornerRadius(10)
                        }
                    )
                }

                HStack {
                    Text("Order")
                        .bold()
                        .font(.title)
                    Spacer()
                    Text("Close")
                        .font(.title2)
                }
                .padding(.all, 20)
                .foregroundColor(.white)
                .frame(width: UIScreen.main.bounds.width)
                .padding(.top, -250)

            }
            .navigationBarHidden(true)
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
