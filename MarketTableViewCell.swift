//
//  MarketTableViewCell.swift
//  CoinClash
//
//  Created by Mark Lagae on 7/19/17.
//  Copyright © 2017 Mark Lagae. All rights reserved.
//

import UIKit
import Parse

class MarketTableViewCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView?
    
    var collectionViewData = [(String, String)]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionViewData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let (imageName, title) = collectionViewData[indexPath.row]
        
        let image = UIImage(named: imageName)
        
        let cell = self.collectionView?.dequeueReusableCell(withReuseIdentifier: "marketCollCell", for: indexPath) as! MarketCollectionViewCell
        
        cell.imageView?.image = image
        cell.titleLabel?.text = title
        
        //cell.backgroundColor = UIColor.init(hex: PFUser.current()?.value(forKey: "interface_color") as! String)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        let cell = cell as! MarketCollectionViewCell
        
        cell.imageView?.layer.cornerRadius = (cell.imageView?.bounds.size.width)! / 2
        cell.imageView?.layer.borderColor = UIColor.white.cgColor
        cell.imageView?.layer.borderWidth = 5
        cell.imageView?.clipsToBounds = true
        
        cell.setNeedsLayout()
        cell.setNeedsDisplay()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: self.bounds.size.height, height: self.bounds.size.height)
        
    }

}
