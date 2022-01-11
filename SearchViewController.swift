//
//  SearchViewController.swift
//  CoinClash
//
//  Created by Mark Lagae on 6/4/17.
//  Copyright © 2017 Mark Lagae. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class SearchViewController: ViewController, UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate, UICollectionViewDelegateFlowLayout {

    var users = [PFObject]()
    
    @IBOutlet weak var searchBar: UISearchBar?
    @IBOutlet weak var collectionView: UICollectionView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let homeImageView = UIImageView(image: #imageLiteral(resourceName: "search_navbar_icon"))
        self.navigationItem.titleView = homeImageView
        
        self.searchBar?.autocapitalizationType = .none
        self.view.backgroundColor = UIColor.init(hex: PFUser.current()?.value(forKey: "interface_color") as! String)
    }

    func loadUsers(query: String) {
        let userQuery = PFUser.query()
        userQuery?.whereKey("username", contains: query)
        userQuery?.whereKey("username", notEqualTo: PFUser.current()!.username! as Any)
        SwiftLoader.show(animated: true)
        userQuery?.findObjectsInBackground(block: { (objects, error) in
            // my code
            SwiftLoader.hide()
            if error != nil {
                displayParseErrorWith(title: "Error getting users", error: error!, sender: self)
            } else {
                print("setting users")
                self.users = objects!
                print(self.users.count)
                DispatchQueue.main.async {
                    self.collectionView?.reloadData()
                }
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
        print("number")
        return users.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "userCell", for: indexPath) as! UserCollectionViewCell
        
        let userObj = users[indexPath.row]
        
        print(userObj.object(forKey: "username") as? String ?? "Username blank")
        cell.usernameLabel?.text = userObj.object(forKey: "username") as? String
        
        cell.profileImageView?.file = userObj.object(forKey: "profilePic") as? PFFile
        cell.profileImageView?.load(inBackground: { (_, _) in
            DispatchQueue.main.async {
                cell.profileImageView?.layer.cornerRadius = (cell.profileImageView?.bounds.size.width)! / 2
                cell.profileImageView?.clipsToBounds = true
            }
        })
        
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
        
        let selectedUser = users[indexPath.row]
        self.performSegue(withIdentifier: "showProfile", sender: selectedUser)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        loadUsers(query: searchBar.text!)
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showProfile" {
            let dest = segue.destination as! OtherProfileViewController
            dest.userObject = sender as? PFUser
        }
    }
    

}
