//
//  ViewController.swift
//  CoinClash
//
//  Created by Mark Lagae on 6/4/17.
//  Copyright © 2017 Mark Lagae. All rights reserved.
//

import UIKit

class ViewController: UIViewController, SWRevealViewControllerDelegate {

    var fadeView: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let rVC = self.revealViewController()
        if (rVC != nil) {
            
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "menu_icon").withRenderingMode(.alwaysOriginal), style: .plain, target: self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)))
            
            self.revealViewController().rearViewRevealWidth = ((self.view.bounds.size.height - UIApplication.shared.statusBarFrame.size.height) / 7) + 16
            //self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            self.revealViewController().delegate = self
            self.revealViewController().rearViewRevealOverdraw = 0.0
            self.revealViewController().rearViewRevealDisplacement = 0.0
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    /*
    func revealController(_ revealController: SWRevealViewController!, animateTo position: FrontViewPosition) {
        if position == .left {
            self.view.alpha = 1
        } else if position == .right {
            self.view.alpha = 0.75
        }
    }
 */
}

