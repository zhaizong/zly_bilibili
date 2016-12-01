//
//  CGFloat+BBKAddition.swift
//  BiliBiliKit
//
//  Created by Crazy on 16/11/26.
//  Copyright © 2016年 Zly. All rights reserved.
//

import Foundation

extension CGFloat {
  
//  弧度制转为角度制
  public func angleTransRadian() -> CGFloat {
    return (self) / 180.0 * CGFloat(M_PI)
  }
  
}
