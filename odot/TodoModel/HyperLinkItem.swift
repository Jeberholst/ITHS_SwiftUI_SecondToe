//
//  HyperLinkItem.swift
//  odot
//
//  Created by Joakim Eberholst on 2021-01-26.
//

import Foundation

struct HyperLinkItem: Identifiable {
    var id = UUID()
    
    var title: String = "Set title here"
    var description: String = "Set description here"
    var hyperlink: String = "https://setlinkhere.com"
}
