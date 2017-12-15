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

class UserVC: UIViewController, UIImagePickerControllerDelegate, UIPickerViewDelegate, UINavigationControllerDelegate  {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var mealsCountLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var logoutBtn: UIButton!
    @IBOutlet weak var removeAccountBtn: UIButton!
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var libraryButton: UIButton!
    
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var currentUser:User!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // hide keyboard
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(AddMealVC.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        if let inloggedUserEmail: String = KeychainWrapper.standard.string(forKey: "EMAIL") {
            print("Saved email is: " + inloggedUserEmail)
            currentUser = CoreDataHandler.getUser(email: inloggedUserEmail)
        }
        if let user = currentUser {
            print(currentUser.userImage)
            if let image = user.userImage {
                imageView.image = UIImage(data: image as! Data)
            }
        }
        
        
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor(red: 0/255, green: 122/255, blue: 255/255, alpha: 1.0).cgColor
        
        cameraButton.layer.cornerRadius = 10
        cameraButton.layer.borderWidth = 2
        cameraButton.layer.borderColor = UIColor(red: 0/255, green: 122/255, blue: 255/255, alpha: 1.0).cgColor
        
        libraryButton.layer.cornerRadius = 10
        libraryButton.layer.borderWidth = 2
        libraryButton.layer.borderColor = UIColor(red: 0/255, green: 122/255, blue: 255/255, alpha: 1.0).cgColor
        
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
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let inloggedUserEmail: String = KeychainWrapper.standard.string(forKey: "EMAIL") {
            print("Saved email is: " + inloggedUserEmail)
            currentUser = CoreDataHandler.getUser(email: inloggedUserEmail)
        }
        usernameLabel.text = currentUser.username
        emailLabel.text = currentUser.email

        if let count = currentUser.meals?.count, count > 0 {
             mealsCountLabel.text = String(describing: currentUser.meals!.count)
        } else {
            mealsCountLabel.text = "0"
        }
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
    
    
    @IBAction func cameraPressed(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func libraryPressed(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        imageView.image = image
        saveImageInCoreData()
        self.dismiss(animated: true, completion: nil);
    }
    
    func saveNotice() {
        let alertController = UIAlertController(title: "Image Saved", message: "Image is successfully saved in photo library.", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func saveImageInCoreData() {
        let context = CoreDataHandler.getContext()
        
        let userDescription = NSEntityDescription.entity(forEntityName: "User", in: context)!
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        
        do {
            let users = try context.fetch(request) as! [User]
            for user in users {
                if user.email == currentUser?.email {
                    user.userImage = UIImagePNGRepresentation(imageView.image!)! as NSData?
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
