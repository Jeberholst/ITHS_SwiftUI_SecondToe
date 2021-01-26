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
                            .font(.title)
                    })
                    
                    
                    
                    Group {
                        GroupTitleImageView(systemName: "photo.on.rectangle.angled")
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(0 ..< 7) { item in
                                    ImageRowButton(text: "1")
                                }
                            }
                        }
                    }.padding()
                    Divider()
                    
                    Group {
                        GroupTitleImageView(systemName: "link.circle")
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(0 ..< todoItem!.hyperLinks.capacity, id: \.self){item in
                                    HyperLinkView(hyperLinkItem: todoItem!.hyperLinks[item])
                                    
                                }
                            }
                        }
                    }.padding()
                    Divider()
                    
                    Group {
                        GroupTitleTextCodeBlockView(systemName: "chevron.left.slash.chevron.right")
                        
                        
                        
                        ScrollView{
                            
                            ForEach(0 ..< todoItem!.codeBlocks.capacity){item in
                                CodeBlockView(blockContent: todoItem!.codeBlocks[item])
                                    
                            }
                            
                        }
                        
                        
                        
                    }.padding()
                    Divider()
                    
                    
                }
            }

    }
}


struct TodoSelectedItemView_Previews: PreviewProvider {
    static var todo = Todos()
    
    static var previews: some View {
        TodoSelectedItemView(todos: Todos(), todoItem: todo.listOfItems[3])
    }
}

struct GrayBackGroundView: View {
    
    var body: some View {
        Color.init(UIColor.systemGray2.withAlphaComponent(0.2))
    }
    
}

struct ImageRowButton: View {
    
    var text: String
    
    var body: some View {
        
        Button(action: {
            
        }, label: {
            Image(systemName: "photo")
                .padding()
                .foregroundColor(Color.black)
                .border(Color.gray, width: 1)
                .cornerRadius(3.0)
        })
    }
}

struct CodeBlockView: View {
    
    var blockContent: String
    @State private var comment: String = "Comment"
    
    var body: some View {
       
        Text("\(blockContent)")
            .padding()
            .font(.system(size: 12))
            //.background(Color.blue)
            //.lineSpacing(5.0)
            .frame(width: UIScreen.main.bounds.width, height: 100, alignment: .center)
            //UIScreen.main.bounds.width
        
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
       
        VStack(alignment: .center) {
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

struct GroupTitleImageView: View {
    
    var systemName: String
    
    var body: some View {
        
        HStack {
            
            Image(systemName: "\(systemName)")
                .resizable()
                .foregroundColor(.black)
                .aspectRatio(contentMode: .fit)
                .frame(width: 32, height: 32)
            
            Spacer()
            
            Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                Image(systemName: "plus")
                    .padding()
                    
            })
        }
        
        
    }
}

struct GroupTitleTextCodeBlockView: View {
    
    var systemName: String
    
    var body: some View {
        
        HStack {
            Image(systemName: "\(systemName)")
                .resizable()
                .foregroundColor(.black)
                .aspectRatio(contentMode: .fit)
                .frame(width: 32, height: 32)
       
            Spacer()
            
            ClipBoardActionView(iconSystemName: "doc.on.clipboard", label: "Copy")
            ClipBoardActionView(iconSystemName: "doc.on.clipboard.fill", label: "Paste")
            ClipBoardActionView(iconSystemName: "pencil", label: "Edit")
            ClipBoardActionView(iconSystemName: "square.and.arrow.up.fill", label: "xShare")
            
            Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                Image(systemName: "plus")
                    .padding()
                    
            })
        }
        
        
    }
}
