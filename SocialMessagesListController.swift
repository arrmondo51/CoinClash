//
//  SocialMessagesListController.swift
//  CoinClash
//
//  Created by Mark Lagae on 6/22/17.
//  Copyright © 2017 Mark Lagae. All rights reserved.
//

import UIKit
import ParseUI

class SocialMessagesListController: PFQueryTableViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let homeImageView = UIImageView(image: #imageLiteral(resourceName: "social_navbar_icon"))
        self.navigationItem.titleView = homeImageView
        
        let rVC = self.revealViewController()
        if (rVC != nil) {
            
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "menu_icon").withRenderingMode(.alwaysOriginal), style: .plain, target: self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            self.revealViewController().rearViewRevealWidth = ((self.view.bounds.size.height - UIApplication.shared.statusBarFrame.size.height) / 7) + 16
            self.revealViewController().rearViewRevealOverdraw = 0.0
            self.revealViewController().rearViewRevealDisplacement = 0.0
        }
        
        self.pullToRefreshEnabled = true
        self.paginationEnabled = false
        self.objectsPerPage = 25
        
        self.parseClassName = "Chat"
    }

    override func queryForTable() -> PFQuery<PFObject> {
        
        let query = PFQuery(className: "Chat")
        
        if (objects?.count == 0)
        {
            query.cachePolicy = .cacheThenNetwork
        }
        
        query.whereKey("members", contains: PFUser.current()?.objectId)
        query.order(byDescending: "createdAt")
        
        return query
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.loadObjects()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, object: PFObject?) -> PFTableViewCell? {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "chatCell")
        
        if cell == nil {
            cell = PFTableViewCell(style: .default, reuseIdentifier: "chatCell")
        }
        
        cell?.textLabel?.text = object?.object(forKey: "title") as? String
        cell?.accessoryType = .disclosureIndicator
        return cell as! PFTableViewCell?
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // segue to chat
        
    }
    
    @IBAction func unwindToSocialWith(sender: UIStoryboardSegue) {
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
