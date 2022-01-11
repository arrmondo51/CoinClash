//
//  PhotoPostDetailController.swift
//  CoinClash
//
//  Created by Mark Lagae on 6/6/17.
//  Copyright © 2017 Mark Lagae. All rights reserved.
//

import UIKit
import ParseUI

class PhotoPostDetailController: UIViewController {

    var postObject: PFObject?
    
    @IBOutlet weak var contentView: PFImageView?
    @IBOutlet weak var titleLabel: UILabel?
    @IBOutlet weak var descriptionLabel: UILabel?
    
    @IBOutlet weak var usernameLabel: UILabel?
    @IBOutlet weak var profileImageView: PFImageView?
    
    @IBOutlet weak var likeButton: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        titleLabel?.text = postObject?.object(forKey: "title") as? String
        descriptionLabel?.text = postObject?.object(forKey: "description") as? String
        contentView?.file = postObject?.object(forKey: "content") as? PFFile
        contentView?.loadInBackground()
        
        profileImageView?.file = PFUser.current()?.object(forKey: "profilePic") as? PFFile
        profileImageView?.clipsToBounds = true
        profileImageView?.loadInBackground()
        
        usernameLabel?.text = PFUser.current()?.username
        
        updateLikeButton()
        
        self.view.backgroundColor = UIColor.init(hex: PFUser.current()?.value(forKey: "interface_color") as! String)
    }

    func updateLikeButton() {
        if (PFUser.current()?.object(forKey: "likedPosts") as! [String]).contains((postObject?.objectId)!) {
            // already liked
            
            likeButton?.setImage(#imageLiteral(resourceName: "liked_icon"), for: .normal)
            likeButton?.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18.0)
            
        } else {
            // not liked yet
            likeButton?.setImage(#imageLiteral(resourceName: "not_liked_icon"), for: .normal)
            likeButton?.titleLabel?.font = UIFont.systemFont(ofSize: 18.0)
        }
        
        likeButton?.setTitle(" " + String(describing: postObject!.object(forKey: "likes")!), for: .normal)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func likePressed() {
        
        print(PFUser.current()!.objectId!)
        print(postObject!.objectId!)
        
        if (PFUser.current()?.object(forKey: "likedPosts") as! [String]).contains((postObject?.objectId)!) {
            // unlike
            SwiftLoader.show(animated: true)
            PFCloud.callFunction(inBackground: "unlikePost", withParameters: ["senderId" : PFUser.current()!.objectId!, "postId": postObject!.objectId!, "posterId" : postObject!.object(forKey: "posterId")!], block: { (result, error) in
                
                if (error != nil) {
                    print(error!)
                } else {
                    print("success unliking")
                    PFUser.current()?.fetchInBackground(block: { (_, error) in
                        self.postObject?.fetchInBackground(block: { (_, error) in
                            print(PFUser.current()!.object(forKey: "likedPosts")!)
                            SwiftLoader.hide()
                            self.updateLikeButton()
                            
                        })
                    })
                }
                
            })
        } else {
            // like
            SwiftLoader.show(animated: true)
            PFCloud.callFunction(inBackground: "likePost", withParameters: ["senderId" : PFUser.current()!.objectId!, "postId": postObject!.objectId!, "posterId" : postObject!.object(forKey: "posterId")!], block: { (result, error) in
                
                if (error != nil) {
                    print(error!)
                } else {
                    print("success liking")
                    PFUser.current()?.fetchInBackground(block: { (_, error) in
                        self.postObject?.fetchInBackground(block: { (_, error) in
                            SwiftLoader.hide()
                            print(PFUser.current()!.object(forKey: "likedPosts")!)
                            self.updateLikeButton()
                            
                        })
                    })
                }
            })
        }
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
