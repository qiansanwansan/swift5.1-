//
//  PrettyCell.swift
//  PageTitleView
//
//  Created by macbook on 2019/12/12.
//  Copyright © 2019 常用测试demo. All rights reserved.
//

import UIKit

class PrettyCell: UICollectionViewCell {
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var peopleCountLab: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var roomNameLab: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    var roomModel:RoomModel?{
        didSet{
            guard let iconURL = roomModel?.vertical_src else { return }
            self.roomNameLab.text = roomModel?.room_name
            self.imgView.kf.setImage(with: URL.init(string: iconURL))
            self.cityLabel.text = roomModel?.anchor_city
            
            var countStr:String
            let count:Int = roomModel?.online ?? 0
            if count > 10000 {
                countStr = String.init(format: "%.2f", CGFloat(count)/10000) + "w在线"
            } else {
                countStr = "\(count)在线"
            }
            self.peopleCountLab.text = countStr
        }
    }
}
