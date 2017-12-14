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
        
        /*user = CoreDataHandler.fetchObject()
        for i in user!{
            print(i.username!)
        }*/
       /*
        user = CoreDataHandler.getUser(value: "r")
        
        print("After")
        for i in user!{
            print(i.username!)
        }*/
        
    }


    @IBAction func backPressed(_ sender: Any) {
        performSegue(withIdentifier: "loginToWelcome", sender: nil)
        
    }
    
    @IBAction func loginPressed(_ sender: Any) {
        if emailTF.text == "" || passwordTF.text == ""
        {
            let alert = UIAlertController(title: "Information", message: "Please fill all the fields.", preferredStyle: .alert)
            let ok = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
        }
        else
            
        {
            
            self.CheckForUserNameAndPasswordMatch(email : emailTF.text! as String, password : passwordTF.text! as String)
            
            
        }
    }
    
    func CheckForUserNameAndPasswordMatch( email: String, password : String)
    {
        if let user = CoreDataHandler.getUser(email: email) {
            if (user.password == password) {
                print("Login Succesfully")
                let inloggedUserEmail: Bool = KeychainWrapper.standard.set(emailTF.text!, forKey: "EMAIL")
                if inloggedUserEmail {
                    performSegue(withIdentifier: "loginToHome", sender: nil)
                }
            } else {
                let alert = UIAlertController(title: "Information", message: "Wrong password!", preferredStyle: .alert)
                let ok = UIAlertAction(title: "Ok", style: .default, handler: nil)
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
            }
        } else {
            let alert = UIAlertController(title: "Information", message: "Email is not registered.", preferredStyle: .alert)
            let ok = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
        }
        
    }
        
  
    
    
    //login
    /*let inloggedUserEmail: Bool = KeychainWrapper.standard.set(emailTF.text!, forKey: "EMAIL")
    if inloggedUserEmail {
    performSegue(withIdentifier: "loginToHome", sender: nil)*/
    
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


    




