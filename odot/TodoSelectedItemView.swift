//
//  TodoSelectedItemView.swift
//  odot
//
//  Created by Joakim Eberholst on 2021-01-24.
//

import SwiftUI

struct TodoSelectedItemView: View {
    
    
    var body: some View {
        
        ZStack {
            VStack {
                
            
                HStack {
                
                    ForEach(1 ..< 6) { item in
                        ImageRowButton(text: "\(item)")
                    }
                    
                }
                
                HStack {
                 
                    ForEach(1 ..< 6) { item in
                        Text("L\(item)")
                            .padding()
                    }
                    
                    
                }
                
                Spacer()
                
                ScrollView(.vertical, showsIndicators: true, content: {
                    TodoBlockView(blockContent: "Block 1 asd adasdasda asdasdasdasdsadsadasdasdasdasdasdasdasdasdasdasdadasdasdsadasdasdasdasdasdasdasdsadsadasdassadasdasdasdasdasdsadasdasd")
                    TodoBlockView(blockContent: "Block 2")
                    TodoBlockView(blockContent: "Block 3")
                    TodoBlockView(blockContent: "Block 4")
                })
              
                
            }
        
        }
            
    }
}

struct TodoSelectedItemView_Previews: PreviewProvider {
    static var previews: some View {
        TodoSelectedItemView()
    }
}

struct ImageRowButton: View {
    
    var text: String
    
    var body: some View {
        
        Button(action: {
            
        }, label: {
            
            Text("+")
                .padding()
                .border(Color.gray, width: 1)
                .cornerRadius(3.0)
        })
    }
}

struct TodoBlockView: View {
    
    var blockContent: String
    
    var body: some View {
        
        ZStack {
            
            VStack {
                
                
                HStack {
                    Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                        Text("Copy")
                    })
                    Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                        Text("Edit")
                    })
                    Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                        Text("Paste")
                    })
                    Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                        Text("xShare")
                    })
                    
                }
                
                Text("\(blockContent)")
                    .padding()
                    .font(.system(size: 12))
                    .frame(width: UIScreen.main.bounds.width - 20, height: 125, alignment: .leading)
                    .lineSpacing(5.0)
                    //.border(Color.gray, width: 0.5)
                    //.shadow(color: /*@START_MENU_TOKEN@*/.black/*@END_MENU_TOKEN@*/, radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/, x: 2.0, y: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/)
            }
            
         
        }
       //
        
      
    }
}
