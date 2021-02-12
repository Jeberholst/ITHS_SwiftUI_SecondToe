//
//  ImageLargeDisplayView.swift
//  odot
//
//  Created by Joakim Eberholst on 2021-01-28.
//

import SwiftUI
import SDWebImageSwiftUI
import FirebaseUI

struct ImageLargeDisplayView: View {
    
    @EnvironmentObject var todoDataModel: TodoDataModel
    private let fbUtil = FirebaseUtil.firebaseUtil
    
    @Binding var imagesSelectedIndex: Int
    @Binding var selectedImage: String
    @State var docID: String
    
    @State private var scale: CGFloat = 1.0
    @State private var lastScale: CGFloat = 1.0
    @State private var viewState = CGSize.zero
    
    var body: some View {
        
        ZStack {
            
            VStack {
                
                SheetEditBarView(title: "Image \(imagesSelectedIndex)"){
                    onActionSave()
                } actionDelete: {
                    onActionDelete()
                }
               
                Divider()
                
                Spacer()
                
                VStack(alignment: .center){
                    
                    WebImage(url: URL(string: selectedImage))
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .animation(.spring())
                        .offset(x: viewState.width, y: viewState.height)
                        .frame(width: UIScreen.main.bounds.width - 60, alignment: .center)
                        .gesture(DragGesture()
                              .onChanged { val in
                                  self.viewState = val.translation
                              }
                        )
                        .gesture(MagnificationGesture()
                            .onChanged { val in
                    
                            let delta = val / self.lastScale
                            self.lastScale = val
                            if delta > 0.93 {
                                let newScale = self.scale * delta
                                self.scale = newScale
                            }
                        }
                        .onEnded { _ in
                            self.lastScale = 1.0
                        })
                        .scaleEffect(scale)
                        
                }
                .frame(width: UIScreen.main.bounds.width)
                .clipped()
                .background(GrayBackGroundView(alpha: 0.1))
                .onTapGesture(count: 2, perform: {
                    self.viewState = CGSize.zero
                    self.scale = 1.0
                })
                
                Spacer()
                      
            }
            
        }
        
    }
    
    private func onActionSave(){
        print("!DELETE! Save")
    }
    
    private func onActionDelete(){
        print("Deleting image...")
        let storage = Storage.storage()
        let storageRef = storage.reference(forURL: selectedImage)
        
        let currImages = todoDataModel.todoData[todoDataModel.mainIndex].images
        var newImages = currImages
        newImages.remove(at: imagesSelectedIndex)

        let docData: [[String: Any]] = newImages.map { item in
            item.getAsDictionary()
        }

        fbUtil.deleteImageFromStorage(documentID: docID, imageName: storageRef.name, docData: docData)
        

    }
    
}


