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
      private var listener: ListenerRegistration? = nil

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
    
        func updateList(list: [TodoItem]){
            self.todoData = list
            
        }
    

    func initializeListener(){
      
        if listener == nil {

            listener = Firestore.firestore()
                .collection("\(Auth.auth().currentUser!.uid)")
                .whereField("archive", isEqualTo: false)
                .addSnapshotListener { [self] (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
              print("No documents")
              return
            }

            print("Loading docs...")
            updateList(list: documents.compactMap { queryDocumentSnapshot in
                return try! queryDocumentSnapshot.data(as: TodoItem.self)
            })
            
                    
          }
          
        }
    }

}
