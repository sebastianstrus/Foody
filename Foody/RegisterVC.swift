//
//  RegisterVC.swift
//  Foody
//
//  Created by Sebastian Strus on 2017-12-12.
//  Copyright © 2017 Sebastian Strus. All rights reserved.
//

import UIKit
import CoreData
import SwiftKeychainWrapper

class RegisterVC: UIViewController {

    @IBOutlet weak var usernameTF: HoshiTextField!
    @IBOutlet weak var emailTF: HoshiTextField!
    @IBOutlet weak var passwordTF: HoshiTextField!
    @IBOutlet weak var passwordRepeatTF: HoshiTextField!
    
    @IBOutlet weak var imageView: UIImageView! //remove
    var meal1:Meal?
    //addToMeals(_ value: Meal)
    
    var result = NSArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // hide keyboard
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(AddMealVC.dismissKeyboard))
        view.addGestureRecognizer(tap)
        // Do any additional setup after loading the view.
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }

    @IBAction func backPressed(_ sender: Any) {
        performSegue(withIdentifier: "registerToWelcome", sender: nil)
    }

    @IBAction func registerPressed(_ sender: Any) {
        if usernameTF.text == "" || emailTF.text == "" || passwordTF.text == "" || passwordRepeatTF.text == ""
        {
            let alert = UIAlertController(title: "Information", message: "Please enter all details!", preferredStyle: .alert)
            let ok = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
        }
        else if (passwordTF.text != passwordRepeatTF.text)
        {
            let alert = UIAlertController(title: "Information", message: "Password does not match", preferredStyle: .alert
            )
            let ok = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
        }
        else
        {
            let context = CoreDataHandler.getContext()
            
            
            
            
            let fetchrequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
            
            let predicate = NSPredicate(format: "email = %@", emailTF.text!)
            
            fetchrequest.predicate = predicate
            do
            {
                result = try context.fetch(fetchrequest) as NSArray
                
                if result.count>0
                {
                    let alert = UIAlertController(title: "Information", message: "Email '\(String(describing: emailTF.text))' is already taken.", preferredStyle: .alert
                    )
                    let ok = UIAlertAction(title: "Ok", style: .default, handler: nil)
                    alert.addAction(ok)
                    self.present(alert, animated: true, completion: nil)
                } else {
                    // save new user
                    
                    /*let new_user = NSEntityDescription.insertNewObject(forEntityName: "User", into: context)
                    new_user.setValue(usernameTF.text, forKey: "username")
                    new_user.setValue(emailTF.text, forKey: "email")
                    new_user.setValue(passwordTF.text, forKey: "password")
                    do
                    {
                        try context.save()
                        print("Registered  Sucessfully")
                        
                        // save information about inlogged user
                        let inloggedUserEmail: Bool = KeychainWrapper.standard.set(emailTF.text!, forKey: "EMAIL")
                        if inloggedUserEmail {
                            performSegue(withIdentifier: "registerToHome", sender: nil)
                        }
                    }
                    catch
                    {
                        let Fetcherror = error as NSError
                        print("error", Fetcherror.localizedDescription)
                    }*/
                    
                    if CoreDataHandler.saveUser(username: usernameTF.text!, email: emailTF.text!, password: passwordTF.text!) {
                        let inloggedUserEmail: Bool = KeychainWrapper.standard.set(emailTF.text!, forKey: "EMAIL")
                        print("User saved")
                        if inloggedUserEmail {
                            performSegue(withIdentifier: "registerToHome", sender: nil)
                        }
                    }
                }
            }
            catch
            {
                let fetch_error = error as NSError
                print("error", fetch_error.localizedDescription)
            }
            
        }
        
        //self.navigationController?.popViewController(animated: true)
        
    }
}
    


