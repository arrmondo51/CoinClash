//
//  ProfileViewController.swift
//  CoinClash
//
//  Created by Mark Lagae on 6/5/17.
//  Copyright © 2017 Mark Lagae. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class ProfileViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var posts = [PFObject]()
    
    @IBOutlet weak var postsCollectionView: UICollectionView?
    
    @IBOutlet weak var profileImageView: PFImageView?
    
    @IBOutlet weak var usernameLabel: UILabel?
    @IBOutlet weak var bioLabel: UILabel?
    
    @IBOutlet weak var friendsLabel: UILabel?
    @IBOutlet weak var postsLabel: UILabel?
    @IBOutlet weak var coinsLabel: UILabel?
    @IBOutlet weak var levelImageView: UIImageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        profileImageView?.file = PFUser.current()?.value(forKey: "profilePic") as? PFFile
        profileImageView?.loadInBackground()
        
        usernameLabel?.text = PFUser.current()?.username
        bioLabel?.text = PFUser.current()?.value(forKey: "bio") as? String
        
        friendsLabel?.text = String(describing: (PFUser.current()!.object(forKey: "friends") as? [String])!.count)
        // load posts when all posts load
        
        levelImageView?.image = UIImage.image(with: String(describing: PFUser.current()!.object(forKey: "level")!), size: CGSize(width: (levelImageView?.bounds.size.height)!, height: (levelImageView?.bounds.size.height)!), and: UIColor.white)
        levelImageView?.layer.cornerRadius = (levelImageView?.bounds.size.width)! / 2
        levelImageView?.clipsToBounds = true
        
        self.view.backgroundColor = UIColor.init(hex: PFUser.current()?.value(forKey: "interface_color") as! String)
        
        loadPosts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        coinsLabel?.text = String(describing: PFUser.current()!.object(forKey: "coins")!)
    }
    
    func loadPosts() {
        let postQuery = PFQuery(className: "Post")
        postQuery.whereKey("objectId", containedIn: PFUser.current()?.object(forKey: "posts") as! [Any])
        postQuery.order(byDescending: "createdAt")
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
            self.performSegue(withIdentifier: "toPhotoDetail", sender: posts[indexPath.row])
        } else if type == "video" {
            self.performSegue(withIdentifier: "toVideoDetail", sender: posts[indexPath.row])
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.sectionInset = UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3)
        layout.minimumInteritemSpacing = 03
        layout.minimumLineSpacing = 03
        layout.invalidateLayout()
        
        return CGSize(width: ((self.view.frame.width / 4) - 4), height:((self.view.frame.width / 4) - 4));
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "toPhotoDetail" {
            let dest = segue.destination as! PhotoPostDetailController
            dest.postObject = sender as? PFObject
        } else if segue.identifier == "toVideoDetail" {
            let dest = segue.destination as! VideoPostDetailController
            dest.postObject = sender as? PFObject
        }
    }
    
    
}
