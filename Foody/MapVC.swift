//
//  MapVC.swift
//  Foody
//
//  Created by Sebastian Strus on 2017-10-31.
//  Copyright © 2017 Sebastian Strus. All rights reserved.
//

import UIKit
import MapKit
import CoreData
import SwiftKeychainWrapper

class MapVC: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var currentUser:User?
    
    var locationManager: CLLocationManager!
    var allMeals: [Meal]?
    
    var allUsers: [User]?
    
    var thumbnailImageByAnnotation = [NSValue : UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        allUsers = CoreDataHandler.getUsers()
        for user in allUsers! {
            print("User: \(String(describing: user.username!)) \(String(describing: user.email!)) \(String(describing: user.password!))")
        }
        
        getMeals()
        configureLocationMenager()
        mapView.delegate = self
        addAllMealsToMap()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let span = MKCoordinateSpan(latitudeDelta: 100, longitudeDelta: 100)
            let lookHereRegion = MKCoordinateRegion(center: location.coordinate, span: span)
            mapView.setRegion(lookHereRegion, animated: true)
        }
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
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseID = "myAnnotationView"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseID)
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
            annotationView?.canShowCallout = true
        }
        /// Set the "pin" image of the annotation view
        annotationView?.image = getOurThumbnailForAnnotation(annotation: annotation)
        
        return annotationView
    }
    
    func addAnnotationWithThumbnailImage(thumbnail: UIImage) {
        let annotation = MKPointAnnotation()
        let locationCoordinate = CLLocationCoordinate2DMake(37.783333, -122.416667)
        annotation.coordinate = locationCoordinate
        
        thumbnailImageByAnnotation[NSValue(nonretainedObject: annotation)] = thumbnail
        mapView.addAnnotation(annotation)
    }
    
    func getOurThumbnailForAnnotation(annotation : MKAnnotation) -> UIImage?{
        return thumbnailImageByAnnotation[NSValue(nonretainedObject: annotation)]
    }
    
    func scaleImage(image: UIImage, maximumWidth: CGFloat) -> UIImage {
        let rect: CGRect = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
        let cgImage: CGImage = image.cgImage!.cropping(to: rect)!
        return UIImage(cgImage: cgImage, scale: image.size.width / maximumWidth, orientation: image.imageOrientation)
    }
    
    func configureLocationMenager() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.distanceFilter = 1000
        locationManager.desiredAccuracy = 1000
        locationManager.startUpdatingLocation()
        locationManager.requestWhenInUseAuthorization()
    }
    
    func addAllMealsToMap() {
        for meal in allMeals! as [Meal] {
            let coordinate = CLLocationCoordinate2D(latitude: meal.placeLatitude, longitude: meal.placeLongitude)
            let  annotation = MKPointAnnotation()
            var myImage = UIImage(data: meal.image as! Data)!
            //scale image
            myImage = scaleImage(image: myImage, maximumWidth: 50)
            thumbnailImageByAnnotation[NSValue(nonretainedObject: annotation)] = myImage
            annotation.title = meal.name
            mapView(self.mapView, viewFor: annotation)?.annotation = annotation
            annotation.coordinate = coordinate
            mapView.addAnnotation(annotation)// Replace " as!" with "! as"
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let inloggedUserEmail: String = KeychainWrapper.standard.string(forKey: "EMAIL") {
            print("Saved email is: " + inloggedUserEmail)
            currentUser = CoreDataHandler.getUser(email: inloggedUserEmail)
        }
        getMeals()
        mapView.removeAnnotations(mapView.annotations)
        addAllMealsToMap()
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    // read more about map
    // https://github.com/codepath/ios_guides/wiki/Using-MapKit
}

