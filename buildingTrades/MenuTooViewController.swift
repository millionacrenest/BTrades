//
//  MenuTooViewController.swift
//  buildingTrades
//
//  Created by Allison Mcentire on 9/2/17.
//  Copyright © 2017 Allison Mcentire. All rights reserved.
//

import UIKit

class MenuTooViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let links_arr = ["Map", "Videos", "Resources", "Contacts", "Events", "User Account", "Facebook", "Website"]
    
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return links_arr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menu_cell") as! MenuTableViewCell
        cell.label_text.text = links_arr[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Get Cell Label
        let indexPath = tableView.indexPathForSelectedRow!
        let currentCell = tableView.cellForRow(at: indexPath)! as UITableViewCell
        let row = links_arr[indexPath.row]
        
        
        if indexPath.row == 0 {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "Map")
            self.present(vc!, animated: true, completion: nil)
            
        }
        if indexPath.row == 1 {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "Videos")
            self.present(vc!, animated: true, completion: nil)
        }
        if indexPath.row == 2 {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "Resources")
            self.present(vc!, animated: true, completion: nil)
            
        }
        if indexPath.row == 3 {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "Contacts")
            self.present(vc!, animated: true, completion: nil)
            
        }
        if indexPath.row == 4 {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "Events")
            self.present(vc!, animated: true, completion: nil)
        
        }
        
        if indexPath.row == 5 {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "UserTools")
            self.present(vc!, animated: true, completion: nil)
            
        }
        if indexPath.row == 6 {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "Facebook")
            self.present(vc!, animated: true, completion: nil)
            
        }
        if indexPath.row == 7 {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "Website")
            self.present(vc!, animated: true, completion: nil)
            
        }
        
    }
    
    
    
}

