//
//  OtherProfileViewController.swift
//  CoinClash
//
//  Created by Mark Lagae on 6/10/17.
//  Copyright © 2017 Mark Lagae. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class OtherProfileViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    //var userIdToLoad: String?
    
    var userObject: PFUser?
    
    var posts = [PFObject]()
    
    @IBOutlet weak var postsCollectionView: UICollectionView?
    
    @IBOutlet weak var profileImageView: PFImageView?
    
    @IBOutlet weak var usernameLabel: UILabel?
    @IBOutlet weak var bioLabel: UILabel?
    
    @IBOutlet weak var friendsLabel: UILabel?
    @IBOutlet weak var postsLabel: UILabel?
    @IBOutlet weak var coinsLabel: UILabel?
    @IBOutlet weak var levelImageView: UIImageView?
    
    @IBOutlet weak var friendButton: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        profileImageView?.file = userObject?.value(forKey: "profilePic") as? PFFile
        profileImageView?.loadInBackground()
        
        usernameLabel?.text = userObject?.username
        bioLabel?.text = userObject?.value(forKey: "bio") as? String
        
        friendsLabel?.text = String(describing: (userObject!.object(forKey: "friends") as? [String])!.count)
        // load posts when all posts load
        coinsLabel?.text = String(describing: userObject!.object(forKey: "coins")!)
        levelImageView?.image = UIImage.image(with: String(describing: userObject!.object(forKey: "level")!), size: CGSize(width: (levelImageView?.bounds.size.height)!, height: (levelImageView?.bounds.size.height)!), and: UIColor.white)
        levelImageView?.layer.cornerRadius = (levelImageView?.bounds.size.width)! / 2
        levelImageView?.clipsToBounds = true
        
        self.view.backgroundColor = UIColor.init(hex: PFUser.current()?.value(forKey: "interface_color") as! String)
        
        if ((PFUser.current()?.object(forKey: "friends") as? [String])?.contains(self.userObject!.objectId!))! {
            self.friendButton?.setTitle("Unfriend", for: .normal)
        } else {
            self.friendButton?.setTitle("Friend", for: .normal)
        }
        
        loadPosts()
        
        //loadUser()
    }
    
    //    func loadUser() {
    //        let userQuery = PFUser.query()
    //        userQuery?.whereKey("objectId", equalTo: userIdToLoad as Any)
    //        userQuery?.findObjectsInBackground(block: { (objects, error) in
    //            if error != nil {
    //                displayParseErrorWith(title: "Error fetching user", error: error!, sender: self)
    //            } else {
    //                self.userLoaded = objects?[0] as? PFUser
    //                self.loadPosts()
    //                DispatchQueue.main.async {
    //                    self.updateUI()
    //
    //                    self.friendButton?.isEnabled = true
    //                    if ((PFUser.current()?.object(forKey: "friends") as? [String])?.contains(self.userLoaded!.objectId!))! {
    //                        self.friendButton?.setTitle("Unfriend", for: .normal)
    //                    } else {
    //                        self.friendButton?.setTitle("Friend", for: .normal)
    //                    }
    //                }
    //            }
    //        })
    //    }
    
    func updateUI() {
        
    }
    
    func loadPosts() {
        let postQuery = PFQuery(className: "Post")
        postQuery.whereKey("objectId", containedIn: userObject?.object(forKey: "posts") as! [Any])
        postQuery.order(byDescending: "createdAt")
        //postQuery.includeKey("poster")
        postQuery.findObjectsInBackground { (objects, error) in
            if error != nil {
                displayParseErrorWith(title: "Error loading posts", error: error!, sender: self)
            } else {
                self.posts = objects!
                self.postsCollectionView?.reloadData()
                self.postsLabel?.text = String(describing: self.posts.count)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UICollectionView
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "thumbnailPostCell", for: indexPath) as! ThumbnailPostCell
        let post = posts[indexPath.row]
        cell.imageView?.file = post.object(forKey: "thumbnail") as? PFFile
        cell.imageView?.loadInBackground()
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let type = (posts[indexPath.row]).object(forKey: "type") as? String
        if type == "photo" {
            self.performSegue(withIdentifier: "toPhotoDetail", sender: [posts[indexPath.row], userObject as Any])
        } else if type == "video" {
            self.performSegue(withIdentifier: "toVideoDetail", sender: [posts[indexPath.row], userObject as Any])
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.sectionInset = UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3)
        layout.minimumInteritemSpacing = 03
        layout.minimumLineSpacing = 03
        layout.invalidateLayout()
        
        return CGSize(width: ((self.view.frame.width/4) - 4), height:((self.view.frame.width / 4) - 4));
    }
    
    
    @IBAction func friendButtonPressed() {
        
        if ((PFUser.current()?.object(forKey: "friends") as? [String])?.contains(userObject!.objectId!))! {
            friendButton?.setTitle("Friend", for: .normal)
            //            var friends = PFUser.current()?.object(forKey: "friends") as? [String]
            //            friends?.remove(at: (friends?.index(of: userLoaded!.objectId!))!)
            //            PFUser.current()?.setObject(friends as Any, forKey: "friends")
            //            PFUser.current()?.saveInBackground()
            
            //PFCloud.callFunction(inBackground: "removeFriend", withParameters: ["sender" : PFUser.current()!.objectId as Any, "reciever" : userLoaded!.objectId!])
            PFCloud.callFunction(inBackground: "removeFriend", withParameters: ["sender" : PFUser.current()!.objectId as Any, "reciever" : userObject!.objectId!], block: { (_, _) in
                PFUser.current()?.fetchInBackground()
            })
        } else {
            friendButton?.setTitle("Unfriend", for: .normal)
            //            var friends = PFUser.current()?.object(forKey: "friends") as? [String]
            //            friends?.append(userLoaded!.objectId!)
            //            PFUser.current()?.setObject(friends as Any, forKey: "friends")
            //            PFUser.current()?.saveInBackground()
            
            //PFCloud.callFunction(inBackground: "addFriend", withParameters: ["sender" : PFUser.current()!.objectId as Any, "reciever" : userLoaded!.objectId!])
            PFCloud.callFunction(inBackground: "addFriend", withParameters: ["sender" : PFUser.current()!.objectId as Any, "reciever" : userObject!.objectId!], block: { (_, _) in
                PFUser.current()?.fetchInBackground()
            })
        }
        
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "toPhotoDetail" {
            let dest = segue.destination as! OtherPhotoPostDetailController
            dest.postObject = (sender as? [AnyObject])?[0] as? PFObject
            dest.userObject = (sender as? [AnyObject])?[1] as? PFUser
        } else if segue.identifier == "toVideoDetail" {
            let dest = segue.destination as! OtherVideoPostDetailController
            dest.postObject = (sender as? [AnyObject])?[0] as? PFObject
            dest.userObject = (sender as? [AnyObject])?[1] as? PFUser
        }
    }
    
}
