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
    let userID = Auth.auth().currentUser!.uid

    let locationsRef = Database.database().reference(withPath: "nodeLocations")
    let refUser = Database.database().reference().child("users")

    override func viewDidLoad() {
        super.viewDidLoad()
        getUsers()
        
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
    
    
    func getUsers() {
        let query = refUser.queryOrdered(byChild: "field_uid").queryEqual(toValue: userID)
        query.observe(.value, with: { snapshot in
            // 2
            var frontpages: [Staff] = []
            
            for item in snapshot.children {
                // 4
                let groceryItem = Staff(snapshot: item as! DataSnapshot)

                self.localtag = groceryItem?.nothing
                print("Localtag on: \(self.localtag!)")
                
            }
            
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
       
        let query = locationsRef.child(localtag!)
        query.queryOrdered(byChild:"localtag").queryEqual(toValue: localtag!).observe(.value, with: { snapshot in
    

            for item in snapshot.children {
                guard let locationData = item as? DataSnapshot else { continue }
                let locationValue = locationData.value as! [String: Any]
                let name = locationValue["title"] as! String
                let tags = locationValue["localtag"] as! String
                let latitude = locationValue["LocationLatitude"] as! CLLocationDegrees
                let longitude = locationValue["LocationLongitude"] as! CLLocationDegrees
                let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                let key = locationData.key
                
                let dropPin = MKPointAnnotation()
                dropPin.coordinate = location
                dropPin.title = name
                dropPin.subtitle = key
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
        
        varToPass = annotationView.annotation!.subtitle!!
        
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
