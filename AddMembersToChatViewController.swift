//
//  AddMembersToChatViewController.swift
//  CoinClash
//
//  Created by Mark Lagae on 6/23/17.
//  Copyright © 2017 Mark Lagae. All rights reserved.
//

import UIKit
import ParseUI

class AddMembersToChatViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView?
    
    var users = [PFUser]()
    
    var filteredUsers = [PFUser]()
    
    var selectedUser: PFUser?
    
    var blacklistedIds: [String]?
    
    @IBOutlet weak var searchBar: UISearchBar?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.collectionView?.allowsMultipleSelection = true
        loadInitialUsers()
    }

    func loadInitialUsers() {
        let query = PFUser.query()
        query?.whereKey("objectId", containedIn: PFUser.current()?.object(forKey: "friends") as! [Any])
        query?.order(byAscending: "username")
        query?.whereKey("objectId", notContainedIn: blacklistedIds!)
        SwiftLoader.show(animated: true)
        query?.findObjectsInBackground(block: { (users, error) in
            SwiftLoader.hide()
            
            if error != nil {
                displayParseErrorWith(title: "Error loading friends", error: error!, sender: self)
            } else {
                
                self.users = users as! [PFUser]
                
                self.collectionView?.reloadData()
            }
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if searchBar?.text == "" {
            return users.count
        } else {
            return filteredUsers.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let user: PFUser?
        
        if searchBar?.text == "" {
            user = users[indexPath.row]
        } else {
            user = filteredUsers[indexPath.row]
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "userCell", for: indexPath) as! UserCollectionViewCell
        
        cell.profileImageView?.file = user?.object(forKey: "profilePic") as? PFFile
        cell.profileImageView?.loadInBackground()
        
        cell.usernameLabel?.text = user?.username
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.sectionInset = UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3)
        layout.minimumInteritemSpacing = 03
        layout.minimumLineSpacing = 03
        layout.invalidateLayout()
        
        return CGSize(width: ((self.view.frame.width/4) - 4), height:((self.view.frame.width / 4) - 4));
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let user: PFUser?
        
        if searchBar?.text == "" {
            user = users[indexPath.row]
        } else {
            user = filteredUsers[indexPath.row]
        }
        
        selectedUser = user
        
        self.performSegue(withIdentifier: "unwindToCreate", sender: self)
        
    }
    
    func filterContentFor(text: String) {
        
        filteredUsers = users.filter { user in
            return (user.username?.lowercased().contains(text.lowercased()))!
        }
        collectionView?.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterContentFor(text: searchText)
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
