//
//  CycleCell.swift
//  PageTitleView
//
//  Created by macbook on 2019/12/10.
//  Copyright © 2019 常用测试demo. All rights reserved.
//

import UIKit
import Kingfisher
class CycleCell: UICollectionViewCell {

    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    var model:CycleModel?{
        didSet{
            titleLabel.text = model?.title
            imgView.kf.setImage(with: URL.init(string: (model?.pic_url)!))
        }
    }
}
