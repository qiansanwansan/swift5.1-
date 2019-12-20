//
//  Common.swift
//  PageTitleView
//
//  Created by macbook on 2019/12/3.
//  Copyright © 2019 常用测试demo. All rights reserved.
//

import UIKit

let kScreenW = UIScreen.main.bounds.size.width
let kScreenH = UIScreen.main.bounds.size.height

let IS_IPHONE_X = (kScreenW >= 375.0)&&(kScreenH >= 812.0) ? true : false
let kStateH:CGFloat = kStateBarHeight()
func kStateBarHeight() -> CGFloat {
    if IS_IPHONE_X == true {
        return 44.0
    }else{
        return 20.0
    }
}

let kNavigationH:CGFloat = 44.0
let kTabBarH:CGFloat = IS_IPHONE_X ? 83.0 : 49.0
let kNavAndStateH:CGFloat = kStateH + kNavigationH

/*
 顶部安全区域远离高度 44
 底部安全区域远离高度 34
 */




