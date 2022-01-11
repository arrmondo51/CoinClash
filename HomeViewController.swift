//
//  HomeViewController.swift
//  CoinClash
//
//  Created by Mark Lagae on 6/4/17.
//  Copyright © 2017 Mark Lagae. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class HomeViewController: ViewController, UITableViewDelegate, UITableViewDataSource {

    var posts = [PFObject]()
    
    @IBOutlet weak var feedTableView: UITableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        feedTableView?.rowHeight = UITableViewAutomaticDimension
        feedTableView?.estimatedRowHeight = 561.0
        
        let homeImageView = UIImageView(image: #imageLiteral(resourceName: "home_navbar_icon"))
        self.navigationItem.titleView = homeImageView
        loadFeed()
    }
    func loadFeed() {
        print("loadFeed")
        let feedQuery = PFQuery(className: "Post")
        feedQuery.whereKey("posterId", containedIn: PFUser.current()?.object(forKey: "friends") as! [Any])
        feedQuery.includeKey("poster")
        feedQuery.order(byDescending: "createdAt")
        feedQuery.findObjectsInBackground { (objects, error) in
            if error != nil {
                displayParseErrorWith(title: "Error getting feed", error: error!, sender: self)
            } else {
                self.posts = objects!
                self.feedTableView?.reloadData()
            }
        }
    }
    
    func loadUsersForPosts() {
        
    }
    
    func goToProfile() {
        self.performSegue(withIdentifier: "toProfile", sender: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = posts[indexPath.row]
        
        let type = post.object(forKey: "type") as? String
        
        let poster = post.object(forKey: "poster") as? PFUser
        
        if type == "photo" {
            
            let photoCell = feedTableView?.dequeueReusableCell(withIdentifier: "photoCell", for: indexPath) as! FeedPhotoTableViewCell
            
            photoCell.usernameLabel?.text = poster?.username
            photoCell.profileImageView?.file = poster?.object(forKey: "profilePic") as? PFFile
            photoCell.profileImageView?.loadInBackground()
            
            photoCell.titleLabel?.text = post.object(forKey: "title") as? String
            photoCell.descriptionLabel?.text = post.object(forKey: "description") as? String
            photoCell.postContentView?.file = post.object(forKey: "content") as? PFFile
            photoCell.postContentView?.loadInBackground()
            
            return photoCell
            
        } else if type == "video" {
            
            let videoCell = feedTableView?.dequeueReusableCell(withIdentifier: "videoCell", for: indexPath) as! FeedVideoTableViewCell
            
            videoCell.usernameLabel?.text = poster?.username
            videoCell.profileImageView?.file = poster?.object(forKey: "profilePic") as? PFFile
            videoCell.profileImageView?.loadInBackground()
            
            videoCell.postObject = post
            videoCell.titleLabel?.text = post.object(forKey: "title") as? String
            videoCell.descriptionLabel?.text = post.object(forKey: "description") as? String
            videoCell.initPlayer()
            videoCell.beginPlay()
            
            return videoCell
        }
        
        return UITableViewCell()
    }
    

    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let post = posts[indexPath.row]
        
        let type = post.object(forKey: "type") as? String
        
        if type == "video" {
            let cell = cell as! FeedVideoTableViewCell
            cell.endPlay()
            
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        for cell in (feedTableView?.visibleCells)! {
            if let videoCell = cell as? FeedVideoTableViewCell {
                videoCell.endPlay()
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
