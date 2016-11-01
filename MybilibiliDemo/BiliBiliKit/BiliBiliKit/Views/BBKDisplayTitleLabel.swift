//
//  BBKDisplayTitleLabel.swift
//  BiliBiliKit
//
//  Created by 宅总 on 16/10/23.
//  Copyright © 2016年 Zly. All rights reserved.
//

import UIKit

public class BBKDisplayTitleLabel: UILabel {

  // MARK: - Property
  
  public var progress: CGFloat {
    didSet {
      setNeedsDisplay()
    }
  }
  
  public var fillColor: UIColor
  
  // Only override draw() if you perform custom drawing.
  // An empty implementation adversely affects performance during animation.
  override public func draw(_ rect: CGRect) {
    super.draw(rect)
    // Drawing code
    fillColor.set()
    let _rect = CGRect(origin: rect.origin, size: CGSize(width: rect.size.width * progress, height: rect.size.height))
    UIRectFillUsingBlendMode(_rect, .sourceIn)
  }
  
  override init(frame: CGRect) {
    progress = 0
    fillColor = UIColor.clear
    super.init(frame: frame)
  }
  
  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}
