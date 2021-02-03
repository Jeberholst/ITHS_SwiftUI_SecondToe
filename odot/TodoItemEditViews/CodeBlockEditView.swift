//
//  HyperLinkEditView.swift
//  odot
//
//  Created by Joakim Eberholst on 2021-01-27.
//

import SwiftUI

let icCopy = "doc.text"
let icPaste = "doc.on.doc"
let icPasteLastLine = "arrow.down.doc"
let icShare = "square.and.arrow.up"

let icTitle = "chevron.left.slash.chevron.right"

struct CodeBlockEditView: View {
    
    @State var codeBlockItem: CodeBlockItem

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
                    
                    TextEditorCodeCompoundView(iconSystemName: icTitle, viewTitle: "Code", text: codeBlockItem.code)
                    Spacer()
                    
                }
                
            }
            
        }
        
    }
    
    private func onActionSave(){
        print("Save")
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


struct CodeBlockEditView_Previews: PreviewProvider {
    static var previews: some View {
        CodeBlockEditView(codeBlockItem: CodeBlockItem())
    }
}


struct TextEditorCodeCompoundView: View {
    
    var iconSystemName: String
    var viewTitle: String
    @State var text: String
    //@Binding private var textEditor: TextEditor?

    var body: some View {
        
        HStack {
            VStack(alignment: .leading) {
                
                HStack {
                    
                    Image(systemName: iconSystemName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 32, height: 32)
                    
                    Spacer()
                    HStack(spacing: 15) {
                        ClipBoardActionView(iconSystemName: icCopy, label: "Copy", onAction: {
                            print("Copying to clipboard")
                            UIPasteboard.general.string = text
                        })
                        ClipBoardActionView(iconSystemName: icPaste, label: "Paste", onAction: {
                            print("Pasting from clipboard")
                            if let onPasteBoard = UIPasteboard.general.string {
                                text = onPasteBoard
                            }
                        })
                        ClipBoardActionView(iconSystemName: icPasteLastLine, label: "Paste", onAction: {
                            print("Paste from clipboard last line")
                            if let onPasteBoard = UIPasteboard.general.string {
                                text = "\(text)\r\n\(onPasteBoard)"
                            }
                        })
                        ClipBoardActionView(iconSystemName: icShare, label: "xShare", onAction: {
                            print("Share to...")
                        })
                    }.padding()
                }
                Divider()
                
                TextEditor(text: $text.animation(.easeIn))
                    .frame(minWidth: UIScreen.main.bounds.width - 30, idealWidth: 100, maxWidth: .infinity, minHeight: UIScreen.main.bounds.height / 2, idealHeight: .infinity, maxHeight: .infinity, alignment: .center)
                
            }
        }
        .padding()
        
      
    }
}
