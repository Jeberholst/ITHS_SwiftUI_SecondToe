//
//  AuthUtil.swift
//  odot
//
//  Created by Joakim Eberholst on 2021-02-14.
//

import Foundation
import FirebaseUI

class AuthUtil: ObservableObject {
    
    @Published var isLoggedIn: Bool = false
    @Published var isPresentingLoginUI: Bool = false
    @Published var isPresentingProfile: Bool = false

    var listener: AuthStateDidChangeListenerHandle? = nil
    @Published var listenerCollection: ListenerRegistration? = nil
    
    init() {
        addAuthListener()
    }
    
    func addAuthListener(){
        listener = Auth.auth().addStateDidChangeListener { (auth, user) in
             if user != nil {
                self.alreadySignedIn()
                print("isLoggedIn: \(self.isLoggedIn)")
             } else {
                print("No user signed in")
                self.isLoggedIn = false
             }
         }
    }
    
    func displaySignIn(){
        self.isPresentingLoginUI = true
        self.isLoggedIn = false
    }
    
    func alreadySignedIn(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.isPresentingLoginUI = false
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.isLoggedIn = true
        }
    }
    
//    func getPhotoUrlAbsoluteString() -> String? {
//        guard let photoUrl = Auth.auth().currentUser?.photoURL else { return nil }
//        return photoUrl.absoluteString
//    }
//
//    func getDisplayName() -> String? {
//        guard let displayName =  Auth.auth().currentUser?.displayName else { return nil }
//        return displayName
//    }
//
    func presentingProfileToggle(){
        self.isPresentingProfile.toggle()
    }
    
    func signOut(){
        let authUI = FUIAuth.defaultAuthUI()
        self.isPresentingProfile = false
        self.isLoggedIn = false
        print("Trying to sign out user...")
        try! authUI?.signOut()
    }
    
}
