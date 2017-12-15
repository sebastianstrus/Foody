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
        
        if let inloggedUserEmail: String = KeychainWrapper.standard.string(forKey: "EMAIL") {
            print("Saved email is: " + inloggedUserEmail)
            currentUser = CoreDataHandler.getUser(email: inloggedUserEmail)
        }
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        var tempMeals: [Meal] = []
        for meal in (currentUser?.meals)! as! NSSet {
            tempMeals.append(meal as! Meal)
        }
        allMeals = tempMeals;
        let icon = UIImage(named: "icon_clear")
        let iconSize = CGRect(origin: CGPoint.zero, size: CGSize(width: 30, height: 30))
        let iconButton = UIButton(frame: iconSize)
        iconButton.setBackgroundImage(icon, for: .normal)
        iconButton.tintColor = UIColor.red
        iconButton.addTarget(self, action: #selector(deleteAll), for: .touchUpInside)
        let barButton = UIBarButtonItem(customView: iconButton)
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
            self.allMeals?.removeAll()
            self.tableView.reloadData()
            self.removeAllMealsFromCoreData()
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
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let context = CoreDataHandler.getContext()
            let fetchrequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Meal")
            let predicate = NSPredicate(format: "name = %@", (allMeals?[indexPath.row].name)!)
            fetchrequest.predicate = predicate
            if let result = try? context.fetch(fetchrequest) {
                for object in result {
                    context.delete(object as! NSManagedObject)
                }
            }
            do {
                try context.save()
            }
            catch let error {
                print(error)
            }
            allMeals?.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
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
        //getMeals()
        var tempMeals: [Meal] = []
        for meal in (currentUser?.meals)! as! NSSet {
            tempMeals.append(meal as! Meal)
        }
        allMeals = tempMeals;
        tableView.reloadData()
        print("Number of meals after apear: \(allMeals?.count)")
    }
    
    func removeAllMealsFromCoreData() {
            let context = CoreDataHandler.getContext()
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
            do {
                let users = try context.fetch(request) as! [User]
                for user in users {
                    if user.email == currentUser?.email {
                        user.meals = []
                    }
                }
            } catch let error {
                NSLog("\(error)")
            }
            do {
                try context.save()
            }
            catch let error {
                print(error)
            }
    }
}
