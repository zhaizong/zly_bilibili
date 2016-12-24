//
//  BBKProfileButton.swift
//  BiliBiliKit
//
//  Created by Crazy on 16/12/20.
//  Copyright © 2016年 Zly. All rights reserved.
//

import UIKit

public class BBKProfileButton: UIButton {

  override public func layoutSubviews() {
    super.layoutSubviews()
    
    imageView?.st_size = CGSize(width: 30, height: 30)
    titleLabel?.st_width = st_width
    titleLabel?.textAlignment = .center
    
    imageView?.st_centerX = st_width * 0.5
    imageView?.st_centerY = st_width * 0.5 - (imageView?.st_width)! * 0.5 + 6
    
    titleLabel?.st_centerX = (imageView?.st_centerX)!
    titleLabel?.st_top = (imageView?.st_bottom)! + 8
  }

}
