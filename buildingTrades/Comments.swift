//
//  Comments.swift
//  buildingTrades
//
//  Created by Allison Mcentire on 8/26/17.
//  Copyright © 2017 Allison Mcentire. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase


struct Comments {
    
    var comment:String!
    var title:String!
    var image:String!
    var body:String!
    var dateCreated:String!
    let key: String
    let ref: DatabaseReference?
    
    
    init(title: String, key: String, comment: String, image: String, body: String, dateCreated: String) {
        self.title = title
        self.key = key
        self.comment = comment
        self.image = image
        self.dateCreated = dateCreated
        self.body = body
        self.ref = nil
    }
    
    
    
    init(snapshot: DataSnapshot) {
        key = snapshot.key
        let snapshotValue = snapshot.value as? [String: AnyObject]
        comment = snapshotValue?["comment"] as? String
        title = snapshotValue?["title"] as? String
        image = snapshotValue?["image"] as? String
        body = snapshotValue?["body"] as? String
        dateCreated = snapshotValue?["date"] as? String
        ref = snapshot.ref
 
    }
    
    func toAnyObject() -> Any {
        return [
            "title": title,
            "body": body,
            "image": image,
            "date_created": dateCreated,
            "comment": comment
            
          
            
        ]
    }


    
    
    
}
