//
//  SiteDetailViewController.swift
//  ualocal32
//
//  Created by Allison Mcentire on 7/13/17.
//  Copyright © 2017 Allison Mcentire. All rights reserved.
//

import UIKit
import MapKit
import Firebase
import FirebaseDatabase
import MobileCoreServices
import SDWebImage

class SiteDetailViewController: UIViewController, MKMapViewDelegate, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet weak var siteImage: UIImageView!
    @IBOutlet weak var locationNameTextField: UILabel!
   
    @IBOutlet var sharedWithLabel: UILabel!
    
    @IBOutlet weak var locationTags: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    
    @IBOutlet var locationNotesTextView: UITextView!
    
    
    
    let userID = Auth.auth().currentUser!.uid
    var items: [Comments] = []
    var localtag = UserDefaults.standard.string(forKey: "localtag")
    
    
  
    
    
    
    var varToReceive = ""
    var ref = Database.database().reference()
    
    var updatedName = ""
    var commentArray: [String] = [String]()
    var userArray: [String] = [String]()
    var updatedTag = ""
    var updatedLocationImageUrl = ""
    
    let cellIdentifier = "commentCell"
    var storage: Storage!
    var newMedia: Bool?
    var sharedW: String = ""
    
    let picker = UIImagePickerController()
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        //self.deleteSite.isEnabled = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(taskOne(sender:)))
        
        
        
//        locationNameTextField.delegate = self
//        addCommentsTextField.delegate = self
//        locationTagsTextField.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
       
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 250
//        

        
        

        
       
        
        NotificationCenter.default.addObserver(self, selector: #selector(SiteDetailViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(SiteDetailViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        let nodesRef = ref.child("nodeLocations").child(localtag!)
        let queryRef = nodesRef.queryOrderedByKey().queryEqual(toValue: varToReceive)
        let commentRef = ref.child("post-comments").child(varToReceive)
        
        
        storage = Storage.storage()
        
        queryRef.observeSingleEvent(of: .value, with: { (snapshot) in
            
            for snap in snapshot.children {
                guard let nodeSnap = snap as? DataSnapshot else { continue }
                let id = nodeSnap.key
                guard let nodeDict = nodeSnap.value as? [String:AnyObject]  else { continue }
                let name = nodeDict["name"] as? String
                
                
                let tags = nodeDict["localtag"] as? String
                let imageString = nodeDict["image"] as? String
                var sharedW = nodeDict["sharedWith"] as? String
                var notes = nodeDict["locationNotes"] as? String
                
                self.locationNameTextField.text = name
                
                
                    self.locationTags.text = tags
                
                self.sharedWithLabel.text = sharedW
                
                self.locationNotesTextView.text = notes
                
                
                
                
                
                
                if let url = NSURL(string: imageString!) {
                    if let data = NSData(contentsOf: url as URL) {
                        self.siteImage?.image = UIImage(data: data as Data)
                        
                    }
                }
            }
            
        })
        
        
        commentRef.observe(.value, with: { (snapshot) in
            
            
            // 2
            var frontpages: [Comments] = []
            
            for item in snapshot.children {
                // 4
                let groceryItem = Comments(snapshot: item as! DataSnapshot)
                frontpages.append(groceryItem)
            }
            
            
            // 5
            self.items = frontpages
            self.tableView.reloadData()
            
            
            
            
            
            
        })
        
        
        
        
        
        tableView.reloadData()
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
                if userID == "34767029-f38b-4b67-9021-6d3825fce1b9" {
                    print("uid match: \(userID)")
                } else {
                    self.navigationItem.rightBarButtonItem = nil
                    print("no uid match: \(userID)")
        
                }
    }
    
    
    
    
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        self.locationNameTextField.resignFirstResponder()
//        self.addCommentsTextField.resignFirstResponder()
//        self.locationTagsTextField.resignFirstResponder()
        return true
    }
    
    
    
    @IBAction func addCommentsTapped(_ sender: Any) {
        
          performSegue(withIdentifier: "commentDetail", sender: self)
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "commentDetail" {
                if let toViewController = segue.destination as? CommentPostViewController {
                    toViewController.varToReceive = varToReceive
                }
            }
        }
    
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath as IndexPath) as! CommentsTableViewCell
        
        let comment = items[indexPath.row]
        cell.titleLabel?.text = comment.comment
        cell.bodyView?.text = comment.body
        cell.dateCreatedLabel?.text = comment.dateCreated
        
        var commentImage: String? = nil
        commentImage = comment.image
        
       
        
        cell.imageStringView.sd_setImage(with: URL(string: commentImage!), placeholderImage: UIImage(named: "https://cdn.pixabay.com/photo/2017/08/12/00/17/like-2633137_1280.png"))
        
 
        return cell
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
    
    
    
    
    
    @IBAction func photoLibraryButton(_ sender: Any) {
        
        
        
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        picker.modalPresentationStyle = .popover
        present(picker, animated: true, completion: nil)
        
        
        
        
    }
    
    
    
//    
//    @IBAction func saveTapped(_ sender: Any) {
//        self.commentArray.removeAll()
//        
//        updatedName = locationNameTextField.text!
//        
//        updatedTag = locationTagsTextField.text!
//        
//        ref.child("nodeLocations").child(varToReceive).updateChildValues(["locationName":updatedName])
//        
//        
//        
//        ref.child("nodeLocations").child(varToReceive).updateChildValues(["locationTags":updatedTag])
//        ref.child("nodeLocations").child(varToReceive).updateChildValues(["locationPhoto":updatedLocationImageUrl])
//        
//        
//        updateLabel.text = "Saved"
//        
//        
//        let locationsRef = ref.child("nodeLocations")
//        
//        let thisLocationRef = locationsRef.child(varToReceive)
//        
//        let thisUserPostRef = thisLocationRef.child("comments")
//        let thisCommentPostRef = thisUserPostRef.childByAutoId //create a new post node
//        
//        let comment = addCommentsTextField.text!
//        let newComment = ["comment": comment,
//                          "UID": userID] as [String : Any]
//        
//        
//        thisCommentPostRef().setValue(newComment)
//        
//        
//        
//    }
    
   

    
    @objc func taskOne(sender: UIBarButtonItem) {
        
    
        
        print("key: \(varToReceive), localtag: \(localtag), sharedW: \(sharedW)")

        let ref = Database.database().reference().child("nodeLocations")// see above how to fetch the id
        ref.child(varToReceive).removeValue()
        ref.child(localtag!).child(varToReceive).removeValue()
        ref.child(sharedW).child(varToReceive).removeValue()
    }
    
    
    
    
    
}

