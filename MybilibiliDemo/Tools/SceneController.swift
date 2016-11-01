//
//  DMKSceneController.swift
//  HalfSugar
//
//  Created by 宅总 on 16/5/29.
//  Copyright © 2016年 Crazy. All rights reserved.
//

import UIKit

// 用于各个ViewController的切换
class SceneController {
  
  static let sharedController = SceneController()
  
  func replaceSceneWithSplashView() {
    
    let splashVC: SplashViewController = SplashViewController.instanceFromStoryboard()
    AppDelegate.bili_sharedInstance().window?.rootViewController = splashVC
    
  }
  
  func replaceSceneWithHomeView() {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    appDelegate.window?.rootViewController = appDelegate.tabBarController
    appDelegate.tabBarController.selectedIndex = 0
  }
  
  /*internal func replaceSceneWithChooseCityView() {
    
    
  }*/
  
}
