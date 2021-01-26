//
//  Note.swift
//  odot
//
//  Created by Joakim Eberholst on 2021-01-24.
//

import Foundation

struct TodoItem : Identifiable {
    var id = UUID()
    
    var title: String = "Title"
    var note: String = "Note"
    var date: Date = Date()
    var hyperLinks: [HyperLinkItem] = [HyperLinkItem]()
    var codeBlocks: [String] = [String]()
    
    //Images?
    
    func getFormattedDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        let date = dateFormatter.string(from: self.date)
        return date
        
    }
    
    
}
