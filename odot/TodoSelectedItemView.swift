//
//  TodoSelectedItemView.swift
//  odot
//
//  Created by Joakim Eberholst on 2021-01-24.
//

import SwiftUI
import Firebase
import Combine

struct TodoSelectedItemView: View {
    
    @EnvironmentObject var todoDataModel: TodoDataModel
    @State var todoItemIndex: Int
    @State var documentId: String? = nil
    private let fbUtil = FirebaseUtil.firebaseUtil
    
    @State private var isPrestentingImagePicker = false
    @State private var isPrestentingTodoItemEdit = false
    @State private var isPresentingLargeImage = false
    @State private var isPresentingHyperLinkEdit = false
    @State private var isPresentingBlockEdit = false
    
    var body: some View {
        
            ZStack {
                
                VStack(alignment: .leading) {
                        
                    TitleTextView(dateFormatted: self.todoDataModel.todoData[todoItemIndex].getFormattedDate()) // ?? "Date here")
                    
                    Group {
                        GroupTitleImagesView(systemName: icCamera, todoItem: self.todoDataModel.todoData[todoItemIndex], presented: isPrestentingImagePicker)
                        ScrollView(.horizontal, showsIndicators: false) {
                            
                            HStack(spacing: 15) {
                                ForEach(self.todoDataModel.todoData[todoItemIndex].images!, id: \.self){ item in
                                    ImageRowButton(presented: isPresentingLargeImage)
                                }
                                
                            }
                        }
                    }
                    .padding(.init(top: 10, leading: 20, bottom: 10, trailing: 20))
                    
                    Divider()
                    
                    Group {
                        
                        GroupTitleHyperLinkView(systemName: icLink) {
                            addNewHyperLinkItem()
                        }
                        
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 15) {
                                
                                ForEach(self.todoDataModel.todoData[todoItemIndex].hyperLinks!.indices, id: \.self){ subIndex in
                                    HyperLinkView(hyperLinkItem: self.todoDataModel.todoData[todoItemIndex].hyperLinks![subIndex], presented: isPresentingHyperLinkEdit, documentId: documentId!)
                                }
                                
                            }

                        }
                        
                    }
                    .padding(.init(top: 10, leading: 20, bottom: 10, trailing: 20))
                    
                    Divider()
                    
                    Group {
                        GroupTitleTextCodeBlockView(systemName: icCode){
                            addNewCodeBlockItem()
                        }
                        
                        ScrollView(.vertical, showsIndicators: true) {
                            VStack(spacing: 5) {
                                
                                ForEach(self.todoDataModel.todoData[todoItemIndex].codeBlocks!.indices, id: \.self){ subIndex in
                                    CodeBlockView(codeBlockItem: self.todoDataModel.todoData[todoItemIndex].codeBlocks![subIndex], presented: isPresentingBlockEdit, codeBlockIndex: subIndex, documentID: documentId!)
                                }.animation(.easeIn)
                                
                            }
                        }
        
                    }
                    .padding(.init(top: 10, leading: 20, bottom: 10, trailing: 20))
                    Divider()
                    
                }
            }
            .navigationBarItems(trailing: Button(action: {
                isPrestentingTodoItemEdit.toggle()
            }, label: {
                Image(systemName: icEdit)
            }).sheet(isPresented: $isPrestentingTodoItemEdit, content: {
                SelectedTodoItemEditView(todoItem: self.todoDataModel.todoData[todoItemIndex], docID: documentId!)
            }))
            .navigationBarTitle("\(self.todoDataModel.todoData[todoItemIndex].title)")
            .onAppear(){
                setSelectedMainIndex(mainIndex: self.todoItemIndex)
            }
        
    }

    private func setSelectedMainIndex(mainIndex: Int){
        todoDataModel.mainIndex = mainIndex
    }
        
    private func addNewHyperLinkItem(){
        addNewItem(type: .HYPERLINK)
    }
    
    private func addNewCodeBlockItem(){
        addNewItem(type: .CODEBLOCK)
    }
    
    private func addNewItem(type: DOC_FIELDS_NEW){
        
        if let documentId = self.documentId {
            
            var deterDocumentField: String
            var docData : [String: Any] = [:]
            let FIELD_HYPERLINKS = "hyperLinks"
            let FIELD_CODEBLOCKS = "codeBlocks"

            switch(type){
            case .HYPERLINK:
                
                deterDocumentField = FIELD_HYPERLINKS
                
                docData = HyperLinkItem(
                    title: "New title",
                    description: "New description",
                    hyperlink: "https://linkhere.change").getAsDictionary()
                
                print("Click: Added hyperlink item...")
            
            case .CODEBLOCK:
                
                deterDocumentField = FIELD_CODEBLOCKS
            
                docData = CodeBlockItem(
                    code: "New description").getAsDictionary()
                
                print("Click: Added new code block item...")
                
            }
            
            fbUtil.updateDocumentFieldArrayUnion(documentID: documentId, documentField: deterDocumentField, docData: docData)
            
        }
    }

}

enum DOC_FIELDS_NEW {
    case HYPERLINK, CODEBLOCK;
}


struct ImageRowButton: View {
    
    @State var presented: Bool
    
    var body: some View {
 
        Button(action: {
            presented.toggle()
            
        }, label: {
            Image(systemName: icImage)
                .padding()
                .foregroundColor(Color.black)
        })
        .background(GrayBackGroundView())
        .sheet(isPresented: $presented) {
            ImageLargeDisplayView(
                image: icImage)
        }

    }
}

struct CodeBlockView: View {
    
    @State var codeBlockItem: CodeBlockItem
    @State var presented: Bool
    @State var codeBlockIndex: Int

    var documentID: String
     
    var body: some View {
    
        VStack{
        
            VStack(alignment: .trailing) {
                
                CustomTextView(text: "\(codeBlockItem.getFormattedDate())", fontSize: 12, weight: .light, padding: 10)
      
                Divider()
                
                Text("\(codeBlockItem.code)")
                    .font(.system(size: 12))
                    .foregroundColor(.black)
                    .padding()
                    .frame(width: UIScreen.main.bounds.width - 30, height: 100, alignment: .topLeading)
            }
            
        }
        .background(GrayBackGroundView())
        .onTapGesture(count: 1, perform: {
            presented.toggle()
        })
        .sheet(isPresented: $presented, content: {
            CodeBlockEditView(codeBlockItem: codeBlockItem, codeBlockIndex: codeBlockIndex, docID: documentID)
        })
        .animation(.linear)
        Divider()
        
    }
    
}

struct HyperLinkView: View {
    
    @State var hyperLinkItem: HyperLinkItem
    @State var presented: Bool
    var documentId: String

    var body: some View {
        
        VStack(alignment: .center, spacing: 5) {
  
            CustomTextView(text: "\(hyperLinkItem.title)", fontSize: 12, weight: .bold)
            CustomTextView(text: "\(hyperLinkItem.getFormattedDate())", fontSize: 10)
            CustomTextView(text: "\(hyperLinkItem.description)", fontSize: 12, weight: .none)
            CustomTextView(text: "\(hyperLinkItem.hyperlink.prefix(20) + "...")", fontSize: 12, fontColor: Color.blue, link: hyperLinkItem.hyperlink)
            
        }
        .frame(width: UIScreen.main.bounds.width/2, height: 100, alignment: .center)
        .onTapGesture(count: 1, perform: {
            presented.toggle()
        })
        .sheet(isPresented: $presented, content: {
            HyperLinkEditView(hyperLinkItem: hyperLinkItem, docID: documentId)
        })
        .background(GrayBackGroundView())
        .animation(.linear)

    }

}

struct CustomTextView: View {
    
    var text: String
    var fontSize: CGFloat
    var fontColor: Color? = nil
    var weight: Optional<Font.Weight>? = nil
    var padding: CGFloat? = nil
    var link: String? = nil
    
    var body: some View {
        
        if link != nil {
            if let link = link {
                Link(destination: URL(string: "\(link)")!, label: {
                    Text("\(text)")
                        .font(.system(size: fontSize))
                        .foregroundColor(checkColor())
                        .fontWeight(checkFontWeight())
                        .padding(checkPadding())
                })
            }
        } else {
            Text("\(text)")
                .font(.system(size: fontSize))
                .foregroundColor(checkColor())
                .fontWeight(checkFontWeight())
                .padding(checkPadding())
        }
        
    }
    
    private func checkColor() -> Color {
        if let fColor = fontColor {
            return fColor
        }else{
            return Color.black
        }
    }
    
    private func checkFontWeight() -> Optional<Font.Weight> {
        if let fWeight = weight {
            return fWeight
        }else{
            return Font.Weight.regular
        }
    }
    
    private func checkPadding() -> CGFloat {
        if let fPadding = padding {
            return fPadding
        }else{
            return 0
        }
    }
    
    
}

struct GroupTitleImagesView: View {
    
    var systemName: String
    @State var todoItem: TodoItem
    @State var presented: Bool
    
    var body: some View {
        
        HStack {
            
            Image(systemName: "\(systemName)")
                .resizable()
                .foregroundColor(.black)
                .aspectRatio(contentMode: .fit)
                .frame(width: 32, height: 32)
                .padding(.init(top: 5, leading: 10, bottom: 5, trailing: 10))
        
            Spacer()
            
            VStack {
                Image(systemName: "plus")
                    .foregroundColor(.blue)
            }
            .onTapGesture(perform: {
                presented.toggle()
            })
            .sheet(isPresented: $presented, content: {
               // ImagePickerPresenter(todoItem: todoItem, mainIndex: mainIndex)
            })
            

        }.animation(.linear)
        
        
    }
}

struct GroupTitleHyperLinkView: View {
    
    var systemName: String
    var onAction: () -> ()
    
    var body: some View {
        
        HStack {
            
            Image(systemName: "\(systemName)")
                .resizable()
                .foregroundColor(.black)
                .aspectRatio(contentMode: .fit)
                .frame(width: 32, height: 32)
                .padding(.init(top: 5, leading: 10, bottom: 5, trailing: 10))
        
            Spacer()
            
            Button(action: {
                onAction()
            }, label: {
                Image(systemName: "plus")
            })

        }
        
        
    }
}

struct GroupTitleTextCodeBlockView: View {
    
    var systemName: String
    var onAction: () -> ()
    
    var body: some View {
        
        HStack {
            Image(systemName: "\(systemName)")
                .resizable()
                .foregroundColor(.black)
                .aspectRatio(contentMode: .fit)
                .frame(width: 32, height: 32)
                .padding(.init(top: 5, leading: 10, bottom: 5, trailing: 10))
            
            Spacer()
            
            Button(action: {
                onAction()
            }, label: {
                Image(systemName: "plus")
            })
        }
        
        
    }
}

struct TitleTextView: View {
    
    var dateFormatted: String
    
    var body: some View {
        Text("\(dateFormatted)")
            .font(.system(size: 10))
            .padding(.init(top: 20, leading: 25, bottom: 15, trailing: 0))
    }
}

struct ItemCountView: View {
    
    var itemCount: Int
    
    var body: some View {
        ZStack{
            Circle()
                .frame(width: 32, height: 32, alignment: .center)
            Circle()
                .frame(width: 30, height: 30, alignment: .center)
                .foregroundColor(.white)
            Text("\(itemCount)")
                .foregroundColor(.black)
        }
    }
}

//struct TodoSelectedItemView_Previews: PreviewProvider {
//    static var previews: some View {
//        TodoSelectedItemView(todoItem: TodoItem())
//    }
//}
