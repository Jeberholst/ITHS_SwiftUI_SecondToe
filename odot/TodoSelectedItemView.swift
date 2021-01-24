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
                
            
                HStack(alignment: .top) {
                
                    ForEach(1 ..< 6) { item in
                        ImageRowButton(text: "\(item)")
                    }
                    
                }
                
                HStack(alignment: .top) {
                
                    ForEach(1 ..< 6) { item in
                        Text("Link \(item)")
                    }
                    
                }
                
                ScrollView(.vertical, showsIndicators: true, content: {
                    TodoBlockView(blockContent: "Block 1")
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
                .cornerRadius(/*@START_MENU_TOKEN@*/3.0/*@END_MENU_TOKEN@*/)
        })
    }
}

struct TodoBlockView: View {
    
    var blockContent: String
    
    var body: some View {
        Text("\(blockContent)")
            .padding()
            .frame(width: UIScreen.main.bounds.width - 20, height: 125, alignment: .leading)
    }
}
