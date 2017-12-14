//
//  Meal+CoreDataProperties.swift
//  
//
//  Created by Sebastian Strus on 2017-12-13.
//
//

import Foundation
import CoreData


extension Meal {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Meal> {
        return NSFetchRequest<Meal>(entityName: "Meal")
    }

    @NSManaged public var date: NSDate?
    @NSManaged public var image: NSData?
    @NSManaged public var isFavorite: Bool
    @NSManaged public var mealDescription: String?
    @NSManaged public var name: String?
    @NSManaged public var placeLatitude: Double
    @NSManaged public var placeLongitude: Double
    @NSManaged public var price: String?
    @NSManaged public var rating: Int32

}
