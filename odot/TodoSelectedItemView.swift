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
    @State var documentId: String
    
    private let fbUtil = FirebaseUtil.firebaseUtil
    
    @State private var isPrestentingImagePicker = false
    @State private var isPrestentingTodoItemEdit = false
    @State private var isPresentingLargeImage = false
    @State private var isPresentingHyperLinkEdit = false
    @State private var isPresentingBlockEdit = false
  
    var body: some View {
        
            ZStack {
                ScrollView(.vertical){
                    
                    VStack(alignment: .leading) {
                            
                        TitleTextView(dateFormatted: self.todoDataModel.todoData[todoItemIndex].getFormattedDate()) // ?? "Date here")
                        
                        DisclosureGroup(
                                        content : {
                                            ScrollView(.horizontal, showsIndicators: false) {
                                                
                                                ImagesViews(documentID: documentId)
                                            
                                            }
                                        }, label: {
                                            GroupTitleImagesView(systemName: icCamera, documentID: documentId, presented: isPrestentingImagePicker)
                                                //addNewHyperLinkItem()
                                        })
                                        .padding(.init(top: 10, leading: 20, bottom: 10, trailing: 20))
                    
                        Divider()
                        
                        DisclosureGroup(
                                        content : {
                                            ScrollView(.vertical, showsIndicators: true) {
                                                HyperLinkViews(documentID: documentId)
                                            }
                                            
                                        }, label: {
                                            GroupTitleHyperLinkView(systemName: icLink) {
                                                addNewHyperLinkItem()
                                            }
                                        })
                                        .padding(.init(top: 10, leading: 20, bottom: 10, trailing: 20))
                        Divider()
                        
                        
                        
                        DisclosureGroup(
                                        content : {
                                                ScrollView(.vertical, showsIndicators: true) {
                                                    CodeBlockViews(documentID: documentId)
                                                }
                                        }, label: {
                                            GroupTitleTextCodeBlockView(systemName: icCode){
                                                addNewCodeBlockItem()
                                            }
                                        })
                                        .padding(.init(top: 10, leading: 20, bottom: 10, trailing: 20))
                    
                        Divider()
                        
                    }
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

struct CodeBlockViews: View {
    @EnvironmentObject var todoDataModel: TodoDataModel
    
    @State var documentID: String
    
    @State private var isPresentingBlockEdit: Bool = false
    @State private var selectedItem: Int = 0
    
    @State private var expandItem: Bool = true
    
    func selectItem(index: Int){
        selectedItem = index
        print("Sel. CBLOCK index: \(index) Sel. SELECTEDITEM_INDEX: \(selectedItem)")
    }
    
    var body: some View {
        
            ForEach(todoDataModel.todoData[todoDataModel.mainIndex].codeBlocks.indices, id: \.self){ subIndex in
                    VStack{
                    
                        DisclosureGroup(
                                        content: {
                                            Text(todoDataModel.todoData[todoDataModel.mainIndex].codeBlocks[subIndex].code)
                                                .font(.system(size: 12))
                                                .foregroundColor(.black)
                                                .padding()
                                                .frame(width: UIScreen.main.bounds.width - 60, alignment: .topLeading)
                                        }, label: {
                                            CustomTextView(text: "\(todoDataModel.todoData[todoDataModel.mainIndex].codeBlocks[subIndex].getFormattedDate())", fontSize: 12, weight: .light, padding: 10).padding()
                                        })
                        
                    }
                    .onTapGesture(count: 2, perform: {
                        selectItem(index: subIndex)
                        isPresentingBlockEdit.toggle()
                    })
                    .onTapGesture(count: 1, perform: {
                       // expandItem.toggle()
                       // isPresentingBlockEdit.toggle()
                    })
                    .sheet(isPresented: $isPresentingBlockEdit, content: {
                        CodeBlockEditView(codeBlockIndex: $selectedItem, docID: documentID)
                    })
                    .padding()
                    .background(GrayBackGroundView(alpha: 0.0))
                    Divider()
                    
                }
                .animation(.easeIn)

    }
    
}

struct HyperLinkViews: View {
    
    @EnvironmentObject var todoDataModel: TodoDataModel
    @Environment(\.openURL) var openURL
    
    @State var documentID: String
    
    @State private var isPresentingEdit: Bool = false
    @State private var selectedItem: Int = 0
    
    @State private var expandItem: Bool = false
    
    private func selectItem(index: Int){
        selectedItem = index
        print("Sel. HLINK index: \(index) Sel. SELECTEDITEM_INDEX: \($selectedItem)")
    }
    
    var body: some View {
        
            ForEach(todoDataModel.todoData[todoDataModel.mainIndex].hyperLinks.indices, id: \.self){ subIndex in
                    VStack{
                    
                        DisclosureGroup(
                                        content: {
                                            VStack(alignment: .leading) {
                                                
                                                CustomTextView(text: "\(todoDataModel.todoData[todoDataModel.mainIndex].hyperLinks[subIndex].hyperlink.prefix(80) + "...")", fontSize: 12, fontColor: Color.blue, link: "\(todoDataModel.todoData[todoDataModel.mainIndex].hyperLinks[subIndex].hyperlink)")
                                                    .padding()
                                                    .frame(width: UIScreen.main.bounds.width - 60, alignment: .topLeading)
                                                   
                                            }
                                            .background(GrayBackGroundView())
                                            
                                           
                                        }, label: {
                                            ZStack {
                                                VStack(alignment: .leading, spacing: 5) {
                                                    CustomTextView(text: "\(todoDataModel.todoData[todoDataModel.mainIndex].hyperLinks[subIndex].title)", fontSize: 12, weight: .bold)
                                                    CustomTextView(text: "\(todoDataModel.todoData[todoDataModel.mainIndex].hyperLinks[subIndex].description)", fontSize: 12, weight: .light)
                                                }.padding()
                                            }
                                        })
                        
                    }
                    .onTapGesture(count: 2, perform: {
                        selectItem(index: subIndex)
                        isPresentingEdit.toggle()
                    })
                    .onTapGesture(count: 1, perform: {
                       // expandItem.toggle()
                       // isPresentingBlockEdit.toggle()
                    })
                    .sheet(isPresented: $isPresentingEdit, content: {
                        HyperLinkEditView(hyperLinkIndex: $selectedItem, docID: documentID)
                    })
                    .padding()
                    .background(GrayBackGroundView(alpha: 0.0))
                    Divider()
                    
                }
                .animation(.easeIn)
      
    }
    
}

struct ImagesViews: View {
    
    @EnvironmentObject var todoDataModel: TodoDataModel
    @State private var isPresenting: Bool = false
    @State var documentID: String
    @State private var selectedItem: Int = 0
    
    private let firebaseImageUtil: FirebaseImageUtil = FirebaseImageUtil()
    
    private func selectItem(index: Int){
        selectedItem = index
        print("Sel. IMG index: \(index) Sel. SELECTEDITEM_INDEX: \($selectedItem)")
    }
    
    var body: some View {
        
            ForEach(todoDataModel.todoData[todoDataModel.mainIndex].images.indices, id: \.self){ subIndex in
                    HStack{
                        
                        let image =
                            firebaseImageUtil.loadImage(storageReference: todoDataModel.todoData[todoDataModel.mainIndex].images[subIndex].storageReference)
                        
                        if let image = image {
                            Image(uiImage: image)
                                .resizable()
                                .padding()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 30, height: 30)
                        }
                    
                    }
                    .onTapGesture(count: 2, perform: {
                        selectItem(index: subIndex)
                        isPresenting.toggle()
                    })
                    .onTapGesture(count: 1, perform: {
                       // expandItem.toggle()
                       // isPresentingBlockEdit.toggle()
                    })
                    .sheet(isPresented: $isPresenting, content: {
                        //ImageLargeDisplayView(image: image)
                    })
                    .padding()
                    .background(GrayBackGroundView(alpha: 0.0))
                    Divider()
                    
                }
                .animation(.easeIn)
      
    }
    
}
//
//struct ImageRowButton: View {
//
//    @State var presented: Bool
//
//
//    var body: some View {
//
//        Button(action: {
//            presented.toggle()
//
//        }, label: {
//            Image(systemName: icImage)
//                .padding()
//                .foregroundColor(Color.black)
//        })
//        .background(GrayBackGroundView())
//        .sheet(isPresented: $presented) {
//            ImageLargeDisplayView(
//                image: icImage)
//        }
//
//    }
//}

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
    @State var documentID: String
    @State var presented: Bool
    
    var body: some View {
        
        HStack {
            
            Image(systemName: "\(systemName)")
                .resizable()
                .foregroundColor(.black)
                .aspectRatio(contentMode: .fit)
                .frame(width: 32, height: 32)
                .padding(.init(top: 5, leading: 10, bottom: 5, trailing: 10))
            
            VStack {
                Image(systemName: "plus")
                    .foregroundColor(.blue)
            }
            .onTapGesture(perform: {
                presented.toggle()
            })
            .sheet(isPresented: $presented, content: {
                ImagePickerPresenter(docID: documentID)
            })
            

        }
        .frame(width: UIScreen.main.bounds.width - 40, alignment: .leading)
        //.background(GrayBackGroundView(alpha: 0.1))
        .animation(.linear)
        
        
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
            
            Button(action: {
                onAction()
            }, label: {
                Image(systemName: "plus")
            })
        }
        .frame(width: UIScreen.main.bounds.width - 40, alignment: .leading)
        //.background(GrayBackGroundView(alpha: 0.1))
        .animation(.linear)
        
        
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
            
            Button(action: {
                onAction()
            }, label: {
                Image(systemName: "plus")
            })
        }
        .frame(width: UIScreen.main.bounds.width - 40, alignment: .leading)
        //.background(GrayBackGroundView(alpha: 0.1))
        .animation(.linear)
        
        
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
