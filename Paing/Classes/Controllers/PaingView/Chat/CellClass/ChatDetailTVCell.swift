//
//  MyChatRoomTVCell.swift
//  Nubae
//
//  Created by Rohit Singh Dhakad on 05/09/20.
//  Copyright © 2020 Rohit Singh Dhakad. All rights reserved.
//

import UIKit

class ChatDetailTVCell: UITableViewCell {

    @IBOutlet weak var vwOpponent: UIView!
    @IBOutlet weak var vwMyMsg: UIView!
    @IBOutlet weak var lblOpponentMsg: UILabel!
    @IBOutlet weak var lblopponentMsgTime: UILabel!
    @IBOutlet weak var lblMyMsg: UILabel!
    @IBOutlet weak var lblMyMsgTime: UILabel!
    @IBOutlet weak var vwOpponentImage: UIView!
    @IBOutlet weak var vwMyImage: UIView!
    @IBOutlet weak var imgVwopponent: UIImageView!
    @IBOutlet weak var imgVwMySide: UIImageView!
    @IBOutlet weak var lblOpponentImgTime: UILabel!
    @IBOutlet weak var lblMyImageTime: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
      
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }

}
