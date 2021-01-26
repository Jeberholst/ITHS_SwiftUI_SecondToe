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
            
                VStack(alignment: .leading) {
                    
                    Text("\(todoItem!.title) - \(todoItem!.getFormattedDate())")
                        .font(.system(size: 10))
                        .padding(.init(top: 20, leading: 25, bottom: 15, trailing: 0))
                    
                    Group {
                        GroupTitleImageView(systemName: "photo.on.rectangle.angled")
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(0 ..< 7) { item in
                                    ImageRowButton(text: "1")
                                }
                            }
                        }
                    }.padding(.init(top: 10, leading: 20, bottom: 10, trailing: 20))
                    Divider()
                    
                    Group {
                        GroupTitleImageView(systemName: "link.circle")
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(0 ..< todoItem!.hyperLinks.capacity, id: \.self){item in
                                    HyperLinkView(hyperLinkItem: todoItem!.hyperLinks[item])
                                
                                    
                                }.background(GrayBackGroundView())
                            }
                        }
                    }.padding(.init(top: 10, leading: 20, bottom: 10, trailing: 20))
                    Divider()
                    
                    Group {
                        GroupTitleTextCodeBlockView(systemName: "chevron.left.slash.chevron.right")
                        
                        
                        
                        ScrollView{
                            
                            ForEach(0 ..< todoItem!.codeBlocks.capacity){item in
                                CodeBlockView(blockContent: todoItem!.codeBlocks[item])
                                
                            }
                            
                        }
                        
                        
                        
                    }.padding(.init(top: 10, leading: 20, bottom: 10, trailing: 20))
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
        Color.init(UIColor.systemGray4.withAlphaComponent(0.1))
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
//                .border(Color.gray, width: 1)
//                .cornerRadius(3.0)
        }).background(GrayBackGroundView())
    }
}

struct CodeBlockView: View {
    
    var blockContent: String
    @State private var comment: String = "Comment"
    
    var body: some View {
        
        VStack{
            
             Text("\(blockContent)")
                 .padding()
                 .font(.system(size: 12))
                 //.background(Color.blue)
                 //.lineSpacing(5.0)
                 .frame(width: UIScreen.main.bounds.width - 20, height: 100, alignment: .center)
                 //UIScreen.main.bounds.width
            
        }
        .background(GrayBackGroundView())
       
        
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
        .frame(width: UIScreen.main.bounds.width/2, height: 100, alignment: .center)
            
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
            
            Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                Image(systemName: "plus")
                    
            })
        }
        
        
    }
}

//ClipBoardActionView(iconSystemName: "doc.on.clipboard", label: "Copy")
//ClipBoardActionView(iconSystemName: "doc.on.clipboard.fill", label: "Paste")
//ClipBoardActionView(iconSystemName: "pencil", label: "Edit")
//ClipBoardActionView(iconSystemName: "square.and.arrow.up.fill", label: "xShare")
