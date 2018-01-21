//
//  AboutDetailViewController.swift
//  buildingTrades
//
//  Created by Allison Mcentire on 9/3/17.
//  Copyright © 2017 Allison Mcentire. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import SDWebImage

class EventsDetailViewController: UIViewController {
    
    
    @IBOutlet weak var titleLabel: UILabel!
    
    
    @IBOutlet weak var imageView: UIImageView!
    
    
    
    @IBOutlet weak var tagLabel: UILabel!
    
    
    @IBOutlet weak var bodyTextView: UITextView!
    
    
    var localtag = UserDefaults.standard.string(forKey: "localtag")
    
    let aboutRef = Database.database().reference(withPath: "events")
    var passedValue: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        
        aboutRef.child(localtag!).child(passedValue).observeSingleEvent(of: .value, with: {
            (snapshot:DataSnapshot!) in
            
            // Get user value
            let value = snapshot.value as? NSDictionary
            self.titleLabel.text = value?["title"] as? String ?? ""
          //  self.tagLabel.text = value?["field_tag"] as? String ?? ""
            self.bodyTextView.text = value?["field_event"] as? String ?? ""
           // var imageString = value?["field_image"] as? String ?? ""
            
           // self.imageView?.sd_setImage(with: URL(string: imageString), placeholderImage: UIImage(named: "https://cdn.pixabay.com/photo/2017/08/12/00/17/like-2633137_1280.png"))
            
            
            
            
        })
        
        
        
        
    }
    
    
    
}

