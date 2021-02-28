//
//  HyperLinkEditView.swift
//  odot
//
//  Created by Joakim Eberholst on 2021-01-27.
//

import SwiftUI
import Combine

let icRosette = "rosette"
let icPin = "pin"

struct HyperLinkEditView: View {
    
    @EnvironmentObject var todoDataModel: TodoDataModel
    @Binding var hyperLinkIndex: Int
    
    let documentField = "hyperLinks"
    
    @State private var newHyperLinkItem = HyperLinkItem(title: "", description: "", hyperlink: "")
    
    var body: some View {
        
        ZStack(alignment: .top) {
            VStack(alignment: .leading) {
                
                VStack {
                    
                    SheetEditBarView(title: "\(newHyperLinkItem.getFormattedDate())"){
                        onActionSave()
                    } actionDelete: {
                        onActionDelete()
                    }
                    
                    Divider()
                    
                    TextEditorCompoundView(
                        iconSystemName: icRosette, hyperLinkState: newHyperLinkItem, hyperLinkString: $newHyperLinkItem.title)
                    
                    Divider()
                    
                    TextEditorCompoundView(
                        iconSystemName: icPin, hyperLinkState: newHyperLinkItem, hyperLinkString: $newHyperLinkItem.description)
                    
                    Divider()
                    
                    TextEditorCompoundView(
                        iconSystemName: icLink, hyperLinkState: newHyperLinkItem, hyperLinkString: $newHyperLinkItem.hyperlink)
                    
                    Spacer()
                    
                }
                
            }
            .onAppear(){
                newHyperLinkItem = todoDataModel.todoData[todoDataModel.mainIndex].hyperLinks[hyperLinkIndex]
            }
        }
    }
    
    private func onActionSave(){
        
        let allHyperLinks = todoDataModel.todoData[todoDataModel.mainIndex].hyperLinks
        
        var newCodeBlock = allHyperLinks
        newCodeBlock[hyperLinkIndex] = newHyperLinkItem
        
        let docData: [[String: Any]] = newCodeBlock.map { item in
            item.getAsDictionary()
        }
        
        FirebaseUtil.firebaseUtil.updateDocumentWholeArray(documentID: todoDataModel.selectedDocId, documentField: documentField, docData: docData)
        
    }
    
    private func onActionDelete(){
        
        let allHyperLinks = todoDataModel.todoData[todoDataModel.mainIndex].hyperLinks
        
        var newHyperLink = allHyperLinks
        newHyperLink.remove(at: hyperLinkIndex)
        
        let docData: [[String: Any]] = newHyperLink.map { item in
            item.getAsDictionary()
        }
        
        FirebaseUtil.firebaseUtil.updateDocumentWholeArray(documentID: todoDataModel.selectedDocId, documentField: documentField, docData: docData)
        
    }
    
}

private struct TextEditorCompoundView: View {
    
    var iconSystemName: String
    @State var hyperLinkState: HyperLinkItem
    @State var hyperLinkString: Binding<String>
    
    var body: some View {
        
        HStack {
            VStack(alignment: .leading) {
                Image(systemName: iconSystemName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 32, height: 32)
                
                TextEditor(text: hyperLinkString)
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 100)
                    .cornerRadius(10.0)
                    .keyboardType(.URL)
                    .onReceive(Just(hyperLinkState)){ text in
                        hyperLinkState = text
                    }
            }
        }
        .padding()
        
    }
}

