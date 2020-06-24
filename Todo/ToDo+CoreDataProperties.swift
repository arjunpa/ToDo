//
//  ToDo+CoreDataProperties.swift
//  Todo
//
//  Created by Arjun P A on 24/06/20.
//  Copyright © 2020 Arjun P A. All rights reserved.
//
//

import Foundation
import CoreData


extension ToDo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ToDo> {
        return NSFetchRequest<ToDo>(entityName: "ToDo")
    }

    @NSManaged public var toDoDescription: String?
    @NSManaged public var toDoTitle: String?
    @NSManaged public var uuid: String
    @NSManaged public var dateTime: Date
    @NSManaged public var completed: Bool
}
