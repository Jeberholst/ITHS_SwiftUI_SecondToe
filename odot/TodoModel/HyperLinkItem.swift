//
//  HyperLinkItem.swift
//  odot
//
//  Created by Joakim Eberholst on 2021-01-26.
//

import Foundation

struct HyperLinkItem: Identifiable {
    var id = UUID()
    
    var title: String = "Title"
    var description: String = "Description"
    var hyperlink: String = "https://"
}
