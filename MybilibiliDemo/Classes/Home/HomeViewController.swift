//
//  HomeViewController.swift
//  MybilibiliDemo
//
//  Created by 宅总 on 16/10/25.
//  Copyright © 2016年 Zly. All rights reserved.
//

import UIKit

// 主页根控制器
// @since 1.0.0
// @author 赵林洋
class HomeViewController: BiliViewController, BiliStoryboardViewController {

  // MARK: - Property
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.
    _setupApperance()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    guard let navigationController = navigationController else { return }
    navigationController.navigationBar.alpha = 0
    navigationController.navigationBar.superview?.sendSubview(toBack: navigationController.navigationBar)
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    guard let navigationController = navigationController else { return }
    navigationController.navigationBar.alpha = 0
    navigationController.navigationBar.superview?.sendSubview(toBack: navigationController.navigationBar)
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self)
  }

  /*
  // MARK: - Navigation

  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
  }
  */
  
  override var shouldAutorotate: Bool {
    return true
  }
  
  override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
    return .portrait
  }
  
  override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
    return .portrait
  }
  
  static func instanceFromStoryboard<T>() -> T {
    
    let vc = UIStoryboard.homeStoryboard().instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
    return vc as! T
  }
}

extension HomeViewController {
  
  fileprivate func _setupApperance() {
    
    view.backgroundColor = BBK_Main_White_Color
//    view.backgroundColor = UIColor.red
    automaticallyAdjustsScrollViewInsets = false
    view.autoresizingMask = UIViewAutoresizing(rawValue: UInt(0))
    
    navigationController?.navigationBar.isHidden = false
    
//    添加所有子控制器
    _setupAllViewController()
//    设置字体
    titleFont = UIFont.systemFont(ofSize: 17)
//    根据角标，选中对应的控制器
    selectedIndex = 1
    
//    设置标题渐变, 不需要设置的属性, 可以不管
    setupTitleGradient(true, .rgb, 0.66, 0.65, 0.66, 0.89, 0.49, 0.61)
//    设置下标
    setupUnderLineEffect(true, nil, 3, BBK_Main_Color)
    /*
     如果_isfullScreen = Yes，这个方法就不好使。
     设置整体内容的frame,包含（标题滚动视图和内容滚动视图）
     */
    setupContentViewFrame = CGRect(origin: CGPoint(x: 0, y: 20), size: CGSize(width: BBK_Screen_Width, height: BBK_Screen_Height))
    
    isBisectedWidthUnderLineAndTitle = true
    
//    订阅轮播图, 开始滑动以及结束滑动的通知, 改变首页内容视图是否可以滑动.
    NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController._bannerViewWillBeginDraggingNotification), name: NSNotification.Name(rawValue: BBK_BannerView_WillBeginDraggingNotification), object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController._bannerViewDidEndDeceleratingNotification), name: NSNotification.Name(rawValue: BBK_BannerView_DidEndDeceleratingNotification), object: nil)
  }
  
  fileprivate func _setupAllViewController() {
    
    let liveVC: LiveViewController = LiveViewController.instanceFromStoryboard()
    liveVC.title = "直播"
    addChildViewController(liveVC)
    
    let recommendVC: RecommendViewController = RecommendViewController.instanceFromStoryboard()
    recommendVC.title = "推荐"
    addChildViewController(recommendVC)
    
//    let bangumiVC: BangumiViewController = BangumiViewController.instanceFromStoryboard()
//    bangumiVC.title = "番剧"
//    addChildViewController(bangumiVC)
  }
  
}

extension HomeViewController {
  
  @objc fileprivate func _bannerViewWillBeginDraggingNotification() {
    
    isBanContentViewScroll = true
  }
  
  @objc fileprivate func _bannerViewDidEndDeceleratingNotification() {
    
    isBanContentViewScroll = false
  }
}
