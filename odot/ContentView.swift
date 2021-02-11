//
//  ContentView.swift
//  odot
//
//  Created by Joakim Eberholst on 2021-01-24.
//

import SwiftUI
import FirebaseUI
import FirebaseFirestoreSwift
import Combine

let icLink = "link"
let icCode = "chevron.left.slash.chevron.right"
let icEdit = "square.and.pencil"
let icCamera = "camera"
let icImage = "photo"
let icTrash = "trash"

struct ContentView: View {
    
    @ObservedObject var todoDataModel = TodoDataModel()
    @State private var listener: AuthStateDidChangeListenerHandle? = nil
    
    init() {
        UITableView.appearance().backgroundColor = .systemGray6 // Uses UIColor
        
        listener = Firestore.firestore().collection("\(Auth.auth().currentUser!.uid)").addSnapshotListener { [self] (querySnapshot, error) in
        guard let documents = querySnapshot?.documents else {
          print("No documents")
          return
        }
        
        print("Loading docs...")
        todoDataModel.todoData = documents.compactMap { queryDocumentSnapshot in
            return try! queryDocumentSnapshot.data(as: TodoItem.self)
        }
            
      }
    }
    
    var body: some View {
        NavigationView {
            ZStack{
                VStack {
                    List(){
                        ForEach(todoDataModel.todoData.indices, id: \.self){ index in
                            NavigationLink(
                                destination:
                                    TodoSelectedItemView(
                                        todoItemIndex: index,
                                        documentId: self.todoDataModel.todoData[index].id ?? "0").environmentObject(todoDataModel)){
                                
                                    TodoItemView(index: index).environmentObject(todoDataModel)
                                    
                                        
                            }
                            
                        }
                 
                    }
                    .navigationBarTitleDisplayMode(.inline)
                    .navigationBarItems(trailing: TodoAddNew())
                    
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing: TodoAddNew())
            
    }
    
    private func removeDocument(){
        //ADD FUNCTIONALITY HERE? OR IN ITEM-VIEW?
    }

    
    
}

struct TodoAddNew: View {
    
    let userColRef = FirebaseUtil.firebaseUtil.getUserCollection()
    
    var body: some View {
        HStack {
            
            Button(action: {

                let authUI = FUIAuth.defaultAuthUI()
                print("Trying to sign out user...")
                try! authUI?.signOut()
                
            }, label: {
                Text("Sign out")
            }).padding()
            
            
            Button(action: {
                let newItem = TodoItem(title: "A new title", note: "A new note", date: Date())
                do {
                    try userColRef.document().setData(from: newItem)
                } catch let error {
                    print("Error writing city to Firestore: \(error)")
                }
                
            }, label: {
                Image(systemName: "plus")
            }).padding()
        }
    }
}

struct TodoItemView: View {
    
    @EnvironmentObject var todoDataModel: TodoDataModel
    @State var index: Int
    
    var body: some View {
        
        HStack {
            
            VStack(alignment: .leading){
                
                HStack {
                    
                    VStack(alignment: .leading) {
                        Text("\(todoDataModel.todoData[index].title)")
                            .font(.system(size: 16))
                            .bold()
                        
                        Text("\(todoDataModel.todoData[index].getFormattedDate())")
                            .font(.system(size: 14))
                        
                        Spacer()
   
                        //Text("\(todo.note)")
                          //  .font(.system(size: 14))
                    
                    }
                   
                }
                
                Spacer()
                
                HStack {
                    
                    HStack {
                        Image(systemName: icImage)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 16, height: 16)
                        Text("\(todoDataModel.todoData[index].getImagesCount())").font(.system(size: 14))
                    }
                    HStack {
                        Image(systemName: icLink)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 16, height: 16)
                        Text("\(todoDataModel.todoData[index].getHyperLinksCount())").font(.system(size: 14))
                    }
                    HStack {
                        Image(systemName: icCode)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 16, height: 16)
                        Text("\(todoDataModel.todoData[index].getCodeBlocksCount())").font(.system(size: 14))
                    }
                }
                
            }
            
        }.padding() 
        
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
