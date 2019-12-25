//
//  AvatarCell.swift
//  PageTitleView
//
//  Created by macbook on 2019/12/25.
//  Copyright © 2019 常用测试demo. All rights reserved.
//

import UIKit

class AvatarCell: UITableViewCell {
    @IBOutlet weak var avatarView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        let avatarImg = UIImage.init(named: "IMG")
        avatarView.image = avatarImg?.af_imageRoundedIntoCircle()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
