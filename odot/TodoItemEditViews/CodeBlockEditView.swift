//
//  HyperLinkEditView.swift
//  odot
//
//  Created by Joakim Eberholst on 2021-01-27.
//

import SwiftUI
import Combine
import Firebase
import Prettier_swift

let icCopy = "doc.text"
let icPaste = "doc.on.doc"
let icPasteLastLine = "arrow.down.doc"
let icShare = "square.and.arrow.up"
let icTitle = "chevron.left.slash.chevron.right"

struct CodeBlockEditView: View {
    
    @EnvironmentObject var todoDataModel: TodoDataModel
    
    @Binding var codeBlockIndex: Int
    
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
                                        UIPasteboard.general.string = newCodeBlockItem.code
                                    })
                                    ClipBoardActionView(iconSystemName: icPaste, label: "Paste", onAction: {
                                        if let onPasteBoard = UIPasteboard.general.string {
                                            newCodeBlockItem.code = onPasteBoard
                                        }
                                    })
                                    ClipBoardActionView(iconSystemName: icPasteLastLine, label: "Paste", onAction: {
                                        if let onPasteBoard = UIPasteboard.general.string {
                                            newCodeBlockItem.code = "\(newCodeBlockItem.code)\r\n\(onPasteBoard)"
                                        }
                                    })
                                    ClipBoardActionView(iconSystemName: icShare, label: "Share", onAction: {
                                        isSharingPresented.toggle()
                                    })

                                }.padding()
                            }
                            Divider()
                            
                            HStack {
                                ScrollView(.horizontal) {
                                    FormatCodeActionView(code: $newCodeBlockItem.code)
                                }
                            }
                            
                            Divider()
               
                            HStack(alignment: .top) {
                                ScrollView(.vertical, showsIndicators: true) {
                                    HStack {
                                        CodeBlockContentView(lines: $lines, code: $newCodeBlockItem.code, lineCount: $lineCount)
                                    }
                                    .frame(height: CGFloat(lineCount * 25))
                                }
                            
                            }
                            
                        }
                    }
                    .padding()
                    .onAppear(){
                        newCodeBlockItem = todoDataModel.todoData[todoDataModel.mainIndex].codeBlocks[codeBlockIndex]
                    }
                
                Spacer()
                    
                }
            }
        }.sheet(isPresented: $isSharingPresented, content: {
            ShareController(text: $newCodeBlockItem.code)
        })
        
    }
    
    private func onActionSave(){
      
        let allCodeBlocks = todoDataModel.todoData[todoDataModel.mainIndex].codeBlocks
       
        var newCodeBlock = allCodeBlocks
        newCodeBlock[codeBlockIndex] = newCodeBlockItem

        let docData: [[String: Any]] = newCodeBlock.map { item in
            item.getAsDictionary()
        }
    
        FirebaseUtil.firebaseUtil.updateDocumentWholeArray(documentID: todoDataModel.selectedDocId, documentField: documentField, docData: docData)

    }
    
    private func onActionDelete(){
        
        let allCodeBlocks = todoDataModel.todoData[todoDataModel.mainIndex].codeBlocks
             
        var newCodeBlock = allCodeBlocks
        newCodeBlock.remove(at: codeBlockIndex)

        let docData: [[String: Any]] = newCodeBlock.map { item in
            item.getAsDictionary()
        }
    
        FirebaseUtil.firebaseUtil.updateDocumentWholeArray(documentID: todoDataModel.selectedDocId, documentField: documentField, docData: docData)

    }
}

private enum FORMATS : CaseIterable {
    case CSS
    case HTML
    case JSON
    case TYPESCRIPT
}

private func getFormats() -> [FORMATS] {
    var listOfFormats: [FORMATS] = []
    for format in FORMATS.allCases {
        listOfFormats.append(format)
    }
    return listOfFormats
}

struct CodeBlockContentView: View {
    
    @Binding var lines: String
    @Binding var code: String
    @Binding var lineCount: Int
    
    var body: some View {
        
        VStack(alignment: HorizontalAlignment.leading) {
            TextEditor(text: $code)
                .font(.system(size: 12))
                .lineSpacing(5)
                .onReceive(Just(code)){ text in
                    code = text
                }.onChange(of: code) { value in
              
                    let lf = value.split(omittingEmptySubsequences: false){ $0.isNewline }
                    lineCount = lf.count
                    let ladd = Int(Double((lineCount/5)) * 0.4)
                    updateLines(lineCount: (lineCount + ladd))
                  
                }
        }
        
    }
    
    private func updateLines(lineCount: Int){
        var lines: String = ""
        for i in 0 ..< lineCount {
            lines = lines.appending("\(i + 1) \n")
        }
        self.lines = lines
    }
    
}

struct FormatCodeActionView: View {
    
    @Binding var code: String
    
    private let listOfFormats = getFormats()
    
    var body: some View {
        
        HStack {
            ForEach(listOfFormats.indices, id: \.self){ item in
               
                Button(action: {
                    let output = onPrettifyCode(form: listOfFormats[item], input: code)
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        if let output = output {
                            if output != "" {
                                code = output
                            } else {
                               print("Code formatting failed...")
                            }
                        }
                    }
                }) {
                    Text(String(describing: listOfFormats[item]))
                        .font(.system(size: 12))
                        .foregroundColor(Color("Icons"))
                        .bold()
                }
                .padding()
            }
        }
        
    }
    
    private func onPrettifyCode(form: FORMATS, input: String) -> String? {
                
        let prettier = Prettier()
        var output = ""
        
        switch form {
        
        case .CSS:
            output = prettier.prettify(input, parser: .css) ?? ""
        case .HTML:
            output = prettier.prettify(input, parser: .html) ?? ""
        case .JSON:
            output = prettier.prettify(input, parser: .json) ?? ""
        case .TYPESCRIPT:
            output = prettier.prettify(input, parser: .typescript) ?? ""
        }
            
        return output
     
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
