//
//  HomeFeedViewController.swift
//  CoinClash
//
//  Created by Mark Lagae on 6/19/17.
//  Copyright © 2017 Mark Lagae. All rights reserved.
//

import UIKit
import ParseUI

class HomeFeedViewController: PFQueryTableViewController, SWRevealViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.pullToRefreshEnabled = true
        self.paginationEnabled = false
        self.objectsPerPage = 25
        
        self.parseClassName = "Post"
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 561.0
        
        let rVC = self.revealViewController()
        if (rVC != nil) {
            
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "menu_icon").withRenderingMode(.alwaysOriginal), style: .plain, target: self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)))
            
            self.revealViewController().rearViewRevealWidth = ((self.view.bounds.size.height - UIApplication.shared.statusBarFrame.size.height) / 7) + 16
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            self.revealViewController().delegate = self
            self.revealViewController().rearViewRevealOverdraw = 0.0
            self.revealViewController().rearViewRevealDisplacement = 0.0
        }
        
        self.refreshControl?.tintColor = UIColor.white
        
        let homeImageView = UIImageView(image: #imageLiteral(resourceName: "home_navbar_icon"))
        self.navigationItem.titleView = homeImageView
        
        self.tableView.backgroundColor = UIColor.init(hex: PFUser.current()?.value(forKey: "interface_color") as! String)
    }

    override func queryForTable() -> PFQuery<PFObject> {
        let feedQuery = PFQuery(className: "Post")
        
        if (objects?.count == 0)
        {
            feedQuery.cachePolicy = .cacheThenNetwork
        }
        
        feedQuery.whereKey("posterId", containedIn: PFUser.current()?.object(forKey: "friends") as! [Any])
        feedQuery.includeKey("poster")
        feedQuery.order(byDescending: "createdAt")
        
        return feedQuery
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, object: PFObject?) -> PFTableViewCell? {
        
        let post = object!
        
        let type = post.object(forKey: "type") as? String
        
        let poster = post.object(forKey: "poster") as? PFUser
        
        if type == "photo" {
            
            let photoCell = tableView.dequeueReusableCell(withIdentifier: "photoCell", for: indexPath) as! FeedPhotoTableViewCell
            
            photoCell.postContentView?.image = nil
            
            photoCell.usernameLabel?.text = poster?.username
            photoCell.profileImageView?.file = poster?.object(forKey: "profilePic") as? PFFile
            photoCell.profileImageView?.loadInBackground()
            
            photoCell.titleLabel?.text = post.object(forKey: "title") as? String
            photoCell.descriptionLabel?.text = post.object(forKey: "description") as? String
            photoCell.postContentView?.file = post.object(forKey: "content") as? PFFile
            photoCell.postContentView?.loadInBackground()
            
            photoCell.usernameLabel?.superview?.backgroundColor = self.tableView.backgroundColor?.darker(by: 10)
            
            return photoCell
            
        } else if type == "video" {
            
            let videoCell = tableView.dequeueReusableCell(withIdentifier: "videoCell", for: indexPath) as! FeedVideoTableViewCell
            
            videoCell.player = nil
            
            videoCell.usernameLabel?.text = poster?.username
            videoCell.profileImageView?.file = poster?.object(forKey: "profilePic") as? PFFile
            videoCell.profileImageView?.loadInBackground()
            
            videoCell.postObject = post
            videoCell.titleLabel?.text = post.object(forKey: "title") as? String
            videoCell.descriptionLabel?.text = post.object(forKey: "description") as? String
            videoCell.initPlayer()
            videoCell.beginPlay()
            
            videoCell.usernameLabel?.superview?.backgroundColor = self.tableView.backgroundColor?.darker(by: 10)
            
            return videoCell
        }
        
        return PFTableViewCell()
        
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if let vidCell = cell as? FeedVideoTableViewCell {
            vidCell.player?.pause()
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
