//
//  Book+CoreDataProperties.swift
//  CSE335-class-project
//
//  Created by Jake Anderson on 11/14/18.
//  Copyright © 2018 Jake Anderson. All rights reserved.
//
//

import Foundation
import CoreData


extension Book {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Book> {
        return NSFetchRequest<Book>(entityName: "Book")
    }

    @NSManaged public var author: String?
    @NSManaged public var title: String?
    @NSManaged public var isbn: Int32

}
