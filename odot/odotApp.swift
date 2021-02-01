//
//  odotApp.swift
//  odot
//
//  Created by Joakim Eberholst on 2021-01-24.
//

import SwiftUI

@main
struct odotApp: App {
   // @ObservedObject var todos = Todos()
    
    var body: some Scene {
        WindowGroup {
            LoginRegisterView()
           // ContentView().environmentObject(todos)
        }
    }
}
