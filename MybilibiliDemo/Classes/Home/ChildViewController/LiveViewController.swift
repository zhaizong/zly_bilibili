//
//  LiveViewController.swift
//  MybilibiliDemo
//
//  Created by 宅总 on 16/10/25.
//  Copyright © 2016年 Zly. All rights reserved.
//

import UIKit

// 直播控制器
// @since 1.0.0
// @author 赵林洋
fileprivate struct Commons {
//  轮播图将要开始拖动发出的通知
  static let CycleBannerWillBeginDraggingNotification = "kCycleBannerWillBeginDraggingNotification"
//  轮播图结束滑动发出的通知
  static let CycleBannerDidEndDeceleratingNotification = "kCycleBannerDidEndDeceleratingNotification"
  static let LiveContentTableViewCellID = "LiveContentTableViewCellID"
}

class LiveViewController: UIViewController, BiliStoryboardViewController {

  // MARK: - Property
  
  fileprivate var _banners: [BBCLiveBanner] = [] // 轮播图数据数组
  fileprivate var _entrances: [BBCLiveEntrance] = [] // 入口图片数据数组
  fileprivate var _partitions: [BBCLivePartition] = [] // 分区数据数组
  fileprivate var _liveSources: [[BBCLiveSource]] = []
  
  fileprivate var _lastSelectedTabBarIndex: Int! // 记录上次选中的tabbar索引
  fileprivate var _liveContentTableView: UITableView! // 内容视图
  fileprivate var _tableHeaderView: LiveHeaderView! // 头部视图
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.
    
    _setupApperance()
    _setupDataSource()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    tabBarController?.tabBar.isHidden = false
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    _liveContentTableView.frame = CGRect(origin: .zero, size: view.st_size)
  }
  
  override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
    
    guard let keyPath = keyPath else { return }
    guard let change = change else { return }
    
    if keyPath == "viewHeight" {
      let newValue = change[.newKey] as! CGFloat
      _tableHeaderView.snp.updateConstraints({ (make) in
        make.height.equalTo(newValue)
      })
      _liveContentTableView.tableHeaderView = _tableHeaderView
    }
  }
  
  static func instanceFromStoryboard<T>() -> T {
    
    let vc = UIStoryboard.homeStoryboard().instantiateViewController(withIdentifier: "LiveViewController") as! LiveViewController
    return vc as! T
  }

}

extension LiveViewController: UITableViewDataSource, UITableViewDelegate {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    
    return _partitions.count
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    return 1
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: Commons.LiveContentTableViewCellID, for: indexPath) as! LiveContentTableViewCell
    
    cell.setupCellDataSource(_partitions[indexPath.section], liveSources: _liveSources[indexPath.section])
    
    cell.liveTableViewCellDidSelectedClosure = { [weak self] (liveSource: BBCLiveSource) in
      if let weakSelf = self {
        let vc: LiveDetailViewController = LiveDetailViewController.instanceFromStoryboard()
        vc.liveSource = liveSource
        weakSelf.navigationController?.pushViewController(vc, animated: true)
      }
    }
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    
    return 44
  }
  
  func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    
    return 60
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    
    let view = LiveTableHeaderView(frame: .zero)
    view.partition = _partitions[section]
    view.headerViewTouchesClosure = { [weak self] in
      if let weakSelf = self {
        debugPrint("点击了\(weakSelf._partitions[section].name)模块")
      }
    }
    return view
  }
  
  func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    
    let view = LiveTableFooterView(frame: .zero)
    return view
  }
}

extension LiveViewController: LiveHeaderViewDelegate {
  
  func liveHeaderView(_ liveHeaderView: LiveHeaderView, didSelectedBannerIndex index: Int) {
    
    debugPrint("点击了轮播索引: \(index)")
  }
  
  func liveHeaderView(_ liveHeaderView: LiveHeaderView, selectedAreaID areaID: LiveEntranceIconsViewAreaType) {
    
    debugPrint("点击了入口图标索引: \(areaID)")
  }
}

extension LiveViewController {
  
  @objc fileprivate func _scrollDidFinshNotebeginRefreshing() {
    
    _liveContentTableView.header.beganRefreshing()
  }
  
  @objc fileprivate func _bannerViewWillBeginDraggingNotification() {
    
    _liveContentTableView.isScrollEnabled = false
  }
  
  @objc fileprivate func _bannerViewDidEndDeceleratingNotification() {
    
    _liveContentTableView.isScrollEnabled = true
  }
  
  @objc fileprivate func _tabBarDidSelectNotification() {
    
//    如果是连续选中两次，直接返回.
    if _lastSelectedTabBarIndex == tabBarController?.selectedIndex && view.isShowingOnKeyWindow() {
      _liveContentTableView.header.beganRefreshing()
    }
//    记录这次选中的索引
    _lastSelectedTabBarIndex = tabBarController?.selectedIndex
  }
}

extension LiveViewController {
  
  fileprivate func _setupApperance() {
    
    view.backgroundColor = BBK_Main_Background_Color
    automaticallyAdjustsScrollViewInsets = false
    view.autoresizingMask = .init(rawValue: 0)
    
    _liveContentTableView = UITableView(frame: .zero, style: .grouped)
    _liveContentTableView.register(LiveContentTableViewCell.self, forCellReuseIdentifier: Commons.LiveContentTableViewCellID)
    _liveContentTableView.backgroundColor = BBK_Main_Background_Color
    _liveContentTableView.separatorStyle = .none
    _liveContentTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 49, right: 0)
    _liveContentTableView.scrollIndicatorInsets = _liveContentTableView.contentInset
//    _liveContentTableView.estimatedRowHeight = 306
    _liveContentTableView.rowHeight = 306
    _liveContentTableView.dataSource = self
    _liveContentTableView.delegate = self
    view.addSubview(_liveContentTableView)
    
//    添加下拉刷新控件
    _liveContentTableView.header = BBKRefreshHeader() { (header: BBKRefreshHeader?) in
      self._setupDataSource()
    }
    
//    订阅DisplayViewClickOrScrollDidFinshNote通知决定是否刷新
    #if false
      NotificationCenter.default.addObserver(self, selector: #selector(LiveViewController._scrollDidFinshNotebeginRefreshing), name: NSNotification.Name(rawValue: BBK_DisplayView_ClickOrScrollDidFinshNote), object: nil)
    #endif
    
//    订阅轮播图开始滑动以及结束滑动的通知改变首页内容视图是否可以滑动
    NotificationCenter.default.addObserver(self, selector: #selector(_bannerViewWillBeginDraggingNotification), name: NSNotification.Name(rawValue: Commons.CycleBannerWillBeginDraggingNotification), object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(_bannerViewDidEndDeceleratingNotification), name: NSNotification.Name(rawValue: Commons.CycleBannerDidEndDeceleratingNotification), object: nil)
    
//    监听tabbar点击的通知
    NotificationCenter.default.addObserver(self, selector: #selector(_bannerViewDidEndDeceleratingNotification), name: NSNotification.Name(rawValue: BBK_TabBar_DidSelectNotification), object: nil)
    
    _tableHeaderView = LiveHeaderView.liveHeaderView()
    _tableHeaderView.frame = CGRect(origin: .zero, size: CGSize(width: BBK_Screen_Width, height: 364.5))
    _tableHeaderView.myDelegate = self
    _liveContentTableView.tableHeaderView = _tableHeaderView
    
    _tableHeaderView.addObserver(self, forKeyPath: "viewHeight", options: .new, context: nil)
    
  }
  
//  从网络中加载数据
  fileprivate func _setupDataSource() {
    
    #if false
      if let data = NSData(contentsOfFile: "live_content.json") {
        do {
          let responseObject = try JSONSerialization.jsonObject(with: data as Data, options: .mutableContainers) as! [String: Any]
          let dataDict = responseObject["data"] as! [String: Any]
          banners = dataDict["banner"] as! [[String: String]]
          entranceIcons = dataDict["entranceIcons"] as! [[String: Any]]
          partitions = dataDict["partitions"] as! [[String: Any]]
          
          _contentTableView.reloadData()
          _contentTableView.header.endRefreshing()
        } catch let error {
          debugPrint("error: \(error)")
          _contentTableView.header.endRefreshing()
        }
      }
    #endif
    
    let reloadDataSource: () -> Void = {
      if self._banners.count != 0 && self._entrances.count != 0 && self._partitions.count != 0 && self._liveSources.count != 0 {
        
        self._tableHeaderView.banners = self._banners
        self._tableHeaderView.entranceIcons = self._entrances
        
        self._liveContentTableView.reloadData()
        self._liveContentTableView.header.endRefreshing()
      }
    }
    
    _banners.removeAll(keepingCapacity: false)
    _entrances.removeAll(keepingCapacity: false)
    _partitions.removeAll(keepingCapacity: false)
    _liveSources.removeAll(keepingCapacity: false)
//    轮播图
    BBCLiveBannerManager.default().getLiveBanner(banner: nil, success: { (task: URLSessionDataTask, liveBanners: [BBCLiveBanner]) in
      self._banners = liveBanners
      reloadDataSource()
    }, failure: { (task: URLSessionDataTask, error: Error) in
      debugPrint(error)
      self._liveContentTableView.header.endRefreshing()
    })
    
    BBCLiveEntranceManager.default().getLiveEntrance(entrance: { (liveEntrances: [BBCLiveEntrance]) in
      self._entrances = liveEntrances
      reloadDataSource()
    }, failure: { (error: Error) in
      debugPrint(error)
      self._liveContentTableView.header.endRefreshing()
    })
//    分区
    BBCLiveManager.default().getLiveWithPartition({ (livePartitions: [BBCLivePartition]) in
      self._partitions = livePartitions
      reloadDataSource()
    }, failure: { (error: Error) in
      debugPrint(error)
      self._liveContentTableView.header.endRefreshing()
    })
    
    BBCLiveManager.default().getLiveWithSources({ (liveSources: [[BBCLiveSource]]) in
      self._liveSources = liveSources
      reloadDataSource()
    }, failure: { (error: Error) in
      debugPrint(error)
      self._liveContentTableView.header.endRefreshing()
    })
    
  }
}
