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

struct ContentView: View {
    
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
                                    TodoSelectedItemView(todoItem: item, documentId: item.id)){

                                TodoItemView(todoItem: item, imagesCount: item.getImagesCount(), hyperLinksCount: item.getHyperLinksCount(), codeBlocksCount: item.getCodeBlocksCount())

                            }
                            
                        }.onDelete(perform: { indexSet in
                            todoDataModel.todoData.remove(atOffsets: indexSet)
                        })
                 
                    }
                    .navigationBarTitleDisplayMode(.inline)
                    .navigationBarItems(trailing: TodoAddNew())
                    
                }
            }
        }
        .onAppear(){
            todoDataModel.fetchData()
            //printItems()
        }
            
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
    
    @State var todoItem: TodoItem
    
    @State var imagesCount: Int
    @State var hyperLinksCount: Int
    @State var codeBlocksCount: Int
    
    var body: some View {
        
        HStack {
            
            VStack(alignment: .leading){
                
                HStack {
                    
                    VStack(alignment: .leading) {
                        Text("\(todoItem.title)")
                            .font(.system(size: 16))
                            .bold()
                        
                        Text("\(todoItem.getFormattedDate())")
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
