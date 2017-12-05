//
//  ResourcesViewController.swift
//  buildingTrades
//
//  Created by Allison Mcentire on 11/12/17.
//  Copyright © 2017 Allison Mcentire. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class ResourcesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var valueToPass: String!
    var localTag: String?
    let userID = Auth.auth().currentUser!.uid
    let resourcesRef = Database.database().reference(withPath: "resources")
    let refUser = Database.database().reference().child("users")
    
    var items: [Website] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getUsers()
        
        
      //  let query = resourcesRef.queryOrdered(byChild: "nothing").queryEqual(toValue: localTag!)
        
       
        resourcesRef.observe(.value, with: { snapshot in
            // 2
            var frontpages: [Website] = []
            
            for item in snapshot.children {
                // 4
                let groceryItem = Website(snapshot: item as! DataSnapshot)
                
                
                self.items.append(groceryItem!)
                
            }
            
            
            
            // 5
            
            self.tableView.reloadData()
            
            
        })
        

        // Do any additional setup after loading the view.
    }

    func getUsers() {
        let query = refUser.queryOrdered(byChild: "field_uid").queryEqual(toValue: userID)
        query.observe(.value, with: { snapshot in
            // 2
            var frontpages: [Staff] = []
            
            for item in snapshot.children {
                // 4
                let groceryItem = Staff(snapshot: item as! DataSnapshot)
                
                
                self.localTag = groceryItem?.nothing
                print("Localtag: \(self.localTag!)")
                
            }
            
        })
    }
    

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return items.count
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "resourceCell", for:indexPath)
        var groceryItem = items[indexPath.row]
        
        
        let rawURL = "\(groceryItem.field_document_file)"
        
        cell.textLabel?.text = groceryItem.name
        cell.detailTextLabel?.text = groceryItem.field_document_file
        
        return cell
        
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)!
        
        var groceryItem = items[indexPath.row]
        self.valueToPass = groceryItem.field_document_file
        
        
        // valueToPass = groceryItem.field_document_file
        performSegue(withIdentifier: "ResourceDetailVC", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ResourceDetailVC"{
            if let destination =
                segue.destination as? PDFReadViewController {
                destination.passedValue = valueToPass
            }
        }
    }

}
