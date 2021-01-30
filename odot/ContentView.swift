//
//  ContentView.swift
//  odot
//
//  Created by Joakim Eberholst on 2021-01-24.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var todos : Todos

    var body: some View {
        
        NavigationView {
            
            List(){
                ForEach(0 ..< todos.listOfItems.count, id: \.self){ i in
                    NavigationLink(
                        destination:
                            TodoSelectedItemView(todoItem: todos.listOfItems[i], listItemIndex: i).environmentObject(todos)){
                        
                            TodoItemView(todo: todos.listOfItems[i])
                        
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



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        TodoItemView(todo: TodoItem())
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
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5){
                Text("\(todo.title)")
                    .bold()
                Text("\(todo.note)")
                    .italic()
                    .font(.system(size: 12))
            }
            
            Spacer()
            
            Text("\(todo.getFormattedDate())")
                .italic()
                .padding()
        }
    }
}
