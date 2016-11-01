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
  static let UrlString = "http://live.bilibili.com/AppIndex/home?_device=android&_hwid=51e96f5f2f54d5f9&_ulv=10000&access_key=563d6046f06289cbdcb472601ce5a761&appkey=c1b107428d337928&build=410000&platform=android&scale=xxhdpi&sign=fbdcfe141853f7e2c84c4d401f6a8758"
//  轮播图将要开始拖动发出的通知
  static let CycleBannerWillBeginDraggingNotification = "kCycleBannerWillBeginDraggingNotification"
//  轮播图结束滑动发出的通知
  static let CycleBannerDidEndDeceleratingNotification = "kCycleBannerDidEndDeceleratingNotification"
  static let LiveContentTableViewCellID = "LiveContentTableViewCellID"
}

class LiveViewController: UIViewController, BiliStoryboardViewController {

  // MARK: - Property
  
  fileprivate var _banners: [[String: String]] = [] // 轮播图数据数组
  fileprivate var _entranceIcons: [[String: Any]] = [] // 入口图片数据数组
  fileprivate var _partitions: [[String: Any]] = [] // 分区数据数组
  
  fileprivate var _lastSelectedTabBarIndex: Int! // 记录上次选中的tabbar索引
  fileprivate weak var _contentTableView: UITableView! // 内容视图
  fileprivate weak var _tableHeaderView: LiveHeaderView! // 头部视图
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
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
    
    let vc = UIStoryboard.homeStoryboard().instantiateViewController(withIdentifier: "LiveViewController") as! LiveViewController
    return vc as! T
  }
  
  override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
    
    guard let keyPath = keyPath else { return }
    guard let change = change else { return }
    
    if keyPath == "viewHeight" {
      let newValue = change[.newKey] as! CGFloat
      _tableHeaderView.snp.updateConstraints({ (make) in
        make.height.equalTo(newValue)
      })
      _contentTableView.tableHeaderView = _tableHeaderView
    }
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
    
    return UITableViewCell()
  }
}

extension LiveViewController: LiveHeaderViewDelegate {
  
  func liveHeaderView(_ liveHeaderView: LiveHeaderView, didSelectedBannerIndex index: Int) {
    
  }
  
  func liveHeaderView(_ liveHeaderView: LiveHeaderView, selectedAreaID areaID: LiveEntranceIconsViewAreaType) {
    
  }
}

extension LiveViewController {
  
  @objc fileprivate func _scrollDidFinshNotebeginRefreshing() {
    
    _contentTableView.header.beganRefreshing()
  }
  
  @objc fileprivate func _bannerViewWillBeginDraggingNotification() {
    
    _contentTableView.isScrollEnabled = false
  }
  
  @objc fileprivate func _bannerViewDidEndDeceleratingNotification() {
    
    _contentTableView.isScrollEnabled = true
  }
  
  @objc fileprivate func _tabBarDidSelectNotification() {
    
//    如果是连续选中两次，直接返回.
    if _lastSelectedTabBarIndex == tabBarController?.selectedIndex && view.isShowingOnKeyWindow() {
      _contentTableView.header.beganRefreshing()
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
    
    _contentTableView = UITableView(frame: .zero, style: .grouped)
    _contentTableView.register(LiveEntranceIconsCollectionViewCell.self, forCellReuseIdentifier: Commons.LiveContentTableViewCellID)
    _contentTableView.backgroundColor = BBK_Main_Background_Color
    _contentTableView.separatorStyle = .none
    _contentTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 49, right: 0)
    _contentTableView.scrollIndicatorInsets = _contentTableView.contentInset
    _contentTableView.estimatedRowHeight = 306
    _contentTableView.rowHeight = 306
    _contentTableView.dataSource = self
    _contentTableView.delegate = self
    view.addSubview(_contentTableView)
    
//    添加下拉刷新控件
    _contentTableView.header = BBKRefreshHeader() { (header: BBKRefreshHeader?) in
      self._loadDataArrFromNetwork()
    }
    
//    订阅DisplayViewClickOrScrollDidFinshNote通知决定是否刷新
    #if false
      NotificationCenter.default.addObserver(self, selector: #selector(LiveViewController._scrollDidFinshNotebeginRefreshing), name: NSNotification.Name(rawValue: BBK_DisplayView_ClickOrScrollDidFinshNote), object: nil)
    #endif
    
//    订阅轮播图开始滑动以及结束滑动的通知改变首页内容视图是否可以滑动
    NotificationCenter.default.addObserver(self, selector: #selector(LiveViewController._bannerViewWillBeginDraggingNotification), name: NSNotification.Name(rawValue: Commons.CycleBannerWillBeginDraggingNotification), object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(LiveViewController._bannerViewDidEndDeceleratingNotification), name: NSNotification.Name(rawValue: Commons.CycleBannerDidEndDeceleratingNotification), object: nil)
    
//    监听tabbar点击的通知
    NotificationCenter.default.addObserver(self, selector: #selector(LiveViewController._bannerViewDidEndDeceleratingNotification), name: NSNotification.Name(rawValue: BBK_TabBar_DidSelectNotification), object: nil)
    
    _tableHeaderView = LiveHeaderView.liveHeaderView()
    _tableHeaderView.frame = .zero
    _tableHeaderView.myDelegate = self
    _contentTableView.tableHeaderView = _tableHeaderView
    
    _tableHeaderView.addObserver(self, forKeyPath: "viewHeight", options: .new, context: nil)
    
    _tableHeaderView.snp.makeConstraints { (make) in
      make.width.equalTo(BBK_Screen_Width)
      make.height.equalTo(364.5)
    }
  }
  
//  从网络中加载数据
  fileprivate func _loadDataArrFromNetwork() {
    
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
    
    BBKUtils.get(Commons.UrlString, parameters: nil, downloadProgress: nil, successBlock: { [weak self] (task: URLSessionDataTask, responseObject: Any?) in
      guard let weakSelf = self else { return }
      if let responseObject = responseObject {
        let responseDict = responseObject as! [String: Any]
        let dataDict = responseDict["data"] as! [String: Any]
        weakSelf._banners = dataDict["banner"] as! [[String: String]]
        weakSelf._entranceIcons = dataDict["entranceIcons"] as! [[String: Any]]
        weakSelf._partitions = dataDict["partitions"] as! [[String: Any]]
        
      }
      weakSelf._contentTableView.reloadData()
      weakSelf._contentTableView.header.endRefreshing()
    }) { [weak self] (task: URLSessionDataTask?, error: Error) in
      guard let weakSelf = self else { return }
      debugPrint("error: \(error)")
      weakSelf._contentTableView.header.endRefreshing()
    }
  }
}
