//
//  Media.swift
//  buildingTrades
//
//  Created by Allison Mcentire on 8/24/17.
//  Copyright © 2017 Allison Mcentire. All rights reserved.
//



import Foundation
import Firebase
import FirebaseDatabase



struct Media {
    
    let key: String
    let ref: DatabaseReference?
    let mid: String?
    var url: String?
    var name: String?
    var field_media_video_embed_field: String?
    
    
    
    init(url: String, mid: String, key: String = "", name: String, field_media_video_embed_field: String) {
        self.key = key
        self.url = url
        self.mid = mid
        self.ref = nil
        self.name = name
        self.field_media_video_embed_field = field_media_video_embed_field
        
        
        
    }
    
    
    
    init?(snapshot: DataSnapshot) {
        key = snapshot.key
        let snapshotValue = snapshot.value as? [String: AnyObject]
        url = snapshotValue?["field_image"] as? String
        mid = snapshotValue?["mid"] as? String
        ref = snapshot.ref
        name = snapshotValue?["name"] as? String
        field_media_video_embed_field = snapshotValue?["field_media_video_embed_field"] as? String
    }
    
    func toAnyObject() -> Any {
        return [
            "url": url,
            "mid": mid,
            "name": name,
            "field_media_video_embed_field": field_media_video_embed_field
            
        ]
    }
    
}

