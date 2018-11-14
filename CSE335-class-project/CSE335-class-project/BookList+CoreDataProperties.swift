//
//  BookList+CoreDataProperties.swift
//  CSE335-class-project
//
//  Created by Jake Anderson on 11/14/18.
//  Copyright © 2018 Jake Anderson. All rights reserved.
//
//

import Foundation
import CoreData


extension BookList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BookList> {
        return NSFetchRequest<BookList>(entityName: "BookList")
    }

    @NSManaged public var listTitle: String?
    @NSManaged public var book: NSData?

}
