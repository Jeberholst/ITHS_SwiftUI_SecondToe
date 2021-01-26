//
//  Todos.swift
//  odot
//
//  Created by Joakim Eberholst on 2021-01-24.
//

import Foundation

class Todos: ObservableObject {
    
    @Published var listOfItems = [TodoItem]()
    
    init() {
        createMockData()
    }
    
    func createMockData(){
        
        let hyperLink = [HyperLinkItem(), HyperLinkItem(),HyperLinkItem()]
        
        addItem(todoItem: TodoItem(title: "En titel 1", note: "En note 1", hyperLinks: hyperLink))
        addItem(todoItem: TodoItem(title: "En titel 2", note: "En note 2", hyperLinks: hyperLink))
        addItem(todoItem: TodoItem(title: "En titel 3", note: "En note 3", hyperLinks: hyperLink))
        addItem(todoItem: TodoItem(title: "En titel 4", note: "En note 4", hyperLinks: hyperLink))
    }
    
    func addItem(todoItem: TodoItem){
        listOfItems.append(todoItem)
    }
    
}
