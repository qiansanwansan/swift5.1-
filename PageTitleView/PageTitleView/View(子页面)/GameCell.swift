//
//  GameCell.swift
//  PageTitleView
//
//  Created by macbook on 2019/12/12.
//  Copyright © 2019 常用测试demo. All rights reserved.
//

import UIKit

class GameCell: UICollectionViewCell {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var titleLab: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    var model:RoomModel = RoomModel() {
        didSet{
            imgView.kf.setImage(with: URL.init(string: model.icon_url!))
            titleLab.text = model.tag_name
//            titleLab.backgroundColor = .red
        }
    }
}
