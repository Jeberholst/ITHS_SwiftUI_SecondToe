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
//    @State var codeBlockData : [CodeBlockItem]
    @State var todoItemIndex: Int
    @State var documentId: String
    
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
                                
                                ForEach(self.todoDataModel.todoData[todoItemIndex].images, id: \.self){ item in
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
                                
//                                ForEach(self.todoDataModel.todoData[todoDataModel.mainIndex].hyperLinks.indices, id: \.self){ subIndex in
//
//                                        HyperLinkView(presented: isPresentingHyperLinkEdit,
//                                                      hyperLinkIndex: subIndex,
//                                                      documentId: documentId)
//                                            .environmentObject(todoDataModel)
//                                    }
//
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
                            createCodeViews(documentID: documentId)
                            //VStack(spacing: 5) {

                                //createCodeViews(documentID: documentId)

                                //ForEach(todoDataModel.todoData[todoDataModel.mainIndex].codeBlocks.indices, id: \.self){ subIndex in
//                            ForEach(Array(todoDataModel.todoData[todoDataModel.mainIndex].codeBlocks.enumerated()), id: \.self){ subIndex in
//                                    //CodeBlockView(codeBlockItem: todoDataModel.todoData[todoDataModel.mainIndex].codeBlocks[subIndex],
//                                    CodeBlockView(presented: isPresentingBlockEdit,
//                                                  codeBlockIndex: subIndex,
//                                                  documentID: documentId!)
//                                        .environmentObject(todoDataModel)
//
//                                    }
//                                    .animation(.easeIn)
                           // }
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
                SelectedTodoItemEditView(todoItem: self.todoDataModel.todoData[todoItemIndex], docID: documentId)
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
        
//        if let documentId = self.documentId {
            
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
            
//        }
    }

}

enum DOC_FIELDS_NEW {
    case HYPERLINK, CODEBLOCK;
}

struct createCodeViews: View {
    @EnvironmentObject var todoDataModel: TodoDataModel
   
    @State var documentID: String
    
    @State private var isPresentingBlockEdit: Bool = false
    @State private var selectedItem: Int = 0
    
    func selectItem(index: Int){
        selectedItem = index
    }
    
    var body: some View {
        
        //VStack(spacing: 5) {
        
            ForEach(todoDataModel.todoData[todoDataModel.mainIndex].codeBlocks.indices, id: \.self){ subIndex in
                    //CodeBlockView(codeBlockItem: todoDataModel.todoData[todoDataModel.mainIndex].codeBlocks[subIndex],
                    VStack{
                    
                        VStack(alignment: .trailing) {
                            
                            CustomTextView(text: "\(todoDataModel.todoData[todoDataModel.mainIndex].codeBlocks[subIndex].getFormattedDate())", fontSize: 12, weight: .light, padding: 10)
                  
                            Divider()
                            
                            Text(todoDataModel.todoData[todoDataModel.mainIndex].codeBlocks[subIndex].code)
                                .font(.system(size: 12))
                                .foregroundColor(.black)
                                .padding()
                                .frame(width: UIScreen.main.bounds.width - 30, height: 100, alignment: .topLeading)
                        }
                        
                    }
                    .background(GrayBackGroundView())
                    .onTapGesture(count: 1, perform: {
                        selectItem(index: subIndex)
                        isPresentingBlockEdit.toggle()
                    })
                    .sheet(isPresented: $isPresentingBlockEdit, content: {
                        CodeBlockEditView(codeBlockItem: todoDataModel.todoData[todoDataModel.mainIndex].codeBlocks[selectedItem], codeBlockIndex: selectedItem, docID: documentID)
                    })
                    .animation(.linear)
                    Divider()
                    
                }
                .animation(.easeIn)
       // }
    }
    
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
    
    @EnvironmentObject var todoDataModel: TodoDataModel
    @State var presented: Bool
    @State var codeBlockIndex: Int
    var documentID: String
     
    var body: some View {
    
        let item = todoDataModel.todoData[todoDataModel.mainIndex].codeBlocks[codeBlockIndex]
            
            VStack{
            
                VStack(alignment: .trailing) {
                    
                    CustomTextView(text: "\(item.getFormattedDate())", fontSize: 12, weight: .light, padding: 10)
          
                    Divider()
                    
                    Text(item.code)
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
                CodeBlockEditView(codeBlockItem: todoDataModel.todoData[todoDataModel.mainIndex].codeBlocks[codeBlockIndex], codeBlockIndex: codeBlockIndex, docID: documentID)
            })
            .animation(.linear)
            Divider()
        
    }
    
}

struct ToggleStates {
    var oneIsOn: Bool = false
    var twoIsOn: Bool = true
}


struct HyperLinkView: View {
    
    @EnvironmentObject var todoDataModel: TodoDataModel
    @State var presented: Bool
    @State var hyperLinkIndex: Int
    var documentId: String

    var body: some View {
        
        let item = todoDataModel.todoData[todoDataModel.mainIndex].hyperLinks[hyperLinkIndex]
        
        VStack(alignment: .center, spacing: 5) {
            
            VStack {
                CustomTextView(text: "\(item.title)", fontSize: 12, weight: .bold)
                CustomTextView(text: "\(item.getFormattedDate())", fontSize: 10)
                CustomTextView(text: "\(item.description)", fontSize: 12, weight: .none)
                CustomTextView(text: "\(item.hyperlink.prefix(20) + "...")", fontSize: 12, fontColor: Color.blue, link: item.hyperlink)
            }
   
        }
        .frame(width: UIScreen.main.bounds.width/2, height: 100, alignment: .center)
        .onTapGesture(count: 1, perform: {
            presented.toggle()
        })
        .sheet(isPresented: $presented, content: {
            HyperLinkEditView(hyperLinkItem: item, hyperLinkIndex: hyperLinkIndex, docID: documentId)
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
