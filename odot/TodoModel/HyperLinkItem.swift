//
//  HyperLinkItem.swift
//  odot
//
//  Created by Joakim Eberholst on 2021-01-26.
//

import Foundation

struct HyperLinkItem: Codable, Hashable {
    var index: Int? = 0
    
    var date: Date = Date()
    var title: String
    var description: String
    var hyperlink: String
    
    enum CodingKeys: String, CodingKey {
        case index
        case date
        case title
        case description
        case hyperlink
    }
    
    private func setId(){
        
    }
    
    func getAsDictionary() -> [String : Any] {
       return [
                "date": self.date,
                "title": self.title,
                "description": self.description,
                "hyperlink": self.hyperlink
            ]
    }
    
    func getFormattedDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .short
        return dateFormatter.string(from: self.date)
    }
}
