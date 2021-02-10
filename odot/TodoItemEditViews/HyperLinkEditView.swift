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
        
    }
    
    private func onActionSave(){
        let documentField = "hyperLinks"
        var allHyperLinks = todoDataModel.todoData[todoDataModel.mainIndex].hyperLinks
       
     //   if let allLinks = allHyperLinks {
//            for item in (0 ..< allLinks.count) {
//                print("CURRENT HYPERLINKS: \(item)")
//            }
           // allHyperLinks?[hyperLinkIndex] = hyperLinkItem
        allHyperLinks[hyperLinkIndex] = hyperLinkItem


      //  }

        var docData: [[String: Any]] = [[:]]
        
//        if let allHyperLinks = allHyperLinks {
            docData = allHyperLinks.map { item in
                item.getAsDictionary()
            }
//        }
    
        FirebaseUtil.firebaseUtil.updateDocumentWholeArray(documentID: docID, documentField: documentField, docData: docData)
    }
    
    private func onActionDelete(){
        print("Delete")
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

