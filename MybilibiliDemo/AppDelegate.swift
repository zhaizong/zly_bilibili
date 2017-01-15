//
//  AppDelegate.swift
//  MybilibiliDemo
//
//  Created by 宅总 on 16/10/17.
//  Copyright © 2016年 Zly. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?
  var tabBarController: BiliTabBarController!
  
  var _reacha: Reachability!
  var _preStatus: NetworkStatus = .none

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.
    
    // TODO: - 设置第三方支持
//    ThirdPartyManager.manager().setupThirdPartyConfigurationWithApplication(application, didFinishLaunchingWithOptions: launchOptions)
    
    SceneController.sharedController.replaceSceneWithSplashView()
    
//    网络监测
    _checkNetworkStatus()
    return true
  }

  func applicationWillResignActive(_ application: UIApplication) {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
  }

  func applicationDidEnterBackground(_ application: UIApplication) {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
  }

  func applicationWillEnterForeground(_ application: UIApplication) {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
  }

  func applicationDidBecomeActive(_ application: UIApplication) {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  }

  func applicationWillTerminate(_ application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
  }


}

extension AppDelegate {
  
  fileprivate func _checkNetworkStatus() {
    NotificationCenter.default.addObserver(self, selector: #selector(_networkMonitoring), name: NSNotification.Name.reachabilityChanged, object: nil)
    _reacha = Reachability(hostName: "https://www.baidu.com")
    _reacha.startNotifier()
  }
  
  @objc fileprivate func _networkMonitoring() {
    /*let mgr = AFNetworkReachabilityManager.shared()
    mgr.setReachabilityStatusChange { (status: AFNetworkReachabilityStatus) in
      let currentStatus = BBKHTTPSessionManager.networkStatus()
      debugPrint(currentStatus)
//      当网络状态发生改变的时候调用这个block
      switch status {
      case .reachableViaWiFi:
        debugPrint("WIFI状态")
      case .reachableViaWWAN:
        debugPrint("手机网络")
      case .notReachable:
        debugPrint("没有网络")
      case .unknown:
        debugPrint("未知网络")
      }
    }
//    开始监控
    mgr.startMonitoring()*/
    var tips = ""
    let currentStatus = BBKHTTPSessionManager.networkStatus()
    if currentStatus == _preStatus {
      return
    }
    _preStatus = currentStatus
    switch currentStatus {
    case .none:
      debugPrint("当前无网络, 请检查您的网络状态")
      tips = "当前无网络, 请检查您的网络状态"
    case .towG:
      debugPrint("切换到了2G网络")
      tips = "切换到了2G网络"
    case .threeG:
      debugPrint("切换到了3G网络")
      tips = "切换到了3G网络"
    case .fourG:
      debugPrint("切换到了4G网络")
      tips = "切换到了4G网络"
    case .wifi:
      debugPrint("wifi")
      tips = ""
    }
    if tips != "" {
      let alert = UIAlertController(title: "哔哩哔哩", message: tips, preferredStyle: .alert)
      let cancelAction = UIAlertAction(title: "知道了", style: .cancel, handler: nil)
      alert.addAction(cancelAction)
      window?.rootViewController?.present(alert, animated: true, completion: nil)
    }
  }
  
}

