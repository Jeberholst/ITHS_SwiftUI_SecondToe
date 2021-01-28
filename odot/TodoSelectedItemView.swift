//
//  TodoSelectedItemView.swift
//  odot
//
//  Created by Joakim Eberholst on 2021-01-24.
//

import SwiftUI

struct TodoSelectedItemView: View {
    
    @EnvironmentObject var todos: Todos
    @State var todoItem: TodoItem? = nil
    @State var listItemIndex: Int
    @State private var imagesCount: Int = 0
    @State private var hyperLinksCount: Int = 0
    @State private var codeBlocksCount: Int = 0
    
    var body: some View {
        
        ZStack {
            
                VStack(alignment: .leading) {
                    
                    TitleTextView(dateFormatted: todoItem!.getFormattedDate())
                    
                    Group {
                        GroupTitleImageView(systemName: "camera", itemCount: 0){
                            addNewImageItem()
                        }
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(0 ..< 7) { i in
                                    ImageRowButton(mainIndex: listItemIndex, imageIndex: i)
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
                                    HyperLinkView(hyperLinkItem: todoItem!.hyperLinks[item], itemIndex: item)
                                
                                    
                                }.background(GrayBackGroundView())
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
                                    CodeBlockView(codeBlockItem: todoItem!.codeBlocks[item])
                                        .background(GrayBackGroundView())
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
                //imagesCount = todoItem!.hyperLinks.count
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
    
    var body: some View {
        
        Button(action: {
            print("MainIndex: \(mainIndex) ImageIndex: \(imageIndex)" )
        }, label: {
            Image(systemName: "photo")
                .padding()
                .foregroundColor(Color.black)
        })
        .background(GrayBackGroundView())

    }
}

struct CodeBlockView: View {
    
    var codeBlockItem: CodeBlockItem
     
    var body: some View {
    
        VStack{
        
            NavigationLink(
                destination: CodeBlockEditView(codeBlockItem: codeBlockItem),
                label: {
                    VStack(alignment: .trailing) {
                        Text("\(codeBlockItem.getFormattedDate())")
                            .font(.system(size: 12))
                            .foregroundColor(.black)
                            .padding()
                        
                        Text("\(codeBlockItem.code)")
                            .padding()
                            .font(.system(size: 12))
                            .foregroundColor(.black)
                            .frame(width: UIScreen.main.bounds.width - 30, height: 100, alignment: .topLeading)
                    }
    
                })
            
        }
        Divider()
        
    }
    
}

struct HyperLinkView: View {
    
    var hyperLinkItem: HyperLinkItem
    var itemIndex: Int
    
    var body: some View {
        
        NavigationLink(
            destination: HyperLinkEditView(hyperLinkItem: hyperLinkItem),
            label: {
              
                VStack(alignment: .center) {
                    
                    Text("\(hyperLinkItem.title)")
                        .bold()
                        .foregroundColor(.black)
                    Text("\(hyperLinkItem.description)")
                        .font(.system(size: 14))
                        .foregroundColor(.black)
                    Text("2021-02-33") //ADD DATE
                        .font(.system(size: 10))
                    Text("\(hyperLinkItem.hyperlink.prefix(20) + "...")")
                        .font(.system(size: 14))
                        .foregroundColor(.blue)
                        
                }
                .frame(width: UIScreen.main.bounds.width/2, height: 100, alignment: .center)
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
