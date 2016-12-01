//
//  UIView+BBKAddition.swift
//  BiliBiliKit
//
//  Created by 宅总 on 16/11/2.
//  Copyright © 2016年 Zly. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
  
  public class func viewFromXib() -> Any? {
  
    return Bundle.main.loadNibNamed(NSStringFromClass(self), owner: nil, options: nil)?.last
  }
  
}

extension UIView {
  
  public var layerCornerRadius: CGFloat {
    get {
      return layer.cornerRadius
    }
    set {
      layer.cornerRadius = newValue
      _config()
    }
  }
  
  public var layerBorderWidth: CGFloat {
    get {
      return layer.borderWidth
    }
    set {
      layer.borderWidth = newValue
      _config()
    }
  }
  
  public var layerBorderColor: UIColor? {
    get {
      guard let borderColor = layer.borderColor else { return nil }
      return UIColor(cgColor: borderColor)
    }
    set {
      layer.borderColor = newValue?.cgColor
    }
  }
  
  fileprivate func _config() {
    
    layer.masksToBounds = true
    layer.rasterizationScale = UIScreen.main.scale
    layer.shouldRasterize = true
  }
  
  
  
}
