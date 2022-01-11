//
//  UIImage+Thumbnail.swift
//  CoinClash
//
//  Created by Mark Lagae on 6/6/17.
//  Copyright © 2017 Mark Lagae. All rights reserved.
//

import UIKit

extension UIImage {
    class func imageWith(image: UIImage, scaledToFill size: CGSize) -> UIImage {
        let scale: CGFloat = max(size.width / image.size.width, size.height / image.size.height)
        let width: CGFloat = image.size.width * scale
        let height: CGFloat = image.size.height * scale
        let imageRect = CGRect(x: CGFloat((size.width - width) / 2.0), y: CGFloat((size.height - height) / 2.0), width: width, height: height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        image.draw(in: imageRect)
        let newImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
}
