//
//  WebsiteViewController.swift
//  buildingTrades
//
//  Created by Allison Mcentire on 11/12/17.
//  Copyright © 2017 Allison Mcentire. All rights reserved.
//

import UIKit

class WebsiteViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()

        let url = NSURL (string: "https://www.seattlebt.info");
        let request = NSURLRequest(url: url! as URL);
        webView.loadRequest(request as URLRequest);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
