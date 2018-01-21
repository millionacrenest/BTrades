//
//  LoginViewController.swift
//  buildingTrades
//
//  Created by Allison Mcentire on 6/13/17.
//  Copyright © 2017 Allison Mcentire. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth


class LoginViewController: UIViewController, UITextFieldDelegate {
    
    let mySettingsGroup = DispatchGroup()
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    var userID = UserDefaults.standard.string(forKey: "userID")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        Auth.auth().addStateDidChangeListener { auth, user in
            if let user = user {
                // User is signed in.
                
                if Messaging.messaging().fcmToken != nil {
                    Messaging.messaging().subscribe(toTopic: "/topics/\(user.uid)")
                    Messaging.messaging().subscribe(toTopic: "/topics/all")
                    //  Messaging.messaging().subscribe(toTopic: "/topics/\(tag!)")
                    
                    
                    print("topic created did register notification settings")
                }
                
                
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "Menu")
                self.present(vc!, animated: true, completion: nil)
            } else {
                // No user is signed in.
            }
        }
        
        //let tag = UserDefaults.standard.string(forKey: "localtag")
        
       
        
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        NotificationCenter.default.addObserver(self, selector:#selector(LoginViewController.keyboardWillShow), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector:#selector(LoginViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        
        
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
        self.emailTextField.resignFirstResponder()
        self.passwordTextField.resignFirstResponder()
        return true
    }
    
    
    
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        
        
        
        if self.emailTextField.text == "" || self.passwordTextField.text == "" {
            
            //Alert to tell the user that there was an error because they didn't fill anything in the textfields because they didn't fill anything in
            
            let alertController = UIAlertController(title: "Error", message: "Please enter an email and password.", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            self.present(alertController, animated: true, completion: nil)
            
            
        } else {
            
        let myTagGroup = DispatchGroup()
            myTagGroup.enter()
            
            Auth.auth().signIn(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!) { (user, error) in
            
           
                if error == nil {
                    
                    self.fetchSites()
                    let tag = UserDefaults.standard.string(forKey: "localtag")
                    print("You have been tagged: \(tag)")
                    
                    
                    myTagGroup.leave()
                    myTagGroup.notify(queue: DispatchQueue.main) {
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Menu")
                        self.present(vc!, animated: true, completion: nil)
                    }
                    
                    
                } else {
                    
                    //Tells the user that there is an error and then gets firebase to tell them the error
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                    
                    //Go to the HomeViewController if the login is sucessful
                    //                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "SignUp")
                    //                    self.present(vc!, animated: true, completion: nil)
                }
                
                
                
                
                
            }
        }
        
        
        
        
    }
    
    
    
    func fetchSites() {
        let userID = Auth.auth().currentUser!.uid
        print("userID is \(userID)")
        
        let ref = Database.database().reference().child("ids")
        let queryUser = ref.queryOrderedByKey().queryEqual(toValue: userID)
        queryUser.observe(.value, with: { snapshot in
            
            var frontpages: [Staff] = []
            
            for item in snapshot.children {
                let groceryItem = Staff(snapshot: item as! DataSnapshot)
                UserDefaults.standard.set(groceryItem?.localtag!, forKey: "localtag")
               // UserDefaults.standard.set(groceryItem?.tagLabel!, forKey: "tagLabel")
                UserDefaults.standard.set(groceryItem?.facebook!, forKey: "facebook")
                UserDefaults.standard.set(groceryItem?.website!, forKey: "website")
                UserDefaults.standard.set(groceryItem?.name!, forKey: "name")
              //  UserDefaults.standard.set(groceryItem?.tagLabel!, forKey: "tagLabel")
                
            }
            
        })
    }
    
//    var users: [Staff] = []
//
//    var localtag: String!
//    var userID: String!
//
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//
//
//
//        Auth.auth().addStateDidChangeListener { auth, user in
//            if user != nil {
//                let vc = self.storyboard?.instantiateViewController(withIdentifier: "Menu")
//                self.present(vc!, animated: true, completion: nil)
//
//                let uid = user?.uid
//                let userID = Auth.auth().currentUser!.uid
//                print("the uid is \(uid)")
//
//            }
//
//
//            else {
//                //do nothing
//            }
//        }
//
//
//
//
//
//
//        emailTextField.delegate = self
//        passwordTextField.delegate = self
//
//        NotificationCenter.default.addObserver(self, selector:#selector(LoginViewController.keyboardWillShow), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
//        NotificationCenter.default.addObserver(self, selector:#selector(LoginViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
//
//
//
//
//
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
//
//
//
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        self.emailTextField.resignFirstResponder()
//        self.passwordTextField.resignFirstResponder()
//        return true
//    }
//
//
//
//
//    @IBAction func loginButtonTapped(_ sender: Any) {
//
//
//
//        if self.emailTextField.text == "" || self.passwordTextField.text == "" {
//
//            //Alert to tell the user that there was an error because they didn't fill anything in the textfields because they didn't fill anything in
//
//            let alertController = UIAlertController(title: "Error", message: "Please enter an email and password.", preferredStyle: .alert)
//
//            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
//            alertController.addAction(defaultAction)
//
//            self.present(alertController, animated: true, completion: nil)
//
//
//        } else {
//
//            Auth.auth().signIn(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!) { (user, error) in
//
//                if error == nil {
//                    self.userID = user?.uid
//                    //Print into the console if successfully logged in
//                    print("You have successfully logged in")
//
//
//                    //// Do your task
//
//
//
//                        ////// do your remaining work
//                       // self.fetchOrgSettings()
//
//                        if Messaging.messaging().fcmToken != nil {
//
//                            Messaging.messaging().subscribe(toTopic: "/topics/\(self.userID)")
//                            Messaging.messaging().subscribe(toTopic: "/topics/all")
//                          //  Messaging.messaging().subscribe(toTopic: "topics/\(self.localtag)")
//
//                            print("topic created did register notification settings")
//                        }
//                        print("tasks complete")
//                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Menu")
//                        self.present(vc!, animated: true, completion: nil)
//                    }
//
//
//
//                } else {
//
//                    //Tells the user that there is an error and then gets firebase to tell them the error
//                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
//
//                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
//                    alertController.addAction(defaultAction)
//
//                    self.present(alertController, animated: true, completion: nil)
//
//                    //Go to the HomeViewController if the login is sucessful
////                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "SignUp")
////                    self.present(vc!, animated: true, completion: nil)
//                }
//            }
//        }
//
//
//
//
//    }

////
////        func fetchOrgSettings() {
////            let settingsRef = Database.database().reference().child("settings")
////
////            settingsRef.child(self.localtag!).observe(.value, with: { snapshot in
////
////                var frontpages: [Website] = []
////
////                for item in snapshot.children {
////                    let groceryItem = Website(snapshot: item as! DataSnapshot)
////                    frontpages.append(groceryItem!)
////                    var facebook = groceryItem?.field_facebook
////                    var website = groceryItem?.field_web_address
////
////                    UserDefaults.standard.set(facebook, forKey: "facebook")
////                    UserDefaults.standard.set(website, forKey: "website")
////
////                }
////                
////
////            })
////
////
////    }
//    
    
}
