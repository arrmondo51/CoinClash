//
//  VideoPostDetailController.swift
//  CoinClash
//
//  Created by Mark Lagae on 6/8/17.
//  Copyright © 2017 Mark Lagae. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import ParseUI

class VideoPostDetailController: UIViewController {
    
    var postObject: PFObject?
    
    @IBOutlet weak var playView: UIView?
    
    @IBOutlet weak var titleLabel: UILabel?
    @IBOutlet weak var descriptionLabel: UILabel?
    @IBOutlet weak var usernameLabel: UILabel?
    @IBOutlet weak var profileImageView: PFImageView?
    
    var player: AVPlayer?
    var playerController : AVPlayerViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel?.text = postObject?.object(forKey: "title") as? String
        descriptionLabel?.text = postObject?.object(forKey: "description") as? String
        usernameLabel?.text = PFUser.current()?.username
        
        profileImageView?.file = PFUser.current()?.object(forKey: "profilePic") as? PFFile
        profileImageView?.loadInBackground()
        
        self.view.backgroundColor = UIColor.init(hex: PFUser.current()?.value(forKey: "interface_color") as! String)
        
        // Do any additional setup after loading the view.
        let videoUrl = URL(string: (postObject?.object(forKey: "content") as? PFFile)!.url!)
        
        player = AVPlayer(url: videoUrl!)
        playerController = AVPlayerViewController()
        
        guard player != nil && playerController != nil else {
            return
        }
        playerController!.showsPlaybackControls = false
        
        playerController!.player = player!
        self.addChildViewController(playerController!)
        self.view.addSubview(playerController!.view)
        playerController!.view.frame = playView!.frame
        playerController?.videoGravity = AVLayerVideoGravityResizeAspectFill
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: self.player?.currentItem, queue: nil, using: { (_) in
            DispatchQueue.main.async {
                self.player?.seek(to: kCMTimeZero)
                self.player?.play()
            }
        })
        playerController?.player?.play()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
        player?.pause()
        player = nil
    }
    
    @IBAction func showComments() {
        
        self.performSegue(withIdentifier: "showComments", sender: self)
        
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showComments" {
            let dest = segue.destination as! CommentsViewController
            dest.commentIdsToLoad = self.postObject?.object(forKey: "comments") as? [String]
            dest.post = self.postObject
        }
        
    }
    
}
