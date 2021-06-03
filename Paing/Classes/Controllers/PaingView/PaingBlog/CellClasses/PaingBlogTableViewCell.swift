//
//  PaingBlogTableViewCell.swift
//  Paing
//
//  Created by Rohit Singh Dhakad on 26/05/21.
//

import UIKit

class PaingBlogTableViewCell: UITableViewCell {

    @IBOutlet var imgVwUser: UIImageView!
    @IBOutlet var lblUserName: UILabel!
    @IBOutlet var lblAge: UILabel!
    @IBOutlet var lblMessage: UILabel!
    @IBOutlet var vwContainBtnMenu: UIView!
    @IBOutlet var btnMenuDot: UIButton!
    @IBOutlet var btnLike: UIButton!
    @IBOutlet var imgVwLike: UIImageView!
    @IBOutlet var btnComment: UIButton!
    @IBOutlet var lblLikeCount: UILabel!
    @IBOutlet var lblCommentCount: UILabel!
    @IBOutlet var imgVwThreeDot: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }

}
