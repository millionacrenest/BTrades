//
//  VideoPlayerViewController.swift
//  buildingTrades
//
//  Created by Allison Mcentire on 11/13/17.
//  Copyright © 2017 Allison Mcentire. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import YouTubePlayer

class VideoPlayerViewController: UIViewController {
    
    @IBOutlet weak var videoPlayer: YouTubePlayerView!
    var localtag = UserDefaults.standard.string(forKey: "localtag")
    let videoRef = Database.database().reference(withPath: "videos")
    var passedValue: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        videoRef.child(localtag!).child(passedValue!).observeSingleEvent(of: .value, with: {
            (snapshot:DataSnapshot!) in
            
            // Get user value
            let value = snapshot.value as? NSDictionary

            let myVideoURLString = value?["field_media_video_embed_field"] as? String ?? ""
            let myVideoURL = URL(string: myVideoURLString)
            
            self.videoPlayer.loadVideoURL(myVideoURL!)
            
            
           
            
            
        })

        // Do any additional setup after loading the view.
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
