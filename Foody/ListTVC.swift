//
//  ListTVC.swift
//  Foody
//
//  Created by Sebastian Strus on 2017-10-31.
//  Copyright © 2017 Sebastian Strus. All rights reserved.
//

import UIKit
import CoreData
import SwiftKeychainWrapper

class ListTVC: UITableViewController {
    
    var currentUser:User?
    
    var allMeals: [Meal]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")


        /*let backgroundImage = UIImage(named: "sky")
        self.tableView.backgroundView = UIImageView(image: backgroundImage)
        tableView.backgroundColor = UIColor.clear
        */
        
        // retrive from CoreData
        getMeals()
        
        let icon = UIImage(named: "icon_clear")
        let iconSize = CGRect(origin: CGPoint.zero, size: CGSize(width: 30, height: 30))
        let iconButton = UIButton(frame: iconSize)
        iconButton.setBackgroundImage(icon, for: .normal)
        iconButton.tintColor = UIColor.red
        let barButton = UIBarButtonItem(customView: iconButton)
        iconButton.addTarget(self, action: #selector(deleteAll), for: .touchUpInside)
        let delete = UIBarButtonItem(title: "Delete All", style: .plain, target: self, action: #selector(deleteAll))
        delete.tintColor = UIColor.red
        navigationItem.rightBarButtonItems = [barButton]
    }
    
    func deleteAll() {
        let isEmpty = allMeals?.isEmpty
        let message = isEmpty! ? "There is no meals to delete." : "Are you sure you want to delete all the meals??"
        let alertController = UIAlertController(title: "DELETE ALL ITEMS", message: message, preferredStyle: .actionSheet)
        let okAction = UIAlertAction(title: "Ok", style: .default) { (result: UIAlertAction) -> Void in
            print("ok")
        }
        let deleteAllAction = UIAlertAction(title: "Delete all", style: .destructive) { (result: UIAlertAction) -> Void in
            self.deleteAllData(entity: "Meal")
            self.allMeals?.removeAll()
            self.tableView.reloadData()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (result: UIAlertAction) -> Void in
            print("cancel")
        }
        if !isEmpty! {
            alertController.addAction(deleteAllAction)
            alertController.addAction(cancelAction)
        }
        else {
            alertController.addAction(okAction)
        }
        self.present(alertController, animated: true, completion: nil)
    }
    
    func deleteAllData(entity: String) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try managedContext.fetch(fetchRequest)
            for managedObject in results
            {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                managedContext.delete(managedObjectData)
                try managedContext.save()
            }
        } catch let error as NSError {
            print("Detele all data in \(entity) error : \(error) \(error.userInfo)")
        }
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return allMeals!.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mealCell", for: indexPath) as! MealCell
        cell.imageView?.image = UIImage(data: allMeals?[indexPath.row].image! as! Data)
        cell.imageView?.frame.size.width = 80
        cell.firstLabel?.text = allMeals?[indexPath.row].name
        cell.firstLabel?.font = UIFont(name: "Baskerville-BoldItalic", size:25)
        let k = Int((allMeals?[indexPath.row].rating)!)
        print("\(k)")
        var stars = ""
        if k > 0 {
            for i in 1...k {
                stars += "☆"// "✶"
            }
        }
        print(stars)
        cell.secondLabel?.text = stars
        cell.secondLabel?.font = UIFont(name: "Baskerville-BoldItalic", size:25)
        cell.backgroundColor = UIColor.clear
        return cell
    }
    
    
    /*
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIdentifier = "Cell"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.value2, reuseIdentifier: cellIdentifier)
        }
        
        cell?.imageView?.image = UIImage(data: allMeals?[indexPath.row].image! as! Data)
        cell?.imageView?.frame.size.width = 80
        cell?.textLabel?.text = allMeals?[indexPath.row].name
        cell?.textLabel?.font = UIFont(name: "Baskerville-BoldItalic", size:25)
        cell?.detailTextLabel?.text = "Ten stars"
        cell?.detailTextLabel?.font = UIFont(name: "Baskerville-BoldItalic", size:15)
        cell?.backgroundColor = UIColor.clear
        return cell!
    }*/
    
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Meal")
            do {
                let results = try context.fetch(request)
                if !results.isEmpty {
                    for result in results as! [Meal] {
                        if let name = result.value(forKey: "name") as? String {
                            //TODO: set old and new image that vill change image in CoreData
                            if name == allMeals?[indexPath.row].name {//or == unik number
                                context.delete(result as NSManagedObject)
                                print("deleted")
                                do {
                                    try context.save()
                                    print("saved")
                                }
                                catch {
                                    print("error")
                                }
                            }
                        }
                    }
                }
            }
            catch
            {
                print("error when retrieving")
            }
            allMeals?.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    
    /* DELETE + EDIT
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let editAction = UITableViewRowAction(style: .normal, title: "Favorite", handler: { (action, indexPath) in
            /*let alert = UIAlertController(title: "", message: "Edit list item", preferredStyle: .alert)
            alert.addTextField(configurationHandler: { (textField) in
                textField.text = self.allMeals?[indexPath.row]
            })
            alert.addAction(UIAlertAction(title: "Update", style: .default, handler: { (updateAction) in
                self.allMeals?[indexPath.row] = alert.textFields!.first!.text!
                self.tableView.reloadRows(at: [indexPath], with: .fade)
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert, animated: false)*/
        })
        
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete", handler: { (action, indexPath) in
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Meal")
            do {
                let results = try context.fetch(request)
                if !results.isEmpty {
                    for result in results as! [Meal] {
                        if let name = result.value(forKey: "name") as? String {
                            //TODO: set old and new image that vill change image in CoreData
                            if name == self.allMeals?[indexPath.row].name {//or == unik number
                                context.delete(result as NSManagedObject)
                                print("deleted")
                                do {
                                    try context.save()
                                    print("saved")
                                }
                                catch {
                                    print("error")
                                }
                            }
                        }
                    }
                }
            }
            catch
            {
                print("error when retrieving")
            }
            self.allMeals?.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        })
        
        return [deleteAction, editAction]
    }*/
    
    
    
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMeal" {
            if let IndexPath = self.tableView.indexPathForSelectedRow {
                let meal = allMeals?[IndexPath.row]
                (segue.destination as! MealVC).meal = meal
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let inloggedUserEmail: String = KeychainWrapper.standard.string(forKey: "EMAIL") {
            print("Saved email is: " + inloggedUserEmail)
            currentUser = CoreDataHandler.getUser(email: inloggedUserEmail)
        }
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        
        getMeals()
        tableView.reloadData()
    }

    

    // retrive from CoreData
    func getMeals() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Meal")
        do {
            let meals = try context.fetch(request) as! [Meal]
            allMeals = meals
        }
        catch let error {
            print("\(error)")
        }
        print("All meals (\(allMeals?.count)):")
        for meal in allMeals! {
            print("Meal: \(meal.description)")
        }
    }

}
