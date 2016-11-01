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
