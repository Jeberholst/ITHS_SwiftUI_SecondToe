//
//  SheetEditBarView.swift
//  odot
//
//  Created by Joakim Eberholst on 2021-01-28.
//

import SwiftUI

let icCheckmarkCircle = "checkmark.circle"
let icTrashCircle = "trash.circle"

struct SheetEditBarView: View {
    
    @Environment(\.presentationMode) private var presentationMode
    @State var isPresentingAlert = false
    
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
                Image(systemName: icCheckmarkCircle)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 32, height: 32)
                    .foregroundColor(.green)
            })
            
            Button(action: {
                isPresentingAlert.toggle()
            }, label: {
                Image(systemName: icTrashCircle)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 32, height: 32)
                    .foregroundColor(.red)
            }).alert(isPresented: $isPresentingAlert) {
                Alert(
                        title: Text(LocalizeNoCom(name: "Delete this item?")),
                        message: Text(LocalizeNoCom(name: "Deletion cannot be undone")),
                        primaryButton: .destructive(Text(LocalizeNoCom(name: "Delete"))) {
                            actionDelete()
                            presentationMode.wrappedValue.dismiss()
                        },
                        secondaryButton: .cancel()
                    )
            }
            
        }
        .padding()
    }
}
