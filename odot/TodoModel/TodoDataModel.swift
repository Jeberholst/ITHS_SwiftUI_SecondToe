//
//  TodoDataModel.swift
//  odot
//
//  Created by Joakim Eberholst on 2021-02-04.
//

import Foundation
import FirebaseUI
import Firebase
import FirebaseFirestoreSwift

class TodoDataModel: ObservableObject, RandomAccessCollection {
    typealias Index = Int
    typealias Element = (index: Index, element: TodoItem)
    
   
      @Published var todoData = [TodoItem]()
      @Published var mainIndex = 0

      var startIndex: Index { todoData.startIndex }

      var endIndex: Index { todoData.endIndex }

      func index(after i: Index) -> Index {
            todoData.index(after: i)
      }

      func index(before i: Index) -> Index {
            todoData.index(before: i)
      }

      func index(_ i: Index, offsetBy distance: Int) -> Index {
            todoData.index(i, offsetBy: distance)
      }

      subscript(position: Index) -> Element {
          (index: position, element: todoData[position])
      }
 
}
