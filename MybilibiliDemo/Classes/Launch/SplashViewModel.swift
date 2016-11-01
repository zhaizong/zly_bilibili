//
//  SplashViewModel.swift
//  MybilibiliDemo
//
//  Created by 宅总 on 16/10/18.
//  Copyright © 2016年 Zly. All rights reserved.
//

import UIKit

class SplashViewModel: NSObject {

  // MARK: - Property
  
  var model: SplashModel!
  
  override init() {
    super.init()
  }
  
  convenience init(model: SplashModel) {
    self.init()
    self.model = model
  }
  
}

extension SplashViewModel {
  
//  是否符合当前时间戳
  func conformsNowtimestamp() -> Bool {
    
    let timestamp = Date().timeIntervalSince1970
    if (timestamp > Double(model.start_time)!) && (timestamp < Double(model.end_time)!) {
      return true
    }
    return false
  }
  
}
