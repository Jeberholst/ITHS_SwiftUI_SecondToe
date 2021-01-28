//
//  CodeBlockItem.swift
//  odot
//
//  Created by Joakim Eberholst on 2021-01-28.
//

import Foundation

struct CodeBlockItem {
    
    var date: Date = Date()
    var code: String = "Example []"

    func getFormattedDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        return dateFormatter.string(from: self.date)
    }
}

