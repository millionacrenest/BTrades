//
//  AddContactsViewController.swift
//  buildingTrades
//
//  Created by Allison Mcentire on 8/28/17.
//  Copyright © 2017 Allison Mcentire. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class AddContactsViewController: UIViewController {
    @IBOutlet weak var contactNameLabel: UITextField!
    
    @IBOutlet weak var contactCompanyLabel: UITextField!
    
    @IBOutlet weak var contactTelephoneLabel: UITextField!
    
    
    @IBOutlet weak var contactAddressLabel: UITextField!
    
     var items: [Contractors] = []
   
    var refContacts = Database.database().reference().child("contacts")

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func saveContactTapped(_ sender: Any) {
        
        
        let key = refContacts.childByAutoId().key
        
        //creating artist with the given values
        let contact = ["field_contact": contactNameLabel.text! as String,
                            "localtag": "test",
                            "field_phone": contactTelephoneLabel.text! as String,
                            "field_address": contactAddressLabel.text! as String,
                            "field_company": contactCompanyLabel.text! as String]
        
        
        
        
        //adding the artist inside the generated unique key
        refContacts.child(key).setValue(contact)
        
        
        
    }
  

}
