//
//  HyperLinkEditView.swift
//  odot
//
//  Created by Joakim Eberholst on 2021-01-27.
//

import SwiftUI

struct HyperLinkEditView: View {
    
    @State var hyperLinkItem: HyperLinkItem

    
    var body: some View {
        
        ZStack {
            
            VStack(alignment: .leading) {
                
                NavigationLink(
                    destination: EmptyView().frame(width: 0, height: 0, alignment: .center),
                    label: {
                        
                    })
                    .navigationBarTitle("\(hyperLinkItem.title)")
                    .navigationBarItems(trailing: Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                        Text("Save")
                    }))
                
                VStack {
                    TextEditor(text: $hyperLinkItem.title)
                        .frame(width: UIScreen.main.bounds.width, height: 100, alignment: .leading)
                    TextEditor(text: $hyperLinkItem.description)
                        .frame(width: UIScreen.main.bounds.width, height: 100, alignment: .leading)
                    TextEditor(text: $hyperLinkItem.hyperlink)
                        .frame(width: UIScreen.main.bounds.width, height: 100, alignment: .leading)
                }
                
            }
            
        }
        
    }
}

struct HyperLinkEditView_Previews: PreviewProvider {
    static var previews: some View {
        HyperLinkEditView(hyperLinkItem: HyperLinkItem())
    }
}
