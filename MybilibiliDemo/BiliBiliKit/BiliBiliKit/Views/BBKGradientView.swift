//
//  GradientView.swift
//  LessChat-iOS
//
//  Created by 宅总 on 15/7/31.
//  Copyright (c) 2015年 Frank Lin. All rights reserved.
//

import UIKit

public class BBKGradientView: UIView {
  
  // Only override drawRect: if you perform custom drawing.
  // An empty implementation adversely affects performance during animation.
  override public func draw(_ rect: CGRect) {
    // Drawing code
    let currentContext = UIGraphicsGetCurrentContext()
    
    currentContext!.saveGState()
    
    let colorSpace = CGColorSpaceCreateDeviceRGB()
    
//    let startColor = UIColor(hexRGB: 0x88d1a4)
    let startColor = UIColor(hexString: "#000000")
    let startColorComponents = startColor.cgColor.components
    
//    let middleColor = UIColor(hexRGB: 0x54c0c2)
//    let middleColorComponents = CGColorGetComponents(middleColor.CGColor)
    
//    let endColor = UIColor(hexRGB: 0x349ec6)
    let endColor = UIColor(hexString: "#FFFFFF")
    let endColorComponents = endColor.cgColor.components
    
    let colorComponents =
    [startColorComponents![0],
      startColorComponents![1],
      startColorComponents![2],
      startColorComponents![3],
//            middleColorComponents[0],
//            middleColorComponents[1],
//            middleColorComponents[2],
//            middleColorComponents[3],
      endColorComponents![0],
      endColorComponents![1],
      endColorComponents![2],
      endColorComponents![3]]
    let colorIndices: [CGFloat] = [0.0, 1.0]
    
    let gradient = CGGradient(colorSpace: colorSpace, colorComponents: colorComponents, locations: colorIndices, count: 2)
    
    let startPoint: CGPoint, endPoint: CGPoint
    startPoint = CGPoint(x: frame.size.width / 2, y: frame.size.height)
    endPoint = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2)
    let startLocation: CGGradientDrawingOptions = CGGradientDrawingOptions.drawsBeforeStartLocation
    let endLocation: CGGradientDrawingOptions = CGGradientDrawingOptions.drawsAfterEndLocation
    
    currentContext!.drawLinearGradient(gradient!, start: startPoint, end: endPoint, options: [startLocation, endLocation])
    
    currentContext!.restoreGState()
  }
}
