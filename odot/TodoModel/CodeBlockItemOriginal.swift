//
//  CodeBlockItem.swift
//  odot
//
//  Created by Joakim Eberholst on 2021-01-28.
//

import Foundation

struct CodeBlockItem: Codable {
    
    var date: Date
    var code: String

    func getFormattedDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .medium
        return dateFormatter.string(from: self.date)
    }
}

struct CodeBlockItemOriginal {
    
    var date: Date = Date()
    var code: String = "var itemCount: Int = 0"

    func getFormattedDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .medium
        return dateFormatter.string(from: self.date)
    }
}

