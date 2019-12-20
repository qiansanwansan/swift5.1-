//
//  NormalViewCell.swift
//  PageTitleView
//
//  Created by macbook on 2019/12/10.
//  Copyright © 2019 常用测试demo. All rights reserved.
//

import UIKit
import Kingfisher
class NormalViewCell: UICollectionViewCell {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var roomNameLab: UILabel!
    @IBOutlet weak var nickNameLab: UILabel!
    @IBOutlet weak var perpleCountLab: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    var roomModel:RoomModel?{
        didSet{
            guard let iconURL = roomModel?.vertical_src else {
                return
            }
//            let processor = RoundCornerImageProcessor.init(cornerRadius: 5)
            
            let url = URL(string: iconURL)
            self.imgView.kf.setImage(with: url)
//            self.imgView.kf.setImage(with: url, placeholder: nil, options: [.processor(processor)], progressBlock: nil, completionHandler: nil)
            self.roomNameLab.text = roomModel?.room_name
            self.nickNameLab.text = roomModel?.nickname
            
            var countStr:String
            let count:Int = roomModel?.online ?? 0
            if count > 10000 {
                countStr = String.init(format: "%.2f", CGFloat(count)/10000)
            }else{
                countStr = "\(count)在线"
            }
            
            self.perpleCountLab.text = countStr
        }
    }
    
    
    
}
