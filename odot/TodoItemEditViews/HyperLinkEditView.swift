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
            
            VStack(alignment: .leading) {
                
                VStack {
                    
                    SheetEditBarView(title: "\(hyperLinkItem.getFormattedDate())"){
                        onActionSave()
                    } actionDelete: {
                        onActionDelete()
                    }
                    
                    Divider()
                    
                    TextEditorCompoundView(
                        iconSystemName: "rosette", viewTitle: "Title",text: $hyperLinkItem.title)
                    
                    TextEditorCompoundView(
                        iconSystemName: "pin", viewTitle: "Description", text:$hyperLinkItem.description)
                    
                    TextEditorCompoundView(
                        iconSystemName: "link",  viewTitle: "Hyperlink",text: $hyperLinkItem.hyperlink)
                }
                Spacer()
            }
        
    }
    
    private func onActionSave(){
        print("Save")
    }
    
    private func onActionDelete(){
        print("Delete")
    }
    
}


struct HyperLinkEditView_Previews: PreviewProvider {
    static var previews: some View {
        HyperLinkEditView(hyperLinkItem: HyperLinkItem())
    }
}

private struct TextEditorCompoundView: View {
    
    var iconSystemName: String
    var viewTitle: String
    var text: Binding<String>
    
    var body: some View {
        
        HStack {
            VStack(alignment: .leading) {
                Image(systemName: iconSystemName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 32, height: 32)
                
                TextEditor(text: text)
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 100)
                    .cornerRadius(10.0)
                    //.border(Color.gray, width: 0.3)
                    
            }
        }
        .padding()
        Divider()
        
      
    }
}

