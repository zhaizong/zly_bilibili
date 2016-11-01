//
//  SplashModel.swift
//  MybilibiliDemo
//
//  Created by 宅总 on 16/10/18.
//  Copyright © 2016年 Zly. All rights reserved.
//

import UIKit

class SplashModel: NSObject {

  // MARK: - Property
  
//  启动页的结束时间戳
  var end_time: String!
//  启动页的开始时间戳
  var start_time: String!
//  启动页持续的时间
  var duration: String!
//  启动页图片地址
  var image: String!
//  启动页的出现次数
  var times: String!
  
  var animate: String!
  var skip: String!
  var idStr: String!
  var key: String!
  
  /**
   *  type = 0 (广告(3秒读秒) 带链接参数)
   *  type = 1 无参数活动预告
   */
  var type: String!
  /**
   *  链接参数
   */
  var param: String!
  
  #if false
  fileprivate class func mj_replacedKeyFromPropertyName() -> [String: String] {
  
    return ["idStr": "id"]
  }
  #endif
  
  fileprivate class func modelCustomPropertyMapper() -> [String: String] {
    
    return ["idStr": "id"]
  }
}
