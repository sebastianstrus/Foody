//
//  Meal+CoreDataProperties.swift
//  Foody
//
//  Created by Sebastian Strus on 2017-11-03.
//  Copyright © 2017 Sebastian Strus. All rights reserved.
//

import Foundation
import CoreData


extension Meal {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Meal> {
        return NSFetchRequest<Meal>(entityName: "Meal")
    }

    @NSManaged public var date: NSDate?
    @NSManaged public var image: NSData?
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var mealDescription: String?
    @NSManaged public var name: String?
    @NSManaged public var price: Int32
    @NSManaged public var favorite: Bool

}
