//
//  ToDoListItem+CoreDataProperties.swift
//  ToDo
//
//  Created by Arghadeep Chakraborty on 19/08/21.
//
//

import Foundation
import CoreData


extension ToDoListItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ToDoListItem> {
        return NSFetchRequest<ToDoListItem>(entityName: "ToDoListItem")
    }

    @NSManaged public var title: String?
    @NSManaged public var timeStamp: Date?

}

extension ToDoListItem : Identifiable {

}
