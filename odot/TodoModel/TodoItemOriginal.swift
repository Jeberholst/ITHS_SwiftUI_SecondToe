//
//  Note.swift
//  odot
//
//  Created by Joakim Eberholst on 2021-01-24.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

struct TodoItem: Codable, Identifiable {
    @DocumentID var id: String?
    
    var title: String?
    var note: String?
    var date: Date? = Date()
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
        let date = dateFormatter.string(from: self.date ?? Date())
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

struct TodoItemOriginal : Identifiable {
    var id = UUID()
    
    var title: String = "Title"
    var note: String = "Note"
    var date: Date = Date()
    var hyperLinks: [HyperLinkItem] = [HyperLinkItem]()
    var codeBlocks: [CodeBlockItem] = [CodeBlockItem]()
    var images: [ImagesItem] = [ImagesItem]()
   
    func getFormattedDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        let date = dateFormatter.string(from: self.date)
        return date
        
    }
    
    mutating func addImagesItem(item: ImagesItem){
        images.append(item)
    }
    
    mutating func addHyperLinkItem(item: HyperLinkItem){
        hyperLinks.append(item)
    }
    
    mutating func addCodeBlockItem(item: CodeBlockItem){
        codeBlocks.append(item)
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
    
    
}
