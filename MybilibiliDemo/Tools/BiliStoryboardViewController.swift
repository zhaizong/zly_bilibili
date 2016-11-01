//
//  DMKStoryboardViewController.swift
//  HalfSugar
//
//  Created by 宅总 on 16/5/29.
//  Copyright © 2016年 Crazy. All rights reserved.
//

import UIKit

public protocol BiliStoryboardViewController {
  
  static func instanceFromStoryboard<T>() -> T
}
