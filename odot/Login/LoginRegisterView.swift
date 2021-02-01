//
//  LoginRegisterView.swift
//  odot
//
//  Created by Joakim Eberholst on 2021-02-01.
//

import SwiftUI

struct LoginRegisterView: View {
    
    @ObservedObject var todos = Todos()
    @State private var isLoggedIn: Bool = false
    
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
                isLoggedIn.toggle()
            }, label: {
                Text("Login / Register")
            })
        
            Spacer()
        }
        .fullScreenCover(isPresented: $isLoggedIn, content: {
            ContentView().environmentObject(todos)
        })
      
    }
}

struct LoginRegisterView_Previews: PreviewProvider {
    static var previews: some View {
        LoginRegisterView()
    }
}
