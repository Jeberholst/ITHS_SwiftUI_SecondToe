//
//  HyperLinkEditView.swift
//  odot
//
//  Created by Joakim Eberholst on 2021-01-27.
//

import SwiftUI
import Combine

struct SelectedTodoItemEditView: View {
    
    @EnvironmentObject private var todoDataModel: TodoDataModel
    @State var todoItem: TodoItem
//    var docID: String
    private let prioritys = [1, 2, 3]
    @State private var selectedPr = 1
    
    var body: some View {
            
            VStack(alignment: .leading) {
                
                VStack {
                    
                    SheetSaveOnlyBarView(title: todoItem.getFormattedDate()){
                        onActionSave()
                    }
                    
                    Divider()
                
                    HStack {
                        
                        VStack(alignment: .leading) {
                            Image(systemName: "rosette")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 32, height: 32)
                                .padding(.init(top: 5, leading: 0, bottom: 10, trailing: 0))
                            
                            TextEditor(text: $todoItem.title.toNonOptional())
                                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 100)
                                .cornerRadius(10.0)
                                .onReceive(Just(todoItem.title)){ text in
                                    //print(text)
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
                                .padding(.init(top: 5, leading: 0, bottom: 10, trailing: 0))
                            
                            TextEditor(text: $todoItem.note.toNonOptional())
                                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 100)
                                .cornerRadius(10.0)
                                .onReceive(Just(todoItem.note)){ text in
                                    //print(text)
                                    todoItem.note = text
                                }
                        }
                    }
                    .padding()
                    
                    Divider()
                    
                    HStack {
                        
                        VStack(alignment: .leading){
                            
                            Image(systemName: "exclamationmark.shield")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 32, height: 32)
                                .padding(.init(top: 5, leading: 0, bottom: 10, trailing: 0))
                            
                            Picker("Priority", selection: $selectedPr) {
                                ForEach(prioritys, id: \.self) {
                                    Text("\($0)")
                                }.onChange(of: selectedPr) { value in
                                    print(value)
                                    selectedPr = value
                                }
                            }
                            .pickerStyle(SegmentedPickerStyle())
                            .frame( width: UIScreen.main.bounds.width / 3)
                        }
                        Spacer()
                        
                    }
                    .padding()
                 
                }
                Spacer()
            }
            .onAppear {
                selectedPr = todoItem.priority ?? 1
            }
            
    }
    
    private func onActionSave(){
        
        guard let title = todoItem.title else { return }
        guard let note = todoItem.note else { return }

        let docData: [String : Any] = [
                "title": title,
                "note" : note,
                "priority": selectedPr
             ]
        
        FirebaseUtil.firebaseUtil.updateDocumentField(documentID: todoDataModel.selectedDocId, docData: docData)
        
    }
    
}

