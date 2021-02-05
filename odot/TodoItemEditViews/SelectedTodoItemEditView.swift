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
                                //.border(Color.gray, width: 0.3)
                        }
                    }
                    .padding()
                 
                }
                Spacer()
            }
        
    }
    
    private func onActionSave(){
        print("Saving too...")
        print(docID)
        let docRef = FirebaseUtil.firebaseUtil.getUserCollection().document(docID)
    
            let docData: [String : Any] = [
                    "title": todoItem.title,
                    "note" : todoItem.note,
                 ]
      
            docRef.updateData(docData){ err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    print("Document successfully updated")
                }
            }
        
        
    }
    
}


struct SelectedTodoItemEditView_Previews: PreviewProvider {
    static var previews: some View {
        SelectedTodoItemEditView(todoItem: TodoItem(title: "Title", note: "Note", date: Date()), docID: "SomeID")
    }
}

