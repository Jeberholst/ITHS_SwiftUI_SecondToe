//
//  ImageLargeDisplayView.swift
//  odot
//
//  Created by Joakim Eberholst on 2021-01-28.
//

import SwiftUI

struct ImageLargeDisplayView: View {
    
    @EnvironmentObject private var todos : Todos
    var image: String
    @State var mainIndex: Int
    @State var imageIndex: Int
    
    var body: some View {
        
        ZStack {
            
            VStack {
                
                SheetEditBarView(title: "Image \(imageIndex)"){
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
        ImageLargeDisplayView(image: "photo", mainIndex: 0, imageIndex: 0)
    }
}


