//
//  TodoSelectedItemView.swift
//  odot
//
//  Created by Joakim Eberholst on 2021-01-24.
//

import SwiftUI

struct TodoSelectedItemView: View {
    
    @State var todos: Todos
    @State var todoItem: TodoItem? = nil
    //@State var currentSelection: Int = 0
    
    var body: some View {
        
        ZStack {
            
            
            VStack {
                
                HStack(content: {
                    Text("\(todoItem!.title)")
                        .padding()

                })
                
                GroupBox{
                    HStack {
                        ForEach(0 ..< 5) { item in
                            ImageRowButton(text: "1")
                        }
                    }
                }
                GroupBox(label: GroupTitleTextView(text: "Hyperlinks"), content: {
                    HStack {
                       List(){
                            ForEach(todoItem!.hyperLinks){ item in
                                HyperLinkView(hyperLinkItem: item)
                            }.onDelete(perform: { indexSet in
                                
                              //  let todoItemIndex = todos.listOfItems.firstIndex { self.$todos.$listOfItems -> todoItem?.id}
                                
                                todoItem?.hyperLinks.remove(atOffsets: indexSet)
                               // todos.listOfItems[]
                            })

                       }
                    }
                })
              
                
                Spacer()
                
                
                let mockTodoBlock = ["Block 1 asdasdasdasdsdasdasdasdasdasdasdasdasda", "Block 2 asdasdasdasdasdasdsdasdas", "Block 3", "Block 4"]
                
                GroupBox(label: GroupTitleTextView(text: "Code-Blocks"), content: {
                    HStack {
                       List(){
                            ForEach(0 ..< mockTodoBlock.capacity) { i in
                                TodoBlockView(blockContent: mockTodoBlock[i])
                            }
                       }
                    }
                })
              
                
            }
        
        }
            
    }
}

struct TodoSelectedItemView_Previews: PreviewProvider {
    static var todo = Todos()
    
    static var previews: some View {
        TodoSelectedItemView(todos: Todos(), todoItem: todo.listOfItems[0])
    }
}

struct ImageRowButton: View {
    
    var text: String
    
    var body: some View {
        
        Button(action: {
            
        }, label: {
            Image(systemName: "photo")
                .padding()
                .border(Color.gray, width: 1)
                .cornerRadius(3.0)
        })
    }
}

struct TodoBlockView: View {
    
    var blockContent: String
    @State private var comment: String = "Comment"
    
    var body: some View {
        
        VStack {
            
            
            HStack {
                
                //Text latest change Date
                //Comment? Below?
                //Delete button?
                //Create new button?
                
                Text("\(blockContent)")
                    .padding()
                    .font(.system(size: 12))
                    .lineSpacing(5.0)
            
                GroupBox {
            
                    Spacer()
                    ClipBoardActionView(iconSystemName: "doc.on.clipboard", label: "Copy")
                    ClipBoardActionView(iconSystemName: "doc.on.clipboard.fill", label: "Paste")
                    ClipBoardActionView(iconSystemName: "pencil", label: "Edit")
                    ClipBoardActionView(iconSystemName: "square.and.arrow.up.fill", label: "xShare")

                }
                
                
            }
            
            TextField("Placeholder", text: $comment)
                .padding()
         
        }
        
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
                .frame(width: 16, height: 16)
            Text(label)
                .font(.system(size: 12))
        }
        .cornerRadius(3.0)
        
    }
}

struct HyperLinkView: View {
    
    var hyperLinkItem: HyperLinkItem
    
    var body: some View {
       
        VStack(alignment: .leading) {
            Text("\(hyperLinkItem.title)")
                .bold()
            Text("\(hyperLinkItem.description)")
                .font(.system(size: 14))
            Text("\(hyperLinkItem.hyperlink)")
                .font(.system(size: 14))
                .foregroundColor(.blue)
        }
            
    }
}

struct GroupTitleTextView: View {
    
    var text: String
    
    var body: some View {
        
        HStack {
            Text("\(text)")
                .foregroundColor(.black)
                .font(.custom("Brush Script MT", size: 16))
            Spacer()
            
            Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                Image(systemName: "plus")
                    .padding()
                    
            })
        }
        
        
    }
}
