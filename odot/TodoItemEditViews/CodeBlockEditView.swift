//
//  HyperLinkEditView.swift
//  odot
//
//  Created by Joakim Eberholst on 2021-01-27.
//

import SwiftUI
import Combine
import Firebase

let icCopy = "doc.text"
let icPaste = "doc.on.doc"
let icPasteLastLine = "arrow.down.doc"
let icShare = "square.and.arrow.up"
let icTitle = "chevron.left.slash.chevron.right"



struct CodeBlockEditView: View {
    
    @EnvironmentObject var todoDataModel: TodoDataModel
    
    @Binding var codeBlockIndex: Int
    var docID: String
    
    let documentField = "codeBlocks"
    
    @State private var newCodeBlockItem = CodeBlockItem(date: Date(), code: "")

    var body: some View {
        
    
        ZStack(alignment: .top) {
            VStack {
                
                SheetEditBarView(title: newCodeBlockItem.getFormattedDate()){
                    onActionSave()
                } actionDelete: {
                    onActionDelete()
                }
                
                Divider()
              
                VStack(alignment: .trailing) {
                    
                    HStack {
                        VStack(alignment: .leading) {
                            
                            HStack {
                                
                                Image(systemName: "\(icTitle)")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 32, height: 32)
                                
                                Spacer()
                                HStack(spacing: 15) {
                                    ClipBoardActionView(iconSystemName: icCopy, label: "Copy", onAction: {
                                        print("Copying to clipboard")
                                        UIPasteboard.general.string = newCodeBlockItem.code
                                    })
                                    ClipBoardActionView(iconSystemName: icPaste, label: "Paste", onAction: {
                                        print("Pasting from clipboard")
                                        if let onPasteBoard = UIPasteboard.general.string {
                                            newCodeBlockItem.code = onPasteBoard
                                        }
                                    })
                                    ClipBoardActionView(iconSystemName: icPasteLastLine, label: "Paste", onAction: {
                                        print("Paste from clipboard last line")
                                        if let onPasteBoard = UIPasteboard.general.string {
                                            newCodeBlockItem.code = "\(newCodeBlockItem.code)\r\n\(onPasteBoard)"
                                        }
                                    })
                                    ClipBoardActionView(iconSystemName: icShare, label: "xShare", onAction: {
                                        print("Share to...")
                                    })
                                }.padding()
                            }
                            Divider()
                            
                            TextEditor(text: $newCodeBlockItem.code)
                                .frame(minWidth: UIScreen.main.bounds.width - 30, idealWidth: 100, maxWidth: .infinity, minHeight: UIScreen.main.bounds.height / 2, idealHeight: .infinity, maxHeight: .infinity, alignment: .center)
                                .onReceive(Just(newCodeBlockItem.code)){ text in
                                    print(text)
                                    newCodeBlockItem.code = text
                                }
                        }
                    }
                    .padding()
                    .onAppear(){
                        newCodeBlockItem = todoDataModel.todoData[todoDataModel.mainIndex].codeBlocks[codeBlockIndex]
                        print("CodeBlockIndex: \(codeBlockIndex)")
                    }
                    
                    Spacer()
                    
                }
                
            }
            
        }
        
    }
    
    private func onActionSave(){
      
        let allCodeBlocks = todoDataModel.todoData[todoDataModel.mainIndex].codeBlocks
       
       // if let allCodeBlocks = allCodeBlocks {
            
            var newCodeBlock = allCodeBlocks
            newCodeBlock[codeBlockIndex] = newCodeBlockItem

            let docData: [[String: Any]] = newCodeBlock.map { item in
                item.getAsDictionary()
            }
        
            FirebaseUtil.firebaseUtil.updateDocumentWholeArray(documentID: docID, documentField: documentField, docData: docData)
     //   }
  
    }
    
    private func onActionDelete(){
        
        let allCodeBlocks = todoDataModel.todoData[todoDataModel.mainIndex].codeBlocks
       
//        if let allCodeBlocks = allCodeBlocks {
            
            var newCodeBlock = allCodeBlocks
            newCodeBlock.remove(at: codeBlockIndex)

            let docData: [[String: Any]] = newCodeBlock.map { item in
                item.getAsDictionary()
            }
        
            FirebaseUtil.firebaseUtil.updateDocumentWholeArray(documentID: docID, documentField: documentField, docData: docData)
//        }
    }
}


struct ClipBoardActionView: View {
    
    var iconSystemName: String
    var label: String
    var onAction: () -> ()
    
    var body: some View {
        
        VStack {
            Button {
                onAction()
            } label: {
                Image(systemName: iconSystemName)
                    .resizable()
                    .foregroundColor(.black)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 32, height: 32)
            }
        }
        .cornerRadius(3.0)
        
    }
}
