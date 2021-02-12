//
//  SheetEditBarView.swift
//  odot
//
//  Created by Joakim Eberholst on 2021-01-28.
//

import SwiftUI

struct SheetEditBarView: View {
    
    @Environment(\.presentationMode) private var presentationMode
    var title: String
    var actionSave: () -> ()
    var actionDelete: () -> ()
    
    var body: some View {
        HStack(spacing: 15) {
           
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }, label: {
               
                Text("\(title)")
                    .font(.system(size: 12))
                    .foregroundColor(Color("AccentColor"))
            
            })
            
            Spacer()
            
            Button(action: {
                actionSave()
                presentationMode.wrappedValue.dismiss()
            }, label: {
                Image(systemName: "checkmark.circle")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 32, height: 32)
                    .foregroundColor(.green)
            })
            Button(action: {
                actionDelete()
                presentationMode.wrappedValue.dismiss()
            }, label: {
                Image(systemName: "trash.circle")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 32, height: 32)
                    .foregroundColor(.red)
            })
            
        }
        .padding()
    }
}

struct SheetEditBarView_Previews: PreviewProvider {
    static var previews: some View {
        SheetEditBarView(title: "1"){
            
        } actionDelete: {
            
        }
    }
}
