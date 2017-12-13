//
//  LoginVC.swift
//  Foody
//
//  Created by Sebastian Strus on 2017-10-31.
//  Copyright © 2017 Sebastian Strus. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {

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
        performSegue(withIdentifier: "loginToWelcome", sender: nil)}

    }
    




