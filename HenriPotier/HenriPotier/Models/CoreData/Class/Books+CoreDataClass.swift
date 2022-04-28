//
//  Books+CoreDataClass.swift
//  HenriPotier
//
//  Created by Lefdili Alaoui Ayoub on 27/4/2022.
//
//

import Foundation
import CoreData

extension CodingUserInfoKey {
    static let context = CodingUserInfoKey(rawValue: "context")
}

var bookIndex = 1

@objc(Books)
public class Books: NSManagedObject, Codable {
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        do {
            try container.encode(price, forKey: .price)
            try container.encode(isbn, forKey: .isbn)
            try container.encode(title, forKey: .title)
            try container.encode(cover, forKey: .cover)
            try container.encode(synopsis, forKey: .cover)
        }catch {
            fatalError(error.localizedDescription)
        }
    }
    
    required convenience public init(from decoder: Decoder) throws {
        
        guard let contextUserInfoKey = CodingUserInfoKey.context,
              let managedObjectContext = decoder.userInfo[contextUserInfoKey] as? NSManagedObjectContext,
              let entity = NSEntityDescription.entity(forEntityName: "Books", in: managedObjectContext) else {
            fatalError("Failed to decode Books.")
        }
        
        self.init(entity: entity, insertInto: managedObjectContext)
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        do {
            index = Int16(bookIndex)
            price = try values.decode(Int16.self, forKey: .price)
            isbn = try values.decode(String.self, forKey: .isbn)
            title = try values.decode(String.self, forKey: .title)
            cover = try values.decode(String.self, forKey: .cover)
            synopsis = try values.decode([String].self, forKey: .synopsis)
            
            bookIndex += 1
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case index
        case price = "price"
        case isbn = "isbn"
        case title = "title"
        case cover = "cover"
        case synopsis = "synopsis"
    }
    
}
