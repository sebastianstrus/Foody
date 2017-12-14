//
//  User+CoreDataProperties.swift
//  
//
//  Created by Sebastian Strus on 2017-12-13.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var password: String?
    @NSManaged public var username: String?
    @NSManaged public var email: String?

}
