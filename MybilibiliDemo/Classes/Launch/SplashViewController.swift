//
//  SplashViewController.swift
//
//  Created by 宅总 on 16/5/29.
//  Copyright © 2016年 Crazy. All rights reserved.
//

import UIKit

// 启动页
// 有网为广告、无网为动画
// 先默认无网

fileprivate struct SplashCommons {
  static let AppITunesURL = "https://itunes.apple.com/cn/app/bi-li-bi-li-dong-hua-dan-mu/id736536022?mt=8"
}

class SplashViewController: UIViewController, BiliStoryboardViewController {
  
  // MARK: - Property
  
//  背景加载图片
  @IBOutlet weak var bgImageView: UIImageView!
//  启动图片ImageView
  @IBOutlet weak var splashImageView: UIImageView!
  
//  启动图片宽度的约束
  @IBOutlet weak var splashImgWidthConstraint: NSLayoutConstraint!
//  启动图片高度的约束
  @IBOutlet weak var splashImgHeightConstraint: NSLayoutConstraint!
  
  lazy var splashViewModel: SplashViewModel = {
    let lazilyCreatedSplashViewModel = SplashViewModel()
    return lazilyCreatedSplashViewModel
  }()
  
//  当前的时间戳是否在模型的时间戳范围内的标志
  var timeStampInModelTimesFlag: Bool!
  
  // MARK: - Lifecycle
  /*
  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.
  }
  */
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    // TODO: - DMKAccountManager 用户账号管理相关的类 (iOS) 在此处判断是否登陆过
    BBCDirector.bbk_resetDefaultDirectorAsStranger()
    BBCDirector.default()?.resetManagers()
    
    _setupAppearance()
    
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  deinit {
    debugPrint("SplashViewController deinit")
    AFNetworkReachabilityManager.shared().stopMonitoring()
  }

}

extension SplashViewController {
  
  fileprivate func _setupAppearance() {
    
//    设置启动动画图片的锚点
    splashImageView.layer.anchorPoint = CGPoint(x: 0.5, y: 0.8)
//    初始化约束
    _setupSplashConstraint()
//    加载启动图片(先判断程序是否是第一次启动)
    let appLaunchTimes = BiliPreference.sharedPreference().preferredAppLaunchTimes
    if appLaunchTimes.isEmpty == false { // 如果不是第一次启动
//      正常形式加载(广告或动画)
      _setupLaunchImage()
    } else {
//      第一次启动(动画形式加载)
      weak var weakSelf = self
      let myDispatch_time = DispatchTime.now() + 0.5
      DispatchQueue.main.asyncAfter(deadline: myDispatch_time, execute: {
        guard let weakSelf = weakSelf else { return }
        weakSelf._launchWithAnimate()
      })
//      动画加载之后如果有网要进行网络请求缓存图片, 如果没有网络那么不必开启计数器, 因此计数器要放在网络请求成功之后开启.
      // TODO: - loadLaunchDataWhenAppFirstOpen
    }
  }
  
  fileprivate func _setupSplashConstraint() {
    
    splashImgWidthConstraint.constant = 0.0
    splashImgHeightConstraint.constant = 0.0
    view.layoutIfNeeded()
  }
  
  fileprivate func _setupLaunchImage() {
    
    let appLaunchTimes = BiliPreference.sharedPreference().preferredAppLaunchTimes
    if Int(appLaunchTimes) == 3 { // 弹出好评框
      let myDispatch_time = DispatchTime.now() + 0.5 * Double(NSEC_PER_SEC)
      DispatchQueue.main.asyncAfter(deadline: myDispatch_time) {
        BBKAlertView.show(withTitle: "给我们评分", message: "如果您喜欢哔哩哔哩动画，请给我们评分。您的支持会让我们做得更好!", cancelButtonTitle: "以后再说", otherButtonTitles: ["评分"], andAction: { (buttonIndex: Int) in
          if buttonIndex == 1 {
            debugPrint("跳转到评分页")
            UIApplication.shared.open(URL(string: SplashCommons.AppITunesURL)!, completionHandler: nil)
          }
          }, andParentView: nil)
      }
    }
    
    AFNetworkReachabilityManager.shared().setReachabilityStatusChange { (status: AFNetworkReachabilityStatus) in
      switch status {
      case .notReachable:
        // TODO: - 先从数据库中加载广告启动页, 判断是否符合时间戳, 如果符合加载广告启动页. 如果不符合动画形式加载.
        break
      case .reachableViaWiFi, .reachableViaWWAN:
//        加载启动数据
//        _loadLaunchData()
        break
      default:
        break
      }
    }
    
  }
  
  fileprivate func _loadLaunchData() {
//    动画形式加载
//    比较时间戳 取出对应的应该放置的启动页
//    从网络加载启动页
//    有符合时间戳的模型 存储到数据库中
//    如果请求到的数据不在时间范围内就动画形式加载
  }
  
  fileprivate func _loadData(_ block: ((_ launchModels: [Any]) -> Void)) {
    // TODO: - 从网络加载数据
    // TODO: - 计数器++
    // TODO: - 回调block
  }
  
}

extension SplashViewController {
  
  // MARK: - 动画形式加载启动页
  fileprivate func _launchWithAnimate() {
    
//    播放默认动画
    splashImageView.isHidden = false
    splashImgWidthConstraint.constant = 320
    splashImgHeightConstraint.constant = 420
    
    UIView.animate(withDuration: 1.5, delay: 0.5, usingSpringWithDamping: 0.2, initialSpringVelocity: 8.0, options: .allowAnimatedContent, animations: {
      self.view.layoutIfNeeded()
    }) { (finished: Bool) in
      let myDispatch_time = DispatchTime.now() + 0.5
      DispatchQueue.main.asyncAfter(deadline: myDispatch_time) {
//        初始化 tabBarController
        AppDelegate.bili_sharedInstance().tabBarController = UIStoryboard.mainStoryboard().instantiateInitialViewController() as! BiliTabBarController
        
//        切换根控制器
        SceneController.sharedController.replaceSceneWithHomeView()
      }
    }
  }
}

extension SplashViewController {
  
  static func instanceFromStoryboard<T>() -> T {
    
    let vc = UIStoryboard.mainStoryboard().instantiateViewController(withIdentifier: "SplashViewController")
    return vc as! T
  }
}
