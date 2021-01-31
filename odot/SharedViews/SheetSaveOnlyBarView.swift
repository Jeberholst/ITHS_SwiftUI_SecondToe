//
//  SheetSaveOnlyBar.swift
//  odot
//
//  Created by Joakim Eberholst on 2021-01-31.
//

import SwiftUI

struct SheetSaveOnlyBarView: View {
    
    var title: String
    var actionSave: () -> ()
    
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
            
        }
        .padding()
    }
}

struct SheetSaveOnlyBar_Previews: PreviewProvider {
    static var previews: some View {
        SheetSaveOnlyBarView(title: "1"){
            
        }
    }
}
