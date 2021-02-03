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
  
    @ObservedObject var todos = Todos()
    @State private var isLoggedIn: Bool = false
    @State private var isPresentingLoginUI = false
    
    var body: some View {
        
        VStack {
            
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
                //startSignIn()
                isPresentingLoginUI.toggle()
               
               // isLoggedIn.toggle()
            }, label: {
                Text("Login / Register")
            })
        
           
        
            Spacer()
        }
       
        
        .fullScreenCover(isPresented: $isLoggedIn) {
            ContentView().environmentObject(todos)
        }
        
        .sheet(isPresented: $isPresentingLoginUI) {
           // FUIAuthBaseViewController() as! View
            //print("Displaying")
            SignInTestUI()
            
        }
       
        .onAppear(){
            Auth.auth().addStateDidChangeListener { (auth, user) in
                if let user = user {
                        self.showUserInfo(user: user)
                    } else {
                        print("No user signed in")
                        self.showLoginVC()
                    }
            }
        }
    }
    
    func showLoginVC() {
        let authUI = FUIAuth.defaultAuthUI()
        let providers = [FUIGoogleAuth(authUI: authUI!)]
        authUI?.providers = providers
        let authViewController = authUI!.authViewController()
        isPresentingLoginUI.toggle()
      
    }
    
    func showUserInfo(user: User){
        print(user.email)
        print(user.displayName)
    }
   

}



struct LoginRegisterView_Previews: PreviewProvider {
    static var previews: some View {
        LoginRegisterView()
    }
}
