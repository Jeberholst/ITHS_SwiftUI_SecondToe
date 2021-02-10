//
//  TodoItem.swift
//  odot
//
//  Created by Joakim Eberholst on 2021-02-05.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

struct TodoItem: Codable, Identifiable, Hashable, RandomAccessCollection {
    typealias Index = Int
    typealias Element = (index: Index, element: CodeBlockItem)
    
    @DocumentID var id: String?
    
    var title: String
    var note: String
    var date: Date
    var hyperLinks: [HyperLinkItem] = []
    var codeBlocks: [CodeBlockItem] = []
    var images: [ImagesItem] = []
    
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
        return images.count
    }
    
    func getHyperLinksCount() -> Int {
        return hyperLinks.count
    }
    
    func getCodeBlocksCount() -> Int {
        return codeBlocks.count
    }
    
    func getHyperLinksAsDictionary() -> [[String : Any]] {
        
        if hyperLinks.count != 0 {
            let map = hyperLinks.map { item in
                item.getAsDictionary()
            }
            return map
        }
       
        return [[:]]
    }
    
    var startIndex: Index { codeBlocks.startIndex }

    var endIndex: Index { codeBlocks.endIndex }

    func index(after i: Index) -> Index {
        codeBlocks.index(after: i)
    }

    func index(before i: Index) -> Index {
        codeBlocks.index(before: i)
    }

    func index(_ i: Index, offsetBy distance: Int) -> Index {
        codeBlocks.index(i, offsetBy: distance)
    }

    subscript(position: Index) -> Element {
        (index: position, element: codeBlocks[position])
    }
    
}
