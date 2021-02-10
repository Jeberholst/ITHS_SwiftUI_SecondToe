//
//  HyperLinkEditView.swift
//  odot
//
//  Created by Joakim Eberholst on 2021-01-27.
//

import SwiftUI
import Combine


struct HyperLinkEditView: View {
    
    @EnvironmentObject var todoDataModel: TodoDataModel
    @State var hyperLinkItem: HyperLinkItem
    @State var hyperLinkIndex: Int
    var docID: String
    
    let documentField = "hyperLinks"
    
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
                        iconSystemName: "rosette", hyperLinkState: hyperLinkItem, hyperLinkString: $hyperLinkItem.title)
                   
                    Divider()
                    
                    TextEditorCompoundView(
                        iconSystemName: "pin", hyperLinkState: hyperLinkItem, hyperLinkString: $hyperLinkItem.description)
                    
                    Divider()
                    
                    TextEditorCompoundView(
                        iconSystemName: "link", hyperLinkState: hyperLinkItem, hyperLinkString: $hyperLinkItem.hyperlink)
                    
                    Spacer()
                    
                }
              
            }
            .onAppear(){
                print("HyperLinkIndex: \(hyperLinkIndex)")
            }
        
    }
    
    private func onActionSave(){
      
        let allCodeBlocks = todoDataModel.todoData[todoDataModel.mainIndex].hyperLinks
       
       // if let allCodeBlocks = allCodeBlocks {
            
            var newCodeBlock = allCodeBlocks
        newCodeBlock[hyperLinkIndex] = HyperLinkItem(date: hyperLinkItem.date, title: hyperLinkItem.title, description: hyperLinkItem.title, hyperlink: hyperLinkItem.hyperlink)

            let docData: [[String: Any]] = newCodeBlock.map { item in
                item.getAsDictionary()
            }
        
            FirebaseUtil.firebaseUtil.updateDocumentWholeArray(documentID: docID, documentField: documentField, docData: docData)
     //   }
  
    }
    
    private func onActionDelete(){
        
        let allHyperLinks = todoDataModel.todoData[todoDataModel.mainIndex].hyperLinks
       
//        if let allCodeBlocks = allCodeBlocks {
            
            var newHyperLink = allHyperLinks
            newHyperLink.remove(at: hyperLinkIndex)

            let docData: [[String: Any]] = newHyperLink.map { item in
                item.getAsDictionary()
            }
        
            FirebaseUtil.firebaseUtil.updateDocumentWholeArray(documentID: docID, documentField: documentField, docData: docData)
//        }
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
                    .onReceive(Just(hyperLinkState)){ text in
                        hyperLinkState = text
                    }
                    //.border(Color.gray, width: 0.3)
                    
            }
        }
        .padding()
        
      
    }
}

