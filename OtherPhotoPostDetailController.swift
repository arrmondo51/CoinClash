//
//  OtherPhotoPostDetailController.swift
//  CoinClash
//
//  Created by Mark Lagae on 6/10/17.
//  Copyright © 2017 Mark Lagae. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class OtherPhotoPostDetailController: UIViewController {

    var postObject: PFObject?
    var userObject: PFUser?
    
    @IBOutlet weak var contentView: PFImageView?
    @IBOutlet weak var titleLabel: UILabel?
    @IBOutlet weak var descriptionLabel: UILabel?
    
    @IBOutlet weak var usernameLabel: UILabel?
    @IBOutlet weak var profileImageView: PFImageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        titleLabel?.text = postObject?.object(forKey: "title") as? String
        descriptionLabel?.text = postObject?.object(forKey: "description") as? String
        contentView?.file = postObject?.object(forKey: "content") as? PFFile
        contentView?.loadInBackground()
        
        profileImageView?.file = userObject?.object(forKey: "profilePic") as? PFFile
        profileImageView?.loadInBackground()
        
        usernameLabel?.text = userObject?.username
        
        self.view.backgroundColor = UIColor.init(hex: PFUser.current()?.value(forKey: "interface_color") as! String)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
