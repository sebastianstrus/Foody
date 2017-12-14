//
//  SettingsVC.swift
//  Foody
//
//  Created by Sebastian Strus on 2017-10-31.
//  Copyright © 2017 Sebastian Strus. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import CoreData

class SettingsVC: UIViewController {
    
    @IBOutlet weak var logoutBtn: UIButton!
    
    @IBOutlet weak var removeAccountBtn: UIButton!
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var currentUser:User?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        logoutBtn.backgroundColor = .clear
        logoutBtn.layer.cornerRadius = 20
        logoutBtn.layer.borderWidth = 2
        logoutBtn.layer.borderColor = UIColor(red: 0/255, green: 122/255, blue: 255/255, alpha: 1.0).cgColor
        
        logoutBtn.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: 1)
        
        removeAccountBtn.backgroundColor = .clear
        removeAccountBtn.layer.cornerRadius = 20
        removeAccountBtn.layer.borderWidth = 2
        removeAccountBtn.layer.borderColor = UIColor.red.cgColor
        removeAccountBtn.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: 1)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let inloggedUserEmail: String = KeychainWrapper.standard.string(forKey: "EMAIL") {
            print("Saved email is: " + inloggedUserEmail)
            currentUser = CoreDataHandler.getUser(email: inloggedUserEmail)
        }
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }


    

    @IBAction func logoutPressed(_ sender: Any) {
        logout()
    }
    
    @IBAction func removeAccountPressed(_ sender: Any) {
        let alertController = UIAlertController(title: "REMOVE ACCOUNT", message: "Are you sure you want to remove your account?", preferredStyle: .actionSheet)
        let removeAccount = UIAlertAction(title: "Remove account", style: .destructive) { (result: UIAlertAction) -> Void in
            print("remove")
            if CoreDataHandler.deleteUser(user: self.currentUser!) {
                self.logout()
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (result: UIAlertAction) -> Void in
            print("cancel")
        }
        alertController.addAction(removeAccount)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    


    func logout() {
        let removeSuccessful: Bool = KeychainWrapper.standard.removeObject(forKey: "EMAIL")
        print("removeSuccessful: \(removeSuccessful)")
        if removeSuccessful {
            performSegue(withIdentifier: "settingsToWelcome", sender: nil)
        }
    }
    
}
