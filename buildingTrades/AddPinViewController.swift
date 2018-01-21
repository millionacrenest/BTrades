//
//  MapViewViewController.swift
//  ualocal32
//
//  Created by Allison Mcentire on 6/14/17.
//  Copyright © 2017 Allison Mcentire. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Firebase
import FirebaseDatabase
import FirebaseAuth
import MobileCoreServices
import PhotoEditorSDK


class AddPinViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UITextFieldDelegate, UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var firstImageView: UIImageView!
 
    
    @IBOutlet weak var keyboardHeightLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var locationName: UITextField!
   
    
    
    
  
    
    
    @IBOutlet weak var coordinatesLabel: UILabel!
    
    @IBOutlet weak var tagsTextField: UITextField!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    @IBOutlet weak var tableView: UITableView!
    
    let locationManager =  CLLocationManager()
    let newPin = MKPointAnnotation()
    var locationImageUrl: String?
    var longitude: Double = 0
    var latitude: Double = 0
    var ref = Database.database().reference()
    var storage: Storage!
    var newMedia: Bool?
    let userID = Auth.auth().currentUser!.uid

    
    var tagHere: String?
    var filename: String?
    var image: UIImage?
    var data: Data?
    let myGroup = DispatchGroup()
    

    let refUser = Database.database().reference().child("users")
    var refNodeLocations = Database.database().reference().child("nodeLocations")
    var localtag = UserDefaults.standard.string(forKey: "localtag")
   
   
    
    
    var items: [NodeLocation] = []
    var pickerData = ["SeattleBuildingTrades", "Asbestos Workers Local 7", "Boilermakers Local 502", "BAC Pacific Northwest ADC", "Carpet, Lino. & Soft Tile Layers Local 1238", "CementMasonsandPlasterersLocal528", "Electrical Workers Local 46", "Elevator Constructors Local 19", "Glaziers Local 188", "Iron Workers Local 86", "Laborers Local 242", "Laborers Local 440", "IUPAT Local 300", "IUPAT Local 1964", "Plumbers & Pipefitters Local 32", "Roofers Local 54", "Sheet Metal Workers Local 66", "Sign Painters Local 1094", "Sprinkler Fitters Local 699", "Teamsters Local 174", "Laborers District Council", "IUPAT District Council 5", "Operating Engineers Local 302"]
    
    
   
    

    
    
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //getUsers()
        
 
//        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardNotification(notification:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
//
  
        tableView.delegate = self
        tableView.dataSource = self
     
//


        
        storage = Storage.storage()
        storage.maxOperationRetryTime = 100000
      
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        if #available(iOS 8.0, *) {
            locationManager.requestAlwaysAuthorization()
        } else {
            // Fallback on earlier versions
        }
        locationManager.startUpdatingLocation()
        
        self.tableView.allowsMultipleSelection = true

     
    }
    

//    
//    deinit {
//        NotificationCenter.default.removeObserver(self)
//    }
//    
//    @objc func keyboardNotification(notification: NSNotification) {
//        if let userInfo = notification.userInfo {
//            let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
//            let duration:TimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
//            let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
//            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIViewAnimationOptions.curveEaseInOut.rawValue
//            let animationCurve:UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animationCurveRaw)
//            if (endFrame?.origin.y)! >= UIScreen.main.bounds.size.height {
//                self.keyboardHeightLayoutConstraint?.constant = 0.0
//            } else {
//                self.keyboardHeightLayoutConstraint?.constant = endFrame?.size.height ?? 0.0
//            }
//            UIView.animate(withDuration: duration,
//                           delay: TimeInterval(0),
//                           options: animationCurve,
//                           animations: { self.view.layoutIfNeeded() },
//                           completion: nil)
//        }
//    }

    
  
    
//    func keyboardWillShow(notification: NSNotification) {
//        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
//            if self.view.frame.origin.y == 0{
//                self.view.frame.origin.y -= keyboardSize.height
//            }
//        }
//    }
//
//    func keyboardWillHide(notification: NSNotification) {
//        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
//            if self.view.frame.origin.y != 0{
//                self.view.frame.origin.y += keyboardSize.height
//            }
//        }
//    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //mapView.removeAnnotation(newPin)
        
        let location = locations.last! as CLLocation
        
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        var locValue:CLLocationCoordinate2D = locationManager.location!.coordinate
        //print("locations = \(locValue.latitude) \(locValue.longitude)")
        latitude = locValue.latitude
        longitude = locValue.longitude
        
    }

    private func buildConfiguration() -> Configuration {
        let configuration = Configuration() { builder in
            // Configure camera
            builder.configureCameraViewController() { options in
                // Just enable Photos
                options.allowedRecordingModes = [.photo]
            }
        }
        
        return configuration
    }
    
    

    
    private func presentCameraViewController() {
        let configuration = buildConfiguration()
        let cameraViewController = CameraViewController(configuration: configuration)
        cameraViewController.dataCompletionBlock = { [unowned cameraViewController] data in
            if let data = data {
                let photo = Photo(data: data)
                cameraViewController.present(self.createPhotoEditViewController(with: photo), animated: true, completion: nil)
                
            
            }
        }
        
        present(cameraViewController, animated: true, completion: nil)
    }
    

 
    private func createPhotoEditViewController(with photo: Photo) -> PhotoEditViewController {
        let configuration = buildConfiguration()
        var menuItems = PhotoEditMenuItem.defaultItems
        menuItems.removeLast() // Remove last menu item ('Magic')
        
        // Create a photo edit view controller
        let photoEditViewController = PhotoEditViewController(photoAsset: photo, configuration: configuration, menuItems: menuItems)
        photoEditViewController.delegate = self
    
        return photoEditViewController
    }
    
    private func presentPhotoEditViewController() {
        guard let url = Bundle.main.url(forResource: "129968", withExtension: "jpg") else {
            return
        }
        
        let photo = Photo(url: url)
        present(createPhotoEditViewController(with: photo), animated: true, completion: nil)
    }

    private func pushPhotoEditViewController() {
        guard let url = Bundle.main.url(forResource: "129968", withExtension: "jpg") else {
            return
        }
        
        let photo = Photo(url: url)
        navigationController?.pushViewController(createPhotoEditViewController(with: photo), animated: true)
     
    }
    
    private func presentCustomizedCameraViewController() {
        let configuration = Configuration { builder in
            // Setup global colors
           // builder.backgroundColor = self.whiteColor
            builder.menuBackgroundColor = UIColor.lightGray
            
          //  self.customizeCameraController(builder)
          //  self.customizePhotoEditorViewController(builder)
           // self.customizeTextTool()
        }
        
        let cameraViewController = CameraViewController(configuration: configuration)
        
        // Set a global tint color, that gets inherited by all views
       // if let window = UIApplication.shared.delegate?.window! {
           // window.tintColor = redColor
        //}
        
        cameraViewController.dataCompletionBlock = { data in
            let photo = Photo(data: data!)
            let photoEditViewController = PhotoEditViewController(photoAsset: photo, configuration: configuration)
//           photoEditViewController.view.tintColor = UIColor(red: 0.11, green: 0.44, blue: 1.00, alpha: 1.00)
//            photoEditViewController.toolbar.backgroundColor = UIColor.gray
            photoEditViewController.delegate = self
            //        //  Get a reference to the location where we'll store our photos
            cameraViewController.present(photoEditViewController, animated: true, completion: nil)
        }
        
        present(cameraViewController, animated: true, completion: nil)
    }
    
 
    
    @IBAction func useCamera(_ sender: Any) {
        presentCameraViewController()

    }

    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pickerData.count
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tagsCell", for: indexPath as IndexPath) as! UITableViewCell
        
        
        cell.textLabel?.text = pickerData[indexPath.row]
 
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tagHere = pickerData[indexPath.row]
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
  
    
    func saveData(){
   
        
            var refNodeLocationsLocal = Database.database().reference().child("nodeLocations/\(self.localtag!)")
            let key = self.refNodeLocations.childByAutoId().key
            if self.tagHere != nil {
                var refNodeLocationsShared = Database.database().reference().child("nodeLocations/\(self.tagHere!)")
            
            //creating artist with the given values
                let nodeLocation = ["name": self.locationName.text! as String,
                                    "localtag": self.localtag,
                                    "sharedWith": self.tagHere,
                                    "latitude": self.latitude as Double,
                                    "longitude": self.longitude as Double,
                                    "image": self.locationImageUrl as! String,
                                    "UID": "\(self.userID)"] as [String : Any]
            
            //adding the artist inside the generated unique key
            
            refNodeLocationsLocal.child(key).setValue(nodeLocation)
            refNodeLocationsShared.child(key).setValue(nodeLocation)
                self.refNodeLocations.child(key).setValue(nodeLocation)
        } else {
            //creating artist with the given values
                let nodeLocation = ["name": self.locationName.text! as String,
                                    "localtag": self.localtag,
                                "sharedWith": "SBT",
                                "latitude": self.latitude as Double,
                                "longitude": self.longitude as Double,
                                "image": self.locationImageUrl as! String,
                                "UID": "\(self.userID)"] as [String : Any]
            
            //adding the artist inside the generated unique key
            refNodeLocationsLocal.child(key).setValue(nodeLocation)
                self.refNodeLocations.child(key).setValue(nodeLocation)
            
                }
            
    }
    

    
    @IBAction func addLocationTapped(_ sender: Any) {
        locationManager.stopUpdatingLocation()
        
        
        if locationImageUrl != nil {
            self.saveData()
            
            let alertController = UIAlertController(title: "Success", message: "Report has been posted.", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            self.present(alertController, animated: true, completion: nil)
        } else {
                //Alert to tell the user that there was an error because they didn't fill anything in the textfields because they didn't fill anything in
            
                let alertController = UIAlertController(title: "Error", message: "Your image is did not load. Please try again.", preferredStyle: .alert)
            
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
            
                self.present(alertController, animated: true, completion: nil)
            
            
        }
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Map")
        self.present(vc!, animated: true, completion: nil)
        }


    
}

extension AddPinViewController: PhotoEditViewControllerDelegate {
    func photoEditViewController(_ photoEditViewController: PhotoEditViewController, didSave image: UIImage, and data: Data) {
        
        
        let photosRef = self.storage.reference().child("images")
        //
        //            // Get a reference to store the file at chat_photos/<FILENAME>
        let filename = ("\(arc4random())")
        //
        let photoRef = photosRef.child("\(filename).png")
        //
        //            // Upload file to Firebase Storage
        let metadata = StorageMetadata()
        metadata.contentType = "image/png"
        
        let smallImageData = UIImage(data:data,scale:1.0)
        
        
        //
        let imageData = UIImageJPEGRepresentation(smallImageData!, 0.1)!
        //
        //
        photoRef.putData(imageData, metadata: metadata).observe(.success) { (snapshot) in
            //
            
            let text = snapshot.metadata?.downloadURL()?.absoluteString
            // Set the download URL to the message box, so that the user can send it to the database
            self.locationImageUrl = text!
            
            
        }
        
        dismiss(animated: true, completion: nil)
     

        
    }
        
    
    
    func photoEditViewControllerDidFailToGeneratePhoto(_ photoEditViewController: PhotoEditViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func photoEditViewControllerDidCancel(_ photoEditViewController: PhotoEditViewController) {
        dismiss(animated: true, completion: nil)
    }
}

extension UIImage {
    func resized(withPercentage percentage: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: size.width * percentage, height: size.height * percentage)
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    func resized(toWidth width: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}




