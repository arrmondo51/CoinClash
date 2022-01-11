//
//  UserSettingsViewController.swift
//  CoinClash
//
//  Created by Mark Lagae on 7/22/17.
//  Copyright © 2017 Mark Lagae. All rights reserved.
//

import UIKit
import ParseUI

class UserSettingsViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    @IBAction func logOutUser() {
        PFUser.logOutInBackground { (error) in
            if error != nil {
                displayParseErrorWith(title: "Error logging out", error: error!, sender: self)
            }
            
            self.performSegue(withIdentifier: "toSetup", sender: self)
        }
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        let dest = segue.destination
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        appDelegate.window?.rootViewController = dest
    }
}
