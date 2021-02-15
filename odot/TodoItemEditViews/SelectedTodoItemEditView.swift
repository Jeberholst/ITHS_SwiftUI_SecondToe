//
//  HyperLinkEditView.swift
//  odot
//
//  Created by Joakim Eberholst on 2021-01-27.
//

import SwiftUI
import Combine

struct SelectedTodoItemEditView: View {
    
    @State var todoItem: TodoItem
    var docID: String

    var body: some View {
            
            VStack(alignment: .leading) {
                
                VStack {
                    
                    SheetSaveOnlyBarView(title: "\(todoItem.getFormattedDate())"){
                        onActionSave()
                    }
                    
                    Divider()
                
                    HStack {
                        
                        VStack(alignment: .leading) {
                            Image(systemName: "rosette")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 32, height: 32)
                            
                            TextEditor(text: $todoItem.title)
                                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 100)
                                .cornerRadius(10.0)
                                .onReceive(Just(todoItem.title)){ text in
                                    print(text)
                                    todoItem.title = text
                                }
                        }
                    }
                    .padding()
                    
                    Divider()
       
                    HStack {
                        VStack(alignment: .leading) {
                            Image(systemName: "doc.text")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 32, height: 32)
                            
                            TextEditor(text: $todoItem.note)
                                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 100)
                                .cornerRadius(10.0)
                                .onReceive(Just(todoItem.note)){ text in
                                    print(text)
                                    todoItem.note = text
                                }
                        }
                    }
                    .padding()
                 
                }
                Spacer()
            }
        
    }
    
    private func onActionSave(){

        let docData: [String : Any] = [
                "title": todoItem.title,
                "note" : todoItem.note,
             ]
        
        FirebaseUtil.firebaseUtil.updateDocumentField(documentID: docID, docData: docData)
        
    }
    
}


