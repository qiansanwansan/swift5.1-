//
//  CycleModel.swift
//  PageTitleView
//
//  Created by macbook on 2019/12/9.
//  Copyright © 2019 常用测试demo. All rights reserved.
//

import UIKit
import SwiftyJSON
struct CycleModel {
    var title:String?
    var pic_url:String?
    
    init(jsonData:JSON) {
        title = jsonData["title"].stringValue
        pic_url = jsonData["pic_url"].stringValue
    }
}
