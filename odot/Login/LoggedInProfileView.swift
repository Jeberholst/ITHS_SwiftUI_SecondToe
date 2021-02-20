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
    @State private var isPresentingSignOutAlert: Bool = false
    
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
                isPresentingSignOutAlert.toggle()
            }, label: {
                Text("Sign out")
                    .font(.system(size: 16))
            }).alert(isPresented: $isPresentingSignOutAlert) {
                Alert(
                        title: Text(LocalizeNoCom(name: "Sign out")),
                    message: Text(LocalizeNoCom(name: "Are you sure you want to ") + LocalizeNoCom(name: "Sign out") + "?"),
                        primaryButton: .destructive(Text("Sign out")) {
                            authUtil.signOut()
                            presentationMode.wrappedValue.dismiss()
                        },
                        secondaryButton: .cancel()
                    )
            }
            .padding()

            
        }.animation(.linear)
        
    }
    
}
