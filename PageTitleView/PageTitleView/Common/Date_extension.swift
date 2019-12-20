//
//  Date_extension.swift
//  PageTitleView
//
//  Created by macbook on 2019/12/11.
//  Copyright © 2019 常用测试demo. All rights reserved.
//

import UIKit

extension Date{
    // 获取当前时间
    static func getCurrentTimeStamp() -> String{
        let now = NSDate()
//        print(now)
        
        // 创建一个日期格式器
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年MM月dd日 HH:mm:ss" // YYYY-MM-dd HH:mm:ss
//        print("当前日期时间：\(formatter.string(from: now as Date))")
        
        //当前时间的时间戳
        let timeInterval0:TimeInterval = now.timeIntervalSince1970
        let timeStamp = Int(timeInterval0)
        //        print("当前时间的时间戳：\(timeStamp)")
        return "\(timeStamp)"
    }
    
    // 将时间戳转化为日期时间
    static func timeStampToTimeFormatStr(timeStamp:Int) -> String{
        //转换为时间
        let timeInterval:TimeInterval = TimeInterval(timeStamp)
        let date = NSDate(timeIntervalSince1970: timeInterval)
        
        //格式话输出
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年MM月dd日 HH:mm:ss"
//        print("对应的日期时间：\(formatter.string(from: date as Date))")
        let dateStr:String = formatter.string(from: date as Date)
        
        return "\(dateStr)"
    }
}
