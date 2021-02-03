//
//  ImagesItem.swift
//  odot
//
//  Created by Joakim Eberholst on 2021-02-02.
//

import Foundation

struct ImagesItem: Identifiable {
    
    var id = UUID()
    
    var date: Date = Date()
    var storageReference: String
    
}
