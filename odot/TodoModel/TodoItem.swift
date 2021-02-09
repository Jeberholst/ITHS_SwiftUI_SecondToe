//
//  TodoItem.swift
//  odot
//
//  Created by Joakim Eberholst on 2021-02-05.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

struct TodoItem: Codable, Identifiable, Hashable {
    
    @DocumentID var id: String?
    
    var title: String
    var note: String
    var date: Date
    var hyperLinks: [HyperLinkItem]? = []
    var codeBlocks: [CodeBlockItem]? = []
    var images: [ImagesItem]? = []
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case note
        case date
        case hyperLinks
        case codeBlocks
        case images
    }
    
    func getFormattedDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        let date = dateFormatter.string(from: self.date)
        return date
    }
    
    func getImagesCount() -> Int {
        return images?.count ?? 0
    }
    
    func getHyperLinksCount() -> Int {
        return hyperLinks?.count ?? 0
    }
    
    func getCodeBlocksCount() -> Int {
        return codeBlocks?.count ?? 0
    }
    
}
