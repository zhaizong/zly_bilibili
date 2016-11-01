//
//  UIView+HSFrame.swift
//  HalfSugarMainPage
//
//  Created by 宅总 on 16/9/15.
//  Copyright © 2016年 Crazy. All rights reserved.
//

import UIKit

extension UIView {
  
  public func isShowingOnKeyWindow() -> Bool {
    
//    主窗口
    let keyWindow = UIApplication.shared.keyWindow
//    以主窗口左上角为坐标原点, 计算self的矩形框
    let newFrame = keyWindow?.convert(frame, from: superview)
    let winBounds = keyWindow?.bounds
//    主窗口的bounds 和 self的矩形框 是否有重叠
    let intersects = newFrame?.intersects(winBounds!)
    return !isHidden && alpha > 0.01 && window == keyWindow && intersects!
  }
}

extension UIView {
  
  public var st_x: CGFloat {
    get {
      return frame.origin.x
    }
    set {
      var rect = frame
      rect.origin.x = newValue
      frame = rect
    }
  }
  
  public var st_y: CGFloat {
    get {
      return frame.origin.y
    }
    set {
      var rect = frame
      rect.origin.y = newValue
      frame = rect
    }
  }
  
  public var st_width: CGFloat {
    get {
      return frame.size.width
    }
    set {
      var rect = frame
      rect.size.width = newValue
      frame = rect
    }
  }
  
  public var st_height: CGFloat {
    get {
      return frame.size.height
    }
    set {
      var rect = frame
      rect.size.height = newValue
      frame = rect
    }
  }
  
  public var st_centerX: CGFloat {
    get {
      return center.x
    }
    set {
      var center = self.center
      center.x = newValue
      self.center = center
    }
  }
  
  public var st_centerY: CGFloat {
    get {
      return center.y
    }
    set {
      var center = self.center
      center.y = newValue
      self.center = center
    }
  }
		
  public var st_size: CGSize {
    get {
      return frame.size
    }
    set {
      var frame = self.frame
      frame.size = newValue
      self.frame = frame
    }
  }
  
  public var st_top: CGFloat {
    get {
      return frame.origin.y
    }
    set {
      frame = CGRect(origin: CGPoint(x: st_left, y: newValue), size: CGSize(width: st_width, height: st_height))
    }
  }
  
  public var st_bottom: CGFloat {
    get {
      return frame.origin.y + frame.size.height
    }
    set {
      frame = CGRect(origin: CGPoint(x: st_left, y: newValue - st_height), size: CGSize(width: st_width, height: st_height))
    }
  }
  
  public var st_left: CGFloat {
    get {
      return frame.origin.x
    }
    set {
      frame = CGRect(origin: CGPoint(x: newValue, y: st_top), size: CGSize(width: st_width, height: st_height))
    }
  }
  
  public var st_right: CGFloat {
    get {
      return frame.origin.x + frame.size.width
    }
    set {
      frame = CGRect(origin: CGPoint(x: newValue - st_width, y: st_top), size: CGSize(width: st_width, height: st_height))
    }
  }
  
}
