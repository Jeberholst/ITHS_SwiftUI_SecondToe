//
//  ContentView.swift
//  odot
//
//  Created by Joakim Eberholst on 2021-01-24.
//

import SwiftUI

let icLink = "link"
let icCode = "chevron.left.slash.chevron.right"
let icEdit = "square.and.pencil"
let icCamera = "camera"
let icImage = "photo"

struct ContentView: View {
    
    @EnvironmentObject private var todos : Todos
    
    var body: some View {
        
            NavigationView {
                
                List(){
                    ForEach(0 ..< todos.listOfItems.count, id: \.self){ i in
                        NavigationLink(
                            destination:
                                TodoSelectedItemView(todoItem: todos.listOfItems[i], listItemIndex: i)
                                .environmentObject(todos)){
                            
                            TodoItemView(todo: todos.listOfItems[i], imagesCount: 7, hyperLinksCount: todos.listOfItems[i].getHyperLinksCount(), codeBlocksCount: todos.listOfItems[i].getCodeBlocksCount())
                            
                        }
                        
                    }.onDelete(perform: { indexSet in
                        todos.removeItem(indexSet: indexSet)
                    })
                }
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarTitle("Todo")
                .navigationBarItems(trailing: TodoAddNew(todos: todos))
            }
        
    }
}

struct ContentViewP: View {
    
    private var todos = Todos()
    
    var body: some View {
    
            NavigationView {
            
                
                List(){
                    ForEach(0 ..< todos.listOfItems.count, id: \.self){ i in
                        NavigationLink(
                            destination:
                                TodoSelectedItemView(todoItem: todos.listOfItems[i],
                                                 listItemIndex: i)){
                            
                                TodoItemView(todo: todos.listOfItems[i],
                                             imagesCount: 0, hyperLinksCount: 0, codeBlocksCount: 0)
                            
                        }
                        
                    }.onDelete(perform: { indexSet in
                        todos.removeItem(indexSet: indexSet)
                    })
                  
                }
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarTitle("Todo")
                .navigationBarItems(trailing: TodoAddNew(todos: todos))
                    
            }
            
    }
}

struct TodoAddNew: View {
    
    var todos: Todos
    
    var body: some View {
        HStack {
            Button(action: {
                let newItem = TodoItem(title: "Hej")
                todos.addItem(todoItem: newItem)
            }, label: {
                Image(systemName: "plus")
            })
        }
    }
}

struct TodoItemView: View {
    
    var todo: TodoItem
    
    var imagesCount: Int
    var hyperLinksCount: Int
    var codeBlocksCount: Int
    
    var body: some View {
        
        HStack {
            VStack(alignment: .leading){
                
                HStack {
                    
                    VStack(alignment: .leading) {
                        Text("\(todo.title)")
                            .font(.system(size: 14))
                            .bold()
                        
                        Text("\(todo.getFormattedDate())")
                            .font(.system(size: 10))
                            .italic()
                        
                        Spacer()
                   
                        Text("\(todo.note)")
                            .font(.system(size: 12))
                    
                    }
                   
                }
                
                Spacer()
                
                HStack {
                    
                    HStack {
                        Image(systemName: icImage)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 12, height: 12)
                        Text("\(imagesCount)").font(.system(size: 8))
                    }
                    HStack {
                        Image(systemName: icLink)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 12, height: 12)
                        Text("\(hyperLinksCount)").font(.system(size: 8))
                    }
                    HStack {
                        Image(systemName: icCode)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 12, height: 12)
                        Text("\(codeBlocksCount)").font(.system(size: 8))
                    }
                }
                
             
            }
            
        }
        
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentViewP()
    }
}
