//
//  MealVC.swift
//  Foody
//
//  Created by Sebastian Strus on 2017-11-04.
//  Copyright © 2017 Sebastian Strus. All rights reserved.
//

import UIKit
import MapKit

class MealVC: UIViewController, CLLocationManagerDelegate {
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descriptionView: UITextView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var starsLabel: UILabel!
    
    var locationManager: CLLocationManager!
    
    var meal: Meal!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

    
        descriptionView.layer.borderWidth = 1
        descriptionView.layer.cornerRadius = 10
        
        view.addSubview(scrollView)
        
        if let m = meal {
            titleLabel.text = m.name
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd.MM.yyyy"
            let somedateString = dateFormatter.string(from: m.date! as Date)
            dateLabel.text = somedateString

            imageView.image = UIImage(data: m.image as! Data)
            descriptionView.text = m.mealDescription
            priceLabel.text = m.price
            let k = Int((m.rating))
            var stars = ""
            if k > 0 {
                for i in 1...k {
                    stars += "☆"// "✶"
                }
            }
            starsLabel.text = stars
        }
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.distanceFilter = 1000
        locationManager.desiredAccuracy = 1000
        locationManager.startUpdatingLocation()
        locationManager.requestWhenInUseAuthorization()
        
        let coordinate = CLLocationCoordinate2D(latitude: (meal?.placeLatitude)!, longitude: (meal?.placeLongitude)!)
        let  annotation = MKPointAnnotation()
        annotation.title = meal?.name
        
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        scrollView.contentSize = CGSize(width: 375
            , height: 750)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userCenter = CLLocationCoordinate2D(latitude: meal.placeLatitude, longitude: meal.placeLongitude)
        
        let region = MKCoordinateRegion(center: userCenter, span: MKCoordinateSpan(latitudeDelta: 100, longitudeDelta: 100))
        
        mapView.setRegion(region, animated: true)
    }

    
    


}
