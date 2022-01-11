//
//  CommentsViewController.swift
//  CoinClash
//
//  Created by Mark Lagae on 6/10/17.
//  Copyright © 2017 Mark Lagae. All rights reserved.
//

import UIKit
import ParseUI

class CommentsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var commentIdsToLoad: [String]?
    var comments = [PFObject]()
    var post: PFObject?
    
    @IBOutlet weak var commentTextField: UITextField?
    
    @IBOutlet weak var tableView: UITableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        tableView?.rowHeight = UITableViewAutomaticDimension
        tableView?.estimatedRowHeight = 65
        
        
        loadComments()
        
        self.view.backgroundColor = UIColor.init(hex: PFUser.current()?.value(forKey: "interface_color") as! String)
        
        self.commentTextField?.backgroundColor = self.view.backgroundColor?.darker(by: 10)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadComments() {
        let commentQuery = PFQuery(className: "Comment")
        commentQuery.whereKey("objectId", containedIn: commentIdsToLoad!)
        commentQuery.includeKey("poster")
        commentQuery.order(byAscending: "createdAt")
        commentQuery.findObjectsInBackground { (objects, error) in
            if error != nil {
                displayParseErrorWith(title: "Error retrieving comments", error: error!, sender: self)
            } else {
                print("found")
                self.comments = objects!
                DispatchQueue.main.async {
                    self.tableView?.reloadData()
                    if self.comments.count > 0 {
                        self.tableView?.scrollToRow(at: IndexPath.init(row: self.comments.count - 1, section: 0), at: .bottom, animated: true)
                    }
                }
                
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let comment = comments[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath) as! CommentCell
        
        let poster = comment.object(forKey: "poster") as? PFUser
        
        cell.profileImageView?.file = poster?.object(forKey: "profilePic") as? PFFile
        cell.profileImageView?.loadInBackground()
        
        cell.usernameLabel?.text = poster?.username
        
        cell.commentLabel?.text = comment.object(forKey: "text") as? String
        
        return cell
    }
    
    @IBAction func addComment() {
        
        let text = commentTextField?.text
        if text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) == "" {
            return
        }
        
        let comment = PFObject(className: "Comment")
        comment["poster"] = PFUser.current()
        comment["posterId"] = PFUser.current()?.objectId
        comment["text"] = text
        
        SwiftLoader.show(animated: true)
        
        comment.saveInBackground { (success, error) in
            if error != nil {
                SwiftLoader.hide()
                displayParseErrorWith(title: "Error Posting Comment", error: error!, sender: self)
            } else {
                var comments = self.post?.object(forKey: "comments") as! [String]
                comments.append(comment.objectId!)
                self.post?.setObject(comments, forKey: "comments")
                self.post?.saveInBackground(block: { (success, error) in
                    SwiftLoader.hide()
                    self.commentTextField?.text = ""
                    self.commentIdsToLoad?.append(comment.objectId!)
                    DispatchQueue.main.async {
                        self.loadComments()
                    }
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
