//
//  ProfileView.swift
//  Foodier! Restaurant
//
//  Created by Biduit on 13/11/23.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @State private var isMenuVisible = false

    var body: some View {
        NavigationView {
            ZStack(alignment: .leading) {
                VStack {
                    HStack {
                        Button(action: {
                            withAnimation {
                                isMenuVisible.toggle()
                            }
                        }) {
                            Image(systemName: "line.horizontal.3")
                                .imageScale(.large)
                                .padding()
                        }

                        Spacer()
                    }
                    .background(.white)
                    .foregroundColor(.black)

                    Spacer()
                }

                if isMenuVisible {
                    SideMenuBarView(isMenuVisible: $isMenuVisible)
                        .frame(width: UIScreen.main.bounds.width * 3 / 5, height: UIScreen.main.bounds.height - 20)
                        .background(Color.white)
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            withAnimation {
                                isMenuVisible.toggle()
                            }
                        }
                }
            }
            .background(Color.white)
            .onTapGesture {
                // Close the sidebar when tapping outside of it
                withAnimation {
                    isMenuVisible = false
                }
            }
        }
    }
}

struct SideMenuBarView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @Binding var isMenuVisible: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Menu")
                .font(.title)
                .foregroundColor(.black)
                .padding(.top, 20)
                .padding(.leading, 20)

            Button {
                viewModel.signOut()
            } label: {
                HStack {
                    Image(systemName: "arrow.left.circle.fill")
                        .foregroundColor(.red)
                    Text("Sign Out")
                        .foregroundColor(.black)
                }
                .padding(.leading, 20)
                .padding(.top, 50)
            }

            Spacer()
        }
        .frame(width: UIScreen.main.bounds.width * 3 / 5, height: UIScreen.main.bounds.height - 20, alignment: .leading)
        .background(Color(white: 0.80))
        .edgesIgnoringSafeArea(.all)
    }
}

struct Card: View {
    var title: String
    var cardColor: Color

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(cardColor)
                .shadow(radius: 5)

            Text(title)
                .font(.title)
                .foregroundColor(.white)
        }
        .frame(height: 150)
        .padding(.horizontal)
        .padding(.vertical, 10)
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
