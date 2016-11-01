//
//  ThirdPartyManager.swift
//  MybilibiliDemo
//
//  Created by 宅总 on 16/10/17.
//  Copyright © 2016年 Zly. All rights reserved.
//

import UIKit

fileprivate struct Define {
//  百度地图
  static let kBaiduMapAppKey = "QBYw0OI0LwB1q3poQRQZiq4drnmOAXWq"
//  友盟
  static let kUMAppKey = "57625aeae0f55a9b8f001175"
//  微信
  static let kWechatAppID = "wx583a9239406dfa5f"
  static let kWechatAppSecret = "d4624c36b6795d1d99dcf0547af5443d"
//  QQ
  static let kQQAppID = "1105476106"
  static let kQQAppKey = "FtXkR3atEHANB4tG"
//  新浪微博
  static let kSinaAppKey = "1576468831"
  static let kSinaAppSecret = "22316f7a15b1733d8761c33f8876ba2b"
}

class ThirdPartyManager: NSObject {

  fileprivate static var _manager: ThirdPartyManager?
  
  class func manager() -> ThirdPartyManager {
    if let _manager = _manager {
      return _manager
    } else {
      _manager = ThirdPartyManager()
      return _manager!
    }
  }
  
  override init() {
    super.init()
  }
  
  func setupThirdPartyConfigurationWithApplication(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) {
    
  }
  
}
