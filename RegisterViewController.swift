//
//  RegisterViewController.swift
//  CoinClash
//
//  Created by Mark Lagae on 6/5/17.
//  Copyright © 2017 Mark Lagae. All rights reserved.
//

import UIKit
import Parse

class RegisterViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var usernameField: UITextField?
    @IBOutlet weak var passwordField: UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func register() {
        
        SwiftLoader.show(animated: true)
        
        let newUser = PFUser()
        newUser.username = usernameField?.text
        newUser.password = passwordField?.text
        
        let picFile = PFFile(data: UIImageJPEGRepresentation(#imageLiteral(resourceName: "profile_placeholder"), 1.0)!)
        
        newUser["profilePic"] = picFile
        newUser["posts"] = []
        newUser["friends"] = []
        newUser["bio"] = " "
        newUser["coins"] = 0
        newUser["level"] = 1
        newUser["likedPosts"] = []
        
        newUser.signUpInBackground { (success, error) in
            
            SwiftLoader.hide()
            
            if error != nil {
                displayParseErrorWith(title: "Registration Error", error: error!, sender: self)
            } else {
                UINavigationBar.appearance().barTintColor = UIColor.init(hex: PFUser.current()?.value(forKey: "interface_color") as! String)
                self.performSegue(withIdentifier: "toMain", sender: nil)
            }
        }
        
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
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
