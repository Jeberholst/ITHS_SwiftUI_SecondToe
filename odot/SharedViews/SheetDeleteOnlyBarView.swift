//
//  SheetDeleteOnlyBarView.swift
//  odot
//
//  Created by Joakim Eberholst on 2021-02-16.
//

import SwiftUI

struct SheetDeleteOnlyBarView: View {
    
    @Environment(\.presentationMode) private var presentationMode
    @State var isPresentingAlert = false
    
    var title: String
    var actionDelete: () -> ()
    
    var body: some View {
        HStack(spacing: 15) {
            
            Text("\(title)")
                .font(.system(size: 12))
            
            Spacer()
            
            Button(action: {
                
                isPresentingAlert.toggle()
                
            }, label: {
                
                Image(systemName: "trash.circle")
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

