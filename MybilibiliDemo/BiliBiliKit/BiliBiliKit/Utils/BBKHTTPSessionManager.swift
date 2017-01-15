//
//  BBKHTTPSessionManager.swift
//  BiliBiliKit
//
//  Created by 宅总 on 16/10/26.
//  Copyright © 2016年 Zly. All rights reserved.
//

import UIKit
import bilibilicore

// 基于AFHTTPSessionManager的单例类 BBKHTTPSessionManager.sharedManager()
// @since 1.0.0
// @author 赵林洋

public enum NetworkStatus: UInt {
  case none
  case towG
  case threeG
  case fourG
  case wifi
}

public class BBKHTTPSessionManager: AFHTTPSessionManager {

  // MARK: - Property
  
  fileprivate static var _sharedManager: BBKHTTPSessionManager?
  
  public class func sharedManager() -> BBKHTTPSessionManager {
    
    if let sharedManager = _sharedManager {
      return sharedManager
    } else {
      _sharedManager = BBKHTTPSessionManager(baseURL: nil, sessionConfiguration: nil)
      return _sharedManager!
    }
  }
  
  override fileprivate init(baseURL url: URL?, sessionConfiguration configuration: URLSessionConfiguration?) {
    super.init(baseURL: url, sessionConfiguration: configuration)
    
    responseSerializer.acceptableContentTypes = Set(arrayLiteral: "application/json", "text/json", "text/javascript", "text/plain", "text/html")
  }
  
  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}

extension BBKHTTPSessionManager {
  
  public class func networkStatus() -> NetworkStatus {
    let subviews = ((UIApplication.shared.value(forKeyPath: "statusBar") as AnyObject).value(forKeyPath: "foregroundView") as! UIView).subviews
    var status = NetworkStatus.none
    for child in subviews {
      if child.isKind(of: NSClassFromString("UIStatusBarDataNetworkItemView")!) {
        let networkType = child.value(forKeyPath: "dataNetworkType") as! Int
        switch networkType {
        case 0:
          status = .none
        case 1:
          status = .towG
        case 2:
          status = .threeG
        case 3:
          status = .fourG
        case 4:
          status = .wifi
        default: break
        }
      }
    }
    return status
  }
  
}
