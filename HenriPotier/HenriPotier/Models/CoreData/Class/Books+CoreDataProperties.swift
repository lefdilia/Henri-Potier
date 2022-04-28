//
//  Books+CoreDataProperties.swift
//  HenriPotier
//
//  Created by Lefdili Alaoui Ayoub on 27/4/2022.
//
//

import Foundation
import CoreData


extension Books {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Books> {
        return NSFetchRequest<Books>(entityName: "Books")
    }

    @NSManaged public var cover: String?
    @NSManaged public var isbn: String?
    @NSManaged public var price: Int16
    @NSManaged public var synopsis: [String]?
    @NSManaged public var title: String?
    @NSManaged public var quantity: Int16
    @NSManaged public var bookmark: Bool
    @NSManaged public var index: Int16

}

extension Books : Identifiable {

}
