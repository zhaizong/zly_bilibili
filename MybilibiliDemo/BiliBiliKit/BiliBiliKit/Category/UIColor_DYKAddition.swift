//
//  UIColor_DYKAddition.swift
//  HalfSugar
//
//  Created by 宅总 on 16/5/31.
//  Copyright © 2016年 Crazy. All rights reserved.
//

import UIKit

public extension UIColor {
  
  //MARK: - Hex
  
  public convenience init(hexRGB: Int) {
    self.init(red:CGFloat((hexRGB >> 16) & 0xff) / 255.0,
              green:CGFloat((hexRGB >> 8) & 0xff) / 255.0,
              blue:CGFloat(hexRGB & 0xff) / 255.0,
              alpha: 1.0)
  }
}
