//
//  RecommendViewController.swift
//  MybilibiliDemo
//
//  Created by 宅总 on 16/10/25.
//  Copyright © 2016年 Zly. All rights reserved.
//

import UIKit

// 首页推荐
// @since 1.0.0
// @author 赵林洋
fileprivate struct Commons {
  //  轮播图将要开始拖动发出的通知
  static let CycleBannerWillBeginDraggingNotification = "kCycleBannerWillBeginDraggingNotification"
  //  轮播图结束滑动发出的通知
  static let CycleBannerDidEndDeceleratingNotification = "kCycleBannerDidEndDeceleratingNotification"
  static let StartBeginRefreshing = "YPVideoLaunchTransitionDidFinishedNotification"
  
//  普通四图 tableViewCell identifier
  static let RecommendNormalImageTableViewCellID = "recommend_normal_image_cell_identifier"
//  大图 tableView cell identifier
  static let RecommendLargeImageTableViewCellID = "recommend_large_image_cell_identifier"
//  电视剧small tableView Cell
  static let RecommendSmallImageTableViewCellID = "recommend_small_image_cell_identifier"
}

class RecommendViewController: UIViewController, BiliStoryboardViewController {

  // MARK: - Property
  
  fileprivate lazy var _bannerViews: [Any] = {
    let lazilyCreatedBannerViews = [Any]()
    return lazilyCreatedBannerViews
  }()// 轮播数据源数组
  fileprivate lazy var _recommendContentViews: [Any] = {
    let lazilyCreatedViews = [Any]()
    return lazilyCreatedViews
  }()// 推荐内容数据源数组
  
  fileprivate weak var _bannerView: BBKCycleBannerView! // 轮播控件
  
  fileprivate var _contentTableView: UITableView! // 内容视图(TableView)
  
  fileprivate var _lastSelectedTabBarIndex: Int! // 记录上次选中的tabbar索引
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    _setupApperance()
//    _setupDataSource()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  deinit {
    
  }
  
  /*
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destinationViewController.
   // Pass the selected object to the new view controller.
   }
   */
  
  static func instanceFromStoryboard<T>() -> T {
    
    let vc = UIStoryboard.homeStoryboard().instantiateViewController(withIdentifier: "RecommendViewController") as! RecommendViewController
    return vc as! T
  }

}

extension RecommendViewController {
  
  fileprivate func _setupApperance() {
    
    view.backgroundColor = BBK_Main_Background_Color
    automaticallyAdjustsScrollViewInsets = false
    view.autoresizingMask = .init(rawValue: 0)
    
    _contentTableView = UITableView(frame: .zero, style: .grouped)
    _contentTableView.backgroundColor = BBK_Main_Background_Color
    _contentTableView.separatorStyle = .none
    _contentTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 49, right: 0)
    _contentTableView.scrollIndicatorInsets = _contentTableView.contentInset
    view.addSubview(_contentTableView)
    
//    订阅轮播图开始滑动以及结束滑动的通知改变首页内容视图是否可以滑动
    NotificationCenter.default.addObserver(self, selector: #selector(RecommendViewController._bannerViewWillBeginDraggingNotification), name: NSNotification.Name(rawValue: Commons.CycleBannerWillBeginDraggingNotification), object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(RecommendViewController._bannerViewDidEndDeceleratingNotification), name: NSNotification.Name(rawValue: Commons.CycleBannerDidEndDeceleratingNotification), object: nil)
//    如果是视频方式加载进入的时候刷新
    NotificationCenter.default.addObserver(self, selector: #selector(RecommendViewController._startBeginRefreshing), name: NSNotification.Name(rawValue: Commons.StartBeginRefreshing), object: nil)
//    监听tabbar点击的通知
    NotificationCenter.default.addObserver(self, selector: #selector(RecommendViewController._tabbarDidClickNotification), name: NSNotification.Name(rawValue: BBK_TabBar_DidSelectNotification), object: nil)
    
    _contentTableView.register(RecommendNormalImageTableViewCell.self, forCellReuseIdentifier: Commons.RecommendNormalImageTableViewCellID)
    _contentTableView.register(RecommendLargeImageTableViewCell.self, forCellReuseIdentifier: Commons.RecommendLargeImageTableViewCellID)
    _contentTableView.register(RecommendSmallImageTableViewCell.self, forCellReuseIdentifier: Commons.RecommendSmallImageTableViewCellID)
    
    _bannerView = BBKCycleBannerView.initBannerViewWithFrame(CGRect(origin: .zero, size: CGSize(width: BBK_Screen_Width, height: 120)), placeholderImage: nil)
//    _contentTableView.tableHeaderView = _bannerView
    _bannerView.bannerViewClosureDidClick =  { [weak self] (didselectIndex: Int) in
      guard let _ = self else { return }
      // TODO: - 轮播图的点击跳转, 以后再做.
    }
    
//    添加下拉刷新控件, 后期需进行改进.
    _contentTableView.header = BBKRefreshHeader() { (header: BBKRefreshHeader?) in
      self._setupDataSource()
    }
  }
  
  fileprivate func _setupDataSource() {
    
    _setupBannerDataSource()
  }
  
  fileprivate func _setupBannerDataSource() {
    
    let parameters = ["build": "3360", "channel": "appstore", "plat": "2"]
    
//    加载轮播图数据
    BBKHTTPSessionManager.sharedManager().get(BBK_Banner_URL, parameters: parameters, progress: nil, success: { [weak self] (task: URLSessionDataTask, responseObject: Any?) in
      guard let _ = self else { return }
      if let responseObject = responseObject {
        debugPrint("responseObject: \(responseObject)")
      }
    }) { (task: URLSessionDataTask?, error: Error) in
      debugPrint("加载轮播图数据: \(error)")
    }
    
  }
  
}

extension RecommendViewController {
  
  @objc fileprivate func _bannerViewWillBeginDraggingNotification() {
    
    _contentTableView.isScrollEnabled = false
  }
  
  @objc fileprivate func _bannerViewDidEndDeceleratingNotification() {
    
    _contentTableView.isScrollEnabled = true
  }
  
  @objc fileprivate func _startBeginRefreshing() {
    
    _contentTableView.header.beganRefreshing()
  }
  
  @objc fileprivate func _tabbarDidClickNotification() {
    
//    如果是连续选中2此，直接返回
    if _lastSelectedTabBarIndex == tabBarController?.selectedIndex && view.isShowingOnKeyWindow() {
      _contentTableView.header.beganRefreshing()
    }
//    记录这次选中的索引
    _lastSelectedTabBarIndex = tabBarController?.selectedIndex
  }
}

















