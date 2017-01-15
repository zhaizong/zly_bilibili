//
//  DMKTabBarController.swift
//  HalfSugar
//
//  Created by 宅总 on 16/5/30.
//  Copyright © 2016年 Crazy. All rights reserved.
//

import UIKit

class BiliTabBarController: UITabBarController {

  // MARK: - Commons
  
  fileprivate let kHomeTabIndex     = 0
//  fileprivate let kZoneTabIndex     = 1
//  fileprivate let kFollowTabIndex   = 2
//  fileprivate let kFindTabIndex     = 3
  fileprivate let kMeTabIndex       = 1
  
  // MARK: - Property
  
  fileprivate var _homeNavigationViewController: UINavigationController!
//  fileprivate var _zoneNavigationViewController: UINavigationController!
//  fileprivate var _followNavigationViewController: UINavigationController!
//  fileprivate var _findNavigationViewController: UINavigationController!
  fileprivate var _meNavigationViewController: UINavigationController!
  
  override var selectedIndex: Int {
    didSet {
//      _zoneNavigationViewController.popToRootViewController(animated: true)
//      _followNavigationViewController.popToRootViewController(animated: true)
//      _findNavigationViewController.popToRootViewController(animated: true)
      _meNavigationViewController.popToRootViewController(animated: true)
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.
    _setupContentViewControllers()
    _setupApperance()
  }

}

extension BiliTabBarController {
  
  fileprivate func _setupContentViewControllers() {
    
    _homeNavigationViewController = UIStoryboard.homeStoryboard().instantiateInitialViewController() as! UINavigationController
//    _zoneNavigationViewController = UIStoryboard.zoneStoryboard().instantiateInitialViewController() as! UINavigationController
//    _followNavigationViewController = UIStoryboard.followStoryboard().instantiateInitialViewController() as! UINavigationController
//    _findNavigationViewController = UIStoryboard.findStoryboard().instantiateInitialViewController() as! UINavigationController
    _meNavigationViewController = UIStoryboard.meStoryboard().instantiateInitialViewController() as! UINavigationController
    
    viewControllers = [_homeNavigationViewController,
//                       _zoneNavigationViewController,
//                       _followNavigationViewController,
//                       _findNavigationViewController,
                       _meNavigationViewController
    ]
    
    if let homeTabItem = tabBar.items?[kHomeTabIndex] {
      homeTabItem.title = "首页"
      homeTabItem.image = UIImage(named: "home_home_tab")?.withRenderingMode(.alwaysOriginal)
      homeTabItem.selectedImage = UIImage(named: "home_home_tab_s")?.withRenderingMode(.alwaysOriginal)
      homeTabItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -5)
    }
    
//    if let zoneTabItem = tabBar.items?[kZoneTabIndex] {
//      zoneTabItem.title = "分区"
//      zoneTabItem.image = UIImage(named: "Square_normal")?.imageWithRenderingMode(.AlwaysOriginal)
//      zoneTabItem.selectedImage = UIImage(named: "Square_selected")?.imageWithRenderingMode(.AlwaysOriginal)
//    }
    
//    if let followTabItem = tabBar.items?[kFollowTabIndex] {
//      followTabItem.title = "关注"
//      followTabItem.image = UIImage(named: "Show_normal")?.imageWithRenderingMode(.AlwaysOriginal)
//      followTabItem.selectedImage = UIImage(named: "Show_normal")?.imageWithRenderingMode(.AlwaysOriginal)
//    }
    
//    if let findTabItem = tabBar.items?[kFindTabIndex] {
//      findTabItem.title = "发现"
//    }
    
    if let meTabItem = tabBar.items?[kMeTabIndex] {
      meTabItem.title = "我的"
      meTabItem.image = UIImage(named: "home_mine_tab")?.withRenderingMode(.alwaysOriginal)
      meTabItem.selectedImage = UIImage(named: "home_mine_tab_s")?.withRenderingMode(.alwaysOriginal)
      meTabItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -5)
    }
    
  }
  
  fileprivate func _setupApperance() {
    
    delegate = self
    UITabBar.appearance().tintColor = BBK_Main_Color
    UITabBar.appearance().isTranslucent = false
  }
  
}

extension BiliTabBarController: UITabBarControllerDelegate {
  
  func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
    
    NotificationCenter.default.post(name: NSNotification.Name(rawValue: BBK_TabBar_DidSelectNotification), object: nil)
  }
  
}

extension BiliTabBarController {
  
//  屏幕旋转控制方法
  override var shouldAutorotate: Bool {
    guard let selectedViewController = selectedViewController else { return true }
    return selectedViewController.shouldAutorotate
  }
  
  override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
    guard let selectedViewController = selectedViewController else { return .portrait }
    return selectedViewController.supportedInterfaceOrientations
  }
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    guard let selectedViewController = selectedViewController else { return .default }
    return selectedViewController.preferredStatusBarStyle
  }
  
  override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
    return .fade
  }
  
}


















