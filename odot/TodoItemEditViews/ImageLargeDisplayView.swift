//
//  ImageLargeDisplayView.swift
//  odot
//
//  Created by Joakim Eberholst on 2021-01-28.
//

import SwiftUI
import SDWebImageSwiftUI

struct ImageLargeDisplayView: View {
    
    @EnvironmentObject var todoDataModel: TodoDataModel
    @Binding var imagesSelectedIndex: Int
    @Binding var selectedImage: String
    
    private let firebaseImageUtil: FirebaseImageUtil = FirebaseImageUtil()
    
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
        print("Save")
    }
    
    private func onActionDelete(){
        print("Delete")
    }
    
}


