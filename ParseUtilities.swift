//
//  ParseUtilities.swift
//  CoinClash
//
//  Created by Mark Lagae on 6/5/17.
//  Copyright © 2017 Mark Lagae. All rights reserved.
//

import UIKit

func displayParseErrorWith(title: String, error: Error, sender: UIViewController) {
    
    let alertController = UIAlertController(title: title, message: error.localizedDescription, preferredStyle: .alert)
    let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
    
    alertController.addAction(okAction)
    sender.present(alertController, animated: true, completion: nil)
    
}
