//
//  AuthViewModel.swift
//  Foodier! Restaurant
//
//  Created by Biduit on 13/11/23.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

protocol AuthenticationFormProtocol {
    var formIsValid: Bool {get }
}

@MainActor
class AuthViewModel: ObservableObject {
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: Restaurant?

    init() {
        self.userSession = Auth.auth().currentUser

        Task {
            await fetchUser()
        }
    }
    func signIn(withEmail email: String, password: String) async throws {
//        print("Sign In..")
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
            await fetchUser()
        } catch {
            print("Debug: Failed to log in with error \(error.localizedDescription)")
        }
    }
    func createUser(withEmail email: String, password: String, fullname: String) async throws {
//        print("Create User..")
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user
            let user = Restaurant(id: result.user.uid, full_name: fullname, email: email)
            let encoderUser = try Firestore.Encoder().encode(user)
            try await Firestore.firestore().collection("restaurants").document(user.id).setData(encoderUser)
            await fetchUser()
        } catch {
            print("Debug: failed to create user with error \(error.localizedDescription)")
        }
    }
    func signOut() {
        do {
            try Auth.auth().signOut()
            self.userSession = nil
            self.currentUser = nil
        } catch {
            print("Debug: Failed to sign out with error \(error.localizedDescription)")
        }
    }
    func deleteAccount() {

    }
    func fetchUser() async {
        guard let uid = Auth.auth().currentUser?.uid else {return }
        guard let snapshot = try? await Firestore.firestore().collection("restaurants").document(uid).getDocument() else {return }
        self.currentUser = try? snapshot.data(as: Restaurant.self)
    }
}
