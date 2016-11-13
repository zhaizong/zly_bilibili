//
//  LiveHeaderView.swift
//  MybilibiliDemo
//
//  Created by 宅总 on 16/10/27.
//  Copyright © 2016年 Zly. All rights reserved.
//

import UIKit

// 直播内容头视图
// @since 1.0.0
// @author 赵林洋
fileprivate struct Commons {
  
}

class LiveHeaderView: UIView {

  // MARK: - Property
  
  var bannerModels: [[String : Any]]? {
    didSet {
      guard let bannerModels = bannerModels, bannerModels.count != 0 else { return }
      _bannerView.models = bannerModels
    }
  }
  var entranceIconArray: [String]? {
    didSet {
      guard let entranceIconArray = entranceIconArray, entranceIconArray.count != 0 else { return }
      // TODO: - 数组类型待定
//      _bottomView.entranceIconArray = entranceIconArray as! [LiveEntranceIconModel]
    }
  }
  
  var viewHeight: CGFloat // 记录头部视图的高度
  
  weak var myDelegate: LiveHeaderViewDelegate?
  
  fileprivate var _bannerView: BBKCycleBannerView! // 顶部轮播View
  fileprivate var _bottomView: LiveEntranceIconsView! // 底部入口View
  
  // MARK: - Lifecycle
  
  class func liveHeaderView() -> LiveHeaderView {
    
    return LiveHeaderView()
  }
  
  override init(frame: CGRect) {
    viewHeight = 0
    super.init(frame: frame)
    _setupApperance()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    _bannerView.snp.makeConstraints { (make) in
      make.width.equalTo(BBK_Screen_Width)
      make.height.equalTo(120)
    }
    _bottomView.snp.makeConstraints { (make) in
      make.centerY.equalTo(self._bannerView.snp.bottom)
      make.width.equalTo(BBK_Screen_Width)
      make.height.equalTo(BBK_Screen_Width * 0.5 + BBK_APP_TabBar_Height + BBK_App_Padding_8)
    }
    /*_bannerView.frame = CGRect(origin: .zero, size: CGSize(width: BBK_Screen_Width, height: 120))
    _bottomView.frame = CGRect(origin: CGPoint(x: 0, y: _bannerView.st_bottom), size: CGSize(width: BBK_Screen_Width, height: BBK_Screen_Width * 0.5 + BBK_APP_TabBar_Height + BBK_App_Padding_8))*/
    
    viewHeight = _bottomView.st_bottom
  }

}

extension LiveHeaderView {
  
  fileprivate func _setupApperance() {
    
    backgroundColor = BBK_Main_Background_Color
    
    _bannerView = BBKCycleBannerView.initBannerViewWithFrame(.zero, placeholderImage: nil)
    addSubview(_bannerView)
    _bannerView.bannerViewClosureDidClick = { [weak self] (didSelectIndex: Int) in
      guard let weakSelf = self else { return }
      guard let myDelegate = weakSelf.myDelegate else { return }
      if myDelegate.responds(to: #selector(LiveHeaderViewDelegate.liveHeaderView(_:didSelectedBannerIndex:))) {
        myDelegate.liveHeaderView(weakSelf, didSelectedBannerIndex: didSelectIndex)
      }
    }
    
    _bottomView = LiveEntranceIconsView.liveEntranceIconsView() { [weak self] (selectedAreaID: LiveEntranceIconsViewAreaType) in
      guard let weakSelf = self else { return }
      guard let myDelegate = weakSelf.myDelegate else { return }
      if myDelegate.responds(to: #selector(LiveHeaderViewDelegate.liveHeaderView(_:selectedAreaID:))) {
        myDelegate.liveHeaderView(weakSelf, selectedAreaID: selectedAreaID)
      }
    }
    addSubview(_bottomView)
  }
  
}

@objc protocol LiveHeaderViewDelegate: NSObjectProtocol {
  /**
   *  轮播图点击触发的代理
   *
   *  @param didSelectedBannerIndex     轮播索引
   */
  func liveHeaderView(_ liveHeaderView: LiveHeaderView, didSelectedBannerIndex index: Int)
  /**
   *  入口图标被点击触发的索引
   *
   *  @param selectedAreaID             入口图标索引
   */
  func liveHeaderView(_ liveHeaderView: LiveHeaderView, selectedAreaID areaID: LiveEntranceIconsViewAreaType)
}
