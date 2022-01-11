//
//  PostVideoViewController.swift
//  CoinClash
//
//  Created by Mark Lagae on 6/8/17.
//  Copyright © 2017 Mark Lagae. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import Parse

class PostVideoViewController: UIViewController {
    
    var videoUrl: URL?
    
    var player: AVPlayer?
    var playerController : AVPlayerViewController?
    
    @IBOutlet weak var imageView: UIImageView?
    @IBOutlet weak var titleField: UITextField?
    @IBOutlet weak var descriptionField: UITextField?
    @IBOutlet weak var playView: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
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
    
    func firstFrameFromMov(at url: URL) -> UIImage {
        let asset = AVAsset(url: url)
        let assetGenerator = AVAssetImageGenerator(asset: asset)
        let imageRef = try! assetGenerator.copyCGImage(at: kCMTimeZero, actualTime: nil)
        //let frame = UIImage(cgImage: imageRef)
        let frame = UIImage(cgImage: imageRef, scale: 1.0, orientation: .right)
        return frame
    }
    
    @IBAction func post() {
        self.view.endEditing(true)
        player?.pause()
        SwiftLoader.show(title: "Posting", animated: true)
        let title = titleField?.text
        let description = descriptionField?.text
        
        let newPost = PFObject(className: "Post")
        newPost["title"] = title
        newPost["description"] = description
        newPost["type"] = "video"
        
        let thumbnail = UIImage.imageWith(image: firstFrameFromMov(at: videoUrl!), scaledToFill: CGSize(width: 64, height: 64))
        let thumbnailData = UIImageJPEGRepresentation(thumbnail, 1.0)
        
        let contentData = NSData(contentsOf: videoUrl!) as Data?
        
        let thumbnailFile = PFFile(data: thumbnailData!)!
        let contentFile = PFFile(data: contentData!, contentType: "video/quicktime")
        
        newPost["thumbnail"] = thumbnailFile
        newPost["content"] = contentFile
        newPost["poster"] = PFUser.current()
        newPost["posterId"] = PFUser.current()?.objectId
        newPost["comments"] = []
        newPost["likes"] = 0
        
        newPost.saveInBackground { (success, error) in
            if error != nil {
                displayParseErrorWith(title: "Error posting video", error: error!, sender: self)
            } else {
                var posts = PFUser.current()?.object(forKey: "posts") as! [String]
                posts.append(newPost.objectId!)
                PFUser.current()?.setObject(posts, forKey: "posts")
                PFUser.current()?.saveInBackground(block: { (success, error) in
                    FileManager.default.clearTmpDirectory()
                    SwiftLoader.hide()
                    self.performSegue(withIdentifier: "unwindToShare", sender: self)
                })
                
            }
        }
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
