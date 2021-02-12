//
//  LoginRegisterView.swift
//  odot
//
//  Created by Joakim Eberholst on 2021-02-01.
//

import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseUI


struct LoginRegisterView: View {
      
    @State private var isLoggedIn: Bool = false
    @State private var isPresentingLoginUI = false
    @State private var listener: AuthStateDidChangeListenerHandle? = nil

    var body: some View {
    
            VStack {
                
                VStack{}.sheet(isPresented: $isPresentingLoginUI) {
                    SignInTestUI()
                }
                VStack{}.fullScreenCover(isPresented: $isLoggedIn) {
                    ContentView()
                }
             
                Spacer()
                
                HStack(alignment: .center, spacing: 0) {
            
                    HStack(spacing: 1) {
                        Text("S")
                            .font(.system(size: 48))
                        Text("ECOND")
                            .font(.system(size: 24))
                    }
                    
                    HStack(spacing: 1) {
                        Text("T")
                            .font(.system(size: 48))
                        Text("OE")
                            .font(.system(size: 24))
                    }
                    
                }
                
                Spacer()
                
                Button(action: {
                    if(Auth.auth().currentUser != nil){
                        print("IsLoggedIn: \(isLoggedIn)")
                        isLoggedIn = true
                        print("IsLoggedIn toggled: \(isLoggedIn)")
                    } else {
                        isPresentingLoginUI = true
                    }
                }, label: {
                    Text("Login / Register")
                })
                .padding()
                
                Button(action: {
                    self.signOut()
                }, label: {
                    Text("SignOut (test)")
                }).padding()
                
                Spacer()
            }
            .background(bcOff)
            .onAppear(){
                print("On appear")
                addAuthListener()
            }
       
    }
    
    func showUserInfo(user: User){
        print(user.email!)
        print(user.displayName!)
    }
   
    func signOut(){
        let authUI = FUIAuth.defaultAuthUI()
        print("Trying to sign out user...")
        try! authUI?.signOut()
    }

    func addAuthListener(){
        listener = Auth.auth().addStateDidChangeListener { (auth, user) in
             if let user = user {
                self.showUserInfo(user: user)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    isPresentingLoginUI = false
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    isLoggedIn = true
                }
                print("isLoggedIn: \(isLoggedIn)")
             } else {
                 print("No user signed in")
                 isLoggedIn = false
             }
         }
    }
    
    
}

