//
//  BBKHTTPSessionManager.swift
//  BiliBiliKit
//
//  Created by 宅总 on 16/10/26.
//  Copyright © 2016年 Zly. All rights reserved.
//

import UIKit

// 基于AFHTTPSessionManager的单例类 BBKHTTPSessionManager.sharedManager()
// @since 1.0.0
// @author 赵林洋
public class BBKHTTPSessionManager: AFHTTPSessionManager {

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
