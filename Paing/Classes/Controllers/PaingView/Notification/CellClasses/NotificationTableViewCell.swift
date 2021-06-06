//
//  NotificationTableViewCell.swift
//  Paing
//
//  Created by Rohit Singh Dhakad on 26/05/21.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {

    @IBOutlet var imgVw: UIImageView!
    @IBOutlet var btnCheckUncheck: UIButton!
    @IBOutlet var imgVwCheckUncheck: UIImageView!
    @IBOutlet var lblMsg: UILabel!
    @IBOutlet var btnOpenProfile: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
