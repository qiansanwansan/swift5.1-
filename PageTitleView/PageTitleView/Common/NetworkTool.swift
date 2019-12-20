//
//  NetworkTool.swift
//  PageTitleView
//
//  Created by macbook on 2019/12/10.
//  Copyright © 2019 常用测试demo. All rights reserved.
//

import UIKit
import Alamofire

enum MethodType {
    case get
    case post
}

extension Dictionary {
    func disToUrlString() -> String{
        let mutableStr = NSMutableString()
        for (k,v) in self {
            let temp:String = "\(k)=\(v)&"
            mutableStr.append(temp)
        }
        return String(mutableStr.substring(to: mutableStr.length - 1))
    }
}

class NetworkTool {
    class func requestData(type:MethodType,URLString:String,parameters:[String:Any]? = nil,finishedCallBack:@escaping(_ result : AnyObject) -> Void){
        // 获取类型
        let method = type == .get ? HTTPMethod.get : HTTPMethod.post
        
        // 请求头
        var headers:[String:String]?{
            return ["Content-type":"application/json"]
        }
        
        // 发送网络请求
        Alamofire.request(URLString, method: method, parameters: parameters, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
            // 获取结果
            guard let result = response.result.value else{
                print("请求错误\(String(describing: response.result.error))")
                return
            }
            
            if parameters != nil{
//                print(response.result)
            }
            
            // 将结果返回
            finishedCallBack(result as AnyObject)
        }
        
    }
}

private extension String{
    var utf8Encode:Data{
        return data(using: String.Encoding.utf8)!
    }
}
