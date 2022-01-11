//
//  PlaceholderViewController.swift
//  CoinClash
//
//  Created by Mark Lagae on 6/5/17.
//  Copyright © 2017 Mark Lagae. All rights reserved.
//

import UIKit
import Parse

class PlaceholderViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("viewDidAppear")
        //SwiftLoader.show(animated: true)
        //self.performSegue(withIdentifier: "toSetup", sender: nil)
        if PFUser.current() == nil {
            
            SwiftLoader.hide()
            self.performSegue(withIdentifier: "toSetup", sender: nil) // most likely first time
            
        } else {
            SwiftLoader.hide()
            PFUser.current()?.fetchInBackground(block: { (user, error) in
                SwiftLoader.hide()
                print("fetch completed")
                if user != nil {
                    // show main
                    UINavigationBar.appearance().barTintColor = UIColor.init(hex: PFUser.current()?.value(forKey: "interface_color") as! String)
                    self.performSegue(withIdentifier: "toMain", sender: nil)
                    print("main")
                } else {
                    // show setup
                    self.performSegue(withIdentifier: "toSetup", sender: nil)
                    print("setup")
                }
            })
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
