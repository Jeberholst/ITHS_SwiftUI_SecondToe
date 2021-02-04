//
//  Todos.swift
//  odot
//
//  Created by Joakim Eberholst on 2021-01-24.
//

import Foundation

class Todos: ObservableObject, Identifiable {
    
    @Published var listOfItems = [TodoItemOriginal]()
    
    init() {
        createMockData()
    }
    
    func createMockData(){
        
//        let image0 = ImagesItem(storageReference: "https:SomeRef")
//        let image1 = ImagesItem(storageReference: "https:SomeRef3")
//        let hyperLink0 = HyperLinkItemOriginal()
//        let hyperLink1 = HyperLinkItemOriginal(hyperlink: "https://www.something.com")
//        let codeBlock0 = CodeBlockItem()
//        let codeBlock1 = CodeBlockItem(code: "var itemCount = 2")
//
//        for i in (0...5){
//            var todoItem = TodoItem(title: "Item \(i)")
//            todoItem.addImagesItem(item: image0)
//            todoItem.addImagesItem(item: image1)
//            todoItem.addHyperLinkItem(item: hyperLink0)
//            todoItem.addHyperLinkItem(item: hyperLink1)
//            todoItem.addCodeBlockItem(item: codeBlock0)
//            todoItem.addCodeBlockItem(item: codeBlock1)
//            addItem(todoItem: todoItem)
//        }
//
    }
    
    func addItem(todoItem: TodoItemOriginal){
        listOfItems.append(todoItem)
    }
    
    func removeItem(indexSet: IndexSet){
        listOfItems.remove(atOffsets: indexSet)
    }
    
}
