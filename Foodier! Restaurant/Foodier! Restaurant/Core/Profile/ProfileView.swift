//
//  ProfileView.swift
//  Foodier!
//
//  Created by Biduit on 11/11/23.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        if let user = viewModel.currentUser {
            NavigationView {
                List {
                    Section {
                        HStack {
                            Text(user.initials)
                                .font(.title)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .frame(width: 72, height: 72)
                                .background(Color(.systemGray3))
                                .clipShape(Circle())

                            VStack(alignment: .leading, spacing: 4) {
                                Text(user.full_name)
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .padding(.top, 4)

                                Text(user.email)
                                    .font(.footnote)
                                    .foregroundColor(.gray)
                            }
                        }
                    }

                    Section("General") {
                        HStack {
                            SettingsRowView(imageName: "gear", title: "Version", tintColor: Color(.systemGray))

                            Spacer()

                            Text("1.0.0")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }

                    Section("Account") {
                        Button {
                            viewModel.signOut()
                        } label: {
                            SettingsRowView(imageName: "arrow.left.circle.fill", title: "Sign Out", tintColor: .red)
                        }

                        // Add more buttons if needed
                    }
                }
                .navigationBarTitle("Profile", displayMode: .inline)
                .navigationBarItems(
                    leading: Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .imageScale(.large)
                            .foregroundColor(.accentColor)
                    }
                )
            }
            .navigationBarBackButtonHidden(true)
        } else {
            NavigationView {
                List {
                    Section {
                        HStack {
                            Text(Restaurant.mock_user.initials)
                                .font(.title)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .frame(width: 72, height: 72)
                                .background(Color(.systemGray3))
                                .clipShape(Circle())

                            VStack(alignment: .leading, spacing: 4) {
                                Text(Restaurant.mock_user.full_name)
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .padding(.top, 4)

                                Text(Restaurant.mock_user.email)
                                    .font(.footnote)
                                    .foregroundColor(.gray)
                            }
                        }
                    }

                    Section("General") {
                        HStack {
                            SettingsRowView(imageName: "gear", title: "Version", tintColor: Color(.systemGray))

                            Spacer()

                            Text("1.0.0")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }

                    Section("Account") {
                        Button {
                            viewModel.signOut()
                        } label: {
                            SettingsRowView(imageName: "arrow.left.circle.fill", title: "Sign Out", tintColor: .red)
                        }

                        // Add more buttons if needed
                    }
                }
                .navigationBarTitle("Profile", displayMode: .inline)
                .navigationBarItems(
                    leading: Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .imageScale(.large)
                            .foregroundColor(.accentColor)
                    }
                )
            }
            .navigationBarBackButtonHidden(true)
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
            .environmentObject(AuthViewModel())
    }
}
