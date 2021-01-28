//
//  TodoSelectedItemView.swift
//  odot
//
//  Created by Joakim Eberholst on 2021-01-24.
//

import SwiftUI

struct TodoSelectedItemView: View {
    
    @EnvironmentObject var todos: Todos
    @Environment(\.presentationMode) var presentationMode
    
    @State var todoItem: TodoItem? = nil
    @State var listItemIndex: Int
    @State private var imagesCount: Int = 7
    @State private var hyperLinksCount: Int = 0
    @State private var codeBlocksCount: Int = 0
    
    @State private var isPresentingLargeImage = false
    @State private var isPresentingHyperLinkEdit = false
    @State private var isPresentingBlockEdit = false
    
    var body: some View {
        
        
        ZStack {
            
                VStack(alignment: .leading) {
                    
                    TitleTextView(dateFormatted: todoItem!.getFormattedDate())
                    
                    Group {
                        GroupTitleImageView(systemName: "camera", itemCount: imagesCount){
                            addNewImageItem()
                        }
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(0 ..< imagesCount) { i in
                                
                                    ImageRowButton(mainIndex: listItemIndex, imageIndex: i, presented: isPresentingLargeImage)
                                }
                            }
                        }
                    }
                    .padding(.init(top: 10, leading: 20, bottom: 10, trailing: 20))
                    
                    Divider()
                    
                    Group {
                        
                        GroupTitleImageView(systemName: "link", itemCount: hyperLinksCount) {
                            addNewHyperLinkItem()
                        }
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                              
                                ForEach((0 ..< hyperLinksCount).reversed(), id: \.self){item in
                                    HyperLinkView(hyperLinkItem: todoItem!.hyperLinks[item], itemIndex: item, presented: isPresentingHyperLinkEdit)
                                
                                }
                                .background(GrayBackGroundView())
                          
                            }
                        }
                    }
                    .padding(.init(top: 10, leading: 20, bottom: 10, trailing: 20))
                    
                    Divider()
                    
                    Group {
                        GroupTitleTextCodeBlockView(systemName: "chevron.left.slash.chevron.right", itemCount: codeBlocksCount){
                            addNewCodeBlockItem()
                        }
                        
                        ScrollView(.vertical, showsIndicators: false) {
                            VStack {
                               
                                ForEach((0 ..< codeBlocksCount).reversed(), id: \.self){item in
                                    CodeBlockView(codeBlockItem: todoItem!.codeBlocks[item], presented: isPresentingBlockEdit)
                                        
                                }
                            }
                        }
        
                    }
                    .padding(.init(top: 10, leading: 20, bottom: 10, trailing: 20))
                    Divider()
                    
                }
            }
            .navigationBarTitle("\(todoItem!.title)")
            .onAppear(){
                imagesCount = 7 //todoItem!.hyperLinks.count
                hyperLinksCount = todoItem!.getHyperLinksCount()
                codeBlocksCount = todoItem!.getCodeBlocksCount()
            }
        
        
    }
    
    private func addNewImageItem(){
        print("Click: Add new image...")
    }
    
    private func addNewHyperLinkItem(){
        let newItem = HyperLinkItem()
        todos.listOfItems[listItemIndex].addHyperLinkItem(item: newItem)
        todoItem?.addHyperLinkItem(item: newItem)
        hyperLinksCount += 1
        print("Click: Add hyperlink item...")
    }
    
    private func addNewCodeBlockItem(){
        let newItem = CodeBlockItem()
        todos.listOfItems[listItemIndex].addCodeBlockItem(item: newItem)
        todoItem?.addCodeBlockItem(item: newItem)
        codeBlocksCount += 1
        print("Click: Add new code block item...")
    }

}

struct TodoSelectedItemView_Previews: PreviewProvider {
    static var todo = Todos()
    static var previews: some View {
        TodoSelectedItemView(todoItem: todo.listOfItems[3], listItemIndex: 3)
    }
}


struct ImageRowButton: View {
    
    var mainIndex: Int
    var imageIndex: Int
    @State var presented: Bool
    
    var body: some View {
 
        Button(action: {
            presented.toggle()
            print("MainIndex: \(mainIndex) ImageIndex: \(imageIndex)" )
        }, label: {
            Image(systemName: "photo")
                .padding()
                .foregroundColor(Color.black)
        })
        .background(GrayBackGroundView())
        .sheet(isPresented: $presented) {
            ImageLargeDisplayView(
                image: "link", mainIndex: mainIndex, imageIndex: imageIndex)
        }

    }
}

struct CodeBlockView: View {
    
    var codeBlockItem: CodeBlockItem
    @State var presented: Bool
     
    var body: some View {
    
        VStack{
        
            VStack(alignment: .trailing) {
                Text("\(codeBlockItem.getFormattedDate())")
                    .font(.system(size: 12))
                    .foregroundColor(.black)
                    .padding()
                
                Divider()
                
                Text("\(codeBlockItem.code)")
                    .padding()
                    .font(.system(size: 12))
                    .foregroundColor(.black)
                    .frame(width: UIScreen.main.bounds.width - 30, height: 100, alignment: .topLeading)
            }
            
        }
        .background(GrayBackGroundView())
        .onTapGesture(count: 1, perform: {
            presented.toggle()
        })
        .sheet(isPresented: $presented, content: {
            CodeBlockEditView(codeBlockItem: codeBlockItem)
        })
        Divider()
        
    }
    
}

struct HyperLinkView: View {
    
    var hyperLinkItem: HyperLinkItem
    var itemIndex: Int
    @State var presented: Bool
    
    var body: some View {
        
        VStack(alignment: .center) {
            
            Text("\(hyperLinkItem.getFormattedDate())") //ADD DATE
                .font(.system(size: 10))
                .foregroundColor(.black)
            Text("\(hyperLinkItem.title)")
                .bold()
                .foregroundColor(.black)
            Text("\(hyperLinkItem.description)")
                .font(.system(size: 14))
                .foregroundColor(.black)
            Text("\(hyperLinkItem.hyperlink.prefix(20) + "...")")
                .font(.system(size: 14))
                .foregroundColor(.blue)
        }
        .frame(width: UIScreen.main.bounds.width/2, height: 100, alignment: .center)
        .onTapGesture(count: 1, perform: {
            presented.toggle()
        })
        .sheet(isPresented: $presented, content: {
            HyperLinkEditView(hyperLinkItem: hyperLinkItem)
        })

    }

}

struct GroupTitleImageView: View {
    
    var systemName: String
    var itemCount: Int
    var onAction: () -> ()
    
    var body: some View {
        
        HStack {
            
            Image(systemName: "\(systemName)")
                .resizable()
                .foregroundColor(.black)
                .aspectRatio(contentMode: .fit)
                .frame(width: 32, height: 32)
                .padding(.init(top: 5, leading: 10, bottom: 5, trailing: 10))
            
            Text("\(itemCount)")
                .foregroundColor(.black)
                .underline()
                
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
    var itemCount: Int
    var onAction: () -> ()
    
    var body: some View {
        
        HStack {
            Image(systemName: "\(systemName)")
                .resizable()
                .foregroundColor(.black)
                .aspectRatio(contentMode: .fit)
                .frame(width: 32, height: 32)
                .padding(.init(top: 5, leading: 10, bottom: 5, trailing: 10))
            
            Text("\(itemCount)")
                .underline()
            
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
