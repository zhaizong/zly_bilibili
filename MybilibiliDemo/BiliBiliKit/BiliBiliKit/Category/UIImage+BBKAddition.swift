//
//  UIImage+BBKAddition.swift
//  BiliBiliKit
//
//  Created by 宅总 on 16/10/27.
//  Copyright © 2016年 Zly. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
  
  /**
   *  将方图片转换成圆图片
   */
  public class func circleImageWithOldImage(_ oldImage: UIImage, borderWidth: CGFloat, borderColor: UIColor) -> UIImage {
    
//    开启上下文
    let border = borderWidth
    let imageWidth = oldImage.size.width + 2 * border
    let imageHeight = oldImage.size.height + 2 * border
    let imageSize = CGSize(width: imageWidth, height: imageHeight)
    
    UIGraphicsBeginImageContextWithOptions(imageSize, false, 0)
//    获取当前上下文
    let ctx = UIGraphicsGetCurrentContext()
//    画边框(大圆)
    borderColor.set()
    let bigRadius = imageWidth * 0.5
    let centerX = bigRadius
    let centerY = bigRadius
    ctx?.addArc(center: CGPoint(x: centerX, y: centerY), radius: bigRadius, startAngle: 0, endAngle: CGFloat(M_PI * 2), clockwise: false)
    ctx?.fillPath()
//    小圆
    let smallRadius = bigRadius - border
    ctx?.addArc(center: CGPoint(x: centerX, y: centerY), radius: smallRadius, startAngle: 0, endAngle: CGFloat(M_PI * 2), clockwise: false)
    ctx?.clip()
//    画图
    oldImage.draw(in: CGRect(origin: CGPoint(x: border, y: border), size: oldImage.size))
//    取图
    let image = UIGraphicsGetImageFromCurrentImageContext()
//    结束上下文
    UIGraphicsEndImageContext()
    
    return image!
  }
  
  public class func generateCenterImageWithBgColor(_ bgImageColor: UIColor, bgImageSize: CGSize, centerImage: UIImage) -> UIImage? {
    
    if let bgImage = UIImage.imageWithColor(bgImageColor, size: bgImageSize) {
      UIGraphicsBeginImageContext(bgImage.size)
      bgImage.draw(in: CGRect(origin: .zero, size: bgImage.size))
      centerImage.draw(in: CGRect(origin: CGPoint(x: (bgImage.size.width - centerImage.size.width) * 0.5, y: (bgImage.size.height - centerImage.size.height) * 0.5), size: centerImage.size))
      let resultingImage = UIGraphicsGetImageFromCurrentImageContext()
      UIGraphicsEndImageContext()
      return resultingImage
    }
    return nil
  }
  
  internal class func imageWithColor(_ color: UIColor, size: CGSize) -> UIImage? {
    
    let rect = CGRect(origin: .zero, size: size)
    UIGraphicsBeginImageContext(rect.size)
    if let currentContext = UIGraphicsGetCurrentContext() {
      currentContext.setFillColor(color.cgColor)
      currentContext.fill(rect)
      let image = UIGraphicsGetImageFromCurrentImageContext()
      UIGraphicsEndImageContext()
      return image
    }
    return nil
  }
  
}
