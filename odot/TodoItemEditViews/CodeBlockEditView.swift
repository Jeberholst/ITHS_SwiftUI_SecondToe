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
    
    private let documentField = "codeBlocks"
    @State private var isSharingPresented = false
    @State private var lineCount: Int = 0
    @State private var lines: String = ""
    
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
                                        isSharingPresented.toggle()
                                    })

                                }.padding()
                            }
                            Divider()
               
                            HStack(alignment: .top) {
                                ScrollView(.vertical, showsIndicators: true) {
                                    
                                        HStack {
                                        
                                            VStack(alignment: HorizontalAlignment.leading) {
                                                
                                                
                                                TextEditor(text: $lines)
                                                
                                                    .font(.system(size: 12))
                                                    .lineSpacing(5)
                                                    //.background(Color(.red))
                                                    //.fixedSize(horizontal: true, vertical: false)
                                                    .disabled(true)
                                                    .frame(width: 35)
                                                    .onAppear {
                                                        UITextView.appearance().backgroundColor = .clear
                                                    }
                                                
                                                    
                                            }
                                           
                                            
                                            VStack(alignment: HorizontalAlignment.leading) {
                                                TextEditor(text: $newCodeBlockItem.code)
                                                    .font(.system(size: 12))
                                                    .lineSpacing(5)
                                                    .onReceive(Just(newCodeBlockItem.code)){ text in
                                                        //print(text)
                                                        newCodeBlockItem.code = text
                                                    }.onChange(of: newCodeBlockItem.code) { value in
                                                  
                                                        let lf = value.split(omittingEmptySubsequences: false){ $0.isNewline }
                                                        self.lineCount = lf.count
                                                        let ladd = Int(Double((lineCount/5)) * 0.4)
                                                        updateLines(lineCount: (lineCount + ladd))
                                                      
                                                    }
                                                    
                                                
                                            }
                                            
                                      
                                        }
                                        .frame(height: CGFloat(lineCount * 25))
                                        //.background(Color(.green))
                                 
                                    
                                }
                               // .background(GrayBackGroundView(alpha: 0.2))
                                  
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
            
        }.sheet(isPresented: $isSharingPresented, content: {
            //ShareController()
            ShareController(text: $newCodeBlockItem.code)
        })
        
        
    }
    
    private func updateLines(lineCount: Int){
        var lines: String = ""
        for i in 0 ..< lineCount {
            lines = lines.appending("\(i + 1) \n")
        }
        self.lines = lines
        print("LineCount: \(self.lineCount)")
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
                    .foregroundColor(Color("Icons"))
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 32, height: 32)
            }
        }
        .cornerRadius(3.0)
        
    }
}
