//
//  CommentAddViewController.swift
//  CoinClash
//
//  Created by Mark Lagae on 6/11/17.
//  Copyright © 2017 Mark Lagae. All rights reserved.
//

import UIKit
import ParseUI

class CommentAddViewController: UIViewController {

    @IBOutlet weak var commentTextView: UITextView?
    
    var post: PFObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addComment() {
        
        
        let text = commentTextView?.text
        
        SwiftLoader.show(title: "Posting comment", animated: true)
        
        let comment = PFObject(className: "Comment")
        comment["text"] = text
        comment["poster"] = PFUser.current()
        comment["posterId"] = PFUser.current()?.objectId
        
        comment.saveInBackground { (success, error) in
            if success {
                
                var comments = self.post?["comments"] as! [String]
                comments.append(comment.objectId!)
                self.post?.setObject(comments, forKey: "comments")
                self.post?.saveInBackground(block: { (success, error) in
                    SwiftLoader.hide()
                    self.dismiss(animated: true) {
                        (self.parent as! CommentsViewController).loadComments()
                    }
                })
                
            } else {
                displayParseErrorWith(title: "Error posting comment", error: error!, sender: self)
            }
            
            self.dismiss(animated: true) {
                print(type(of: self.presentingViewController))
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
