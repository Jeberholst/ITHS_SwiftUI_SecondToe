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
    
    @Environment(\.presentationMode) private var presentationMode
    
    var body: some View {
        
        VStack {
            
            if let image = Auth.auth().currentUser?.photoURL {
                
                WebImage(url: URL(string: image.absoluteString))
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(25)
                    .frame(width: 125, height: 125)
            }
            
            if let userName = Auth.auth().currentUser?.displayName {
                Text("\(userName)")
                    .font(.system(size: 16))
                    .bold()
                    .frame(alignment: .center)
                    .padding()
                    
            }
            
            Button(action: {
                signOut()
            }, label: {
                Text("Sign Out")
                    .font(.system(size: 16))
            })
            .padding()
            
            Button(action: {
                
            }, label: {
                Text("Remove account")
                    .foregroundColor(.red)
                    .font(.system(size: 16))
            })
            .padding()
            
            
        }.animation(.linear)
        
        
    }
    
    func signOut(){
        let authUI = FUIAuth.defaultAuthUI()
        print("Trying to sign out user...")
        presentationMode.wrappedValue.dismiss()
        try! authUI?.signOut()
        
    }
    
    func removeAccount(){
        print("!IMPLEMENT! trying to remove account...")
    }
    
}

struct LoggedInProfileView_Previews: PreviewProvider {
    static var previews: some View {
        LoggedInProfileView()
    }
}
