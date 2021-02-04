//
//  HyperLinkItem.swift
//  odot
//
//  Created by Joakim Eberholst on 2021-01-26.
//

import Foundation

struct HyperLinkItem: Codable {
    var date: Date
    var title: String
    var description: String
    var hyperlink: String
    
    func getFormattedDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .short
        return dateFormatter.string(from: self.date)
    }
}

struct HyperLinkItemOriginal: Identifiable {
    var id = UUID()
    
    var date: Date = Date()
    var title: String = "Set title here"
    var description: String = "Set description here"
    var hyperlink: String = "https://setlinkhere.com"
    
    func getFormattedDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .short
        return dateFormatter.string(from: self.date)
    }
}
