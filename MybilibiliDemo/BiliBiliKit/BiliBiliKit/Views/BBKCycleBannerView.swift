//
//  BBKCycleBannerView.swift
//  BiliBiliKit
//
//  Created by 宅总 on 16/10/27.
//  Copyright © 2016年 Zly. All rights reserved.
//

import UIKit
import bilibilicore

// 无限轮播图控件 N+2个`UIImageView`思路

// @since 1.0.0
// @author 赵林洋
fileprivate struct Commons {
//  轮播图将要开始拖动发出的通知
  static let CycleBannerWillBeginDraggingNotification = "kCycleBannerWillBeginDraggingNotification"
//  轮播图结束滑动发出的通知
  static let CycleBannerDidEndDeceleratingNotification = "kCycleBannerDidEndDeceleratingNotification"
//  cellID
  static let CycleBannerCollectionViewCellReuseIdentifier = "BBKCycleBannerViewCellReuseIdentifier"
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
      guard let models = models, models.count != 0 else { return }
      _models.removeAll(keepingCapacity: false)
      _models = models
      _models.insert(models.last!, at: 0)
      _models.append(models.first!)
//      停止计时器器
      _invalidateTimer()
//      重新计算数据源
      _totalItemsCount = models.count + 2
      _mainPageControl.numberOfPages = models.count
//      刷新页面
      _mainView.reloadData()
      setNeedsLayout()
      
      if models.count > 1 {
        _mainView.isScrollEnabled = true
//        开启定时器
        _setupTimer(autoScrollTimeInterval)
      } else {
        _mainView.isScrollEnabled = false
      }
    }
  }
  
//  新的图片url数组, 使用bilibilicore
  public var newModels: [BBCLiveBanner]? {
    didSet {
      guard let newModels = newModels, newModels.count != 0 else { return }
      _newModels.removeAll(keepingCapacity: false)
      _newModels = newModels
      _newModels.insert(newModels.last!, at: 0)
      _newModels.append(newModels.first!)
//      停止计时器器
      _invalidateTimer()
//      重新计算数据源
      _totalItemsCount = newModels.count + 2
      _mainPageControl.numberOfPages = newModels.count
//      刷新页面
      _mainView.reloadData()
      setNeedsLayout()
      
      if newModels.count > 1 {
        _mainView.isScrollEnabled = true
//        开启定时器
        _setupTimer(autoScrollTimeInterval)
      } else {
        _mainView.isScrollEnabled = false
      }
    }
  }
  
  public var autoScrollTimeInterval: TimeInterval // 自动滚动间隔时间, 默认5s
  
  public var bannerViewClosureDidClick: ((_ didselectIndex: Int) -> Void)?
  
  fileprivate var _mainView: UICollectionView! // 轮播图View
  fileprivate var _flowLayout: UICollectionViewFlowLayout! // 轮播图布局
  fileprivate var _mainPageControl: UIPageControl! // 页码控件
  
  fileprivate var _totalItemsCount: Int // 总item的数量
  
  fileprivate var _currentNumber: Int
  
  fileprivate var _timer: Timer! // 轮播定时器
  
  fileprivate var _models: [[String: Any]]
  fileprivate var _newModels: [BBCLiveBanner]
  
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
    return bannerView
  }
  
  override fileprivate init(frame: CGRect) {
    autoScrollTimeInterval = 5
    _models = []
    _newModels = []
    _totalItemsCount = 0
    _currentNumber = 0
    super.init(frame: frame)
    _setupApperance()
  }
  
  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    _flowLayout.itemSize = bounds.size
  }
  
}

extension BBKCycleBannerView {
  
  fileprivate func _setupApperance() {
    
    backgroundColor = BBK_Main_Background_Color
    
    _flowLayout = UICollectionViewFlowLayout()
    _flowLayout.minimumLineSpacing = 0
    _flowLayout.minimumInteritemSpacing = 0
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
    _mainPageControl.currentPage = 0
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
  
  fileprivate func _setupTimer(_ timeInterval: TimeInterval) {
    
    _timer = Timer(timeInterval: timeInterval, target: self, selector: #selector(_automaticScroll), userInfo: nil, repeats: true)
    /**
     *  NSDefaultRunLoopMode 滚动视图的模式无效
     *  UITrackingRunLoopMode 滚动视图的模式才有效
     *  NSRunLoopCommonModes 两者兼容
     */
    RunLoop.main.add(_timer, forMode: .defaultRunLoopMode)
  }
  
  @objc fileprivate func _automaticScroll() {
    
    guard _totalItemsCount != 0 else { return }
    
    _currentNumber = _calculateCurrentNumber(_currentNumber + 1, at: _totalItemsCount - 2)
    _mainPageControl.currentPage = _currentNumber
    _mainView.scrollToItem(at: IndexPath(row: _currentNumber, section: 0), at: .right, animated: true)
  }
  
  fileprivate func _calculateCurrentNumber(_ valueA: Int, at valueB: Int) -> Int {
    return (valueA + valueB) % valueB
  }

  fileprivate func _invalidateTimer() {
    
    guard _timer != nil else { return }
    _timer.invalidate()
    _timer = nil
  }
}

extension BBKCycleBannerView: UICollectionViewDataSource, UICollectionViewDelegate {
  
//  UICollectionViewDataSource
  
  public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return _totalItemsCount
  }
  
  public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Commons.CycleBannerCollectionViewCellReuseIdentifier, for: indexPath) as! BBKCycleBannerViewCell
    
    if _newModels.count != 0 {
      cell.imageURL = _newModels[indexPath.row].imageUrl
    } else {
      cell.imageURL = _models[indexPath.row]["image"] as? String
    }
    
    return cell
  }
  
//  UICollectionViewDelegate
  
  public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    if _newModels.count != 0 {
      bannerViewClosureDidClick?(indexPath.item % _newModels.count)
    } else {
      bannerViewClosureDidClick?(indexPath.item % _models.count)
    }
  }
  
  public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
//    发送开始拖拽的通知
    NotificationCenter.default.post(name: NSNotification.Name(rawValue: Commons.CycleBannerWillBeginDraggingNotification), object: nil)
//    取消定时器
    _invalidateTimer()
  }
  
  public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    // TODO: - 手动滑动滚动式图_mainPageControl.currentPage还有个小bug
    let contentOffsetFullScrolledRight = _mainView.frame.size.width * CGFloat(_totalItemsCount - 1)
    if scrollView.contentOffset.x == contentOffsetFullScrolledRight {
      let path = IndexPath(row: 1, section: 0)
      _mainView.scrollToItem(at: path, at: .right, animated: false)
      _currentNumber = _calculateCurrentNumber(_currentNumber + 1, at: _totalItemsCount - 2)
    } else if scrollView.contentOffset.x == 0 {
      let path = IndexPath(row: _totalItemsCount - 2, section: 0)
      _mainView.scrollToItem(at: path, at: .right, animated: false)
      _currentNumber = _calculateCurrentNumber(_currentNumber - 1, at: _totalItemsCount - 2)
    }
    _mainPageControl.currentPage = _currentNumber
//    发送结束滚动的通知
    NotificationCenter.default.post(name: NSNotification.Name(rawValue: Commons.CycleBannerDidEndDeceleratingNotification), object: nil)
//    设置定时器
    _setupTimer(autoScrollTimeInterval)
  }
  
}
