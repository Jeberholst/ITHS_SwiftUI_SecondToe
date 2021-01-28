//
//  SheetEditBarView.swift
//  odot
//
//  Created by Joakim Eberholst on 2021-01-28.
//

import SwiftUI

struct SheetEditBarView: View {
    
    var title: String
    var actionSave: () -> ()
    var actionDelete: () -> ()
    
    var body: some View {
        HStack(spacing: 15) {
            
            Text("\(title)")
                .font(.system(size: 12))
            
            Spacer()
            
            Button(action: {
                actionSave()
            }, label: {
                Image(systemName: "checkmark.circle")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 42, height: 42)
                    .foregroundColor(.green)
            })
            Button(action: {
                actionDelete()
            }, label: {
                Image(systemName: "trash.circle")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 42, height: 42)
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
