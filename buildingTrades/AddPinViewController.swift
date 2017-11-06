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
import MobileCoreServices




class AddPinViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var firstImageView: UIImageView!
 
    
    @IBOutlet weak var locationName: UITextField!
    
    
    
    @IBOutlet weak var myImageView: UIImageView!
    
    
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
    var refNodeLocations: DatabaseReference!
    var storage: Storage!
    var newMedia: Bool?
    let userID = Auth.auth().currentUser!.uid
    
    var lastPoint = CGPoint.zero
    var red: CGFloat = 0.0
    var green: CGFloat = 0.0
    var blue: CGFloat = 0.0
    var brushWidth: CGFloat = 10.0
    var opacity: CGFloat = 1.0
    var swiped = false
    
    
    let picker = UIImagePickerController()
   
    
    
    var items: [NodeLocation] = []
    var pickerData = ["SeattleBT", "opcmia528", "Painters", "test", "Item 5", "Item 6"]
    
    
    var uploadComplete = false
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: 700)
        locationName.delegate = self
        // locationNotes.delegate = self
      //  tagsTextField.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(AddPinViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(AddPinViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        myImageView.clipsToBounds = true
        myImageView.translatesAutoresizingMaskIntoConstraints = false
        
        picker.delegate = self
        
        //FirebaseApp.configure()
        refNodeLocations = Database.database().reference().child("nodeLocations")
        
        storage = Storage.storage()
        
        
        // User's location
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        if #available(iOS 8.0, *) {
            locationManager.requestAlwaysAuthorization()
        } else {
            // Fallback on earlier versions
        }
        locationManager.startUpdatingLocation()
        
        self.tableView.allowsMultipleSelection = true
        
        //generating a new key inside artists node
        //and also getting the generated key
       
        // Get a reference to the location where we'll store our photos
        //  let userID = UserDefaults.standard.value(forKey: "uid") as! String
        //  let usersRef = refNodeLocations.child(byAppendingPath: "users").child(byAppendingPath: userID)
        
        
        
     
      
        
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }
    
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
    
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let mediaType = info[UIImagePickerControllerMediaType] as! NSString
        
        
        
        if mediaType.isEqual(to: kUTTypeImage as String) {
            let image = info[UIImagePickerControllerOriginalImage]
                as! UIImage
            let imageData = UIImageJPEGRepresentation(image, 0.3)!
            
            myImageView.image = image
            
            if (newMedia == true) {
                UIImageWriteToSavedPhotosAlbum(image, self,
                                               #selector(AddPinViewController.image(image:didFinishSavingWithError:contextInfo:)), nil)
            } else if mediaType.isEqual(to: kUTTypeMovie as String) {
                // Code to support video here
            }
            
            
        }
        //myImageView.contentMode = .scaleAspectFit //3
        self.dismiss(animated: true, completion: nil)
        
        
    }
    
    func image(image: UIImage, didFinishSavingWithError error: NSErrorPointer, contextInfo:UnsafeRawPointer) {
        
        if error != nil {
            let alert = UIAlertController(title: "Save Failed",
                                          message: "Failed to save image",
                                          preferredStyle: UIAlertControllerStyle.alert)
            
            let cancelAction = UIAlertAction(title: "OK",
                                             style: .cancel, handler: nil)
            
            alert.addAction(cancelAction)
            self.present(alert, animated: true,
                         completion: nil)
        }
    }
    
    
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.locationName.resignFirstResponder()
        // self.locationNotes.resignFirstResponder()
       // self.tagsTextField.resignFirstResponder()
        return true
    }
    
    
    @IBAction func useCamera(_ sender: Any) {
        
        if UIImagePickerController.isSourceTypeAvailable(
            UIImagePickerControllerSourceType.camera) {
            
            let imagePicker = UIImagePickerController()
            
            imagePicker.delegate = self
            imagePicker.sourceType =
                UIImagePickerControllerSourceType.camera
            imagePicker.mediaTypes = [kUTTypeImage as String]
            imagePicker.allowsEditing = false
            
            self.present(imagePicker, animated: true,
                         completion: nil)
            newMedia = true
        }
    }
    
    func savePhoto(completion: () -> Void){
     
        
        
        
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pickerData.count
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tagsCell", for: indexPath as IndexPath) as! UITableViewCell
        
        let tagHere = pickerData[indexPath.row]
        cell.textLabel?.text = tagHere
 
        return cell
    }
    
    

        
    
    
    

    
    
    
    @IBAction func addLocationTapped(_ sender: Any) {
        
        let key = refNodeLocations.childByAutoId().key
        
        //creating artist with the given values
        let nodeLocation = ["title": locationName.text! as String,
                            "localtag": "test",
                            "LocationLatitude": latitude as Double,
                            "LocationLongitude": longitude as Double,
                            "image": locationImageUrl as! String,
                            "UID": "\(userID)"] as [String : Any]
        
        
        
        
        //adding the artist inside the generated unique key
        refNodeLocations.child(key).setValue(nodeLocation)
   
      
            
            
        

    
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        swiped = false
        if let touch = touches.first {
            lastPoint = touch.location(in: self.view)
        }
    }
    
    func drawLine(from fromPoint: CGPoint, to toPoint: CGPoint) {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, 0)
        
        
        myImageView.image?.draw(in: view.bounds)
        

        let context = UIGraphicsGetCurrentContext()
        
        context?.move(to: fromPoint)
        context?.addLine(to: toPoint)
        
        context?.setLineCap(CGLineCap.round)
        context?.setLineWidth(brushWidth)
        context?.setStrokeColor(red: red, green: green, blue: blue, alpha: 1.0)
        context?.setBlendMode(CGBlendMode.normal)
        context?.strokePath()
        
        myImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        myImageView.alpha = opacity
        UIGraphicsEndImageContext()
        
        
        // Get a reference to the location where we'll store our photos
        let photosRef = storage.reference().child("images")
        
        // Get a reference to store the file at chat_photos/<FILENAME>
        let filename = arc4random()
        let photoRef = photosRef.child("\(filename).png")
        
        // Upload file to Firebase Storage
        let metadata = StorageMetadata()
        metadata.contentType = "image/png"
        let imageData = UIImageJPEGRepresentation(myImageView.image!, 0.3)!
        photoRef.putData(imageData, metadata: metadata).observe(.success) { (snapshot) in
            // When the image has successfully uploaded, we get it's download URL
            // self.imageUpoadingLabel.text = "Upload complete"
            self.uploadComplete = true
            let text = snapshot.metadata?.downloadURL()?.absoluteString
            
            // Set the download URL to the message box, so that the user can send it to the database
            self.locationImageUrl = text!
            
            
            
            
            
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        swiped = true
        if let touch = touches.first {
            let currentPoint = touch.location(in: view)
            drawLine(from: lastPoint, to: currentPoint)
            
            lastPoint = currentPoint
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !swiped {
            // draw a single point
            self.drawLine(from: lastPoint, to: lastPoint)
        }
    }
    
}

