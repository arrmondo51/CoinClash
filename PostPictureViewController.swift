//
//  PostPictureViewController.swift
//  CoinClash
//
//  Created by Mark Lagae on 6/7/17.
//  Copyright © 2017 Mark Lagae. All rights reserved.
//

import UIKit
import Parse

class PostPictureViewController: UIViewController {

    var imageToPost: UIImage?
    
    @IBOutlet weak var imageView: UIImageView?
    @IBOutlet weak var titleField: UITextField?
    @IBOutlet weak var descriptionField: UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        imageView?.image = imageToPost
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func post() {
        self.view.endEditing(true)
        SwiftLoader.show(title: "Posting", animated: true)
        let title = titleField?.text
        let description = descriptionField?.text
        
        let newPost = PFObject(className: "Post")
        newPost["title"] = title
        newPost["description"] = description
        newPost["type"] = "photo"
        
        let thumbnail = UIImage.imageWith(image: imageToPost!, scaledToFill: CGSize(width: 64, height: 64))
        let thumbnailData = UIImageJPEGRepresentation(thumbnail, 1.0)
        
        let contentData = UIImageJPEGRepresentation(imageToPost!, 1.0)
        
        let thumbnailFile = PFFile(data: thumbnailData!)
        let contentFile = PFFile(data: contentData!)
        
        newPost["thumbnail"] = thumbnailFile
        newPost["content"] = contentFile
        newPost["poster"] = PFUser.current()
        newPost["posterId"] = PFUser.current()?.objectId
        newPost["comments"] = []
        newPost["likes"] = 0
        
        newPost.saveInBackground { (success, error) in
            if error != nil {
                displayParseErrorWith(title: "Error posting image", error: error!, sender: self)
            } else {
                var posts = PFUser.current()?.object(forKey: "posts") as! [String]
                posts.append(newPost.objectId!)
                PFUser.current()?.setObject(posts, forKey: "posts")
                PFUser.current()?.saveInBackground(block: { (success, error) in
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
