
//
//  File.swift
//  buildingTrades
//
//  Created by Allison Mcentire on 6/15/17.
//  Copyright © 2017 Allison Mcentire. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase



struct Staff {
    
    let key: String
    let ref: DatabaseReference?
    let field_full_name: String?
    let field_local_32_member_since: String?
    let field_on_staff_since: String?
    let field_profile_picture: String?
    let field_tags: String?
    let field_type: String?
    let field_email: String?
    let field_uid: String?
    let uid: String?
    let permission: Bool?
    let nothing: String?
    let name: String?
    
    
    
    init(name: String, field_uid: String, field_full_name: String, field_local_32_member_since: String, field_on_staff_since: String, field_profile_picture: String, field_tags: String, field_type: String, uid: String, permission: Bool, field_email: String, key: String = "", nothing: String) {
        self.key = key
        self.name = name
        self.field_full_name = field_full_name
        self.field_local_32_member_since = field_local_32_member_since
        self.field_on_staff_since = field_on_staff_since
        self.field_profile_picture = field_profile_picture
        self.field_tags = field_tags
        self.field_type = field_type
        self.field_email = field_email
        self.uid = uid
        self.field_uid = field_uid
        self.ref = nil
        self.permission = permission
        self.nothing = nothing
    }
    
    init?(snapshot: DataSnapshot) {
        key = snapshot.key
        let snapshotValue = snapshot.value as? [String: AnyObject]
        field_full_name = snapshotValue?["field_full_name"] as? String
        name = snapshotValue?["name"] as? String
        field_local_32_member_since = snapshotValue?["field_local_32_member_since"] as? String
        field_on_staff_since = snapshotValue?["field_on_staff_since"] as? String
        field_profile_picture = snapshotValue?["field_profile_picture"] as? String
        field_tags = snapshotValue?["field_contractor_type"] as? String
        field_type = snapshotValue?["field_type"] as? String
        field_email = snapshotValue?["field_email"] as? String
        field_uid = snapshotValue?["field_uid"] as? String
        uid = snapshotValue?["uid"] as? String
        nothing = snapshotValue?["nothing"] as? String
        permission = snapshotValue?["permission"] as? Bool
        ref = snapshot.ref
    }
    
    func toAnyObject() -> Any {
        return [
            "field_full_name": field_full_name,
            "name": name,
            "field_local_32_member_since": field_local_32_member_since,
            "field_on_staff_since": field_on_staff_since,
            "field_profile_picture": field_profile_picture,
            "field_tags": field_tags,
            "field_type": field_type,
            "field_email": field_email,
            "field_uid": field_uid,
            "uid": uid,
            "permission": permission,
            "nothing": nothing,
            
        ]
    }
    
}


