//
//  FeedVideoTableViewCell.swift
//  CoinClash
//
//  Created by Mark Lagae on 6/10/17.
//  Copyright © 2017 Mark Lagae. All rights reserved.
//

import UIKit
import ParseUI
import AVKit
import AVFoundation

class FeedVideoTableViewCell: PFTableViewCell {

    @IBOutlet weak var playView: UIView?
    
    @IBOutlet weak var titleLabel: UILabel?
    @IBOutlet weak var descriptionLabel: UILabel?
    @IBOutlet weak var usernameLabel: UILabel?
    @IBOutlet weak var profileImageView: PFImageView?
    
    var userObject: PFUser?
    var postObject: PFObject?
    
    var player: AVPlayer?
    var playerLayer: AVPlayerLayer?
    
    var shouldPlay = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func initPlayer() {
        let videoUrl = URL(string: (postObject?.object(forKey: "content") as? PFFile)!.url!)
        
        player = AVPlayer(url: videoUrl!)
        
        playerLayer = AVPlayerLayer()
        
        guard player != nil && playerLayer != nil else {
            return
        }
        
        playerLayer?.player = player
        self.playView?.layer.addSublayer(playerLayer!)
        playerLayer?.frame = (playView?.bounds)!
        playerLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
    }
    
    func beginPlay() {
        self.player?.play()
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: self.player?.currentItem, queue: nil, using: { (_) in
            DispatchQueue.main.async {
                self.player?.seek(to: kCMTimeZero)
                self.player?.play()
            }
        })
    }
    
    func endPlay() {
        NotificationCenter.default.removeObserver(self)
        self.player?.pause()
        self.player = nil
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
