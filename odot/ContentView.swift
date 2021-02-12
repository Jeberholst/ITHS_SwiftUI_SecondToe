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
import SDWebImageSwiftUI

let icLink = "link"
let icLinkAdd = "link.badge.plus"
let icCode = "chevron.left.slash.chevron.right"
let icEdit = "square.and.pencil"
let icCamera = "camera"
let icImage = "photo"
let icTrash = "trash"
let icPlus = "plus"

struct ContentView: View {
    
    @ObservedObject var todoDataModel = TodoDataModel()
    @State private var listener: AuthStateDidChangeListenerHandle? = nil
    @State private var isPresentingProfile = false
    
    init() {
        UITableView.appearance().backgroundColor = UIColor(Color("Background"))
        
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
        ZStack{
           
            NavigationView {
            
                VStack {
                    List(){
                        ForEach(todoDataModel.todoData.indices, id: \.self){ index in
                            NavigationLink(
                                destination:
                                    TodoSelectedItemView(
                                        todoItemIndex: index,
                                        documentId: self.todoDataModel.todoData[index].id ?? "0")
                                            .background(Color("Background").ignoresSafeArea())
                                            .environmentObject(todoDataModel)){
                                
                                TodoItemView(index: index).environmentObject(todoDataModel)
                                    
                            }
                            
                        }.listRowBackground(Color("BackgroundOver"))
                 
                    }
                 
                    .navigationBarTitleDisplayMode(.inline)
                    .navigationBarItems(leading: ProfileNavigateView(isPresenting: $isPresentingProfile), trailing: TodoAddNew())
                    
                }
              
            }
           
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing: TodoAddNew())
        .frame(width: UIScreen.main.bounds.width)
        .sheet(isPresented: $isPresentingProfile, content: {
            LoggedInProfileView()
        })
        
    }
    
    private func removeDocument(){
        //ADD FUNCTIONALITY HERE? OR IN ITEM-VIEW?
    }
    
}
struct ProfileNavigateView: View {
    
    @Binding var isPresenting: Bool
    
    var body: some View {
        
        Button(action: {

            isPresenting.toggle()

        }, label: {
            
            HStack {
                
                if let image = Auth.auth().currentUser?.photoURL {
                    
                    WebImage(url: URL(string: image.absoluteString))
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(25)
                        .frame(width: 25, height: 25)
                }
                
                if let userName = Auth.auth().currentUser?.displayName {
                    Text("\(userName)")
                        .font(.system(size: 12))
                        .frame(alignment: .center)
                        .foregroundColor(Color("AccentColor"))
                }
                
            }
            
        })
        
    }
    
}


struct TodoAddNew: View {
    
    let userColRef = FirebaseUtil.firebaseUtil.getUserCollection()
    
    var body: some View {
        HStack {
            Button(action: {
                
                let newItem = TodoItem(title: "A new title", note: "A new note", date: Date())
                FirebaseUtil.firebaseUtil.updateUserDocument(newTodoItem: newItem)
                
            }, label: {
                Image(systemName: icPlus)
            })
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
                        
                        Spacer().frame(height: 10)
                        
                        Text("\(todoDataModel.todoData[index].note)")
                            .font(.system(size: 14))
                        
                        Spacer().frame(height: 10)
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
            
        }
        .padding()
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
