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
    
    @EnvironmentObject private var authUtil: AuthUtil
    @EnvironmentObject private var todoDataModel: TodoDataModel

    @State private var delIndex: Int = 0
    
    init() {
        UITableView.appearance().backgroundColor = UIColor(Color("Background"))
    }
    
    var body: some View {
        
        ZStack{
            NavigationView {
                List(){
                    ForEach(todoDataModel.todoData.indices, id: \.self){ index in
                        if todoDataModel.todoData[index].archive == false {
                            NavigationViews(index: index).environmentObject(todoDataModel)
                        }
                    }
                    .onDelete(perform: delete)
                    
                    .listRowBackground(Color("BackgroundOver"))
                }
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarItems(leading: ProfileNavigateView(isPresenting: $authUtil.isPresentingProfile).environmentObject(todoDataModel), trailing: TodoAddNew())
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing: TodoAddNew())
        .frame(width: UIScreen.main.bounds.width)
        .sheet(isPresented: $authUtil.isPresentingProfile, content: {
            LoggedInProfileView()
        })
        .onAppear {
            todoDataModel.initializeListener()
        }
        
    }
    
    func delete(at offsets: IndexSet) {
        let index = offsets[offsets.startIndex]
        FirebaseUtil.firebaseUtil.deleteSingleUserDocument(documentID: self.todoDataModel.todoData[index].id!)
        //FirebaseUtil.firebaseUtil.archiveDocument(documentID: self.todoDataModel.todoData[index].id ?? "")
    }

}

struct NavigationViews: View {
    
    @EnvironmentObject var todoDataModel: TodoDataModel
    @EnvironmentObject var authUtil: AuthUtil
    @State var index: Int
    
    var body: some View {
        
            if let docId = todoDataModel.todoData[index].id {
                VStack {
                    NavigationLink(
                        destination:
                            TodoSelectedItemView(
                                todoItemIndex: index,
                                documentId: docId)
                                    .background(Color("Background").ignoresSafeArea())
                                    .environmentObject(todoDataModel)){
                        
                            TodoItemView(index: index).environmentObject(todoDataModel)
                        
                    }
                }
            }
            
    }

}

struct DeterView: View {
    
    @EnvironmentObject var todoDataModel: TodoDataModel
    @State var index: Int
    
    @ViewBuilder var resultView: some View {
        if todoDataModel.todoData.indices.contains(index) {
            TodoItemView(index: index)
        } else {
            EmptyView()
        }
    }
    
    var body: some View {
        return resultView
    }
    
}

struct ProfileNavigateView: View {
    
    @EnvironmentObject var todoDataModel: TodoDataModel
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

    var body: some View {
        HStack {
            Button(action: {
                let newItem = TodoItem(title: "A new title", note: "A new note", date: Date(), archive: false)
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
                        Text(todoDataModel.todoData[index].title!)
                            .font(.system(size: 16))
                            .bold()
                        
                        Text(todoDataModel.todoData[index].getFormattedDate())
                            .font(.system(size: 14))
                        
                        Spacer().frame(height: 10)
                        
                        Text("\(todoDataModel.todoData[index].note!)")
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

extension Binding where Value == String? {
    func toNonOptional() -> Binding<String> {
        return Binding<String>(
            get: {
                return self.wrappedValue ?? ""
            },
            set: {
                self.wrappedValue = $0
            }
        )
    }
}
