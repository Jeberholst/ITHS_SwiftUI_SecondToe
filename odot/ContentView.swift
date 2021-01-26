//
//  ContentView.swift
//  odot
//
//  Created by Joakim Eberholst on 2021-01-24.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var todos = Todos()
    
    var body: some View {
        
//        VStack {
            
//            Text("Odot")
//                .bold()
//                .italic()
//                .font(.system(size: CGFloat(55), weight: Font.Weight.bold, design: Font.Design.rounded))
            
//            Section {
                NavigationView {
                    List(){
                        ForEach(todos.listOfItems){ todoItem in
                            NavigationLink(
                                destination: TodoSelectedItemView(todos: todos, todoItem: todoItem)){
                                
                                TodoItemView(todo: todoItem)
                                
                                }
                            }
                    }
                        
                }.padding()
                
                
//            }.padding()
            
            
            
//        }
        
        
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct TodoItemView: View {
    
    var todo: TodoItem
    
    var body: some View {
        HStack {
            Text("\(todo.title)")
            Spacer()
            Text("\(todo.getFormattedDate())")
                .italic()
        }
    }
}
