//
//  LikesTableViewCell.swift
//  Paing
//
//  Created by Rohit Singh Dhakad on 03/06/21.
//

import UIKit

class LikesTableViewCell: UITableViewCell {

    @IBOutlet var lblName: UILabel!
    @IBOutlet var imgVwUser: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
