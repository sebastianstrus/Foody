//
//  LoginVC.swift
//  Foody
//
//  Created by Sebastian Strus on 2017-10-31.
//  Copyright © 2017 Sebastian Strus. All rights reserved.
//

import UIKit
import CoreData
import SwiftKeychainWrapper


class LoginVC: UIViewController {
    @IBOutlet weak var emailTF: HoshiTextField!
    @IBOutlet weak var passwordTF: HoshiTextField!
    
    var result = NSArray()
    
    var user:[User]? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        /*CoreDataHandler.saveObject(username: "Sebek", password: "123456")
        CoreDataHandler.saveObject(username: "Tomek", password: "123456")
        CoreDataHandler.saveObject(username: "Bartek", password: "123456")
        CoreDataHandler.saveObject(username: "Sebek", password: "123456")
        CoreDataHandler.saveObject(username: "Tomek", password: "123456")
        CoreDataHandler.saveObject(username: "Bartek", password: "123456")
        CoreDataHandler.saveObject(username: "Sebek", password: "123456")
        CoreDataHandler.saveObject(username: "Tomek", password: "123456")
        CoreDataHandler.saveObject(username: "Bartek", password: "123456")
        */
        /*if CoreDataHandler.saveObject(username: "Sebek", password: "123456") {
            user = CoreDataHandler.fetchObject()
        
            print("Before single deleting:")
            for i in user!{
                print(i.username!)
            }
            
            if CoreDataHandler.deleteObject(user: user![1]) {
                user = CoreDataHandler.fetchObject()
                print("After single deleting:")
                for i in user!{
                    print(i.username!)
                }
            }
        
            if CoreDataHandler.cleanDelete() {
                user = CoreDataHandler.fetchObject()
                print("After cleaning:")
                
                print(user!.count)
            }
        }*/
        
        user = CoreDataHandler.fetchObject()
        for i in user!{
            print(i.username!)
        }
        
        user = CoreDataHandler.filterData(value: "r")
        
        print("After")
        for i in user!{
            print(i.username!)
        }
        
    }


    @IBAction func backPressed(_ sender: Any) {
        performSegue(withIdentifier: "loginToWelcome", sender: nil)
        
    }
    
    @IBAction func loginPressed(_ sender: Any) {
        if emailTF.text == "" || passwordTF.text == ""
        {
            let alert = UIAlertController(title: "Information", message: "Please enter all the fields", preferredStyle: .alert)
            
            let ok = UIAlertAction(title: "Ok", style: .default, handler: nil)
            let cancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
            
            alert.addAction(ok)
            alert.addAction(cancel)
            
            self.present(alert, animated: true, completion: nil)
        }
        else
            
        {
            
            self.CheckForUserNameAndPasswordMatch(username : emailTF.text! as String, password : passwordTF.text! as String)
            
            
        }
    }
    
    func CheckForUserNameAndPasswordMatch( email: String, password : String)
    {
        let app = UIApplication.shared.delegate as! AppDelegate
        
        let context = app.persistentContainer.viewContext
        
        let fetchrequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        
        let predicate = NSPredicate(format: "email = %@", emailTF.text!)
        
        fetchrequest.predicate = predicate
        do
        {
            result = try context.fetch(fetchrequest) as NSArray
            
            if result.count>0
            {
                let objectentity = result.firstObject as! User
                
                if objectentity.email == email && objectentity.password == password
                {
                    print("Login Succesfully")
                    
                    // save inlogged user
                    let inloggedUserEmail: Bool = KeychainWrapper.standard.set(emailTF.text!, forKey: "EMAIL")
                    if inloggedUserEmail {
                        performSegue(withIdentifier: "loginToHome", sender: nil)
                    }
                    
                    
                    
                    
                    //let retrievedString: String? = KeychainWrapper.standard.string(forKey: "myKey")
                    
                    //let removeSuccessful: Bool = KeychainWrapper.standard.remove(key: "myKey")
                }
                else
                {
                    print("Wrong username or password !!!")
                }
            }
        }
            
        catch
        {
            let fetch_error = error as NSError
            print("error", fetch_error.localizedDescription)
        }
    }
    
    /*
     override func viewDidAppear(_ animated: Bool) {
        if let inloggedUserEmail: String = KeychainWrapper.standard.string(forKey: "EMAIL") {
            print("Saved email is: " + inloggedUserEmail)
        } else {
            print("KeychainWrapper is empty.")
            performSegue(withIdentifier: "logout", sender: nil)
            
        }
    }
 */
    
    
    

}


    




