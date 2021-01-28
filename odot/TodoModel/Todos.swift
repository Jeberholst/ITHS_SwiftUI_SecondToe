//
//  Todos.swift
//  odot
//
//  Created by Joakim Eberholst on 2021-01-24.
//

import Foundation

class Todos: ObservableObject, Identifiable {
    
    @Published var listOfItems = [TodoItem]()
    
    init() {
        createMockData()
    }
    
    func createMockData(){
        
        let hyperLink0 = [HyperLinkItem(), HyperLinkItem(),HyperLinkItem()]
        let hyperLink1 = [HyperLinkItem(hyperlink: "https://www.something.com"), HyperLinkItem(),HyperLinkItem()]
        let codeBlock0 = [CodeBlockItem(), CodeBlockItem()]
        let codeBlock1 = [CodeBlockItem(code: "var itemCount = 2"), CodeBlockItem(), CodeBlockItem(), CodeBlockItem(), CodeBlockItem(code: "Senaste")]
        
        addItem(todoItem: TodoItem(title: "En titel 1", note: "En note 1", hyperLinks: hyperLink0, codeBlocks: codeBlock0))
        addItem(todoItem: TodoItem(title: "En titel 2", note: "En note 2", hyperLinks: hyperLink0, codeBlocks: codeBlock0))
        addItem(todoItem: TodoItem(title: "En titel 3", note: "En note 3", hyperLinks: hyperLink1, codeBlocks: codeBlock1))
        addItem(todoItem: TodoItem(title: "En titel 4", note: "En note 4", hyperLinks: hyperLink1, codeBlocks: codeBlock1))
    }
    
    func addItem(todoItem: TodoItem){
        listOfItems.append(todoItem)
    }
    
    func removeItem(indexSet: IndexSet){
        listOfItems.remove(atOffsets: indexSet)
    }
    
}
