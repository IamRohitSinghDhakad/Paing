//
//  BlockListTableViewCell.swift
//  Paing
//
//  Created by Rohit Singh Dhakad on 02/06/21.
//

import UIKit

class BlockListTableViewCell: UITableViewCell {
    
    @IBOutlet var imgVwUser: UIImageView!
    @IBOutlet var lblUsername: UILabel!
    @IBOutlet var lblOtherDetails: UILabel!
    @IBOutlet var btnUnBlock: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
