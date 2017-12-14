//
//  FavoritesVC.swift
//  Foody
//
//  Created by Sebastian Strus on 2017-10-31.
//  Copyright © 2017 Sebastian Strus. All rights reserved.
//

import UIKit
import CoreData
import SwiftKeychainWrapper

class FavoritesVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var currentUser:User?
    
    var allMeals: [Meal]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getMeals()
        // Do any additional setup after loading the view.
        
        let itemSize = UIScreen.main.bounds.width/3 - 3
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsetsMake(20, 0, 10, 0)
        layout.itemSize = CGSize(width: itemSize, height: itemSize)
        layout.minimumInteritemSpacing = 3
        layout.minimumLineSpacing = 3
        collectionView.collectionViewLayout = layout
    }

    // number of views
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (allMeals?.count)!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! FavoriteCell
        
        //let screenSize: CGRect = UIScreen.main.bounds
        //cell.frame.width = screenSize.width - 10
            // CGRect(x: 0, y: 0, width: 50, height: screenSize.height * 0.2)
        
        cell.favoriteImageView.image = UIImage(data:(allMeals?[indexPath.row].image)! as Data,scale:1.0)
        
        
        return cell// Cannot convert value of type 'NSData?' to type 'UIImage' in coercion
    }
    
    
    
    
    
    
    
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
    
    override func viewDidAppear(_ animated: Bool) {
        if let inloggedUserEmail: String = KeychainWrapper.standard.string(forKey: "EMAIL") {
            print("Saved email is: " + inloggedUserEmail)
            currentUser = CoreDataHandler.getUser(email: inloggedUserEmail)
        }
        getMeals()
        collectionView.reloadData()
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //Pass indexPath as sender
        self.performSegue(withIdentifier: "showFavoriteMeal", sender: indexPath)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if( segue.identifier == "showFavoriteMeal" ) {
            
            let VC1 = segue.destination as! MealVC
            if let indexPath = sender as? IndexPath {
                
                let meal = allMeals?[indexPath.row]
                VC1.meal = meal
            }
        }
    }

}
