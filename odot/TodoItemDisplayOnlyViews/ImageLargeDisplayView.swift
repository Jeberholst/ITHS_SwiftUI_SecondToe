//
//  ImageLargeDisplayView.swift
//  odot
//
//  Created by Joakim Eberholst on 2021-01-28.
//

import SwiftUI

struct ImageLargeDisplayView: View {
    
    var image: String
    @State var mainIndex: Int
    @State var imageIndex: Int
    
    var body: some View {
        
        ZStack {
            
            VStack {
                
                HStack(spacing: 15) {
                    Text("ImageName \(imageIndex)")
                    
                    Spacer()
                    Button(action: {
                        //onSaveButtonClick()
                    }, label: {
                        Text("Save")
                    })
                    Button(action: {
                        //onDeleteButtonClick()
                    }, label: {
                        Text("Delete")
                            .foregroundColor(.red)
                    })
                    
                        
                }.padding()
               
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
}

struct ImageLargeDisplayView_Previews: PreviewProvider {
    static var previews: some View {
        ImageLargeDisplayView(image: "link", mainIndex: 0, imageIndex: 0)
    }
}
