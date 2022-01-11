//
//  CreateChatViewController.swift
//  CoinClash
//
//  Created by Mark Lagae on 6/22/17.
//  Copyright © 2017 Mark Lagae. All rights reserved.
//

import UIKit
import ParseUI

class CreateChatViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var membersCollectionView: UICollectionView?

    var membersToAdd = [PFUser]()
    
    @IBOutlet weak var chatTitleField: UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        membersToAdd.append(PFUser.current()!)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        DispatchQueue.main.async {
            self.membersCollectionView?.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return membersToAdd.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            
            // add icon
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "addUserCell", for: indexPath) as! AddChatAddUserCell
            
            cell.imageView?.image = #imageLiteral(resourceName: "add_user_to_chat_icon")
            
            return cell
            
        } else {
            
            // show users
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "userCell", for: indexPath) as! AddChatUserCell
            let userObj = membersToAdd[indexPath.row - 1]
            
            cell.profileImageView?.file = userObj.object(forKey: "profilePic") as! PFFile?
            cell.profileImageView?.loadInBackground()
            
            cell.usernameLabel?.text = userObj.username
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            self.performSegue(withIdentifier: "addMembers", sender: self)
        }
        
    }
    
    @IBAction func unwindToCreate(sender: UIStoryboardSegue) {
        
        if let senderVC = sender.source as? AddMembersToChatViewController {
            membersToAdd.append(senderVC.selectedUser!)
        }
    }
    
    @IBAction func createChat() {
        
        let chat = PFObject(className: "Chat")
        
        var ids = [String]()
        for user in membersToAdd {
            ids.append(user.objectId!)
        }
        
        chat["members"] = ids
        chat["messages"] = []
        chat["title"] = chatTitleField?.text
        
        SwiftLoader.show(animated: true)
        
        chat.saveInBackground { (success, error) in
            
            SwiftLoader.hide()
            
            if error != nil {
                displayParseErrorWith(title: "Error creating chat", error: error!, sender: self)
            } else {
                
                // perform segue
                self.performSegue(withIdentifier: "unwindToSocial", sender: nil)
            }
            
        }
        
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "addMembers" {
            
            let dest = segue.destination as! AddMembersToChatViewController
            
            var ids = [String]()
            for user in membersToAdd {
                ids.append(user.objectId!)
            }
            
            dest.blacklistedIds = ids
        }
        
    }
    

}
