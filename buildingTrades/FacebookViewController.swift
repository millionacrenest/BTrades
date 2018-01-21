//
//  FacebookViewController.swift
//  buildingTrades
//
//  Created by Allison Mcentire on 11/12/17.
//  Copyright © 2017 Allison Mcentire. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase


class FacebookViewController: UIViewController {
    
    
   var facebook = UserDefaults.standard.string(forKey: "facebook")
    

    @IBOutlet weak var webView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        let url = NSURL (string: facebook!);
        let request = NSURLRequest(url: url! as URL);
        DispatchQueue.main.async {
            self.webView.loadRequest(request as URLRequest)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    



}
