//
//  ContentView.swift
//  odot
//
//  Created by Joakim Eberholst on 2021-01-24.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var todos = Todos()
    
    var body: some View {
        
        List(){
            ForEach(todos.listOfItems){ todo in
                HStack {
                    Text("\(todo.title)")
                        .padding()
                    Text("\(todo.note)")
                        .padding()
                }
            }
            
        }
        
        
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
