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

class TodoDataModel: ObservableObject {

    @Published var todoData = [TodoItem]()
    @Published var mainIndex = 0
    

//    init() {
//        fetchData()
//    }
//    
//    func fetchData() {
//        
//        Firestore.firestore().collection("\(Auth.auth().currentUser!.uid)").addSnapshotListener { [self] (querySnapshot, error) in
//        guard let documents = querySnapshot?.documents else {
//          print("No documents")
//          return
//        }
//        
//        print("Loading docs...")
//        todoData = documents.compactMap { queryDocumentSnapshot in
//            return try! queryDocumentSnapshot.data(as: TodoItem.self)
//        }
//        
//      }
//    }
}
