//
//  ImageLargeDisplayView.swift
//  odot
//
//  Created by Joakim Eberholst on 2021-01-28.
//

import SwiftUI

struct ImageLargeDisplayView: View {
    
    @Environment(\.presentationMode) var presentationMode
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
        presentationMode.wrappedValue.dismiss()
    }
    
    private func onActionDelete(){
        print("Delete")
        presentationMode.wrappedValue.dismiss()
    }
    
}

struct ImageLargeDisplayView_Previews: PreviewProvider {
    static var previews: some View {
        ImageLargeDisplayView(image: "link", mainIndex: 0, imageIndex: 0)
    }
}


