//
//  RecommendRegionFooterView.swift
//  MybilibiliDemo
//
//  Created by 宅总 on 16/11/13.
//  Copyright © 2016年 Zly. All rights reserved.
//

import UIKit

// 首页推荐 -> 分区 footer view
// @use RecommendViewController.swift
// @since 1.0.0
// @author 赵林洋
class RecommendRegionFooterView: UIView {

  // MARK: - Property
  
  fileprivate var _moreLiveButton: UIButton
  
  fileprivate var _refreshButton: UIButton
  
  // MARK: - Lifecycle
  
  override init(frame: CGRect) {
    _moreLiveButton = UIButton(type: .custom)
    _refreshButton = UIButton(type: .custom)
    super.init(frame: frame)
    
    _moreLiveButton.frame = .zero
    _moreLiveButton.setTitle("更多直播", for: .normal)
    _moreLiveButton.setTitleColor(UIColor(hexString: "#AAAAAA"), for: .normal)
    _moreLiveButton.setBackgroundImage(UIImage(named: "shadow_5_corner_246_bg"), for: .normal)
    
    _refreshButton.frame = .zero
    _refreshButton.setTitle("15条动态，点击刷新！", for: .normal)
    _refreshButton.setTitleColor(UIColor.black, for: .normal)
    _refreshButton.setImage(UIImage(named: "home_refresh"), for: .normal)
    _refreshButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
    
    addSubview(_moreLiveButton)
    addSubview(_refreshButton)
    
    _moreLiveButton.snp.makeConstraints { (make) in
      make.centerY.equalTo(0)
      make.leading.equalTo(8)
      make.width.equalTo(150)
      make.height.equalTo(35)
    }
    
    _refreshButton.snp.makeConstraints { (make) in
      make.centerY.equalTo(0)
      make.trailing.equalTo(-16)
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}
