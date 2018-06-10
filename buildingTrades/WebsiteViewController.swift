//
//  WebsiteViewController.swift
//  buildingTrades
//
//  Created by Allison Mcentire on 11/12/17.
//  Copyright © 2017 Allison Mcentire. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class WebsiteViewController: UIViewController {

    
    var website = "https://www.seattlebuildingtrades.net"
    @IBOutlet weak var webView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
      //  fetchSites()

        let url = NSURL (string: website)
        let request = NSURLRequest(url: url! as URL)
        DispatchQueue.main.async {
        self.webView.loadRequest(request as URLRequest)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

//    func fetchSites() {
//
//        locationsRef.observe(.value, with: { snapshot in
//
//            var frontpages: [Website] = []
//
//            for item in snapshot.children {
//                let groceryItem = Website(snapshot: item as! DataSnapshot)
//                self.urlString = (groceryItem?.field_web_address)!
//
//            }
//
//        })
//    }


}
