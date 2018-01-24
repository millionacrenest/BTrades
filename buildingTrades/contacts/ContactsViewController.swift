//
//  ContactsViewController.swift
//  buildingTrades
//
//  Created by Allison Mcentire on 8/28/17.
//  Copyright © 2017 Allison Mcentire. All rights reserved.
//

import UIKit
import Firebase

class ContactsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    
    
    let userID = Auth.auth().currentUser!.uid
    var items: [Staff] = []
    var ref = Database.database().reference()
    var localtag = UserDefaults.standard.string(forKey: "localtag")
    let contactsRef = Database.database().reference(withPath: "users")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        contactsRef.child(localtag!).observe(.value, with: { snapshot in
            // 2
            var contractors: [Staff] = []
            
            for item in snapshot.children {
                // 4
                let groceryItem = Staff(snapshot: item as! DataSnapshot)
                contractors.append(groceryItem!)
            }
            
            // 5
            self.items = contractors
            self.tableView.reloadData()
            
        })


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contractorCell", for: indexPath as IndexPath) as! ContractorTableViewCell
        
        let contact = items[indexPath.row]
        cell.nameLabel.text = "\(contact.field_full_name!) | \(contact.nothing!)"
        cell.bodyField.text = "\(contact.name!)"
        var imageProfile = contact.field_profile_picture
        
        let url = URL(string: imageProfile!)
        let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
        cell.profileImageView.image = UIImage(data: data!)
        
        
      
        
        
       
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let contact = items[indexPath.row]
        
    }
    


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
