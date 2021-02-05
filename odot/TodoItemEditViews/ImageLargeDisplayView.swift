//
//  ImageLargeDisplayView.swift
//  odot
//
//  Created by Joakim Eberholst on 2021-01-28.
//

import SwiftUI

struct ImageLargeDisplayView: View {
    
    //@EnvironmentObject private var todos : Todos
    var image: String
    
    var body: some View {
        
        ZStack {
            
            VStack {
                
                SheetEditBarView(title: "Image (id here later)"){
                    onActionSave()
                } actionDelete: {
                    onActionDelete()
                }
               
                Divider()
                Spacer()
                
                Image(systemName: "\(image)")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding()
                
                Spacer()
                
            }
            
        }
        
    }
    
    private func onActionSave(){
        print("Save")
    }
    
    private func onActionDelete(){
        print("Delete")
    }
    
}

struct ImageLargeDisplayView_Previews: PreviewProvider {
    static var previews: some View {
        ImageLargeDisplayView(image: "photo")
    }
}


