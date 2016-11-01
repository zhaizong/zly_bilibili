//
//  BBKUtils.swift
//  BiliBiliKit
//
//  Created by 宅总 on 16/10/26.
//  Copyright © 2016年 Zly. All rights reserved.
//

import UIKit

public class BBKUtils: NSObject {

  public class func get(_ urlString: String, parameters: Any?, downloadProgress: ((_ downloadProgress: Progress) -> Void)?, successBlock: ((_ task: URLSessionDataTask, _ responseObject: Any?) -> Void)?, failureBlock: ((_ task: URLSessionDataTask?, _ error: Error) -> Void)?) {
    
    let mgr = BBKHTTPSessionManager.sharedManager()
    mgr.get(urlString, parameters: parameters, progress: downloadProgress, success: { (task: URLSessionDataTask, responseObject: Any?) in
      if let successBlock = successBlock {
        successBlock(task, responseObject)
      }
    }) { (task: URLSessionDataTask?, error: Error) in
      if let failureBlock = failureBlock {
        failureBlock(task, error)
      }
    }
  }
  
  public class func post(_ urlString: String, parameters: Any?, downloadProgress: ((_ downloadProgress: Progress) -> Void)?, successBlock: ((_ task: URLSessionDataTask, _ responseObject: Any?) -> Void)?, failureBlock: ((_ task: URLSessionDataTask?, _ error: Error) -> Void)?) -> URLSessionDataTask? {
    
    let mgr = BBKHTTPSessionManager.sharedManager()
    let task = mgr.post(urlString, parameters: parameters, progress: downloadProgress, success: { (task: URLSessionDataTask, responseObject: Any?) in
      if let successBlock = successBlock {
        successBlock(task, responseObject)
      }
    }) { (task: URLSessionDataTask?, error: Error) in
      if let failureBlock = failureBlock {
        failureBlock(task, error)
      }
    }
    return task
  }
  
}
