//
//  SheetSaveOnlyBar.swift
//  odot
//
//  Created by Joakim Eberholst on 2021-01-31.
//

import SwiftUI

struct SheetSaveOnlyBarView: View {
    
    @Environment(\.presentationMode) private var presentationMode
    var title: String
    var actionSave: () -> ()
    
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
            
        }
        .padding()
    }
}
