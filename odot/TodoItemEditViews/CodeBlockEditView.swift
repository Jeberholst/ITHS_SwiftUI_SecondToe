//
//  HyperLinkEditView.swift
//  odot
//
//  Created by Joakim Eberholst on 2021-01-27.
//

import SwiftUI
import Combine

let icCopy = "doc.text"
let icPaste = "doc.on.doc"
let icPasteLastLine = "arrow.down.doc"
let icShare = "square.and.arrow.up"
let icTitle = "chevron.left.slash.chevron.right"

struct CodeBlockEditView: View {
    
    @EnvironmentObject var todoDataModel: TodoDataModel
    @State var codeBlockItem: CodeBlockItem
    @State var codeBlockIndex: Int
    var docID: String

    var body: some View {
        
        ZStack(alignment: .top) {
            VStack {
                
                SheetEditBarView(title: "\(codeBlockItem.getFormattedDate())"){
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
                                        UIPasteboard.general.string = codeBlockItem.code
                                    })
                                    ClipBoardActionView(iconSystemName: icPaste, label: "Paste", onAction: {
                                        print("Pasting from clipboard")
                                        if let onPasteBoard = UIPasteboard.general.string {
                                            codeBlockItem.code = onPasteBoard
                                        }
                                    })
                                    ClipBoardActionView(iconSystemName: icPasteLastLine, label: "Paste", onAction: {
                                        print("Paste from clipboard last line")
                                        if let onPasteBoard = UIPasteboard.general.string {
                                            codeBlockItem.code = "\(codeBlockItem.code)\r\n\(onPasteBoard)"
                                        }
                                    })
                                    ClipBoardActionView(iconSystemName: icShare, label: "xShare", onAction: {
                                        print("Share to...")
                                    })
                                }.padding()
                            }
                            Divider()
                            
                            TextEditor(text: $codeBlockItem.code)
                                .frame(minWidth: UIScreen.main.bounds.width - 30, idealWidth: 100, maxWidth: .infinity, minHeight: UIScreen.main.bounds.height / 2, idealHeight: .infinity, maxHeight: .infinity, alignment: .center)
                                .onReceive(Just(codeBlockItem.code)){ text in
                                    print(text)
                                    codeBlockItem.code = text
                                }
                        }
                    }
                    .padding()
                    .onAppear(){
                        print("CodeBlockIndex: \(self.codeBlockIndex)")
                        
                    }
                    
                    Spacer()
                    
                }
                
            }
            
        }
        
    }
    
    private func onActionSave(){
        let documentField = "codeBlocks"
        
        
        
        let docData: [String : Any] = [
            "date" : codeBlockItem.date,
            "code" : codeBlockItem.code,
         ]
    
         FirebaseUtil.firebaseUtil.updateDocumentFieldArrayUnion(documentID:
            docID, documentField: documentField, docData: docData)
    }
    
    private func onActionDelete(){
        print("Delete")
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
