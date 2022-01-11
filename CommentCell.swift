//
//  CommentCell.swift
//  CoinClash
//
//  Created by Mark Lagae on 6/10/17.
//  Copyright © 2017 Mark Lagae. All rights reserved.
//

import UIKit
import ParseUI

class CommentCell: UITableViewCell {

    @IBOutlet weak var profileImageView: PFImageView?
    @IBOutlet weak var usernameLabel: UILabel?
    @IBOutlet weak var commentLabel: UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
