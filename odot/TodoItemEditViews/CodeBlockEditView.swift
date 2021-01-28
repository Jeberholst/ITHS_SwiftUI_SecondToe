//
//  HyperLinkEditView.swift
//  odot
//
//  Created by Joakim Eberholst on 2021-01-27.
//

import SwiftUI

struct CodeBlockEditView: View {
    
    @State var codeBlockItem: CodeBlockItem

    var body: some View {
        
        ZStack(alignment: .top) {
            VStack {
                
                HStack(spacing: 15) {
                    Text("\(codeBlockItem.getFormattedDate())")
                        .font(.system(size: 12))
                    
                    Spacer()
                    Button(action: {
                        //onSaveButtonClick()
                    }, label: {
                        Text("Save")
                    })
                    Button(action: {
                        //onDeleteButtonClick()
                    }, label: {
                        Text("Delete")
                            .foregroundColor(.red)
                    })
                    
                        
                }.padding()
                
                Divider()
                Spacer()
                
                VStack(alignment: .trailing) {
                    
                    TextEditorCodeCompoundView(iconSystemName: "chevron.left.slash.chevron.right", viewTitle: "Code", text: $codeBlockItem.code)
                    Spacer()
                    
                }
            }
         
            
        }
        
        
    }
    
    func onSaveButtonClick(){

        print($codeBlockItem)
        //SAVE ITEM HERE

    }
}


struct ClipBoardActionView: View {
    
    var iconSystemName: String
    var label: String
    
    var body: some View {
        
        VStack {
            Image(systemName: iconSystemName)
                .resizable()
                .foregroundColor(.black)
                .aspectRatio(contentMode: .fit)
                .frame(width: 32, height: 32)
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
    var text: Binding<String>
    
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
                        ClipBoardActionView(iconSystemName: "doc.text", label: "Copy")
                        ClipBoardActionView(iconSystemName: "doc.on.doc", label: "Paste")
                        ClipBoardActionView(iconSystemName: "arrow.down.doc", label: "Paste")
                        ClipBoardActionView(iconSystemName: "square.and.arrow.up", label: "xShare")
                    }.padding()
                }
                Divider()
                
                TextEditor(text: text)
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 100)
                    .cornerRadius(10.0)
                    //.border(Color.gray, width: 0.3)
                    
            }
        }
        .padding()
        
      
    }
}
