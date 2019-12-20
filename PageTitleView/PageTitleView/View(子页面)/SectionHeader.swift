//
//  SectionHeader.swift
//  PageTitleView
//
//  Created by macbook on 2019/12/12.
//  Copyright © 2019 常用测试demo. All rights reserved.
//

import UIKit

class SectionHeader: UICollectionReusableView {
    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override var layer: CALayer {
        let layer = super.layer
        layer.zPosition = 0 // make the header appear below the collection view scroll bar
        return layer
    }
    
    var recommdendModel:RecommendModel? {
        didSet{
            titleLabel.text = recommdendModel?.tag_name
            imgView.image = UIImage.init(named: recommdendModel?.icon_name ?? "home_header_normal")
            
        }
    }
}
