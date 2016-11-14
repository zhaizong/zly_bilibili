//
//  BBKCycleBannerView.swift
//  BiliBiliKit
//
//  Created by 宅总 on 16/10/27.
//  Copyright © 2016年 Zly. All rights reserved.
//

import UIKit

// 无限轮播图控件
// @since 1.0.0
// @author 赵林洋
fileprivate struct Commons {
//  轮播图将要开始拖动发出的通知
  static let CycleBannerWillBeginDraggingNotification = "kCycleBannerWillBeginDraggingNotification"
//  轮播图结束滑动发出的通知
  static let CycleBannerDidEndDeceleratingNotification = "kCycleBannerDidEndDeceleratingNotification"
//  cellID
  static let CycleBannerCollectionViewCellReuseIdentifier = "BBKCycleBannerViewCellReuseIdentifier"
  static let ItemGroupCount = 4
}

internal class BBKCycleBannerViewCell: UICollectionViewCell {
  
  internal var imageURL: String? {
    didSet {
      guard let imageURL = imageURL, imageURL != "" else { return }
      _imageView.sd_setImage(with: URL(string: imageURL), placeholderImage: _placeholderImage, options: .progressiveDownload)
    }
  }
  
  fileprivate var _imageView: UIImageView!
  
  fileprivate lazy var _placeholderImage: UIImage = { // 占位图
    if let lazilyCreatedPlaceholderImage = UIImage.generateCenterImageWithBgColor(BBK_Main_Placeholder_Background_Color, bgImageSize: CGSize(width: BBK_Screen_Width, height: 120), centerImage: UIImage(named: "default_img")!) {
      return lazilyCreatedPlaceholderImage
    }
    return UIImage()
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    _setupApperance()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func layoutSubviews() {
    
    _imageView.frame = contentView.bounds
  }
  
  fileprivate func _setupApperance() {
    
    backgroundColor = BBK_Main_Background_Color
    _imageView = UIImageView(frame: .zero)
    contentView.addSubview(_imageView)
  }
  
}

public class BBKCycleBannerView: UIView {
  
  // 图片url数组
  public var models: [[String: Any]]? {
    didSet {
      guard let models = models else { return }
      _models = models
//      停止计时器器
      _invalidateTimer()
//      重新计算数据源
      _totalItemsCount = models.count * Commons.ItemGroupCount
      _mainPageControl.numberOfPages = models.count
//      刷新页面
      _mainView.reloadData()
      setNeedsLayout()
      if models.count <= 1 {
        _mainView.isScrollEnabled = false
      } else {
        _mainView.isScrollEnabled = true
//        开启定时器
        _setupTimerWithTimeInterval(autoScrollTimeInterval)
      }
    }
  }
  
  public var autoScrollTimeInterval: TimeInterval // 自动滚动间隔时间, 默认5s
  
  public var bannerViewClosureDidClick: ((_ didselectIndex: Int) -> Void)?
  
  fileprivate var _mainView: UICollectionView! // 轮播图View
  fileprivate var _flowLayout: UICollectionViewFlowLayout! // 轮播图布局
  fileprivate var _mainPageControl: UIPageControl! // 页码控件
  fileprivate var _placeholderImage: UIImage! // 占位图
  
  fileprivate var _totalItemsCount: Int // 总item的数量
  
  fileprivate var _itemIndex: Int!
  
  fileprivate var _timer: Timer! // 轮播定时器
  
  fileprivate var _models: [[String: Any]]
  
  /**
   *  初始化方法
   *
   *  @param frame            轮播图的frame
   *  @param placeholderImage 占位图片
   *  @param block            block
   *
   *  @return 轮播图实例
   */
  
  public class func initBannerViewWithFrame(_ frame: CGRect, placeholderImage: UIImage?) -> BBKCycleBannerView {
    
    let bannerView = BBKCycleBannerView(frame: frame)
    bannerView._placeholderImage = placeholderImage
    return bannerView
  }
  
  override fileprivate init(frame: CGRect) {
    _models = []
    autoScrollTimeInterval = 5
    _totalItemsCount = 0
    super.init(frame: frame)
    _setupApperance()
  }
  
  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    _flowLayout.itemSize = bounds.size
    _mainView.contentInset = UIEdgeInsets(top: 0,
                                          left: -((CGFloat(_totalItemsCount) * 0.5 - 1) * BBK_Screen_Width),
                                          bottom: 0,
                                          right: -((CGFloat(_totalItemsCount) * 0.5 - 2) * BBK_Screen_Width))
    if _totalItemsCount > 0 {
      let targetIndex = CGFloat(_totalItemsCount) * 0.5
      _mainView.scrollToItem(at: IndexPath(item: Int(targetIndex), section: 0), at: .init(rawValue: 0), animated: false)
      _mainView.setContentOffset(CGPoint(x: _mainView.contentOffset.x - BBK_Screen_Width, y: 0), animated: true)
      _itemIndex = Int(targetIndex)
    }
    
  }
  
}

extension BBKCycleBannerView {
  
  fileprivate func _setupApperance() {
    
    backgroundColor = BBK_Main_Background_Color
    
    _flowLayout = UICollectionViewFlowLayout()
    _flowLayout.minimumLineSpacing = 0
    _flowLayout.scrollDirection = .horizontal
    
    _mainView = UICollectionView(frame: .zero, collectionViewLayout: _flowLayout)
    _mainView.register(BBKCycleBannerViewCell.self, forCellWithReuseIdentifier: Commons.CycleBannerCollectionViewCellReuseIdentifier)
    _mainView.backgroundColor = BBK_Main_Background_Color
    _mainView.isPagingEnabled = true
    _mainView.showsHorizontalScrollIndicator = false
    _mainView.showsVerticalScrollIndicator = false
    _mainView.scrollsToTop = false
    _mainView.dataSource = self
    _mainView.delegate = self
    addSubview(_mainView)
    
    _mainPageControl = UIPageControl()
    _mainPageControl.hidesForSinglePage = true
    _mainPageControl.currentPageIndicatorTintColor = BBK_Main_Color
    _mainPageControl.pageIndicatorTintColor = BBK_Main_White_Color
    _mainPageControl.isUserInteractionEnabled = false
    addSubview(_mainPageControl)
    
    _mainView.snp.makeConstraints { (make) in
      make.top.equalTo(0)
      make.bottom.equalTo(0)
      make.leading.equalTo(0)
      make.trailing.equalTo(0)
    }
    
    _mainPageControl.snp.makeConstraints { (make) in
      make.right.equalTo(self._mainPageControl.superview!.snp.right).offset(-8)
      make.bottom.equalTo(self._mainPageControl.superview!.snp.bottom).offset(8)
    }
  }
  
  fileprivate func _invalidateTimer() {
    
    guard _timer != nil else { return }
    _timer.invalidate()
  }
  
  fileprivate func _currentIndex() -> Int {
    
    guard _mainView.st_width != 0 || _mainView.st_height != 0 else { return 0 }
    var index = (_mainView.contentOffset.x + _flowLayout.itemSize.width * 0.5) / _flowLayout.itemSize.width
    return max(0, Int(index))
  }
  
  fileprivate func _setupTimerWithTimeInterval(_ timeInterval: TimeInterval) {
    
    let timer = Timer(timeInterval: timeInterval, target: self, selector: #selector(BBKCycleBannerView._automaticScroll), userInfo: nil, repeats: true)
    _timer = timer
    /**
     *  NSDefaultRunLoopMode 滚动视图的模式无效
     *  UITrackingRunLoopMode 滚动视图的模式才有效
     *  NSRunLoopCommonModes 两者兼容
     */
    RunLoop.main.add(timer, forMode: .defaultRunLoopMode)
  }
  
  @objc fileprivate func _automaticScroll() {
    
    guard _totalItemsCount != 0 else { return }
    
    _mainView.contentInset = UIEdgeInsets.zero
    let currentIndex = _currentIndex()
    var targetIndex = currentIndex + 1
    if targetIndex >= _totalItemsCount {
      targetIndex = Int(CGFloat(_totalItemsCount) * 0.5)
      _mainView.scrollToItem(at: IndexPath(item: targetIndex - 1, section: 0), at: .init(rawValue: 0), animated: false)
//      立即调用定时器
      _timer.fire()
      return
    }
    _mainView.scrollToItem(at: IndexPath(item: targetIndex, section: 0), at: .init(rawValue: 0), animated: true)
  }
}

extension BBKCycleBannerView: UICollectionViewDataSource, UICollectionViewDelegate {
  
  public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
    return _totalItemsCount
  }
  
  public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Commons.CycleBannerCollectionViewCellReuseIdentifier, for: indexPath) as! BBKCycleBannerViewCell
    let itemIndex = indexPath.item % _models.count
    
    cell.imageURL = _models[itemIndex]["image"] as? String
    
    return cell
  }
  
  public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
    bannerViewClosureDidClick?(indexPath.item % _models.count)
  }
  
  public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    
//    发送开始拖拽的通知
    NotificationCenter.default.post(name: NSNotification.Name(rawValue: Commons.CycleBannerWillBeginDraggingNotification), object: nil)
//    取消定时器
    _invalidateTimer()
  }
  
  public func scrollViewDidScroll(_ scrollView: UIScrollView) {
    
    _itemIndex = _currentIndex()
    _mainPageControl.currentPage = _currentIndex() % _models.count
  }
  
  public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    
    let halfTotalItemsCount = _totalItemsCount / 2
    let padding = _itemIndex % (_totalItemsCount / Commons.ItemGroupCount)
    let leftInset = CGFloat(halfTotalItemsCount + padding - 1) * BBK_Screen_Width
    let rightInset = CGFloat(halfTotalItemsCount + padding - 1) * BBK_Screen_Width - (BBK_Screen_Width * CGFloat(padding * 2 + 1))
//    根据当前索引变换contentInset
    _mainView.contentInset = UIEdgeInsets(top: 0, left: -leftInset, bottom: 0, right: -rightInset)
//    结束滑动, 应该默认滚动到中间位置
    let targetIndex = _totalItemsCount / 2
    _mainView.scrollToItem(at: IndexPath(item: targetIndex, section: 0), at: .init(rawValue: 0), animated: false)
    _mainView.setContentOffset(CGPoint(x: _mainView.contentOffset.x - BBK_Screen_Width, y: 0), animated: true)
//    发送结束滚动的通知
    NotificationCenter.default.post(name: NSNotification.Name(rawValue: Commons.CycleBannerDidEndDeceleratingNotification), object: nil)
//    设置定时器
    _setupTimerWithTimeInterval(autoScrollTimeInterval)
  }
  
}
