//
//  WelcomeViewController.swift
//  buildingTrades
//
//  Created by Allison Mcentire on 6/20/17.
//  Copyright © 2017 Allison Mcentire. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth


class WelcomeViewController: UIViewController {
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        Auth.auth().addStateDidChangeListener { auth, user in
            if user != nil {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "Menu")
                self.present(vc!, animated: true, completion: nil)
                
                let uid = user?.uid
                print("the uid is \(uid)")
                
                
                let userID = Auth.auth().currentUser!.uid
                if Messaging.messaging().fcmToken != nil {
                    Messaging.messaging().subscribe(toTopic: "/topics/\(userID)")
                    Messaging.messaging().subscribe(toTopic: "/topics/all")
                    
                    print("topic created did register notification settings")
                }
            }
                
                
            else {
                // No User is signed in. Show user the login screen
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "Login")
                self.present(vc!, animated: true, completion: nil)
            }
        }
        
        
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

