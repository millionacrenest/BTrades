//
//  WelcomeViewController.swift
//  buildingTrades
//
//  Created by Allison Mcentire on 12/18/17.
//  Copyright © 2017 Allison Mcentire. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class WelcomeViewController: UIViewController {
    
   let userID = UserDefaults.standard.string(forKey: "userID")

    @IBOutlet weak var tagLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        tagLabel.text = userID!
        
        
        
        
        
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchSites() {
        var idRef = Database.database().reference().child("ids").child(userID!)
        idRef.observe(.value, with: { snapshot in
            
            var frontpages: [Staff] = []
            
            for item in snapshot.children {
                let groceryItem = Staff(snapshot: item as! DataSnapshot)
                self.tagLabel.text = (groceryItem?.localtag)!
                UserDefaults.standard.set(groceryItem?.localtag!, forKey: "localtag")
                
                
            }
            
        })
    }
    
    
    @IBAction func loadInfo(_ sender: Any) {
        fetchSites()
        
        
    }
    
  

}
