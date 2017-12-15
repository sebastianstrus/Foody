//
//  CoreDataHandler.swift
//  Foody
//
//  Created by Sebastian Strus on 2017-12-04.
//  Copyright © 2017 Sebastian Strus. All rights reserved.
//

import UIKit
import CoreData

class CoreDataHandler: NSObject {
    
    class func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    class func saveUser(username:String, email:String, password:String) -> Bool {
        let context = getContext()
        let entity = NSEntityDescription.entity(forEntityName: "User", in: context)
        let manageObject = NSManagedObject(entity: entity!, insertInto: context)
        manageObject.setValue(username, forKey: "username")
        manageObject.setValue(email, forKey: "email")
        manageObject.setValue(password, forKey: "password")
        let image = UIImagePNGRepresentation(#imageLiteral(resourceName: "image_user"))! as NSData?
        manageObject.setValue(image, forKey: "userImage")
        do {
            try context.save()
            return true
        } catch {
            return false
        }
    }
    
    class func getUsers() -> [User]? {
        let context = getContext()
        var user:[User]? = nil
        do {
            user = try context.fetch(User.fetchRequest())
            return user
        } catch {
            return user
        }
    }
    
    class func deleteUser(user: User) -> Bool {
        let context = getContext()
        context.delete(user)
        do {
            try context.save()
            return true
        } catch {
            return false
        }
    }
    
    class func cleanDelete() -> Bool {
        let context = getContext()
        let delete = NSBatchDeleteRequest(fetchRequest: User.fetchRequest())
        do {
            try context.execute(delete)
            return true
        } catch {
            return false
        }
    }
    
    class func getUser(email:String) -> User? {
        let context = getContext()
        let fetchRequest:NSFetchRequest<User> = User.fetchRequest()
        var user:User? = nil
        var users:[User]? = nil
        let predicate = NSPredicate(format: "email == %@", email)
        fetchRequest.predicate = predicate
        do {
            users = try context.fetch(fetchRequest)
            if let count = users?.count, count > 0 {
                user = users?[0]
            }
            return user
        } catch {
            return user
        }
    }
}














