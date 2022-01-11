//
//  UIImage+ImageWithText.swift
//  CoinClash
//
//  Created by Mark Lagae on 6/9/17.
//  Copyright © 2017 Mark Lagae. All rights reserved.
//

import UIKit
import Parse

extension UIImage {
    class func image(with text: String, size: CGSize, and color: UIColor) -> UIImage {
        let label = UILabel()
        label.frame.size = size
        label.textColor = UIColor.init(hex: PFUser.current()?.value(forKey: "interface_color") as! String)
        label.text = text
        label.textAlignment = NSTextAlignment.center
        label.backgroundColor = color
        label.layer.cornerRadius = 50.0
        
        //UIGraphicsBeginImageContext(label.frame.size)
        UIGraphicsBeginImageContextWithOptions(label.frame.size, false, UIScreen.main.scale)
        label.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}
