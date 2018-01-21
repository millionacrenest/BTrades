//
//  website.swift
//  ualocal32
//
//  Created by Allison Mcentire on 8/22/17.
//  Copyright © 2017 Allison Mcentire. All rights reserved.
//


import Foundation
import Firebase
import FirebaseDatabase



struct Website {
    
    let key: String
    let ref: DatabaseReference?
    let body: String?
    var title: String?
    let field_media_single: String?
    let term_node_tid: String?
    let field_document_file: String?
    let name: String?
    let field_image: String?
    let field_tag: String?
    let field_date_of_event: String?
    let field_telephone_link: String?
    let field_web_address: String?
    let field_webform: String?
    let field_facebook: String?
    
    var comments: [Comments]!
    
    
    init(field_media_single: String, title: String, field_webform: String, field_web_address: String, field_telephone_link: String, field_date_of_event: String, field_tag: String, field_document_file: String, term_node_tid: String, body: String, field_facebook: String, field_image: String, key: String = "", name: String, comments: [Comments]) {
        self.key = key
        self.title = title
        self.body = body
        self.field_image = field_image
        self.term_node_tid = term_node_tid
        self.field_document_file = field_document_file
        self.name = name
        self.ref = nil
        self.field_webform = field_webform
        self.field_web_address = field_web_address
        self.field_telephone_link = field_telephone_link
        self.field_date_of_event = field_date_of_event
        self.field_tag = field_tag
        self.comments = comments
        self.field_media_single = field_media_single
        self.field_facebook = field_facebook
        
        
    }
    
    
    
    init?(snapshot: DataSnapshot) {
        key = snapshot.key
        let snapshotValue = snapshot.value as? [String: AnyObject]
        title = snapshotValue?["title"] as? String
        name = snapshotValue?["name"] as? String
        field_document_file = snapshotValue?["field_document_file"] as? String
        term_node_tid = snapshotValue?["term_node_tid"] as? String
        body = snapshotValue?["body"] as? String
        field_image = snapshotValue?["field_image"] as? String
        ref = snapshot.ref
        field_webform = snapshotValue?["field_webform"] as? String
        field_web_address = snapshotValue?["field_web_address"] as? String
        field_telephone_link = snapshotValue?["field_telephone_link"] as? String
        field_date_of_event = snapshotValue?["field_date_of_event"] as? String
        field_tag = snapshotValue?["field_tag"] as? String
        field_media_single = snapshotValue?["field_media_single"] as? String
        field_facebook = snapshotValue?["field_facebook"] as? String
        comments = (snapshotValue?["comments"] as? [DataSnapshot])?.map({ Comments(snapshot: $0) })
        
        
        
        
        
        
    }
    
    func toAnyObject() -> Any {
        return [
            "title": title,
            "body": body,
            "field_image": field_image,
            "name": name,
            "term_node_tid": term_node_tid,
            "field_document_file": field_document_file,
            "field_tag": field_tag,
            "field_date_of_event": field_date_of_event,
            "field_telephone_link": field_telephone_link,
            "field_web_address": field_web_address,
            "field_webform": field_webform,
            "field_media_single": field_media_single,
            "field_facebook": field_facebook,
            "comments": comments
            
        ]
    }
    
}






