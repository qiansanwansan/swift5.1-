//
//  ViewModel.swift
//  PageTitleView
//
//  Created by macbook on 2019/12/10.
//  Copyright © 2019 常用测试demo. All rights reserved.
//

import UIKit

import SwiftyJSON

class ViewModel {
   
    lazy var recommondArray = [RecommendModel]()
    private lazy var prettyGroup = RecommendModel()
    private lazy var bigDataGroup = RecommendModel()
    
    lazy var cycleArray = [CycleModel]()
    lazy var gameArray = [RoomModel]()
}

extension ViewModel{
    func requestData(callBack:@escaping () -> Void) {
        let disPatchGroup = DispatchGroup()
        
        // 推荐数据
        disPatchGroup.enter()
        NetworkTool.requestData(type: MethodType.get, URLString: "http://capi.douyucdn.cn/api/v1/getbigDataRoom", parameters: ["time":Date.getCurrentTimeStamp()]){(result) in
            let json = JSON(result)
            let data = json["data"].arrayValue
            
            for dic in data{
                let model = RoomModel.init(jsonData: dic)
                self.bigDataGroup.room_list.append(model)
            }
            self.bigDataGroup.tag_name = "热门"
            self.bigDataGroup.icon_name = "home_header_hot"
            
            disPatchGroup.leave()
        }
        
        // 颜值数据
        disPatchGroup.enter()
        let parameters:[String:Any] = ["limit":"4","offset":"0","time":Date.getCurrentTimeStamp()]
        NetworkTool.requestData(type: .get, URLString: "http://capi.douyucdn.cn/api/v1/getVerticalRoom", parameters: parameters) { (result) in
            let json = JSON(result)
            let data = json["data"].arrayValue
            for room in data{
                self.prettyGroup.room_list.append(RoomModel.init(jsonData: room))
            }
            self.prettyGroup.tag_name = "颜值"
            self.prettyGroup.icon_name = "home_header_phone"
            
            disPatchGroup.leave()
        }

        // 游戏
        disPatchGroup.enter()
        NetworkTool.requestData(type: .get, URLString: "http://capi.douyucdn.cn/api/v1/getHotCate", parameters: parameters) { (result) in
            let json = JSON(result)
            let data = json["data"].arrayValue
            for dict in data {
                let recommendModel = RecommendModel.init(jsonData: dict)
                self.recommondArray.append(recommendModel)
            }
            disPatchGroup.leave()
        }
        
        disPatchGroup.notify(queue: DispatchQueue.main) {
            self.recommondArray.insert(self.prettyGroup, at: 0)
            self.recommondArray.insert(self.bigDataGroup, at: 0)
            callBack()
        }
    }

    func requestCycleData(callBack:@escaping () -> Void){
        NetworkTool.requestData(type: .get, URLString: "http://www.douyutv.com/api/v1/slide/6", parameters: ["version" : "2.300"]) { (result) in
            let json = JSON(result)
            let data = json["data"].arrayValue
            for item in data{
                let model:CycleModel = CycleModel.init(jsonData: item)
                self.cycleArray.append(model)
            }
            
            callBack()
        }
    }
    func requestGameData(callBack:@escaping () -> Void){
        NetworkTool.requestData(type: .get, URLString: "http://capi.douyucdn.cn/api/v1/getColumnDetail") { (result) in
            let json = JSON(result)
            let data = json["data"].arrayValue
            for item in data {
                self.gameArray.append(RoomModel.init(jsonData: item))
            }
            callBack()
        }
        
    }
}
