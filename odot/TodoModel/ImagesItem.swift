//
//  ImagesItem.swift
//  odot
//
//  Created by Joakim Eberholst on 2021-02-02.
//

import Foundation

struct ImagesItem: Codable, Hashable {

    var date: Date
    var storageReference: String
    
    enum CodingKeys: String, CodingKey {
        case date
        case storageReference
    }
}

struct ImagesItemOriginal: Identifiable {
    
    var id = UUID()
    
    var date: Date = Date()
    var storageReference: String
    
}
