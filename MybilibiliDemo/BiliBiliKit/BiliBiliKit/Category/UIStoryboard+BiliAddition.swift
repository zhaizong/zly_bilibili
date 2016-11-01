//
//  UIStoryboard+BiliAddition.swift
//  HalfSugar
//
//  Created by 宅总 on 16/5/29.
//  Copyright © 2016年 Crazy. All rights reserved.
//

import UIKit

public extension UIStoryboard {
  
  public class func mainStoryboard() -> UIStoryboard {
    
    return UIStoryboard(name: "Main", bundle: nil)
  }
  
  public class func homeStoryboard() -> UIStoryboard {
    
    return UIStoryboard(name: "Home", bundle: nil)
  }
  
  public class func zoneStoryboard() -> UIStoryboard {
    
    return UIStoryboard(name: "Zone", bundle: nil)
  }
  
  public class func followStoryboard() -> UIStoryboard {
    return UIStoryboard(name: "Follow", bundle: nil)
  }
  
  public class func findStoryboard() -> UIStoryboard {
    
    return UIStoryboard(name: "Find", bundle: nil)
  }
  
  public class func meStoryboard() ->UIStoryboard {
    
    return UIStoryboard(name: "Me", bundle: nil)
  }
}
