//
//  AppDelegate_BiliAddition.swift
//  HalfSugar
//
//  Created by 宅总 on 16/5/29.
//  Copyright © 2016年 Crazy. All rights reserved.
//

import Foundation

extension AppDelegate {
  
   class func bili_sharedInstance() -> AppDelegate {
    return UIApplication.shared.delegate as! AppDelegate
  }
}
