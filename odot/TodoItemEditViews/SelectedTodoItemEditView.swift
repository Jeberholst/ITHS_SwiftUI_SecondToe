//
//  HyperLinkEditView.swift
//  odot
//
//  Created by Joakim Eberholst on 2021-01-27.
//

import SwiftUI

struct SelectedTodoItemEditView: View {
    
    @State var todoItem: TodoItem

    var body: some View {
            
            VStack(alignment: .leading) {
                
                VStack {
                    
                    SheetEditBarView(title: "\(todoItem.getFormattedDate())"){
                        onActionSave()
                    } actionDelete: {
                        onActionDelete()
                    }
                    
                    Divider()
                    
                    TextEditorCompoundView(
                        iconSystemName: "rosette", viewTitle: "Title",text: $todoItem.title)
                    
                    TextEditorCompoundView(
                        iconSystemName: "doc.text", viewTitle: "Note", text:$todoItem.note)
                 
                }
                Spacer()
            }
        
    }
    
    private func onActionSave(){
        print("Save")
    }
    private func onActionDelete(){
        
    }
    
    
}


struct SelectedTodoItemEditView_Previews: PreviewProvider {
    static var previews: some View {
        SelectedTodoItemEditView(todoItem: TodoItem())
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
