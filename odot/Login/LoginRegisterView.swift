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
      
    @EnvironmentObject private var authUtil: AuthUtil
    @EnvironmentObject private var todoDataModel: TodoDataModel

    var body: some View {
        ZStack {
            VStack {
                
                VStack{}.sheet(isPresented: $authUtil.isPresentingLoginUI) {
                    SignInUI()
                        .environmentObject(todoDataModel)
                        .environmentObject(authUtil)
                    
                }
                VStack{}.fullScreenCover(isPresented: $authUtil.isLoggedIn) {
                    ContentView()
                        .environmentObject(todoDataModel)
                        .environmentObject(authUtil)
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
                    if(Auth.auth().currentUser == nil){
                        authUtil.displaySignIn()
                    } else {
                       // print("IsLoggedIn: \($authUtil.isLoggedIn)")
                       // print("IsLoggedIn toggled: \($authUtil.isLoggedIn)")
                    }
                }, label: {
                    Text(LocalizeNoCom(name: "Sign in") + " / " + LocalizeNoCom(name: "Register"))
                })
                .padding()
                
                Spacer()
            }
            .onAppear(){
                if authUtil.listener == nil {
                    authUtil.addAuthListener()
                }
            }
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    }
    
}

