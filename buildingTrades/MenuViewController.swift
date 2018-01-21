//
//  MenuViewController.swift
//  buildingTrades
//
//  Created by Allison Mcentire on 8/26/17.
//  Copyright © 2017 Allison Mcentire. All rights reserved.
//
//
//

import UIKit
import Firebase
import FirebaseDatabase
import SDWebImage

class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var viewView: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    
    
    @IBOutlet weak var leadingC: NSLayoutConstraint!
    
    @IBOutlet weak var trailingC: NSLayoutConstraint!
    var menu_vc: MenuTooViewController!
    let userID =  UserDefaults.standard.string(forKey: "userID")
    
    let refUser = Database.database().reference().child("ids")
    
    
    var localtag = UserDefaults.standard.string(forKey: "localtag")
    var items: [Website] = []
    var menuIsVisible = false
    
    private var frontpageCellExpanded : Bool = false
    var selectedIndexPath: IndexPath?
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
            ////// do your remaining work
        getItems()
        
        menu_vc = self.storyboard?.instantiateViewController(withIdentifier: "MenuToo") as! MenuTooViewController
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToGesture))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToGesture))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        
        self.view.addGestureRecognizer(swipeRight)
        self.view.addGestureRecognizer(swipeLeft)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 140
        tableView.tableFooterView = UIView()

    }
    
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "frontPageCell", for: indexPath) as!TableViewCell
        
        
        
        let groceryItem = items[indexPath.row]
        let imageString = "\(groceryItem.field_image!)"
        
        
        
        
        var url = URL(string: imageString)
        
        
        
        
        
        cell.captionLabel.text = groceryItem.title
      
        cell.picture.sd_setImage(with: URL(string: imageString), placeholderImage: UIImage(named: "129968.jpg"))
        cell.textBodyView.text = groceryItem.body
        
        return cell
        
        
        
    }
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
//    {
//        return 300.0;//Choose your custom row height
//    }
    
    @IBAction func menuTapped(_ sender: Any) {
        
        if AppDelegate.menu_bool == true {
            showMenu()
        } else {
            closeMenu()
        }
        
        
    }
   
    func close_on_swipe() {
        
        if AppDelegate.menu_bool == true {
            // showMenu()
        } else {
            closeMenu()
        }
        
    }
    
//    func getUsers() {
//
//        refUser.child(userID!).observe(.value, with: { snapshot in
//            // 2
//
//
//            for item in snapshot.children {
//                // 4
//                let groceryItem = Staff(snapshot: item as! DataSnapshot)
//
//
//                var localtag = (groceryItem?.localtag)!
//                var name = groceryItem?.name
//                UserDefaults.standard.set(name, forKey: "name")
//                UserDefaults.standard.set(localtag, forKey: "localtag")
//
//
//            }
//
//        })
//
//    }
    
    func getItems() {
        if localtag == nil {
            localtag = "SeattleBuildingTrades"
        }
        let frontpageRef = Database.database().reference(withPath: "frontpage").child(localtag!)
        frontpageRef.observe(.value, with: { snapshot in
            // 2
            var frontpages: [Website] = []
            
            for item in snapshot.children {
                // 4
                let groceryItem = Website(snapshot: item as! DataSnapshot)
                frontpages.append(groceryItem!)
            }
            
            
            // 5
            self.items = frontpages
            self.tableView.reloadData()
            self.tableView.rowHeight = UITableViewAutomaticDimension
            self.tableView.estimatedRowHeight = 150
            
            
        })
    }
    
    

    
    
    func respondToGesture(gesture: UISwipeGestureRecognizer)
    {
        switch gesture.direction {
        case UISwipeGestureRecognizerDirection.right:
            print("right swipe")
        case UISwipeGestureRecognizerDirection.left:
            print("left swipe")
            close_on_swipe()
        default:
            break
        }
        
        
    }
    func showMenu() {
        UIView.animate(withDuration: 0.3) { () ->Void in
            self.menu_vc.view.frame = CGRect(x: 0, y: 60, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
            self.menu_vc.view.backgroundColor = UIColor.black.withAlphaComponent(0.1)
            self.addChildViewController(self.menu_vc)
            self.view.addSubview(self.menu_vc.view)
            AppDelegate.menu_bool = false
            
        }
        
    }
    
    func closeMenu() {
        UIView.animate(withDuration: 0.3, animations: { () ->Void in
            self.menu_vc.view.frame = CGRect(x: -UIScreen.main.bounds.size.width, y: 60, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        }) { (finished) in
            self.menu_vc.view.removeFromSuperview()
        }
        
        AppDelegate.menu_bool = true
        
    }
    
    
    
    
    
    
}

