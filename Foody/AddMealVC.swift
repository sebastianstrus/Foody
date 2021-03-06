//
//  AddMealVC.swift
//  Foody
//
//  Created by Sebastian Strus on 2017-10-31.
//  Copyright © 2017 Sebastian Strus. All rights reserved.
//

import UIKit
import CoreData
import MapKit
import SwiftKeychainWrapper

class AddMealVC: UIViewController, MKMapViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var titleTF: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descriptionTV: UITextView!
    
    @IBOutlet weak var blackView: UIView!
    @IBOutlet weak var ratingPicker: UIPickerView!
    @IBOutlet weak var datePopup: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var dateCancelButton: UIButton!
    @IBOutlet weak var dateOkButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var selectedDateLabel: UILabel!
    @IBOutlet weak var priceTF: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var favouriteSwitch: UISwitch!
    
    var currentUser:User?
    
    var ratings: [Int32]?
    var currentRating: Int32?
    
    var settedDate: Date?
    var dateInPicker: Date?
    var locationManager: CLLocationManager!
    var start : MKPointAnnotation?
    var goal : MKPointAnnotation?
    var originalCenter: CGPoint!
    var currentLatitude = 0.0
    var currentLongitude = 0.0
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        datePopup.layer.shadowColor = UIColor.black.cgColor
        datePopup.layer.shadowOpacity = 1
        datePopup.layer.shadowOffset = CGSize.zero
        datePopup.layer.shadowRadius = 10
        datePopup.layer.cornerRadius = 10
        
        // hide keyboard
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(AddMealVC.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        //set date picker mode
        datePicker.datePickerMode = UIDatePickerMode.date


        //set current Date as default
        let date = Date()
        settedDate = date
        dateInPicker = date
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        selectedDateLabel.text = formatter.string(from: date)
        
        //initial rating
        currentRating = 0
        
        // set map
        mapView.showsUserLocation = true
        mapView.delegate = self
        
        

        blackView.alpha = 0.0
        //datePicker.setValue(UIColor.blue, forKey: "textColor")
        datePopup.alpha = 0
        originalCenter = datePopup.center
        dateCancelButton.addTarget(self, action: #selector(dateCancelPressed), for: .touchUpInside)
        dateOkButton.addTarget(self, action: #selector(dateOkPressed), for: UIControlEvents.touchUpInside)
        ratingPicker.delegate = self
        ratingPicker.dataSource = self
        ratings = [Int32](0...10)
        
        saveButton.backgroundColor = .clear
        saveButton.layer.cornerRadius = 20
        saveButton.layer.borderWidth = 2
        saveButton.layer.borderColor = UIColor(red: 0/255, green: 122/255, blue: 255/255, alpha: 1.0).cgColor
        saveButton.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: 1)
        
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        mapView.showAnnotations([userLocation], animated: true)
    }
    
    @IBAction func showDatePicker(_ sender: UIButton) {
        datePopup.transform = CGAffineTransform(scaleX: 0.3, y: 2)
        UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0, options: .allowUserInteraction, animations: {
            self.datePopup.transform = .identity
        }) { (succes) in
            self.datePopup.center = self.originalCenter
            self.datePopup.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        }
        datePopup.alpha = 1.0
        blackView.alpha = 1.0
    }
    
    @IBAction func cameraButtonPressed(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    @IBAction func libraryButtonPressed(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    @IBAction func mapLongPressed(_ sender: UILongPressGestureRecognizer) {
        if !(titleTF.text?.isEmpty)! {
            if sender.state == .began {
                let position = sender.location(in: mapView)
                let coordinate = mapView.convert(position, toCoordinateFrom: mapView)
                currentLatitude = coordinate.latitude
                currentLongitude = coordinate.longitude
                if let existing = goal {
                    mapView.removeAnnotation(existing)
                }
                let  annotation = MKPointAnnotation()
                annotation.title = titleTF.text
                annotation.coordinate = coordinate
                mapView.addAnnotation(annotation)
                goal = annotation
            }
        }
        else {
            alert(info: "Title can'n be empty!")
        }
    }
    @IBAction func datePickerChanged(_ sender: UIDatePicker) {
        print("print \(sender.date)")
        dateInPicker = sender.date
    }
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        
        if (!(titleTF.text?.isEmpty)!) {
            let context = CoreDataHandler.getContext()
            
            let userDescription = NSEntityDescription.entity(forEntityName: "User", in: context)!
            let mealDescription = NSEntityDescription.entity(forEntityName: "Meal", in: context)!
            
            //let newUser = NSManagedObject(entity: userDescription, insertInto: context) as! User
            let newMeal = NSManagedObject(entity: mealDescription, insertInto: context) as! Meal
            
            newMeal.name = titleTF.text
            newMeal.image = UIImagePNGRepresentation(imageView.image!)! as NSData?
            newMeal.date = settedDate as! NSDate
            newMeal.mealDescription = descriptionTV.text
            newMeal.price = priceTF.text
            newMeal.rating = currentRating!
            newMeal.isFavorite = favouriteSwitch.isOn
            if currentLatitude != 0.0 {
                newMeal.placeLongitude = currentLongitude
                newMeal.placeLatitude = currentLatitude
            }
            
            
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
            
            do {
                let users = try context.fetch(request) as! [User]
                for user in users {
                    if user.email == currentUser?.email {
                        user.addToMeals(newMeal)
                        titleTF.text = ""
                    }
                }
            } catch let error {
                NSLog("\(error)")
            }
            
            do {
                try context.save()
                alert(info: "Meal is successfully saved!")
            }
            catch let error {
                print(error)
            }
        }
        else {
            alert(info: "Title field can't be empty!")
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        imageView.image = image
        self.dismiss(animated: true, completion: nil);
    }
    
    func saveNotice() {
        let alertController = UIAlertController(title: "Image Saved", message: "Your picture was successfully saved in photo library.", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func alert(info: String) {
        let alertController = UIAlertController(title: "Alert", message: "\(info)", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func alertAlreadyExists(title: String) {
        let alertController = UIAlertController(title: "Alert", message: "Trip with the title \"\(title)\" already exists in your list!", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func saveImage() {
        let imageData = UIImageJPEGRepresentation(imageView.image!, 0.6)
        let compressedIPEGImage = UIImage(data: imageData!)
        UIImageWriteToSavedPhotosAlbum(compressedIPEGImage!, nil, nil, nil)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func dateCancelPressed(sender:UIButton!) {
        UIView.animate(withDuration: 0.5, animations: {
            self.datePopup.alpha = 0
            self.blackView.alpha = 0.0
        })
    }
    
    func dateOkPressed(sender:UIButton!) {
        settedDate = dateInPicker
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        print("dateInPicker: \(String(describing: dateInPicker))")
        print("dateInPicker: \(String(describing: dateInPicker))")
        print("dateInPicker: \(String(describing: dateInPicker))")
        let somedateString = dateFormatter.string(from: dateInPicker!)
        selectedDateLabel.text = somedateString
        
        // fade out
        UIView.animate(withDuration: 0.5, animations: {
            self.datePopup.alpha = 0
            self.blackView.alpha = 0.0
        })
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        scrollView.contentSize = CGSize(width: 375
            , height: 900)
    }
    
    // PickerView
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return ratings!.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "" + String(row)
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        currentRating = ratings?[row]
        print(currentRating!)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let inloggedUserEmail: String = KeychainWrapper.standard.string(forKey: "EMAIL") {
            print("Saved email is: " + inloggedUserEmail)
            currentUser = CoreDataHandler.getUser(email: inloggedUserEmail)
        }
    
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
    }
}
