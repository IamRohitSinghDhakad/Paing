//
//  CommentLikesTableViewCell.swift
//  Paing
//
//  Created by Rohit Singh Dhakad on 03/06/21.
//

import UIKit

class CommentLikesTableViewCell: UITableViewCell {

    @IBOutlet var imgVwUser: UIImageView!
    @IBOutlet var imgVwTick: UIImageView!
    @IBOutlet var lblMsgComment: UILabel!
    @IBOutlet var btnOnProfile: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
