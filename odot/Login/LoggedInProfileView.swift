//
//  LoggedInProfileView.swift
//  odot
//
//  Created by Joakim Eberholst on 2021-02-12.
//

import SwiftUI
import SDWebImageSwiftUI
import FirebaseUI

struct LoggedInProfileView: View {
    var body: some View {
        
        VStack {
            WebImage(url: URL(string: "https://lh3.googleusercontent.com/a-/AOh14GjV5Adi6ATykn6P-5s96XfBvyd2U351IN9OIXR6JA=s96-c-rg-br100"))
                .resizable()
                .aspectRatio(contentMode: .fit)
                .cornerRadius(50)
                .frame(width: 125, height: 125)
                .animation(.linear)
            
            if let userName = Auth.auth().currentUser?.displayName {
                Text("\(userName)")
                    .font(.system(size: 16))
                    .bold()
                    .frame(alignment: .center)
                    .padding()
                    .animation(.linear)
                    
            }
            
            Button(action: {
                
            }, label: {
                Text("Sign Out")
                    .font(.system(size: 16))
                    .animation(.linear)
            })
            
            Button(action: {
                
            }, label: {
                Text("Remove account")
                    .foregroundColor(.red)
                    .font(.system(size: 16))
                    .animation(.linear)
            })
            
            
        }
        
        
    }
    
    
    func signOut(){
        let authUI = FUIAuth.defaultAuthUI()
        print("Trying to sign out user...")
        try! authUI?.signOut()
        
    }
    
}

struct LoggedInProfileView_Previews: PreviewProvider {
    static var previews: some View {
        LoggedInProfileView()
    }
}
