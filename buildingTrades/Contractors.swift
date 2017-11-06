//
//  Contractors.swift
//  buildingTrades
//
//  Created by Allison Mcentire on 8/28/17.
//  Copyright © 2017 Allison Mcentire. All rights reserved.
//




import Foundation
import Firebase
import FirebaseDatabase



struct Contractors {
    
    let key: String
    let ref: DatabaseReference?
    let field_address: String?
    let field_city: String?
    let field_company: String?
    let field_contact: String?
    let field_contractor_type: String?
    let field_fax: String?
    let field_phone: String?
    let field_state: String?
    let field_zip: String?
    var comments: [Comments]!
    
    
    init(field_address: String, field_city: String, field_company: String, field_contact: String, field_contractor_type: String, field_fax: String, field_phone: String, field_state: String, field_zip: String, key: String = "",  comments: [Comments]) {
        self.key = key
        self.field_address = field_address
        self.field_city = field_city
        self.field_company = field_company
        self.field_contact = field_contact
        self.field_contractor_type = field_contractor_type
        self.field_fax = field_fax
        self.field_phone = field_phone
        self.field_state = field_state
        self.field_zip = field_zip
        self.ref = nil
        self.comments = comments
        
        
    }
    
    init?(snapshot: DataSnapshot) {
        key = snapshot.key
        let snapshotValue = snapshot.value as? [String: AnyObject]
        field_address = (snapshotValue?["field_address"] as? String)
        field_city = (snapshotValue?["field_city"] as? String)
        field_company = snapshotValue?["field_company"] as? String
        field_contact = snapshotValue?["field_contact"] as? String
        field_contractor_type = snapshotValue?["field_contractor_type"] as? String
        field_fax = snapshotValue?["field_fax"] as? String
        field_phone = snapshotValue?["field_phone"] as? String
        field_state = snapshotValue?["field_state"] as? String
        field_zip = snapshotValue?["field_zip"] as? String
        ref = snapshot.ref
        comments = (snapshotValue?["comments"] as? [DataSnapshot])?.map({ Comments(snapshot: $0) })
    }
    
    func toAnyObject() -> Any {
        return [
            "field_address": field_address,
            "field_city": field_city,
            "field_company": field_company,
            "field_contact": field_contact,
            "field_contractor_type": field_contractor_type,
            "field_fax": field_fax,
            "field_phone": field_phone,
            "field_state": field_state,
            "field_zip": field_zip,
            "comments": comments
            
        ]
    }
    
}

