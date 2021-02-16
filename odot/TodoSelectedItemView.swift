//
//  TodoSelectedItemView.swift
//  odot
//
//  Created by Joakim Eberholst on 2021-01-24.
//

import SwiftUI
import Firebase
import Combine
import FirebaseStorage
import SDWebImageSwiftUI

let bc = Color("Background")

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
                                            ScrollView(.horizontal, showsIndicators: true) {
                                                
                                                ImagesScrollView(documentID: documentId)
                                            
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
                                                HyperLinksScrollView(documentID: documentId)
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
                                                    CodeBlockScrollView(documentID: documentId)
                                                }
                                        }, label: {
                                            GroupTitleTextCodeBlockView(systemName: icCode){
                                                addNewCodeBlockItem()
                                            }
                                        })
                                        .padding(.init(top: 10, leading: 20, bottom: 10, trailing: 20))
                    
                        
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

struct CodeBlockScrollView: View {
    
    @EnvironmentObject var todoDataModel: TodoDataModel
    
    @State var documentID: String
    
    @State private var isPresentingBlockEdit: Bool = false
    @State private var selectedItem: Int = 0
    
    @State private var expandItem: Bool = true
    
    func selectItem(index: Int){
        selectedItem = index
    }
    
    var body: some View {
        
            ForEach(todoDataModel.todoData[todoDataModel.mainIndex].codeBlocks.indices, id: \.self){ subIndex in
                    VStack{
                        DisclosureGroup(
                                        content: {
                                            Text(todoDataModel.todoData[todoDataModel.mainIndex].codeBlocks[subIndex].code)
                                                .font(.system(size: 12))
                                                //.foregroundColor(Color("Font"))
                                                .padding()
                                                .frame(width: UIScreen.main.bounds.width - 60, alignment: .topLeading)
                                        }, label: {
                                        
                                            CustomTextView(text: "\(todoDataModel.todoData[todoDataModel.mainIndex].codeBlocks[subIndex].getFormattedDate())", fontSize: 12, weight: .semibold, padding: 10)
                                                .padding(.init(top: 0, leading: 10, bottom: 0, trailing: 10))
                                            
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
                    //Divider()
                    
                }
                .animation(.easeIn)

    }
    
}

struct HyperLinksScrollView: View {
    
    @EnvironmentObject var todoDataModel: TodoDataModel
    @Environment(\.openURL) var openURL
    
    @State var documentID: String
    
    @State private var isPresentingEdit: Bool = false
    @State private var selectedItem: Int = 0
    
    private func selectItem(index: Int){
        selectedItem = index
    }
    
    var body: some View {
        
            ForEach(todoDataModel.todoData[todoDataModel.mainIndex].hyperLinks.indices, id: \.self){ subIndex in
                    VStack{
                    
                        DisclosureGroup(
                                        content: {
                                            
                                            VStack(alignment: .leading) {
                                                
                                                CustomTextView(text: "\(todoDataModel.todoData[todoDataModel.mainIndex].hyperLinks[subIndex].hyperlink.prefix(80) + "...")", fontSize: 12, fontColor: Color.blue, link: "\(todoDataModel.todoData[todoDataModel.mainIndex].hyperLinks[subIndex].hyperlink)")
                                                    .textCase(.lowercase)
                                                    .padding()
                                                    .frame(width: UIScreen.main.bounds.width - 60, alignment: .topLeading)
                                                   
                                            }
                
                                        }, label: {
                                            
                                            VStack(alignment: .leading, spacing: 5) {
                                                CustomTextView(text: "\(todoDataModel.todoData[todoDataModel.mainIndex].hyperLinks[subIndex].title)", fontSize: 12, weight: .bold)
                                                CustomTextView(text: "\(todoDataModel.todoData[todoDataModel.mainIndex].hyperLinks[subIndex].description)", fontSize: 12, weight: .light)
                                            }
                                            .padding(.init(top: 0, leading: 15, bottom: 0, trailing: 15))
                                       
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
                    
                    
                }
                .animation(.easeIn)
      
    }
    
}

struct ImagesScrollView: View {
    
    @EnvironmentObject var todoDataModel: TodoDataModel
    
    @State private var isPresenting: Bool = false
    @State var documentID: String
    @State private var selectedItem: Int = 0
    @State private var selectedImage: String = ""
    
    private func selectItem(index: Int){
        selectedItem = index
    }
    private func selectImage(imageRef: String){
        selectedImage = imageRef
    }
    
    var body: some View {
        HStack {
            ForEach(todoDataModel.todoData[todoDataModel.mainIndex].images.indices, id: \.self){ subIndex in
                    HStack{
                        let imageRef = todoDataModel.todoData[todoDataModel.mainIndex].images[subIndex].storageReference
                        
                        if let imageRef = imageRef {
                            
                            WebImage(url: URL(string: imageRef))
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .cornerRadius(5)
                                .frame(width: 75, height: 75)
                            
                        } else {
                           
                            Image(systemName: "photo")
                                .resizable()
                                .padding()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 75, height: 75)
                        }
                    
                    }
                    .onTapGesture(count: 2, perform: {
                        selectItem(index: subIndex)
                        selectImage(imageRef: todoDataModel.todoData[todoDataModel.mainIndex].images[subIndex].storageReference)
                        isPresenting.toggle()
                    })
                    .sheet(isPresented: $isPresenting, content: {
                        ImageLargeDisplayView(imagesSelectedIndex: $selectedItem, selectedImage: $selectedImage, docID: documentID)
                    })
                    .padding()
                    .background(GrayBackGroundView(alpha: 0.0))
                    
                }
                .animation(.easeIn)
        }
    
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
                Link(destination: URL(string: "https://\(link)")!, label: {
                    Text("\(text)")
                        .font(.system(size: fontSize))
                        .fontWeight(checkFontWeight())
                        .padding(checkPadding())
                })
            }
        } else {
            Text("\(text)")
                .font(.system(size: fontSize))
                .fontWeight(checkFontWeight())
                .padding(checkPadding())
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
                .foregroundColor(Color("Icons"))
                .aspectRatio(contentMode: .fit)
                .frame(width: 32, height: 32)
                .padding(.init(top: 5, leading: 10, bottom: 5, trailing: 10))
            
            VStack {
                Image(systemName: icPlus)
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
                .foregroundColor(Color("Icons"))
                .aspectRatio(contentMode: .fit)
                .frame(width: 32, height: 32)
                .padding(.init(top: 5, leading: 10, bottom: 5, trailing: 10))
            
            Button(action: {
                onAction()
            }, label: {
                Image(systemName: icPlus)
            })
        }
        .frame(width: UIScreen.main.bounds.width - 40, alignment: .leading)
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
                .foregroundColor(Color("Icons"))
                .aspectRatio(contentMode: .fit)
                .frame(width: 32, height: 32)
                .padding(.init(top: 5, leading: 10, bottom: 5, trailing: 10))
            
            Button(action: {
                onAction()
            }, label: {
                Image(systemName: icPlus)
            })
        }
        .frame(width: UIScreen.main.bounds.width - 40, alignment: .leading)
        .animation(.linear)
        
        
    }
}

struct TitleTextView: View {
    
    var dateFormatted: String
    
    var body: some View {
        Text("\(dateFormatted)")
            .font(.system(size: 10))
            .foregroundColor(Color("AccentColor"))
            .padding(.init(top: 20, leading: 25, bottom: 15, trailing: 0))
    }
}
