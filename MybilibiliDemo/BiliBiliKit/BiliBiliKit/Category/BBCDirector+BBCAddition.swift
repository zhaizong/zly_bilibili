//
//  BBCDirector+BBCAddition.swift
//  BiliBiliKit
//
//  Created by Crazy on 16/12/3.
//  Copyright © 2016年 Zly. All rights reserved.
//

import bilibilicore

/// 扩展 Core中的 MCDirector 让其可以更好的适用于 iOS 的调用情况

extension BBCDirector {
  
  /**
   重置 MCDirector::DefaultDirector 为 Stranger 状态，用于之后再次注册、登录
   */
  public class func bbk_resetDefaultDirectorAsStranger() {
    
    BBCDirector.resetDefaultDirector(BBCDirector(asStrangerWithConfiguration: ()))
  }
  
}
