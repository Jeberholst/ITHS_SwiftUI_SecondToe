//
//  ImageLargeDisplayView.swift
//  odot
//
//  Created by Joakim Eberholst on 2021-01-28.
//

import SwiftUI

struct ImageLargeDisplayView: View {
    
    //@EnvironmentObject private var todos : Todos
    @Binding var image: UIImage
    
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
                
                Image(uiImage: image)
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


