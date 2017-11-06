

//
//  File.swift
//  ualocal32
//
//  Created by Allison Mcentire on 6/15/17.
//  Copyright © 2017 Allison Mcentire. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase



struct NodeLocation {
    
    let key: String
    let name: String
    let addedByUser: String
    let ref: DatabaseReference?
    let location: String?
    let latitude: String?
    let longitude: String?
    let image: String?
    let category: String?
    let email: String?
    let tag: String?
    var comments: [Comments]!
    
    
    init(name: String, tag: String, email: String, category: String, addedByUser: String, comment: String, location: String, longitude: String, latitude: String, image: String, key: String = "",  comments: [Comments]) {
        self.key = key
        self.name = name
        self.addedByUser = addedByUser
        self.location = location
        self.latitude = latitude
        self.longitude = longitude
        self.image = image
        self.category = category
        self.email = email
        self.ref = nil
        self.tag = tag
        self.comments = comments
        
        
    }
    
    init?(snapshot: DataSnapshot) {
        key = snapshot.key
        let snapshotValue = snapshot.value as? [String: AnyObject]
        name = (snapshotValue?["name"] as? String)!
        addedByUser = (snapshotValue?["addedByUser"] as? String)!
        location = snapshotValue?["Location"] as? String
        latitude = snapshotValue?["LocationLatitude"] as? String
        longitude = snapshotValue?["LocationLongitude"] as? String
        image = snapshotValue?["image"] as? String
        category = snapshotValue?["category"] as? String
        email = snapshotValue?["email"] as? String
        tag = snapshotValue?["localtag"] as? String
        ref = snapshot.ref
        comments = (snapshotValue?["comments"] as? [DataSnapshot])?.map({ Comments(snapshot: $0) })
    }
    
    func toAnyObject() -> Any {
        return [
            "name": name,
            "addedByUser": addedByUser,
            "location": location,
            "latitude": latitude,
            "longitude": longitude,
            "image": image,
            "category": category,
            "email": email,
            "tag": tag,
            "comments": comments
            
        ]
    }
    
}

