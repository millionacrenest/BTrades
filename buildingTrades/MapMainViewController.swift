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
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
   
    
    let locationManager = CLLocationManager()
    let annotation = MKPointAnnotation()
   
    let regionRadius: CLLocationDistance = 1000
    var varToPass: String!
    
   
    
    let locationsRef = Database.database().reference(withPath: "nodeLocations")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
       
        self.mapView.showsUserLocation = true
        self.mapView.delegate = self
        
     
        
        
        DispatchQueue.main.async {
            
            self.locationManager.startUpdatingLocation()
        }
        
        mapView.userTrackingMode = .follow

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let tag = "SBT"
        
        locationsRef.queryOrdered(byChild:"localtag").queryEqual(toValue:"\(tag)").observe(.value, with: { snapshot in
    

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
                
                self.mapView.removeAnnotation(dropPin)
                self.mapView.addAnnotation(dropPin)
                
                
                
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
