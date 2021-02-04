//
//  ContentView.swift
//  odot
//
//  Created by Joakim Eberholst on 2021-01-24.
//

import SwiftUI
import FirebaseUI
import FirebaseFirestoreSwift

let icLink = "link"
let icCode = "chevron.left.slash.chevron.right"
let icEdit = "square.and.pencil"
let icCamera = "camera"
let icImage = "photo"

struct ContentView: View {
    
    //@EnvironmentObject private var todos : Todos
   // @ObservedObject private var todos = Todos()
    @ObservedObject var todoDataModel = TodoDataModel()
  
    init() {
        UITableView.appearance().backgroundColor = .systemGray6 // Uses UIColor
    }
    
    var body: some View {
        NavigationView {
        
            ZStack{
                VStack {
                    List(){
                        
                        ForEach(todoDataModel.todoData){ item in
                            
                            NavigationLink(
                                destination:
                                    TodoSelectedItemView(todoItem: item)){
//
                                    TodoItemView(todo: item, imagesCount: 0, hyperLinksCount: 0, codeBlocksCount: 0)
//
                            }
                            
                        }.onDelete(perform: { indexSet in
                            //todos.removeItem(indexSet: indexSet)
                        })
//                        ForEach(0 ..< todoDataModel.todoData.capacity, id: \.self){ i in
//
//
//                            NavigationLink(
//                                destination:
//                                    TodoSelectedItemView(todoItem: todos.listOfItems[i], listItemIndex: i)){
//
//                                TodoItemView(todo: todos.listOfItems[i], imagesCount: 7, hyperLinksCount: todos.listOfItems[i].getHyperLinksCount(), codeBlocksCount: todos.listOfItems[i].getCodeBlocksCount())
//
//                            }
//
//                        }.onDelete(perform: { indexSet in
//                            todos.removeItem(indexSet: indexSet)
//                        })
                    }
                    .navigationBarTitleDisplayMode(.inline)
                    .navigationBarItems(trailing: TodoAddNew())
                    
                }
            }
        }
        .onAppear(){
            todoDataModel.fetchData()
            printItems()
        }
            
    }
    
    func printItems(){
        for item in todoDataModel.todoData {
            print("ITEM: \(item)")
        }
    }
    
}

struct TodoAddNew: View {
    
//    var todos: Todos
    
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
                let newItem = TodoItem(title: "A new title", note: "A new note")
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
    
    var todo: TodoItem
    
    var imagesCount: Int
    var hyperLinksCount: Int
    var codeBlocksCount: Int
    
    var body: some View {
        
        HStack {
            
            VStack(alignment: .leading){
                
                HStack {
                    
                    VStack(alignment: .leading) {
                        Text("\(todo.title ?? "not title")")
                            .font(.system(size: 16))
                            .bold()
                        
                        Text("\(todo.getFormattedDate())")
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
                        Text("\(imagesCount)").font(.system(size: 14))
                    }
                    HStack {
                        Image(systemName: icLink)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 16, height: 16)
                        Text("\(hyperLinksCount)").font(.system(size: 14))
                    }
                    HStack {
                        Image(systemName: icCode)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 16, height: 16)
                        Text("\(codeBlocksCount)").font(.system(size: 14))
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
