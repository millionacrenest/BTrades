//
//  PDFReadViewController.swift
//  buildingTrades
//
//  Created by Allison Mcentire on 11/12/17.
//  Copyright © 2017 Allison Mcentire. All rights reserved.
//

import UIKit

class PDFReadViewController: UIViewController {
    
    @IBOutlet weak var webView: UIWebView!
    
    var passedValue: String?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        let myGroup = DispatchGroup()
        print("passed: \(passedValue!)")
        myGroup.enter()
        //// Do your task
         let url = URL(string: self.passedValue!)
        
        myGroup.leave() //// When your task completes
        myGroup.notify(queue: DispatchQueue.main) {
            
            ////// do your remaining work
            self.webView.loadRequest(URLRequest(url: url!))
        }
        
        
            
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    

    
   
    
    @IBAction func shareButtonTapped(_ sender: Any) {
        // set up activity view controller
        let textToShare = passedValue as Any
        let activityViewController = UIActivityViewController(activityItems: [textToShare], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook ]
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
    }
    

}
