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
    
    @EnvironmentObject private var authUtil: AuthUtil
    @Environment(\.presentationMode) private var presentationMode
    private let fbUtil: FirebaseUtil = FirebaseUtil.firebaseUtil
    
    var body: some View {
        
        VStack {
            
            if let image = Auth.auth().currentUser?.photoURL {
                
                WebImage(url: URL(string: image.absoluteString))
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(25)
                    .frame(width: 125, height: 125)
            }
            
            if let displayName = Auth.auth().currentUser?.displayName {
                
                Text("\(displayName)")
                    .font(.system(size: 16))
                    .bold()
                    .frame(alignment: .center)
                    .padding()
                    
            }
            
            Button(action: {
                authUtil.signOut()
            }, label: {
                Text("Sign Out")
                    .font(.system(size: 16))
            })
            .padding()
            
            Button(action: {
                print("!IMPLEMENT! trying to remove account...")
               // authUtil.removeAccount()
            }, label: {
                Text("Remove account")
                    .foregroundColor(.red)
                    .font(.system(size: 16))
            })
            .padding()
            
            
        }.animation(.linear)
        
    }
    
}

struct LoggedInProfileView_Previews: PreviewProvider {
    static var previews: some View {
        LoggedInProfileView()
    }
}
