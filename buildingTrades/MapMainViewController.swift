//
//  MapMainViewController.swift
//  buildingTrades
//
//  Created by Allison Mcentire on 8/27/17.
//  Copyright © 2017 Allison Mcentire. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Firebase
import FirebaseDatabase
import FirebaseAuth

class MapMainViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    
    @IBOutlet weak var mapView: MKMapView!
    
   
   
    
    let locationManager = CLLocationManager()
    let annotation = MKPointAnnotation()
   
    let regionRadius: CLLocationDistance = 1000
    var varToPass: String!
    var localtag: String?
    var key: String?
  //  let userID = Auth.auth().currentUser!.uid

    let locationsRef = Database.database().reference(withPath: "nodeLocations")
  //  let refUser = Database.database().reference().child("ids")

    override func viewDidLoad() {
        super.viewDidLoad()
       // getUsers()
        localtag = UserDefaults.standard.string(forKey: "localtag")
        print("the localtag is \(localtag)")
        
        
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
       
        self.mapView?.showsUserLocation = true
        self.mapView?.delegate = self
        
     
        
        
        DispatchQueue.main.async {
            
            self.locationManager.startUpdatingLocation()
        }
        
        mapView.userTrackingMode = .follow

        // Do any additional setup after loading the view.
    }
    
    
//    func getUsers() {
//
//        refUser.child("ids").child(userID).observeSingleEvent(of: .value, with: { (snapshot) in
//            // Get user value
//            let value = snapshot.value as? NSDictionary
//            self.localtag = value?["localtag"] as? String ?? ""
//
//
//            // ...
//        }) { (error) in
//            print(error.localizedDescription)
//        }
////        let query = refUser.child(userID)
////        query.observe(.value, with: { snapshot in
////            // 2
////            var frontpages: [Staff] = []
////
////            for item in snapshot.children {
////                // 4
////                let groceryItem = Staff(snapshot: item as! DataSnapshot)
////
////                self.localtag = groceryItem?.nothing
////                print("Localtag on: \(self.localtag!)")
////
////            }
////
////        })
//    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        locationsRef.child(localtag!).observe(.value, with: { snapshot in
    

            for item in snapshot.children {
                guard let locationData = item as? DataSnapshot else { continue }
                let locationValue = locationData.value as! [String: Any]
                guard let name = locationValue["name"] as? String else { continue }
                guard let tags = locationValue["localtag"] as? String else { continue }
                let latitude = locationValue["latitude"] as! CLLocationDegrees
                let longitude = locationValue["longitude"] as! CLLocationDegrees
                let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                self.key = locationData.key
                
                let dropPin = MKPointAnnotation()
                dropPin.coordinate = location
                dropPin.title = name
                dropPin.subtitle = tags
                //
                
                self.mapView?.removeAnnotation(dropPin)
                self.mapView?.addAnnotation(dropPin)
                
                
                
            }
        })
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {return nil}
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            //pinView!.animatesDrop = true
            let calloutButton = UIButton(type: .detailDisclosure)
            pinView!.rightCalloutAccessoryView = calloutButton
            pinView!.sizeToFit()
        }
        else {
            pinView!.annotation = annotation
        }
        
        
        return pinView
    }
    

    func mapView(_ mapView: MKMapView, annotationView: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        //varToPass = annotationView.annotation!.subtitle!!
        varToPass = self.key
        
        mapView.deselectAnnotation(annotationView.annotation, animated: false)
        
        performSegue(withIdentifier: "editDetail", sender: self)
        
    }
   
  
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editDetail" {
            if let toViewController = segue.destination as? SiteDetailViewController {
                toViewController.varToReceive = varToPass
            
            }
        }
    }
    

}
