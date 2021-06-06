//
//  FavoriteTableViewCell.swift
//  Paing
//
//  Created by Rohit Singh Dhakad on 05/06/21.
//

import UIKit

class FavoriteTableViewCell: UITableViewCell {
    
    @IBOutlet var imgVwUser: UIImageView!
    @IBOutlet var lblUserName: UILabel!
    @IBOutlet var lblAgeGender: UILabel!
    @IBOutlet var btnDelete: UIButton!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
