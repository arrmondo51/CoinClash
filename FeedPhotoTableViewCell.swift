//
//  FeedPhotoTableViewCell.swift
//  CoinClash
//
//  Created by Mark Lagae on 6/10/17.
//  Copyright © 2017 Mark Lagae. All rights reserved.
//

import UIKit
import ParseUI

class FeedPhotoTableViewCell: PFTableViewCell {

    @IBOutlet weak var postContentView: PFImageView?
    @IBOutlet weak var titleLabel: UILabel?
    @IBOutlet weak var descriptionLabel: UILabel?
    
    @IBOutlet weak var usernameLabel: UILabel?
    @IBOutlet weak var profileImageView: PFImageView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
