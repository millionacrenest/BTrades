//
//  CommentPostViewController.swift
//  buildingTrades
//
//  Created by Allison Mcentire on 8/27/17.
//  Copyright © 2017 Allison Mcentire. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import MobileCoreServices

class CommentPostViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var commentImageView: UIImageView!
    
    @IBOutlet weak var commentTitle: UITextField!
    
    @IBOutlet weak var commentBody: UITextField!
    let userID = Auth.auth().currentUser!.uid
    var commentArray: [String] = [String]()
    var userArray: [String] = [String]()
    var ref = Database.database().reference()
    var varToReceive: String!
    var newMedia: Bool!
    var commentImageURL: String!
    var storage: Storage!
    
    
    let picker = UIImagePickerController()
    
    var lastPoint = CGPoint.zero
    var red: CGFloat = 247.0
    var green: CGFloat = 239.0
    var blue: CGFloat = 91.0
    var brushWidth: CGFloat = 10.0
    var opacity: CGFloat = 1.0
    var swiped = false

    override func viewDidLoad() {
        super.viewDidLoad()
        storage = Storage.storage()
        commentTitle.delegate = self
        commentBody.delegate = self
        var commentsRef = Database.database().reference().child("contacts")
        
       
        picker.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(CommentPostViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(CommentPostViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)

        // Do any additional setup after loading the view.
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
                self.commentBody.resignFirstResponder()
                self.commentTitle.resignFirstResponder()
        //        self.locationTagsTextField.resignFirstResponder()
        return true
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let mediaType = info[UIImagePickerControllerMediaType] as! NSString
        
        
        
        if mediaType.isEqual(to: kUTTypeImage as String) {
            let image = info[UIImagePickerControllerOriginalImage]
                as! UIImage
            let imageData = UIImageJPEGRepresentation(image, 0.3)!
            
            self.commentImageView.image = image
            
            if (newMedia == true) {
                UIImageWriteToSavedPhotosAlbum(image, self,
                                               #selector(CommentPostViewController.image(image:didFinishSavingWithError:contextInfo:)), nil)
            } else if mediaType.isEqual(to: kUTTypeMovie as String) {
                // Code to support video here
            }
            
            
        }
        //myImageView.contentMode = .scaleAspectFit //3
        self.dismiss(animated: true, completion: nil)
         savePhoto()
        
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
    

    @IBAction func saveTapped(_ sender: Any) {
        

        let locationsRef = ref.child("nodeLocations")
        
        let thisLocationRef = locationsRef.child(varToReceive)
        
        let thisUserPostRef = thisLocationRef.child("comments")
        let thisCommentPostRef = thisUserPostRef.childByAutoId //create a new post node
        
        let comment = commentTitle.text!
        let body = commentBody.text!
        let image = commentImageURL as String!
        let date = "today"
       
        let newComment = ["comment": comment, "body": body, "image": image, "date": date, "UID": userID] as [String : Any]
        
        
        thisCommentPostRef().setValue(newComment)
        
        
        
        
        
    }
        
    
    @IBAction func cameraButton(_ sender: Any) {
        
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
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        swiped = false
        if let touch = touches.first {
            lastPoint = touch.location(in: self.view)
        }
    }
    
    func drawLine(from fromPoint: CGPoint, to toPoint: CGPoint) {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, 0)
        
        
        self.commentImageView.image?.draw(in: view.bounds)
        
        
        let context = UIGraphicsGetCurrentContext()
        
        context?.move(to: fromPoint)
        context?.addLine(to: toPoint)
        
        context?.setLineCap(CGLineCap.round)
        context?.setLineWidth(brushWidth)
        context?.setStrokeColor(red: red, green: green, blue: blue, alpha: 1.0)
        context?.setBlendMode(CGBlendMode.normal)
        context?.strokePath()
        
        self.commentImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        self.commentImageView.alpha = opacity
        UIGraphicsEndImageContext()
        
    
    }
    
    func savePhoto(){
        // Get a reference to the location where we'll store our photos
        let photosRef = storage.reference().child("images")
        
        // Get a reference to store the file at chat_photos/<FILENAME>
        let filename = arc4random()
        let photoRef = photosRef.child("\(filename).png")
        
        // Upload file to Firebase Storage
        let metadata = StorageMetadata()
        metadata.contentType = "image/png"
        let imageData = UIImageJPEGRepresentation(commentImageView.image!, 0.3)!
        photoRef.putData(imageData, metadata: metadata).observe(.success) { (snapshot) in
            // When the image has successfully uploaded, we get it's download URL
            // self.imageUpoadingLabel.text = "Upload complete"
            
            let text = snapshot.metadata?.downloadURL()?.absoluteString
            
            // Set the download URL to the message box, so that the user can send it to the database
            self.commentImageURL = text!
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
