//
//  DMKNavigationController.swift
//  HalfSugar
//
//  Created by 宅总 on 16/6/2.
//  Copyright © 2016年 Crazy. All rights reserved.
//

import UIKit

class BiliNavigationController: UINavigationController {

  override var childViewControllerForStatusBarStyle: UIViewController? {
    return self.topViewController
  }
  
  //MARK: - Lifecycle
  
  override init(rootViewController: UIViewController) {
    super.init(rootViewController: rootViewController)
    
    navigationBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
    navigationBar.shadowImage = UIImage()
  }
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    
    // remove 1px bottom line of the navigation bar
    navigationBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
    navigationBar.shadowImage = UIImage()
    
    /*let backButtonImage: UIImage = UIImage(named: "app_nav_back")!
    navigationBar.backIndicatorImage = backButtonImage;
    navigationBar.backIndicatorTransitionMaskImage = backButtonImage;*/
  }
  
}
