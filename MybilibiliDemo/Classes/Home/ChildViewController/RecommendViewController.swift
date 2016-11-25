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
//  番剧
  static let BangumiContentURL = "http://bangumi.bilibili.com/api/bangumi_recommend?actionKey=appkey&appkey=27eb53fc9058f8c3&build=3440&cursor=0&device=phone&mobi_app=iphone&pagesize=10&platform=ios&sign=51fb8d793fa26c9b12e2b73311bcf95a&ts=1468980621"
}

class RecommendViewController: UIViewController, BiliStoryboardViewController {

  // MARK: - Property
  
  fileprivate lazy var _bannerViews: [[String: Any]] = {
    let lazilyCreatedBannerViews = [[String: Any]]()
    return lazilyCreatedBannerViews
  }()// 轮播数据源数组
  fileprivate lazy var _recommendContentViews: [[String: Any]] = {
    let lazilyCreatedViews = [[String: Any]]()
    return lazilyCreatedViews
  }()// 推荐内容数据源数组
  fileprivate lazy var _movieDataSources: [[String: Any]] = {
    let lazilyCreatedLinks = [[String: Any]]()
    return lazilyCreatedLinks
  }()// 视频数组
  
  fileprivate var _bannerView: BBKCycleBannerView! // 轮播控件
  
  fileprivate var _contentTableView: UITableView! // 内容视图(TableView)
  
  fileprivate var _lastSelectedTabBarIndex: Int! // 记录上次选中的tabbar索引
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    _setupApperance()
    _setupDataSource()
  }
  
  deinit {
    debugPrint("deinit")
    NotificationCenter.default.removeObserver(self)
  }
  
  static func instanceFromStoryboard<T>() -> T {
    
    let vc = UIStoryboard.homeStoryboard().instantiateViewController(withIdentifier: "RecommendViewController") as! RecommendViewController
    return vc as! T
  }

}

extension RecommendViewController: UITableViewDataSource, UITableViewDelegate {
  
  // MARK: - UITableViewDataSource
  
  func numberOfSections(in tableView: UITableView) -> Int {
    
    return _recommendContentViews.count
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    return 1
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let model = _recommendContentViews[indexPath.section]
    let style = model["style"] as! String
    if style == "medium" {
      let cell = tableView.dequeueReusableCell(withIdentifier: Commons.RecommendNormalImageTableViewCellID) as! RecommendNormalImageTableViewCell
      cell.model = model
      return cell
    } else if style == "large" {
      let cell = tableView.dequeueReusableCell(withIdentifier: Commons.RecommendLargeImageTableViewCellID) as! RecommendLargeImageTableViewCell
      cell.model = model
      return cell
    } else if style == "small" {
      let cell = tableView.dequeueReusableCell(withIdentifier: Commons.RecommendSmallImageTableViewCellID) as! RecommendSmallImageTableViewCell
      cell.model = model
      return cell
    }
    
    return UITableViewCell()
  }
  
  // MARK: - UITableViewDelegate
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    
    let model = _recommendContentViews[indexPath.section]
    let style = model["style"] as! String
    if style == "medium" {
      return 300
    } else if style == "large" {
      return 100
    } else if style == "small" {
      return 110
    }
    return 0
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    
    let model = _recommendContentViews[section]
    let type = model["type"] as! String
    if type == "recommend" {
      let view = RecommendHotHeaderView(frame: .zero)
      return view
    } else if type == "live" {
      let view = RecommendLiveHeaderView(frame: .zero)
      return view
    } else if type == "topic" {
      let view = RecommendTopicHeaderView(frame: .zero)
      return view
    } else if type == "av" {
      let view = RecommendAVHeaderView(frame: .zero)
      return view
    } else if type == "bangumi" {
      let view = RecommendRegionHeaderView(frame: .zero)
      view.imageString = "home_subregion_bangumi"
      view.titleString = "番剧推荐"
      view.detailString = "查看所有番剧"
      return view
    } else if type == "region" || type == "sp" {
      let view = RecommendRegionHeaderView(frame: .zero)
      view.imageString = "home_region_icon_\(model["param"])"
      view.titleString = model["title"] as? String
      return view
    }
    return UIView()
  }
  
  func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    
    let model = _recommendContentViews[section]
    let type = model["type"] as! String
    if type == "recommend" {
      let view = RecommendRegionFooterView(frame: .zero)
      view.regionFooterViewRefreshDataSourceClosure = { [weak self] in
        if let _ = self {
          // TODO: - 换一波
//          UIView.animate(withDuration: 1) {
//            view.timer.invalidate()
//            view.timer = nil
//          }
        }
      }
      return view
    } else if type == "bangumi" {
      let view = RecommendBangumiFooterView(frame: .zero)
      return view
    } else if type == "region" || type == "live" {
      let view = RecommendRegionFooterView(frame: .zero)
      return view
    }
    return UIView()
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    
    let model = _recommendContentViews[section]
    let type = model["type"] as! String
    if type == "av" {
      return 10
    }
    return 45
  }
  
  func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    
    let model = _recommendContentViews[section]
    let type = model["type"] as! String
    if type == "av" {
      return 10
    } else if type == "bangumi" {
      return 80
    }
    return 20
  }
  
}

extension RecommendViewController {
  
  fileprivate func _setupApperance() {
    
    view.backgroundColor = BBK_Main_Background_Color
    automaticallyAdjustsScrollViewInsets = false
    
    _contentTableView = UITableView(frame: .zero, style: .grouped)
    _contentTableView.backgroundColor = BBK_Main_Background_Color
    _contentTableView.separatorStyle = .none
    _contentTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 49, right: 0)
    _contentTableView.scrollIndicatorInsets = _contentTableView.contentInset
    _contentTableView.dataSource = self
    _contentTableView.delegate = self
    view.addSubview(_contentTableView)
    _contentTableView.snp.makeConstraints { (make) in
      make.top.equalTo(view.snp.top)
      make.bottom.equalTo(view.snp.bottom)
      make.leading.equalTo(view.snp.leading)
      make.trailing.equalTo(view.snp.trailing)
    }
    
//    订阅轮播图开始滑动以及结束滑动的通知改变首页内容视图是否可以滑动
    NotificationCenter.default.addObserver(self, selector: #selector(_bannerViewWillBeginDraggingNotification), name: NSNotification.Name(rawValue: Commons.CycleBannerWillBeginDraggingNotification), object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(_bannerViewDidEndDeceleratingNotification), name: NSNotification.Name(rawValue: Commons.CycleBannerDidEndDeceleratingNotification), object: nil)
//    如果是视频方式加载进入的时候刷新
    NotificationCenter.default.addObserver(self, selector: #selector(_startBeginRefreshing), name: NSNotification.Name(rawValue: Commons.StartBeginRefreshing), object: nil)
//    监听tabbar点击的通知
    NotificationCenter.default.addObserver(self, selector: #selector(_tabbarDidClickNotification), name: NSNotification.Name(rawValue: BBK_TabBar_DidSelectNotification), object: nil)
    
    _contentTableView.register(RecommendNormalImageTableViewCell.self, forCellReuseIdentifier: Commons.RecommendNormalImageTableViewCellID)
    _contentTableView.register(RecommendLargeImageTableViewCell.self, forCellReuseIdentifier: Commons.RecommendLargeImageTableViewCellID)
    _contentTableView.register(RecommendSmallImageTableViewCell.self, forCellReuseIdentifier: Commons.RecommendSmallImageTableViewCellID)
    
    _bannerView = BBKCycleBannerView.initBannerViewWithFrame(CGRect(origin: .zero, size: CGSize(width: BBK_Screen_Width, height: 120)), placeholderImage: nil)
    _contentTableView.tableHeaderView = _bannerView
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
    
    UIApplication.shared.isNetworkActivityIndicatorVisible = true
    let setupBannerAndRecommend: () -> Void = {
      if self._bannerViews.count != 0 && self._recommendContentViews.count != 0 && self._movieDataSources.count != 0 {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        
        self._bannerView.models = self._bannerViews
        
        self._contentTableView.reloadData()
        self._contentTableView.header.endRefreshing()
      }
    }
    
    _bannerViews.removeAll(keepingCapacity: false)
//    加载轮播图数据
    let parametersBanner = ["build": "3360", "channel": "appstore", "plat": "2"]
    BBKHTTPSessionManager.sharedManager().get(BBK_Banner_URL, parameters: parametersBanner, progress: nil, success: { [weak self] (task: URLSessionDataTask, responseObject: Any?) in
      guard let weakSelf = self else { return }
      if let responseObject = responseObject {
        let dict = responseObject as! [String: Any]
        let datas = dict["data"] as! [[String: Any]]
        
        weakSelf._bannerViews = datas
        setupBannerAndRecommend()
      }
    }) { (task: URLSessionDataTask?, error: Error) in
      UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    _recommendContentViews.removeAll(keepingCapacity: false)
//    加载推荐内容数据
    let parametersContnet = ["build": "3390", "channel": "appstore", "plat": "1", "actionKey": "appkey", "appkey": "27eb53fc9058f8c3", "device": "phone", "platform": "ios", "sign": "dc5d0dd8e3ff190042473a332f435a03", "ts": "1465476506"]
    BBKHTTPSessionManager.sharedManager().get(BBK_RecommendContent_URL, parameters: parametersContnet, progress: nil, success: { [weak self] (task: URLSessionDataTask, responseObject: Any?) in
      guard let weakSelf = self else { return }
      if let responseObject = responseObject {
        let dict = responseObject as! [String: Any]
        let datas = dict["data"] as! [[String: Any]]
        weakSelf._recommendContentViews = datas
        setupBannerAndRecommend()
      }
    }) { (task: URLSessionDataTask?, error: Error) in
      UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
//    视频链接
    _movieDataSources.removeAll(keepingCapacity: false)
    BBKHTTPSessionManager.sharedManager().get(Commons.BangumiContentURL, parameters: nil, progress: nil, success: { [weak self] (task: URLSessionDataTask, responseObject: Any?) in
      guard let weakSelf = self else { return }
      if let responseObject = responseObject {
        let dict = responseObject as! [String: Any]
        let datas = dict["result"] as! [[String: Any]]
        weakSelf._movieDataSources = datas
        setupBannerAndRecommend()
      }
    }) { (task: URLSessionDataTask?, error: Error) in
      UIApplication.shared.isNetworkActivityIndicatorVisible = false
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

















