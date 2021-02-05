//
//  CodeBlockItem.swift
//  odot
//
//  Created by Joakim Eberholst on 2021-02-05.
//

import Foundation

struct CodeBlockItem: Codable, Hashable {
    
    var date: Date = Date()
    var code: String
    
    enum CodeKeys: String,CodingKey {
        case date
        case code
    }
    
    func getAsDictionary() -> [String : Any] {
       return [
                "date": self.date,
                "code": self.code,
            ]
    }

    func getFormattedDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .medium
        return dateFormatter.string(from: self.date)
    }
}
