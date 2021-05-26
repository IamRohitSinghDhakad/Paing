//
//  MessageTableViewCell.swift
//  Paing
//
//  Created by Rohit Singh Dhakad on 25/05/21.
//

import UIKit

class MessageTableViewCell: UITableViewCell {

    @IBOutlet var imgVwUser: UIImageView!
    @IBOutlet var lblUserName: UILabel!
    @IBOutlet var lblMessage: UILabel!
    @IBOutlet var lblTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
