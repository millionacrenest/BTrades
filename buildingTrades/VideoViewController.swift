//
//  PoliticalViewController.swift
//  buildingtrades
//
//  Created by Allison Mcentire on 8/25/17.
//  Copyright © 2017 Allison Mcentire. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class VideoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var items: [Media] = []
    
    var valueToPass:String!
    var localtag = UserDefaults.standard.string(forKey: "localtag")
    
    
    let videoRef = Database.database().reference(withPath: "videos")
    var selectedTask: Media?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getData()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "videoCell", for:indexPath)
        
        var groceryItem = items[indexPath.row]
        
        cell.textLabel?.text = groceryItem.name
        
        
        
        //        cell.tagLabel?.text = groceryItem.field_tag
        //        cell.imageURLStringLabel?.text = groceryItem.field_image
        //        cell.bodyStringLabel?.text = groceryItem.body
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var groceryItem = items[indexPath.row]
        // Get Cell Label
        let indexPath = tableView.indexPathForSelectedRow!
        let currentCell = tableView.cellForRow(at: indexPath)! as UITableViewCell
        
        valueToPass = groceryItem.key
        performSegue(withIdentifier: "politicalSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "politicalSegue") {
            // initialize new view controller and cast it as your view controller
            var viewController = segue.destination as! VideoPlayerViewController
            // your new view controller should have property that will store passed value
            viewController.passedValue = valueToPass
        }
    }
    
    
    
    
    
    
    func getData() {
        videoRef.child(localtag!).observe(.value, with: { snapshot in
            // 2
            var frontpages: [Media] = []
            
            for item in snapshot.children {
                // 4
                let groceryItem = Media(snapshot: item as! DataSnapshot)
                frontpages.append(groceryItem!)
            }
            
            
            // 5
            self.items = frontpages
            self.tableView.reloadData()
            
            
            
        })
        
    }
    
    
    
    
    
    
    
}

