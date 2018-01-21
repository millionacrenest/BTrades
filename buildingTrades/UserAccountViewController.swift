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

class UserAccountViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var localtTagView: UILabel!
   
    
    @IBOutlet weak var nameLabel: UILabel!
    
    
    @IBOutlet weak var websiteLabel: UILabel!
    
    var childIWantToRemove: String!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        localtTagView.text = UserDefaults.standard.string(forKey: "tagLabel")
        nameLabel.text = UserDefaults.standard.string(forKey: "name")
        websiteLabel.text = UserDefaults.standard.string(forKey: "website")
      
        //fetchSites()
        
        var test = UserDefaults.standard.string(forKey: "userID")
        print("test \(test)")
        
      
        
        
       //localtTagView.text = tag
        
//        tableView.delegate = self
//        tableView.dataSource = self
//
//
//
//        tableView.reloadData()

        // Do any additional setup after loading the view.
    }
    
//    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        return 1
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        //return users.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath as IndexPath) as! UITableViewCell
//
//        let item = users[indexPath.row]
//        cell.textLabel?.text = item.name
//        cell.detailTextLabel?.text = item.key
//        self.childIWantToRemove = item.key
//
//
//
//        return cell
//    }
//
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
    

  

}
