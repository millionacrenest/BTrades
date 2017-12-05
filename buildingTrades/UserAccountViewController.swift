//
//  UserAccountViewController.swift
//  buildingTrades
//
//  Created by Allison Mcentire on 11/12/17.
//  Copyright © 2017 Allison Mcentire. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class UserAccountViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    let ref = Database.database().reference()
    let userID = Auth.auth().currentUser?.uid
    var childIWantToRemove: String!
    
    var sites: [NodeLocation] = []
    let locationsRef = Database.database().reference().child("nodeLocations")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchSites()
        tableView.delegate = self
        tableView.dataSource = self
        
       
        
        tableView.reloadData()

        // Do any additional setup after loading the view.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath as IndexPath) as! UITableViewCell
        
        let item = sites[indexPath.row]
        cell.textLabel?.text = item.name
        cell.detailTextLabel?.text = item.key
        self.childIWantToRemove = item.key
        
        
        
        return cell
    }
    
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            print("Deleted")
//
//            self.sites.remove(at: indexPath.row)
//            self.tableView.deleteRows(at: [indexPath], with: .automatic)
//            myDeleteFunction(childIWantToRemove: childIWantToRemove)
//        }
//    }
    
//    func myDeleteFunction(childIWantToRemove: String) {
//        
//        locationsRef.child(childIWantToRemove).removeValue { (error, ref) in
//            if error != nil {
//                print("error \(error)")
//            }
//        }
//    }
    
    func fetchSites() {
        
        locationsRef.queryOrdered(byChild: "UID").queryEqual(toValue: userID!).observe(.value, with: { snapshot in
            
            var frontpages: [NodeLocation] = []
            
            for item in snapshot.children {
                let groceryItem = NodeLocation(snapshot: item as! DataSnapshot)
                frontpages.append(groceryItem!)
                
            }
            self.sites = frontpages
            self.tableView.reloadData()
        })
        
        
    }
    

    @IBAction func userAccountButtonTapped(_ sender: Any) {
        UIApplication.shared.openURL(NSURL(string: UIApplicationOpenSettingsURLString)! as URL)
    }
    
    @IBAction func logOutTapped(_ sender: Any) {
        
        
        do{
            try Auth.auth().signOut()
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            let initialViewController = storyboard.instantiateViewController(withIdentifier: "Login")
            
            self.present(initialViewController, animated: false)
        }catch{
            print("Error while signing out!")
        }
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
