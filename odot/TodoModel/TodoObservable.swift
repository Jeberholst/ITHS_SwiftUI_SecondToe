//
//  TodoObservable.swift
//  odot
//
//  Created by Joakim Eberholst on 2021-02-06.
//

import Foundation

class TodoObservable: ObservableObject {
    
    @Published var todoItem: TodoItem? = nil
    
    init(item: TodoItem){
        self.todoItem = item
    }
    
//    func setObservable(item: TodoItem){
//        self.todoItem = item
//    }
    
}
